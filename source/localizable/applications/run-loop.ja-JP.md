Emberの内部、そしてアプリケーション内で書かれるほとんどのコードは、実行ループ (run loop) の中で実行されます。 実行ループはバッチ処理に使われ、最も効果的かつ効率的な方法で作業を順序付け (または再順序付け) します。

それは、特定のキューで作業をスケジューリングすることで行います。 それらのキューには優先順位があり、その優先順位に従って処理が行われます。

Emberの基本的なアプリケーション開発シナリオでは、実行ループを理解したり、直接使用する必要はありません。 全ての通路はあなた用に綺麗に舗装されているので、あなたは実行ループで直接作業する必要はありません。

実行ループを使用する最も一般的なケースは、非同期のコールバックを含むEmberのものでないAPIを統合するような場合です。それは例えば、以下のようなものです。

* DOMの更新やイベントのコールバック
* `setTimeout`や`setInterval`のコールバック
* `postMessage`や`messageChannel`のイベントハンドラ
* AJAXコールバック
* Websocketコールバック

## 実行ループが便利な理由

大抵の場合は、同様の作業をバッチ処理することには利点があります。 WebブラウザはDOMへの変更をバッチ処理することで、とてもよく似た処理を行います。

以下のHTML片を考えてみてください。

```html
<div id="foo"></div>
<div id="bar"></div>
<div id="baz"></div>
```

次に以下のコードを実行したとします。

```javascript
foo.style.height = '500px' // write
foo.offsetHeight // read (recalculate style, layout, expensive!)

bar.style.height = '400px' // write
bar.offsetHeight // read (recalculate style, layout, expensive!)

baz.style.height = '200px' // write
baz.offsetHeight // read (recalculate style, layout, expensive!)
```

この例では、一連のコードはスタイルの再計算と各処理の後での再レイアウトをブラウザに強制します。 しかし、もし類似したジョブをまとめてバッチ処理できるなら、ブラウザがスタイルの再計算やレイアウトを行うのは一度のみでよくなります。

```javascript
foo.style.height = '500px' // write
bar.style.height = '400px' // write
baz.style.height = '200px' // write

foo.offsetHeight // read (recalculate style, layout, expensive!)
bar.offsetHeight // read (fast since style and layout are already known)
baz.offsetHeight // read (fast since style and layout are already known)
```

興味ふかいことに、このパターンは他の多くの種類の作業にも当てはまります。本質的には、同様の作業をバッチ処理することにより、より良いパイプライン化と最適化が可能になります。

それでは、Emberによって最適化された同様の例を見て見ましょう。`User`オブジェクトから始めます。

```javascript
let User = Ember.Object.extend({
  firstName: null,
  lastName: null,
  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  })
});
```

このオブジェクトの属性を表示するテンプレートは以下のようになります。

```handlebars
{{firstName}}
{{fullName}}
```

実行ループなしに次のコードを実行すると、次のようになります。

```javascript
let user = User.create({ firstName: 'Tom', lastName: 'Huda' });
user.set('firstName', 'Yehuda');
// {{firstName}} and {{fullName}} are updated

user.set('lastName', 'Katz');
// {{lastName}} and {{fullName}} are updated
```

ブラウザがテンプレートを2回描画することがわかります。

しかし、もし上記のコードを実行ループを実行すると、ブラウザは属性を全て設定した後に1度だけテンプレートを描画します。

```javascript
let user = User.create({ firstName: 'Tom', lastName: 'Huda' });
user.set('firstName', 'Yehuda');
user.set('lastName', 'Katz');
user.set('firstName', 'Tom');
user.set('lastName', 'Huda');
```

上記の例を実行ループで実行した場合は、ユーザーの属性は実行前と同じ値になるため、テンプレートは再描画されません!

これらのシナリオをケースバイケースで最適化することはもちろん可能です。しかし、コストを払わずにそれが得られるのはとても良いことです。 実行ループを使用することで、これらのクラスの最適化を各シナリオだけでなく、アプリケーション全体に適用することができます。

## Emberで実行ループはどのように機能するか

前述したように、キューの形で作業をスケジュールし(関数呼び出しの形式で)、これらのキューは優先順位に従って処理されます。

キュー、そしてその優先順位とは一体何でしょうか。

```javascript
Ember.run.queues
// => ["sync", "actions", "routerTransitions", "render", "afterRender", "destroy"]
```

キューの優先順位は順番によって決まるため、"sync" (同期) キューは "render" (描画) キューまたは "destroy" (破棄) キューよりも高い優先度を持ちます。

## これらのキューの中では何が起きるか

* `sync`キューは同期ジョブのバインディングを含みます。
* `actions`キューは一般的な作業キューであり、通常プロミスなどのスケジュールされた作業を含みます。
* `routerTransitions`キューはルーター内の遷移ジョブを含みます。
* `render`キューは描画のためのジョブを含みます。それらのジョブは、通常DOMの更新を行います。
* `afterRender`キューは、スケジュールされた全ての描画作業が完了した後に実行するジョブを含みます。 これは、DOMツリー全体が更新された後にのみ実行されるサードパーティのDOM操作ライブラリにとって、しばしば役に立つものです。
* `destroy`キューは、他のジョブが破棄する予定のオブジェクトの解体を行うジョブを含みます。

## キューではどのような順序でジョブが実行されるか

アルゴリズムは以下のように動作します。

