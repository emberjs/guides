Los modelos son objetos que representan los datos de tu aplicación. Cada aplicación va a tener modelos únicos, dependiendo del tipo de problema.

Por ejemplo, una aplicación para compartir fotos tal vez podría tener un modelo `Foto` para representar a una sola foto y un modelo `AlbumDeFotos` que representa a un grupo de fotos. Por otro lado, una aplicación de ventas en línea podría tener modelos como `Carrito`, `Nota` o `Item`.

Los modelos suelen ser *persistentes*. Quiere decir que el usuario espera que los datos del modelo no se pierdan al cerrar la ventana del navegador. Para estar seguro de que los datos no se pierdan si el usuario realiza algún cambio a un modelo, hay que guardar los datos donde no se pierdan.

Por lo regular, los modelos se cargan y se guardan en un servidor que cuenta con una base de datos para almacenar datos. Generalmente envías los datos de los modelos en formato JSON desde y hacia un servidor HTTP que has preparado. Sin embargo, con Ember es fácil usar otros tipos de almacenamiento como guardar en disco duro del usuario usando [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API), o almacenamiento en la nube que te permiten evitar mantener y alojar tus propios servidores.

Una vez que has cargado tus modelos del almacenamiento, los componentes interpretan los datos de los modelos en una interfaz con la cual el usuario puede interactuar. Para más información acerca de cómo los componentes obtienen los datos de los modelos, consulta la guía de [Specifying a Route's Model](../routing/specifying-a-routes-model).

Ember Data, incluido de forma predeterminada cuando creas una nueva aplicación, es una librería que se integra estrechamente con Ember para que sea fácil de extraer modelos de su servidor en formato JSON, guardar actualizaciones al servidor, y crear nuevos modelos en el navegador.

Gracias a su uso del *adapter pattern*, se puede configurar Ember Data para que funcione con muchos tipos de backends. Hay [todo un "ecosistema" de adaptadores](http://emberobserver.com/categories/ember-data-adapters) que permite que tu aplicación de Ember comunique con diferentes tipos de servidores sin que escribir código de redes.

Si necesitas integrar tu aplicación de Ember.js con un servidor que no cuenta un adaptador disponible (por ejemplo, si tienes un servidor de API personalizado que no adhiere a cualquier especificación JSON), Ember Data está diseñado para ser configurable para funcionar con cualquier tipo de datos que regresa tu servidor.

Ember Data también está diseñado para funcionar con servidores de streaming, como los que utilizan WebSockets. Puedes abrir un socket a tu servidor y empujar cambios a Ember Data cada vez que ocurren, dando a tu aplicación una interfaz de usuario que siempre está actualizada en tiempo real.

Al principio, usar Ember Data puede parecer distinto de la manera que estás acostumbrado a escribir aplicaciones de JavaScript. Muchos desarrolladores están familiarizados con el uso de AJAX para extraer datos JSON desde un endpoint, que puede parecer fácil al principio. Sin embargo, con el tiempo, la complejidad entra en tu código, haciéndolo difícil de mantener.

Con Ember Data, administrar los modelos a medida que crece tu aplicación se vuelva sencillo *y* fácil.

Una vez que ya entiendes Ember Data, vas a tener una mejor manera para manejar la complejidad de la carga de datos en tu aplicación. Esto permitirá que tu código evolucione sin llegar a ser un desorden total.

## El Store (Almacen) y una Sola Fuente de Verdad

Una manera común de construir aplicaciones web es acoplar los elementos de la interfaz con la extracción de datos del servidor. Por ejemplo, imagina que estás escribiendo la parte de administración de una aplicación de blogging, que tiene una función que muestra una lista de los borradores para el usuario actualmente conectado.

Tal vez podrás tener la idea de darle al component la responsabilidad de extraer los datos y guardarlos:

```app/components/list-of-drafts.js export default Ember.Component.extend({ willRender() { $.getJSON('/drafts').then(data => { this.set('drafts', data); }); } });

    <br />Entonces podrías mostrar la lista de borradores en la plantilla de su component así: 
    
    '''app/templates/components/list-of-drafts.hbs 
    <ul>
      {{#each drafts key="id" as |draft|}}
        <li>{{draft.title}}</li>
      {{/each}}
    </ul>
    

Esto funciona muy bien para el component `list-of-drafts`. Sin embargo, tu aplicación probablemente tiene muchos componentes diferentes. En otra página tal vez quieres un componente para mostrar el número de borradores. Tal vez te ocurre copiar y pegar el código de `willRender` existente en el nuevo componente.

```app/components/drafts-button.js export default Ember.Component.extend({ willRender() { $.getJSON('/drafts').then(data => { this.set('drafts', data); }); } });

    <br />```app/templates/components/drafts-button.hbs
    {{#link-to 'drafts' tagName="button"}}
    Drafts ({{drafts.length}})
    {{/link-to}}
    

Lastimosamente, ahora el aplicación va a enviar dos solicitudes al servidor para la misma información. No sólo es costoso solicitar los datos redundantes en términos de ancho de banda desperdiciado y en la velocidad percibida de tu aplicación, también los dos valores fácilmente pueden quedar fuera de sincronización. Probablemente has usado un aplicación web donde la lista de elementos queda fuera de sincronización con el contador en la barra de herramientas, llegando a ser una experiencia frustrante e inconsistente.

Hay también un *acoplamiento estrecho* entre la interfaz de usuario de la aplicación y el código de red. Si la url o el formato del objeto JSON cambia, probablemente todos los componentes de interfaz de usuario se rompen en formas que son difíciles de identificar.

Los principios SOLID de buen diseño nos dicen que los objetos deben tener una sola responsabilidad. La responsabilidad de un componente debe presentar datos del modelo al usuario, no extraer el modelo del servidor.

Buenas aplicaciones de Ember lo hacen de otra manera. Ember Data te da una sola **store** que es el repositorio central de los modelos en tu aplicación. Los componentes y rutas pueden pedirle los modelos del store, y el store es responsable de saber encontrarlos.

También significa que el store puede detectar que dos componentes diferentes piden el mismo modelo, lo que permite tu app extraer los datos del servidor una sola vez. Puedes tomar el store como una caché de read-through para los modelos de tu app. Ambos tus componentes y rutas tienen acceso a este store compartido; cuando necesitan mostrar o modificar un modelo, primero lo piden del store.

## Convention Over Configuration with JSON API

Puedes reducir significativamente la cantidad de código que necesitas escribir y mantener, apoyándose en los convenios de Ember. Dado que estas costumbres se compartirán entre los desarrolladores de tu equipo, seguirlas tiene como resultado código que es más fácil de mantener y entender.

En lugar de crear un conjunto arbitrario de costumbres, Ember Data está diseñado para funcionar automáticamente con el [JSON API](http://jsonapi.org). JSON API es una especificación formal para construir los APIs convencionales, robustos, y de alto rendimiento que permiten a los clientes y servidores comunicarse con los datos de los modelos.

El JSON API estandariza cómo las aplicaciones JavaScript se comunican con los servidores, para reducir el acoplamiento entre el frontend y el backend, y así tienes más libertad para intercambiar las piezas de tu stack.

Como analogía, el JSON API es para las aplicaciones de JavaScript y servidores de API lo que SQL es para los frameworks del lado del servidor y las bases de datos. Frameworks populares como Ruby on Rails, Django, Laravel, Spring, y otros funcionan automáticamente con muchas bases de datos diferentes, como MySQL, PostgreSQL, SQL Server y otras.

Los frameworks (o los apps creadas con esos frameworks) no necesitan un montón de código personalizado para añadir soporte para una base de datos nueva; siempre que la base de datos sea compatible con SQL, añadir soporte para ella es relativamente fácil.

Así también con el JSON API. En utilizar el JSON API para la comunicación entre tu app de Ember y tu servidor, puedes cambiar tu stack de backend totalmente sin romper tu frontend. Y al agregar apps para otras plataformas, como iOS y Android, puedes aprovechar las librerías de JSON API para esas plataformas para utilizar fácilmente la misma API usada por tu app de Ember.

## Modelos

En Ember Data, cada modelo es representado por una subclase de `Model` que define los atributos, relaciones y comportamiento de los datos que le presentas al usuario.

Los modelos definen el tipo de datos que será proporcionado por el servidor. Por ejemplo, un modelo de `Persona` puede tener un atributo `nombre` que es un string (tipo de dato carácter) y un atributo `cumpleaños` que es una fecha:

```app/models/person.js export default DS.Model.extend({ firstName: DS.attr('string'), birthday: DS.attr('date') });

    <br />Un modelo también describe sus relaciones con otros objetos. Por ejemplo, un «pedido» puede tener muchos «artículos» y un «artículo» puede pertenecer a un «pedido».
    
    ```app/models/order.js
    export default DS.Model.extend({
      lineItems: DS.hasMany('line-item')
    });
    

```app/models/line-item.js export default DS.Model.extend({ order: DS.belongsTo('order') });

    <br />Los modelos en sí no tienen datos, sino definen los atributos, relaciones y comportamiento de instancias específicas, que se llaman ** records**(registros).
    
    ## Records(registros)
    
    Un ** record ** es una instancia de un modelo que contiene los datos cargados desde un servidor. Tu aplicación también puede crear nuevos registros y guardarlos al servidor.
    
    Un registro se identifica únicamente por su **tipo** de modelo y su **ID**.
    
    Por ejemplo, si escribieras un app de gestión de contactos, podrías tener un modelo de 'Persona'. Un registro de tu app podría tener un tipo de 'persona' y un ID de '1' o 'steve buscemi'.
    
    ```js
    this.get('store').findRecord('person', 1); // => { id: 1, name: 'steve-buscemi' }
    

An ID is usually assigned to a record by the server when you save it for the first time, but you can also generate IDs client-side.

## Adapter(el Adaptador)

An **adapter** is an object that translates requests from Ember (such as "find the user with an ID of 123") into requests to a server.

For example, if your application asks for a `Person` with an ID of `123`, how should Ember load it? Over HTTP or a WebSocket? If it's HTTP, is the URL `/person/1` or `/resources/people/1`?

The adapter is responsible for answering all of these questions. Whenever your app asks the store for a record that it doesn't have cached, it will ask the adapter for it. If you change a record and save it, the store will hand the record to the adapter to send the appropriate data to your server and confirm that the save was successful.

Adapters let you completely change how your API is implemented without impacting your Ember application code.

## Caching

The store will automatically cache records for you. If a record had already been loaded, asking for it a second time will always return the same object instance. This minimizes the number of round-trips to the server, and allows your application to render its UI to the user as fast as possible.

For example, the first time your application asks the store for a `person` record with an ID of `1`, it will fetch that information from your server.

However, the next time your app asks for a `person` with ID `1`, the store will notice that it had already retrieved and cached that information from the server. Instead of sending another request for the same information, it will give your application the same record it had provided it the first time. This feature—always returning the same record object, no matter how many times you look it up—is sometimes called an *identity map*.

Using an identity map is important because it ensures that changes you make in one part of your UI are propagated to other parts of the UI. It also means that you don't have to manually keep records in sync—you can ask for a record by ID and not have to worry about whether other parts of your application have already asked for and loaded it.

One downside to returning a cached record is you may find the state of the data has changed since it was first loaded into the store's identity map. In order to prevent this stale data from being a problem for long, Ember Data will automatically make a request in the background each time a cached record is returned from the store. When the new data comes in, the record is updated, and if there have been changes to the record since the initial render, the template is re-rendered with the new information.

## Resumen de la Arquitectura

The first time your application asks the store for a record, the store sees that it doesn't have a local copy and requests it from your adapter. Your adapter will go and retrieve the record from your persistence layer; typically, this will be a JSON representation of the record served from an HTTP server.

![Diagram showing process for finding an unloaded record](../images/guides/models/finding-unloaded-record-step1-diagram.png)

As illustrated in the diagram above, the adapter cannot always return the requested record immediately. In this case, the adapter must make an *asynchronous* request to the server, and only when that request finishes loading can the record be created with its backing data.

Because of this asynchronicity, the store immediately returns a *promise* from the `find()` method. Similarly, any requests that the store makes to the adapter also return promises.

Once the request to the server returns with a JSON payload for the requested record, the adapter resolves the promise it returned to the store with the JSON.

The store then takes that JSON, initializes the record with the JSON data, and resolves the promise returned to your application with the newly-loaded record.

![Diagram showing process for finding an unloaded record after the payload has returned from the server](../images/guides/models/finding-unloaded-record-step2-diagram.png)

Let's look at what happens if you request a record that the store already has in its cache.

![Diagram showing process for finding an unloaded record after the payload has returned from the server](../images/guides/models/finding-loaded-record-diagram.png)

In this case, because the store already knew about the record, it returns a promise that it resolves with the record immediately. It does not need to ask the adapter (and, therefore, the server) for a copy since it already has it saved locally.

* * *

Models, records, adapters and the store are the core concepts you should understand to get the most out of Ember Data. The following sections go into more depth about each of these concepts, and how to use them together.