One job of a route handler is rendering the appropriate template to the screen.

Por padrão, o handler de uma rota vai renderizar a template que tenha o mesmo nome da rota sendo acessada. Para fins de exemplo, considere este router:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />Aqui, a rota `posts` vai renderizar a template `posts.hbs`, e a rota `posts.new` vai renderizar `posts/new.hbs`.
    
    Cada template sera renderizado dentro do `{{outlet}}` na template da rota anterior na hierarquia. Por exemplo, a template da rota `posts.new` vai ser renderizada dentro do `{{outlet}}` da template `posts.hbs`, e a template da rota `posts` vai ser renderizada dentro do `{{outlet}}` da template `application.hbs`.
    
    If you want to render a template other than the default one, set the route's [`templateName`][1] property to the name of
    the template you want to render instead.
    
    ```app/routes/posts.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      templateName: 'posts/favorite-posts'
    });
    

You can override the [`renderTemplate()`](http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate) hook if you want finer control over template rendering. Among other things, it allows you to choose the controller used to configure the template and specific outlet to render it into.