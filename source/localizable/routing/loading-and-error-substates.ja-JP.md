Emberルーターはルータが読み込みでエラーが発生した時だけではなく、ルートが読み込み中のときもフィードバックを提供することができます。

## `ローディング`サブステート

`beforeModel` フック、 `model`フックそして `afterModel`フックのが行われる間、データの読み込みに時間がかることがあります。 技術的には、ルーターは各フックのプロミスが満たされるまで、遷移を停止しています。

次のことを検討してください。

```app/router.js Router.map(function() { this.route('slow-model'); });

    <br />```app/routes/slow-model.js
    export default Ember.Route.extend({
      model() {
        return this.store.findAll('slowModel');
      }
    });
    

`モデル` フックの`スローモデル`に遷移したとき、クエリーの完了に時間がかかることがあります。 この間、UIは何が起こっているのかをフィードバックすることはありません。 ページ全体をリフレッシュしたその後に、このルートを入力しているとき、ルートの入力が完全に完了していなく、テンプレートがまだ表示されていないため、UIには何も表示されていません。 もしたのルートから`slow-model`から遷移してきたたとして、モデルの読み込みが完了して、突然、`slow-model`のテンプレートが表示されるまでは事前のルータのテンプレートが表示されたままです。

では、このような遷移の途中でどのようなフードバックを提供することができるでしょうか。

単にEmberが遷移する、`loading` という名称のテンプレート(それに該当するルートを定義することも可能です) を定義することです 読み込み時の、サブステータスへの遷移は即時に行われますが(同期的に)、URLは更新されません、また、他の遷移とは違い、現在のアクティブな遷移は中断されません。

`slow-model`への遷移がが完了すると、`loading` ルートが終了されます、`slow-model`の遷移が続行されます。

ネストされたルートの場合は次のようになります:

```app/router.js Router.map(function() { this.route('foo', function() { this.route('bar', function() { this.route('slow-model'); }); }); });

    <br />Ember は代わりに`foo.bar.slow-model-loading`で始まる階層から`ルータの名前の付いたloading`もしくは`loading`を探します。:
    
    1. `foo.bar.slow-model-loading`
    2. `foo.bar.loading` or `foo.bar-loading`
    3. `foo.loading` または`foo-loading`
    4. `loading` もしくは`アプリケーションloading`
    
    Ember 自身は`slow-model` から`slow-model.loading` テンプレートを探そうとはせず、階層の構文として許されているものを探すことは重要なので指摘しておきます。 これは`slow-model`のような末端のルートでロード画面を表示することが可能になるので、有効です。
    
    ### `読み込み` イベント
    
    もし`beforeModel`/`model`/`afterModel` などのフックが即座に解決できない場合、そのルートで [`loading`][1] イベントが発生します。
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#event_loading
    
    ```app/routes/foo-slow-model.js
    export default Ember.Route.extend({
      model() {
        return this.store.findAll('slowModel');
      },
      actions: {
        loading(transition, originRoute) {
          let controller = this.controllerFor('foo');
          controller.set('currentlyLoading', true);
        }
      }
    });
    

もし、特定のルートで`読み込み` ハンドラーが定義されていなかった場合、 イベントは遷移の親ルートを遡り、`application` ルートがそのイベントを管理する機会を提供します。

この`読み込み` ハンドラーを利用する場合、遷移プロミスを利用して、いつ読み込みイベントが完了したかを把握することができます:

```app/routes/foo-slow-model.js export default Ember.Route.extend({ ... actions: { loading(transition, originRoute) { let controller = this.controllerFor('foo'); controller.set('currentlyLoading', true); transition.promise.finally(function() { controller.set('currentlyLoading', false); }); } } });

    <br />## `エラー` サブステート
    
    Ember はエラーが発生した場合、`読み込み` サブステートに類似したアプローチを提供しています。
    
    デフォルト`loading` イベントハンドラー 実装されているように、デフォルト `error` ハンドラー 遷移すべきするのに適した error サブステータス を探します。
    
    ```app/router.js
    Router.map(function() {
      this.route('articles', function() {
        this.route('overview');
      });
    });
    

`loading` サブステートと同様、`articles.overview`ルートの`モデル`フックか(もしくは`beforeModel` または `afterModel`)らエラーを投げるまたは、プロミスが帰ってこなかった、場合あ Ember はエラーテンプレートまたは次の順番で、ルートを探します。

  1. `articles.overview-error`
  2. `articles.error` または `articles-error`
  3. `error` または `application-error`

上記のうち一つが見つかればルーターはすぐにそのサブステートに遷移します (URLは更新されません)。 エラーの"理由" (例　例外が投げられた、プロミスが値を拒否した)が `モデル`としてエラーステートに渡されます。.

もし、実行可能なエラーサブステートが見つからない場合は、エラーメッセージは記録されます。

### `error` イベント

もし`articles.overview` ルータの `モデル` フック がプロミス拒否で返したら、(例えば、サーバーがエラーを返した、ユーザーがログインしていないなど)、そのルートから、上位のルートに向かって[`エラー`](http://emberjs.com/api/classes/Ember.Route.html#event_error) イベントが発生します。 この`エラー` イベントはログインページへのリダイレクト処理と、エラーメッセージの表示といったように利用できます。

    app/routes/articles-overview.js
    export default Ember.Route.extend({
      model(params) {
        return this.store.findAll('problematicModel');
      },
      actions: {
        error(error, transition) {
          if (error) {
            return this.transitionTo('errorPage');
          }
        }
      }
    });

`読み込み` イベントと同様、複数のルートに同じコードの重複を避けるために `エラー` イベントを管理できます。