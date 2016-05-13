Uma das funções do handler de uma rota é renderizar a template correta.

Por padrão, o handler de uma rota vai renderizar a template que tenha o mesmo nome da rota sendo acessada. Para fins de exemplo, considere este router:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />Aqui, a rota `posts` vai renderizar a template `posts.hbs`, e a rota `posts.new` vai renderizar `posts/new.hbs`.
    
    Cada template sera renderizado dentro do `{{outlet}}` na template da rota anterior na hierarquia. Por exemplo, a template da rota `posts.new` vai ser renderizada dentro do `{{outlet}}` da template `posts.hbs`, e a template da rota `posts` vai ser renderizada dentro do `{{outlet}}` da template `application.hbs`.
    
    Se você quer renderizar uma template diferente da que seria utilizada por padrão, você precisa implementar o método [1] ['renderTemplate ()']: 
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate
    
    ```app/routes/posts.js
    export default Ember.Route.extend({
      renderTemplate() {
        this.render('favoritePosts');
      }
    });