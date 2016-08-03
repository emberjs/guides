Ember Router (ルーター)はルータが読み込みでエラーが発生した時だけではなく、route (ルート)が読み込み中のときでもフィードバックを提供することができます。

## `loading` substates ( ローディング サブステート)

`beforeModel` フック、 `model`フックそして `afterModel`フックのが行われる間、データの読み込みに時間がかることがあります。 技術的には、ルーターは各フックのpromises (プロミス)が満たされるまで、遷移を停止しています。

次のことを検討してください。

```app/router.js Router.map(function() { this.route('slow-model'); });

    <br />```app/routes/slow-model.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.get('store').findAll('slow-model');
      }
    });
    

`モデル` フックの`スローモデル`に遷移したとき、クエリーの完了に時間がかかることがあります。 この間、UIは何が起こっているのかをフィードバックすることはありません。 ページ全体をリフレッシュしたその後に、このルートを入力しているとき、ルートの入力が完全に完了していなく、テンプレートがまだ表示されていないため、UIには何も表示されていません。 もしたのルートから`slow-model`から遷移してきたたとして、モデルの読み込みが完了して、突然、`slow-model`のテンプレートが表示されるまでは事前のルータのテンプレートが表示されたままです。

では、このような遷移の途中でどのようなフードバックを提供することができるでしょうか。

単にEmberが遷移する、`loading` という名称のテンプレート(それに該当するルートを定義することも可能です) を定義することです 読み込み時の、サブステータスへの遷移は即時に行われますが(同期的に)、URLは更新されません、また、他の遷移とは違い、現在のアクティブな遷移は中断されません。

`slow-model`への遷移がが完了すると、`loading` ルートが終了されます、`slow-model`の遷移が続行されます。

ネストされたルートの場合は次のようになります:

```app/router.js Router.map(function() { this.route('foo', function() { this.route('bar', function() { this.route('slow-model'); }); }); });

    <br />`foo.bar.slow-model` route (ルート)にアクセスしている時、Ember 代わりに`routeName-loading` または `loading` template を`foo.bar.slow-model-loading`で始まる回答から、探します:
    
    1. `foo.bar.slow-model-loading`
    2. `foo.bar.loading` or `foo.bar-loading`
    3. `foo.loading` または`foo-loading`
    4. `loading` もしくは `application-loading`
    
    `slow-model`について、次のことに注意してください、Emberは`slow-model.loading` templateを探すことはしませんが、それ以外の階層のうどの構文としても許容されます。 これは`slow-model`のような末端のルートでロード画面を表示することが可能になるので、有効です。
    
    `foo.bar` route (ルート)にアクセスをすると、 Ember は次のものを探します:
    
    1. `foo.bar-loading`
    2. `foo.loading` または `foo-loading`
    3. `loading` または `application-loading`
    
    現段階では`foo.bar.loading` は考慮されていないことに注意してください。
    
    ### `loading` event (ローディングイベント)
    
    もし、複数の `beforeModel`/`model`/`afterModel` hooks
    がすぐに解決されない時は route (ルート)で [`loading`][1] イベンントが発生します。
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#event_loading
    
    ```app/routes/foo-slow-model.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.get('store').findAll('slow-model');
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

```app/routes/foo-slow-model.js import Ember from 'ember';

export default Ember.Route.extend({ ... actions: { loading(transition, originRoute) { let controller = this.controllerFor('foo'); controller.set('currentlyLoading', true); transition.promise.finally(function() { controller.set('currentlyLoading', false); }); } } });

    <br />## `エラー` サブステート
    
    Ember はエラーが発生した場合、`読み込み` サブステートに類似したアプローチを提供しています。
    
    デフォルト`loading` イベントハンドラー 実装されているように、デフォルト `error` ハンドラー 遷移すべきするのに適した error サブステータス を探します。
    
    ```app/router.js
    Router.map(function() {
      this.route('articles', function() {
        this.route('overview');
      });
    });
    

As with the `loading` substate, on a thrown error or rejected promise returned from the `articles.overview` route's `model` hook (or `beforeModel` or `afterModel`) Ember will look for an error template or route in the following order:

  1. `articles.overview-error`
  2. `articles.error` または `articles-error`
  3. `error` または `application-error`

If one of the above is found, the router will immediately transition into that substate (without updating the URL). The "reason" for the error (i.e. the exception thrown or the promise reject value) will be passed to that error state as its `model`.

The model hooks (`beforeModel`, `model`, and `afterModel`) of an error substate are not called. Only the `setupController` method of the error substate is called with the `error` as the model. See example below:

```js
setupController: function(controller, error) {
  Ember.Logger.debug(error.message);
  this._super(...arguments);
}
```

If no viable error substates can be found, an error message will be logged.

### `error` イベント

If the `articles.overview` route's `model` hook returns a promise that rejects (for instance the server returned an error, the user isn't logged in, etc.), an [`error`](http://emberjs.com/api/classes/Ember.Route.html#event_error) event will fire from that route and bubble upward. This `error` event can be handled and used to display an error message, redirect to a login page, etc.

```app/routes/articles-overview.js import Ember from 'ember';

export default Ember.Route.extend({ model(params) { return this.get('store').findAll('problematic-model'); }, actions: { error(error, transition) { if (error) { return this.transitionTo('error-page'); } } } }); ```

Analogous to the `loading` event, you could manage the `error` event at the application level to avoid writing the same code for multiple routes.