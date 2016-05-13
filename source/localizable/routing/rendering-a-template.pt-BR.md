Uma das funções do handler de uma rota é renderizar a template correta.

Por padrão, o handler de uma rota vai renderizar a template que tenha o mesmo nome da rota sendo acessada. Para fins de exemplo, considere este router:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />Aqui, a rota `posts` vai renderizar a template `posts.hbs`, e a rota `posts.new` vai renderizar `posts/new.hbs`.
    
    Cada template sera renderizado dentro do `{{outlet}}` na template da rota anterior. For example, the `posts.new` route will render its template into the
    `posts.hbs`'s `{{outlet}}`, and the `posts` route will render its template into
    the `application.hbs`'s `{{outlet}}`.
    
    If you want to render a template other than the default one, implement the
    [`renderTemplate()`][1] hook:
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate
    
    ```app/routes/posts.js
    export default Ember.Route.extend({
      renderTemplate() {
        this.render('favoritePosts');
      }
    });