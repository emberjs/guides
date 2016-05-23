Quando seu aplicativo for iniciado, o roteador compara com a URL com as *rotas* que você definiu. As rotas, por sua vez, são responsáveis por renderizar as templates, carregar os dados, e definir o estado do seu aplicativo.

## Basic Routes

O método [`map()`](http://emberjs.com/api/classes/Ember.Router.html#method_map) do roteador do seu aplicativo Ember pode ser invocado para definir mapeamentos de URL. Ao chamar `map()`, você deve passar uma função que será invocada com o valor de `this` sendo um objeto que você pode usar para criar rotas.

```app/router.js Router.map(function() { this.route('about', { path: '/about' }); this.route('favorites', { path: '/favs' }); });

    <br />Agora, quando o usuario visitar `/about`, Ember vai renderizar a template`about`. Visitar `/favs` irá renderizar a template `favorites`.
    
    Voce pode omitir path se o nome da template tem o mesmo nome da rota. ```app/router.js
    Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
    });
    

Dentro de suas templates, voce pode usar [`{{link-to}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_link-to) para navegar entre as rotas, usando o nome que voce definiu no método `route`.

```handlebars
{{#link-to "index"}}<img class="logo">{{/link-to}}

<nav>
  {{#link-to "about"}}About{{/link-to}}
  {{#link-to "favorites"}}Favorites{{/link-to}}
</nav>
```

O helper `{{link-to}}` tambem ira adicionar a classe `active` ao link que aponta para a rota atual.

Rotas com nomes compostos por múltiplas palavras, por convenção terão endereços também separados por hífen, por exemplo:

```app/router.js Router.map(function() { this.route('blog-post', { path: '/blog-post' }); });

    <br />A rota definida acima, por padrão, vai utilizar o handler `blog-post.js`, a template `blog-post.hbs`, e qualquer `{{link-to}}` helper vai utilizar `blog-post` para referencia-la.
    
    Rotas com nomes composts de varias palavras quebram esta convenção, como este:
    
    ```app/router.js
    Router.map(function() {
      this.route('blog_post', { path: '/blog-post' });
    });
    

irão, ainda por padrão, usar o handler `blog-post.js` e a template `blog-post.hbs`, mas o helper `{{link-to}}` vai referencia-la como `blog_post`.

## Rotas Embutidas

Muitas vezes você vai querer que uma template seja exibida dentro de outra template. Por exemplo, em um blog, ao invés de ir de uma lista de posts para a criação de um novo post, voce pode querer que a pagina de criação de posts seja exibida ao lado da lista.

Nesses casos, você pode usar rotas embutidas para exibir uma template dentro de outra.

Você pode definir rotas embutidas passando um novo callback para `this.route`:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />E adicionar um helper`{{outlet}}` em sua template onde você quer que a rota seja exibida:
    
    ```templates/posts.hbs
    <h1>Posts</h1>
    <!-- Display posts and other content -->
    {{outlet}}
    

Este router cria uma rota para `/posts` e `/posts/new`. Quando um usuario visita `/posts`, ele ve apenas a template `posts.hbs`. (Abaixo, em [index routes](#toc_index-routes) há explicação adiciona importante sobre isso.) Quando um usuário visita `posts/new`, ele vera a template `posts/new.hbs` exibida dentro do `{{outlet}}` da template de `posts`.

O nome de uma rota embutida inclui o nome de suas rotas antecessoras. Se você quer fazer a transição para uma rota (via `transitionTo` ou `{{#link-to}}`), certifique-se de usar o nome completo de sua rota (`posts.new`, não é `new`).

## A rota application

A rota `application` é inserida quando seu aplicativo é inicializado. Assim como outras rotas, ela irá carregar uma template com o mesmo nome (`application` neste caso) por padrão. Você deve colocar o seu cabeçalho, rodapé e qualquer outro conteúdo decorativo nesta template. Todas as outras rotas serao exibidas dentro do `{{outlet}}` da template `application.hbs`.

Esta rota faz parte de todos os aplicativos, portanto você não precisa especifica-la em `app/router.js`.

## Rotas Index

At every level of nesting (including the top level), Ember automatically provides a route for the `/` path named `index`. To see when a new level of nesting occurs, check the router, whenever you see a `function`, that's a new level.

For example, if you write a simple router like this:

```app/router.js Router.map(function(){ this.route('favorites'); });

    <br />É o equivalente a:
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('favorites');
    });
    

A template `index` será exibida dentro do `{{outlet}}` na template `application`. Se o usuário navega para `/favorites`, Ember substituirá a template `index` com a template `favorites`.

Um router com rotas embutidas como este:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('favorites'); }); });

    <br />É o equivalente a:
    
    ```app/router.js 
    Router.map(function() {
        this.route ('index', {path: '/'});   
        this.route ('posts', function() {
            this.route ('index', {path: '/'});
            this.route('favorites');
         });
     });
    

If the user navigates to `/posts`, the current route will be `posts.index`, and the `posts/index` template will be rendered into the `{{outlet}}` in the `posts` template.

Se o usuário navega para `/posts/favorites`, Ember vai substituir o `{{outlet}}` da template `posts`, com a template `posts/favorites`.

## Dynamic Segments

One of the responsibilities of a route is to load a model.

For example, if we have the route `this.route('posts');`, our route might load all of the blog posts for the app.

Because `/posts` represents a fixed model, we don't need any additional information to know what to retrieve. However, if we want a route to represent a single post, we would not want to have to hardcode every possible post into the router.

Enter *dynamic segments*.

A dynamic segment is a portion of a URL that starts with a `:` and is followed by an identifier.

```app/router.js Router.map(function() { this.route('posts'); this.route('post', { path: '/post/:post_id' }); });

    <br />If the user navigates to `/post/5`, the route will then have the `post_id` of
    `5` to use to load the correct post.
    Ember follows the convention of `:model-name_id` for two reasons.
    The first reason is that Routes know how to fetch the right model by default, if you follow the convention.
    The second is that `params` is an object, and can only have one value associated with a key.
    To put it in code, the following will *not* work properly:
    
    ```app/router.js
    Router.map(function() {
      this.route("photo", { path: "photo/:id" }, function() {
        this.route("comment", { path: "comment/:id" });
      });
    });
    

But the following will:

```app/router.js Router.map(function() { this.route("photo", { path: "photo/:photo_id" }, function() { this.route("comment", { path: "comment/:comment_id" }); }); });

    <br />In the next section, [Specifying a Route's Model](../specifying-a-routes-model), you will learn more about how to load a model.
    
    ## Wildcard / globbing routes
    
    You can define wildcard routes that will match multiple URL segments. This could be used, for example,
    if you'd like a catch-all route which is useful when the user enters an incorrect URL not managed
    by your app.
    
    ```app/router.js
    Router.map(function() {
      this.route('page-not-found', { path: '/*wildcard' });
    });
    

## Route Handlers

To have your route do something beyond render a template with the same name, you'll need to create a route handler. The following guides will explore the different features of route handlers. For more information on routes, see the API documentation for [the router](http://emberjs.com/api/classes/Ember.Router.html) and for [route handlers](http://emberjs.com/api/classes/Ember.Route.html).