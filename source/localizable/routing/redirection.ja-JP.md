ルートから[`transitionTo()`](http://emberjs.com/api/classes/Ember.Route.html#method_transitionTo) を呼び出す、または [`transitionToRoute()`](http://emberjs.com/api/classes/Ember.Controller.html#method_transitionToRoute) をコントローラから呼び出すと、そのとき行われているすべての遷移は中断され、リダイレクトとして機能する新しい遷移が始まります。 [link-to](../../templates/links) ヘルパー`transitionTo()` は同様の動作を行います。

もし、新規のルートがダイナミックセグメントがある場合は、*model*か *identifier*のいずれかを各セグメントとして渡す必要があります。 モデルを渡す時は `model()` フックは(モデルがすでに読み込まれているため)スキップされます。

## モデルがわかる前の、遷移

あるルートから、他のルートにリダイレクトしたい場合、ルートハンドラーの[`beforeModel()`](http://emberjs.com/api/classes/Ember.Route.html#method_beforeModel)フックで遷移を実行することができます。

```app/router.js Router.map(function() { this.route('posts'); });

    <br />```app/routes/index.js
    export default Ember.Route.extend({
      beforeModel() {
        this.transitionTo('posts');
      }
    });
    

もし、アプリケーションの状態を確認して、どこにリダイレクトさせるか検討したい場合は[service](../../applications/services)を利用することができます。.

## モデルがわかる前の、遷移

もし現状のルートの情報がどのルートに遷移するのかを判断するのに必要なら[`afterModel()`](http://emberjs.com/api/classes/Ember.Route.html#method_afterModel) フックの情報を利用することができます。 第一引数としてモデルを、第二引数として遷移を第二引数として受け取ります。 例えば

```app/router.js Router.map(function() { this.route('posts'); this.route('post', { path: '/post/:post_id' }); });

    <br />```app/routes/posts.js
    export default Ember.Route.extend({
      afterModel(model, transition) {
        if (model.get('length') === 1) {
          this.transitionTo('post', model.get('firstObject'));
        }
      }
    });
    

`posts` ルートに遷移するとき、 postが一つしかないときは、現行の遷移は破棄され一つpost オブジェクトをモデルとする`PostRoute`を優先します。

### チャイルドルート

上記のルートをネストされたルートと次のように置き換えます。

```app/router.js Router.map(function() { this.route('posts', function() { this.route('post', { path: ':post_id' }); }); });

    <br />`afterModel` フックで`posts.post` にリダイレクトしたとき`afterModel`は基本的にこのルートに入ることを無効化します。 そうすることで`posts`ルートは`beforeModel`、`model`そして `afterModel` フックが再度、新規のリダイレクトされた遷移で起動されます。 これはリダイレクトの直前で起こるため、効率的ではありません。
    
    その代わりに [`redirect()`][5] メソッドを利用することができます、これは本来の遷移を有効なまま、親ルートフックが再度呼ばれることもありません。
    
    [5]: http://emberjs.com/api/classes/Ember.Route.html#method_redirect
    
    ```app/routes/posts.js
    export default Ember.Route.extend({
      redirect(model, transition) {
        if (model.get('length') === 1) {
          this.transitionTo('posts.post', model.get('firstObject'));
        }
      }
    });