1. 保留されているジョブを含む優先度の高いキューを`CURRENT_QUEUE`とします。保留中のジョブを含むキューが無い場合は、実行ループを完了します。
2. 新しい一時的なキューを`WORK_QUEUE`として宣言します。
3. `CURRENT_QUEUE`から`WORK_QUEUE`にジョブを移します。
4. `WORK_QUEUE`内の全てのキューを順番に処理します。
5. 最初のステップに戻ります。

## 内部構造の例

実行ループをスケジュールするさまざまな関数を内部で呼び出す上位レベルのアプリケーションコードを記述するのではなく、覆っているものを取り除いて、生の実行ループのやり取りをお見せしました。

ほとんどのEmberアプリケーションにおいて、このAPIを直接操作することは一般的ではありません。しかし、この例を理解することは、実行ループアルゴリズムを理解し、より良いEmber開発者となるのに役立ちます。 <iframe src="https://s3.amazonaws.com/emberjs.com/run-loop-guide/index.html" width="678" height="410" style="border:1px solid rgb(170, 170, 170);margin-bottom:1.5em;"></iframe> 

## 実行ループを開始するにはどうするか

実行ループは、コールバックの発生と共に開始する必要があります。

`Ember.run`メソッドは、実行ループを作成するために使用できます。以下の例では、クリックイベントを処理してEmberコードを実行するために、jQueryと`Ember.run`を使用しています。

この例では、`=>`関数構文を使用しています。これはレキシカルな`this`を提供する\[コールバック関数用の新しいES2015構文\](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) です。 もしこの構文が見慣れたものでなければ、定義されているコンテキストと同じ`this`を持つ関数だと考えてください。

```javascript
$('a').click(() => {
  Ember.run(() => {  // begin loop
    // Code that results in jobs being scheduled goes here
  }); // end loop, jobs are flushed and executed
});
```

## 非同期ハンドラ内で実行ループを開始するのを忘れるとどうなるか

上記のように、Ember以外の非同期コールバックは`Ember.run`でラップする必要があります。 そうしないと、Emberは最初と最後を近づけようとします。 次のコールバックを考えてみましょう。

```javascript
$('a').click(() => {
  console.log('Doing things...');

  Ember.run.schedule('actions', () => {
    // Do more things
  });
});
```

実行ループAPIは、*スケジュール*機能 ([`run.schedule`](http://emberjs.com/api/classes/Ember.run.html#method_schedule)、[`run.scheduleOnce`](http://emberjs.com/api/classes/Ember.run.html#method_scheduleOnce)、[`run.once`](http://emberjs.com/api/classes/Ember.run.html#method_once)など) を呼び出します。それらは、実行ループが存在しない場合にそれを近似するプロパティを持っています。 これらは自動的に*autorun*と呼ばれる実行ループを作成しました.

上記の例を使用して何が起こるかを記述する疑似コードを次に示します。

```javascript
$('a').click(() => {
  // 1. autorunはコールバック内の任意のコード実行を変更しません。
  // このコードはコールバックが実行された際に実行されます。
  // 自動実行のスケジュールはされません。
  console.log('Doing things...');

  Ember.run.schedule('actions', () => {
    // 2. scheduleは現在利用可能な実行ループがないことを検知し、
    //    実行ループを1つ作成します。 そして、JSイベントループの次のターンで
    // キューをフラッシュするよう実行ループをスケジュールします。
    if (! Ember.run.hasOpenRunLoop()) {
      Ember.run.start();
      nextTick(() => {
        Ember.run.end()
      }, 0);
    }

    // 3. もう利用可能な実行ループがあるため、scheduleは処理を指定されたキューに追加します。
    Ember.run.schedule('actions', () => {
      // Do more things
    });

  });

  // 4. このscheduleでは、上記のscheduleで作成されたautorunを使用可能な実行ループとして認識し、
  //   そのアイテムが特定のキューに追加されます。
  Ember.run.schedule('afterRender', () => {
    // Do yet more things
  });
});
```

autorunは便利ですが、最適ではありません。 現在のJSフレームは、実行ループがフラッシュされる前に終了することができます。これは、ブラウザが他の処理 (ガベージコレクションのような) を行う機会を得る可能性があることを意味します。 データ変更とDOM再描画の間におけるGCの実行は、視覚的な遅れを引き起こす可能性があルノで、最小にする必要があります。

autorunに依存するのは、実行ループを使用する厳密あるいは効果的な方法ではありません。実行ループを使用するには、イベントハンドラを手動でラップする方が望ましいです。

## 実行ループの振る舞いはテストの際どう異なるか

アプリケーションが*テストモード*の場合、もし利用可能な実行ループが無い状態で作業をスケジュールしようとすると、Emberはエラーを投げます。

いくつかの理由から、テストの際のautorunは無効にされています。

1. autorunは、コールバックをスケジュールする前に実行ループを開くのを忘れた場合に、プロダクションであなたを罰さなくするためのEmber流の方法です。 これはプロダクションでは便利です。しかし、それらを見つけて修正するために、テストの中で明らかにすべき状況です。
2. Emberのテストペルパーの中には、解決する前に実行ループが空になるのをを待つPromiseがあります。 アプリケーションに実行ループの*外側*で実行するコードがある場合は、それらは早く解決されすぎ、誤ったテストの失敗を引き起こしてしまうでしょう。 autorunを禁止することは、これらのシナリオを識別し、テストとアプリケーションの両方を助けることになるでしょう!

## さらなる情報がある場所

[Ember.run](http://emberjs.com/api/classes/Ember.run.html)APIのドキュメントはもちろん、実行ループの動力源である[Backburner ライブラリ](https://github.com/ebryn/backburner.js/)も参照してください。