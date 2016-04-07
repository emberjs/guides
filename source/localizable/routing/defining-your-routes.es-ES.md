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

## Rutas Anidadas

A menudo desearás tener una plantilla que se muestra dentro de otra plantilla. Por ejemplo, en una aplicación de blogging, en vez de ir de una lista de blogs para crear una nueva entrada, talvez quieres que la pantalla de creación de entrada este al lado de la lista.

En estos casos, puedes utilizar rutas anidadas para mostrar una plantilla dentro de otra.

Puedes definir rutas anidadas pasando una retrollamada a `this.route`:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />Y luego añade el ayudante '{{outlet}}' a tu plantilla donde deseas que la plantilla anidada sea mostrada: 
    ```templates/posts.hbs
    <h1> Posts </h1>
    <!--Muestra las entradas y otro contenido--> 
    {{outlet}}
    

El router crea una ruta para `/posts` y una para `posts/new`. Cuando un usuario visita `/posts`, simplemente verá la plantilla `posts.hbs`. (En la sección, [Rutas Índice](#toc_index-routes) se explica una adición importante a esto). Cuando el usuario visita `posts/new`, verá la plantilla de `posts/new.hbs` en el `{{outlet}}` de la plantilla de `posts`.

El nombre de la ruta anidada incluye los nombres de sus antepasados. Si quieres hacer una transición a una ruta (ya sea usando `transitionTo` o `{{#link-to}}`), asegúrate de utilizar el nombre completo de la ruta (`posts.new`, no `new`).

## La Ruta de la Aplicación

La ruta de la `aplicación` es ingresada cuando la aplicación arranca por primera vez. Como otras rutas, cargará la plantilla con el mismo nombre (`aplicación` en este caso) predeterminadamente. Debes de poner tu encabezado, pie de página y cualquier otro contenido decorativo aquí. Todas las otras rutas producirán sus plantillas en el `{{outlet}}` de la plantilla `application.hbs`.

Esta ruta es parte de cada aplicación, por lo cual no necesitas especificar en tu `app/router.js`.

## Rutas de Índice

En cada nivel de anidamiento (incluyendo el nivel superior), Ember proporciona automáticamente una ruta para el camino `/` llamada `index`.

Por ejemplo, si escribes un router simple como este:

```app/router.js Router.map(function(){ this.route('favorites'); });

    <br />Es el equivalente de: 
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('favorites');
    });
    

La plantilla `index` sera producida en el `{{outlet}}` de la plantilla `application`. Si el usuario navega a `/favorites`, Ember reemplazará a la plantilla de `index` con la plantilla de `favorites`.

Un router anidado como este:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('favorites'); }); });

    <br />Es el equivalente de:
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('posts', function() {
        this.route('index', { path: '/' });
        this.route('favorites');
      });
    });
    

Si el usuario navega a `/posts`, la ruta actual será `posts.index`, y la plantilla `posts/index` será mostrada en el `{{outlet}}` de la plantilla de `posts`.

Si el usuario luego navega a `/posts/favorites`, Ember reemplazará el `{{outlet}}` en la plantilla de `posts` con la plantilla de `posts/favorites`.

## Segmentos Dinámicos

Una de las responsabilidades de la ruta es cargar un modelo.

Por ejemplo, si tenemos la ruta `this.route('posts');` nuestra ruta podría cargar todos las entradas del blog para la aplicación.

Porque `/posts` representa un modelo determinado, no necesitamos información adicional para saber qué extraer. Sin embargo, si queremos una ruta para representar una sola entrada, no queremos tener que codificar cada posible entrada en el router.

Para esto usamos *segmentos dinámicos*.

Un segmento dinámico es una porción de la dirección URL que empieza con un `:` y es seguida por un identificador.

```app/router.js Router.map(function() { this.route('posts'); this.route('post', { path: '/post/:post_id' }); });

    <br />Si el usuario navega a ' post/5 ', la ruta tendrá en `post_id` el valor de `5` para cargar la entrada correcta. En la siguiente sección, [Especificando el Modelo de una Ruta] (../specifying-a-routes-model), aprenderás más acerca de cómo cargar un modelo.
    
    ## Comodín / Rutas Globales
    
    Puedes definir rutas comodín que coincidirán con varios segmentos de la URL. Esto podría utilizarse, por ejemplo, si deseas una ruta de comodín que es útil cuando el usuario introduce una URL incorrecta no gestionada por tu aplicación.
    
    ```app/router.js
    Router.map(function() {
      this.route('page-not-found', { path: '/*wildcard' });
    });
    

## Manejadores de Rutas

Para que tu ruta haga algo más allá que producir una plantilla con el mismo nombre, tendrás que create un manejador de ruta. Las siguientes guías explorarán las funciones de manejadores de ruta. Para más información sobre rutas, consulte la documentación de la API para [el router](http://emberjs.com/api/classes/Ember.Router.html) y para [manejadores de ruta](http://emberjs.com/api/classes/Ember.Route.html).