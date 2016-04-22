このセクションではルータの高度なフィーチャーとどのようにしてアプリケーション内の複雑な非同期のロジックを扱えるようにしているかを紹介します。

### プロミスについて...

Emberは、ルーターの非同期のロジックを扱うのにプロミスの概念を多用しています。 一言で言えば、プロミスはのちに起こる値を表すオブジェクトです。 プロミスは*成功*(値の解決に成功) または *リジェクト* (値の解決に失敗) のいずれかとなります。 最終の値を取得する、またはプロミスがリジェクトされた場合のハンドリングは成功、リジェクトの二つのコールバックを受け取ることのできる、プロミスの[`then()`](http://emberjs.com/api/classes/RSVP.Promise.html#method_then)メソッドで処理します。 もし、プロミスが成功すれば、成功の値とともに、成功時のハンドロラーが呼び出されます、また、プロミスがリジェクトされた場合はリジェクトされた理由とともに、リジェクトハンドラーが呼び出されます。 例えば

```js
var promise = fetchTheAnswer();

promise.then(fulfill, reject);

function fulfill(answer) {
  console.log(`The answer is ${answer}`);
}

function reject(reason) {
  console.log(`Couldn't get the answer! Reason: ${reason}`);
}
```

プロミスの力点は、非同期のオペレーションを次々と処理される、列として処理できることです。

```js
// Note: jQuery AJAX メソッドはプロミスを返します。
var usernamesPromise = Ember.$.getJSON('/usernames.json');

usernamesPromise.then(fetchPhotosOfUsers)
                .then(applyInstagramFilters)
                .then(uploadTrendyPhotoAlbum)
                .then(displaySuccessMessage, handleErrors);
```

上記の例では、もし`fetchPhotosOfUsers`　`applyInstagramFilters`　`uploadTrendyPhotoAlbum`のいずれかのメソッドがプロミスのリジェクトを返したら、`handleErrors`が失敗の理由とともに呼び出されます。 このようにして、プロミスはコールバックが右に深くなっていくのを回避して、アプリケーションの非同期のロジックへのアプローチを容易にするtry-catchステートメントが行う非同期の方法に似ています。

このガイドはプロミスを利用できる様々な方法を全て深堀することはしません、しかし[RSVP](https://github.com/tildeio/rsvp.js)のreadmeを見れば、より深くプロミスを紹介しています。

### プロミスのためのルーターの停止

Ember router (Ember ルーター)は route (ルート)間の transitio (遷移)では、transitio (遷移)の完了時にroute (ルート)の controller (コントラーラ)に渡される、models (モデル) (`model` hook (モデルフック)経由で)を回収します。 もし`model` hook (または、関連する `beforeModel` あるいは`afterModel` hooks) が通常のオブジェクト(プロミスではない) を返した場合は、transition (遷移) は即座に完了します。 しかし、もし`model` hook (`モデル` フック) (あるいは、関係のある `beforeModel` hook (`ビフォーモデル` フック) または、<0>afterModel</0> hook (<0>アフターモデル</0> フック) ) がプロミス (あるいは、<0>transitionTo</0>の要素として、プロミスが提供された場合) を返した場合、 transition (遷移) はプロミスが、成功またはリジェクトされるまで一時停止します。

router (ルーター) は`then()`メソッドで定義されているものを、 promise (プロミス) であると判断します。 

promise (プロミス) が成功した場合、 transition (遷移) が中断していたところから再開し、次の (子) route (ルート) の model (モデル) を解決します、次が promise (プロミス) の場合は一旦中断をする、この一連の動きを繰り返し全ての route model(ルート モデル) が解決されるまで繰り返します。 各 route (ルート) に渡される[`setupController()`](http://emberjs.com/api/classes/Ember.Route.html#method_setupController) hook <0>setupController()</0> hook (<0>セットアップコントローラー</0> フック) の値は、成功した promise (プロミス) の値になります。

簡単な例:

```app/routes/tardy.js export default Ember.Route.extend({ model() { return new Ember.RSVP.Promise(function(resolve) { Ember.run.later(function() { resolve({ msg: 'Hold Your Horses' }); }, 3000); }); },

setupController(controller, model) { console.log(model.msg); // "Hold Your Horses" } });

    <br />When transitioning into `route:tardy`, the `model()` hook will be called and
    return a promise that won't resolve until 3 seconds later, during which time
    the router will be paused in mid-transition. When the promise eventually
    fulfills, the router will continue transitioning and eventually call
    `route:tardy`'s `setupController()` hook with the resolved object.
    
    This pause-on-promise behavior is extremely valuable for when you need
    to guarantee that a route's data has fully loaded before displaying a
    new template.
    
    ### Promises (プロミス)がリジェクトされたとき...
    
    すでに、promise (プロミス)が成功したときについては紹介しましたが、リジェクトされた場合はどうでしょうか？
    
    デフォルトで、transition (遷移)中に、model promise (モデル プロミス)がリジェクトされると、transition (遷移)は中止されます、新しく対象のroute templates (ルート テンプレート)が描画されることはありません、そしてコンソールにエラーが出力されます。
    
    この、エラーハンドリングのロジックは、route (ルート)の`actions` hash (アクションハッシュ)の`error` handler (エラーハンドラー)経由で設定できます。 プロミスが拒否すると、ルートで`error` イベントが発生しカスタムエラーハンドラーで処理しないがぎり、`route:application`'のデフォルトのエラーハンドラーまで遡ります、例:
    
    ```app/routes/good-for-nothing.js
    export default Ember.Route.extend({
      model() {
        return Ember.RSVP.reject("FAIL");
      },
    
      actions: {
        error(reason) {
          alert(reason); // "FAIL"
    
          // Can transition to another route here, e.g.
          // this.transitionTo('index');
    
          // Uncomment the line below to bubble this error event:
          // return true;
        }
      }
    });
    

上記の例では、error event (エラーイベント)は`route:good-for-nothing`の error handler (エラーハンドラー)で止まり、上昇していくのは止まります。 `route:application`まで、イベントの上昇を続けるにはerror handler (エラーハンドラー)からtrueを返すことで可能になります。

### リジェクトからの回復

モデルのプロミスがリジェクトされた場合遷移は中断されますが、プロミスは連結することができため、プロミスのリジェクトを`モデル`フック自身で受け取り、遷移を中断しない成功として遷移の中断が発生しないように成功に変換することができます。

    app/routes/funky.js
    export default Ember.Route.extend({
      model() {
        return iHopeThisWorks().catch(function() {
          // Promise rejected, fulfill with some default value to
          // use as the route's model and continue on with the transition
          return { msg: 'Recovered from rejected promise' };
        });
      }
    });