Uma das funções da rota (route) é renderizar o template correto.

Por padrão, o handler de uma rota vai renderizar a template que tenha o mesmo nome da rota sendo acessada. Para fins de exemplo, considere este router:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />Aqui, a rota `posts` vai renderizar a template `posts.hbs`, e a rota `posts.new` vai renderizar `posts/new.hbs`.
    
    Cada template sera renderizado dentro do `{{outlet}}` na template da rota anterior na hierarquia. Por exemplo, a template da rota `posts.new` vai ser renderizada dentro do `{{outlet}}` da template `posts.hbs`, e a template da rota `posts` vai ser renderizada dentro do `{{outlet}}` da template `application.hbs`.
    
    Se você precisa renderizar um template diferente do convencional, basta definir a propriedade da rota (route) [`templateName`][1] para o nome do template que você quer renderizar.
    
    ```app/routes/posts.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      templateName: 'posts/favorite-posts'
    });
    

Você pode sobrescrever a função [`renderTemplate()`](http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate) se você precisa de mais controle na renderização. Entre outras coisas, isso permite você escolher o controller usado para configurar o template e especificar o outlet.