ルートハンドラの役割の一つは、画面に適切なテンプレートを描画することです。

デフォルトで、ルートハンドラはルートと同じ名前のテンプレートを描画します。例えば

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />ここでは`posts` ルートは`posts.hbs`テンプレートをそして、`posts.new`ルートは`posts/new.hbs`テンプレートを描画します。
    
    それぞれのテンプレートは親ルールのテンプレとにある`{{outlet}}`内に描画されます。 例えば`posts.new` ルートは`posts.hbs`の`{{outlet}}`に、 `posts` ルートは`application.hbs`'の`{{outlet}}`にそれぞれ、描画します。
    
    デフォルトのテンプレート以外を描画したい場合は[`renderTemplate()`][1] フックをインプリメントしてください:
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate
    
    ```app/routes/posts.js
    export default Ember.Route.extend({
      renderTemplate() {
        this.render('favoritePosts');
      }
    });