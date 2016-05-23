Cuando se inicia tu aplicación, el Router coincide la URL actual a las *rutas* que has definido. Las rutas, a su vez, son responsables de mostrar plantillas, cargar datos, y también establecer el estado de la aplicación.

## Rutas Básicas

El método [`map()`](http://emberjs.com/api/classes/Ember.Router.html#method_map) del router de la aplicación de Ember puede ser invocado para definir las asignaciones de las direcciones URL. Al invocar `map()`, debes pasar a una función que se invoca con el valor `this` asignado a un objeto que se puede utilizar para crear rutas.

```app/router.js Router.map(function() { this.route('about', { path: '/about' }); this.route('favorites', { path: '/favs' }); });

    <br />Ahora, cuando el usuario visita '/about', Ember producirá la plantilla llamada 'about'. Si visitas '/favs' la plantilla de 'favorites' será producida.
    
    Puedes omitir el camino 'path' si es igual que el nombre de la ruta. En este caso, lo siguiente es equivalente al ejemplo anterior: 
    
    ```app/router.js
    Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
    });
    

Dentro de tus plantillas, puedes utilizar [`{{link-to}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_link-to) para navegar entre rutas, usando el nombre que has proporcionado en el método de la `ruta`.

```handlebars
{{#link-to "index"}}<img class="logo">{{/link-to}}

<nav>
  {{#link-to "about"}}About{{/link-to}}
  {{#link-to "favorites"}}Favorites{{/link-to}}
</nav>
```

El ayudante `{{link-to}}` también agregará la clase `active` al enlace que señala a la ruta activa.

Multi-word route names are conventionally dasherized, such as:

```app/router.js Router.map(function() { this.route('blog-post', { path: '/blog-post' }); });

    <br />The route defined above will by default use the `blog-post.js` route handler,
    the `blog-post.hbs` template, and be referred to as `blog-post` in any
    `{{link-to}}` helpers.
    
    Multi-word route names that break this convention, such as:
    
    ```app/router.js
    Router.map(function() {
      this.route('blog_post', { path: '/blog-post' });
    });
    

will still by default use the `blog-post.js` route handler and the `blog-post.hbs` template, but will be referred to as `blog_post` in any `{{link-to}}` helpers.

## Rutas Anidadas

Often you'll want to have a template that displays inside another template. For example, in a blogging application, instead of going from a list of blog posts to creating a new post, you might want to have the post creation page display next to the list.

In these cases, you can use nested routes to display one template inside of another.

You can define nested routes by passing a callback to `this.route`:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />And then add the `{{outlet}}` helper to your template where you want the nested
    template to display:
    
    ```templates/posts.hbs
    <h1>Posts</h1>
    <!-- Display posts and other content -->
    {{outlet}}
    

This router creates a route for `/posts` and for `/posts/new`. When a user visits `/posts`, they'll simply see the `posts.hbs` template. (Below, [index routes](#toc_index-routes) explains an important addition to this.) When the user visits `posts/new`, they'll see the `posts/new.hbs` template rendered into the `{{outlet}}` of the `posts` template.

A nested route's names includes the names of its ancestors. If you want to transition to a route (either via `transitionTo` or `{{#link-to}}`), make sure to use the full route name (`posts.new`, not `new`).

## La Ruta de la Aplicación

The `application` route is entered when your app first boots up. Like other routes, it will load a template with the same name (`application` in this case) by default. You should put your header, footer, and any other decorative content here. All other routes will render their templates into the `application.hbs` template's `{{outlet}}`.

This route is part of every application, so you don't need to specify it in your `app/router.js`.

## Rutas de Índice

At every level of nesting (including the top level), Ember automatically provides a route for the `/` path named `index`. To see when a new level of nesting occurs, check the router, whenever you see a `function`, that's a new level.

For example, if you write a simple router like this:

```app/router.js Router.map(function(){ this.route('favorites'); });

    <br />It is the equivalent of:
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('favorites');
    });
    

The `index` template will be rendered into the `{{outlet}}` in the `application` template. If the user navigates to `/favorites`, Ember will replace the `index` template with the `favorites` template.

A nested router like this:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('favorites'); }); });

    <br />Is the equivalent of:
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('posts', function() {
        this.route('index', { path: '/' });
        this.route('favorites');
      });
    });
    

If the user navigates to `/posts`, the current route will be `posts.index`, and the `posts/index` template will be rendered into the `{{outlet}}` in the `posts` template.

If the user then navigates to `/posts/favorites`, Ember will replace the `{{outlet}}` in the `posts` template with the `posts/favorites` template.

## Segmentos Dinámicos

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
    

## Manejadores de Rutas

To have your route do something beyond render a template with the same name, you'll need to create a route handler. The following guides will explore the different features of route handlers. For more information on routes, see the API documentation for [the router](http://emberjs.com/api/classes/Ember.Router.html) and for [route handlers](http://emberjs.com/api/classes/Ember.Route.html).