One job of a route handler is rendering the appropriate template to the screen.

デフォルトで、ルートハンドラはルートと同じ名前のテンプレートを描画します。例えば

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />ここでは`posts` ルートは`posts.hbs`テンプレートをそして、`posts.new`ルートは`posts/new.hbs`テンプレートを描画します。
    
    それぞれのテンプレートは親ルールのテンプレとにある`{{outlet}}`内に描画されます。 例えば`posts.new` ルートは`posts.hbs`の`{{outlet}}`に、 `posts` ルートは`application.hbs`'の`{{outlet}}`にそれぞれ、描画します。
    
    If you want to render a template other than the default one, set the route's [`templateName`][1] property to the name of
    the template you want to render instead.
    
    ```app/routes/posts.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      templateName: 'posts/favorite-posts'
    });
    

You can override the [`renderTemplate()`](http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate) hook if you want finer control over template rendering. Among other things, it allows you to choose the controller used to configure the template and specific outlet to render it into.