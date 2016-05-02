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

'''app/models/person.js import Model from 'ember-data/model'; import attr from 'ember-data/attr';

export default Model.extend ({ firstName: attr('string'), birthday: attr('date') });

    <br />Un modelo también describe sus relaciones con otros objetos. Por ejemplo, un «pedido» puede tener muchos «artículos» y un «artículo» puede pertenecer a un «pedido».
    
    ```app/models/order.js
    import Model from 'ember-data/model';
    import { hasMany } from 'ember-data/relationships';
    
    export default Model.extend({
      lineItems: hasMany('line-item')
    });
    

```app/models/line-item.js import Model from 'ember-data/model'; import { belongsTo } from 'ember-data/relationships';

export default Model.extend({ order: belongsTo('order') });

    <br />Los modelos en sí no tienen datos, sino definen los atributos, relaciones y comportamiento de instancias específicas, que se llaman ** records**(registros).
    
    ## Records(registros)
    
    Un ** record ** es una instancia de un modelo que contiene los datos cargados desde un servidor. Tu aplicación también puede crear nuevos registros y guardarlos al servidor.
    
    Un registro se identifica únicamente por su **tipo** de modelo y su **ID**.
    
    Por ejemplo, si escribieras un app de gestión de contactos, podrías tener un modelo de 'Persona'. Un registro de tu app podría tener un tipo de 'persona' y un ID de '1' o 'steve buscemi'.
    
    ```js
    this.store.findRecord('person', 1); // => { id: 1, name: 'steve-buscemi' }
    

Un ID es asignado a un registro generalmente por el servidor cuando lo guardas por primera vez, pero también puedes generar los IDs del lado del cliente.

## Adapter(el Adaptador)

Un **adapter** es un objeto que traduce las peticiones de Ember (como "buscar el usuario con el ID de 123") en las peticiones a un servidor.

Por ejemplo, si tu aplicación solicita una `Persona` con el ID de `123`, ¿Ember cómo debería cargarla? ¿A través de HTTP o un WebSocket? Si es a través de HTTP, la URL sería ¿`/person/1`? o ¿`/resources/people/1`?

El adaptador es responsable de responder a todas estas dudas. Siempre que tu app le pida al <<store>> por un registro que no se encuentra en caché, lo pide del adaptador. Si cambias un registro y lo guardas, el store le pasa el registro al adaptador para enviar los datos correspondientes al servidor y confirmar que se ha guardado correctamente.

Los adaptadores te permiten cambiar completamente la implementación de tu API sin afectar el código de tu aplicación de Ember.

## Caching

El store automáticamente te almacena los registos en caché. Si un registro ya se había cargado, pedirlo otra vez siempre te devuelve la misma instancia de objeto. Esto minimiza el número de peticiones y respuestas del servidor y le permite a tu aplicación hacer el render de la interfaz de usuario lo más rápido posible.

Por ejemplo, la primera vez que tu aplicación le pide un registro de una `persona` con el ID de `1` del store, el store extrae esa información del servidor.

Sin embargo, la próxima vez que tu app pide una `persona` con el ID `1`, el store se dará cuenta de que ya había obtenido y almacenado en caché esa información del servidor. En lugar de enviar otra petición para obtener la misma información, le dará a tu aplicación el mismo registro que había proporcionado la primera vez. Esta característica—siempre devolver el mismo objeto de registro, sin importar cuántas veces que lo pides — a veces se llama un *identity map*(mapa de identidad).

Utilizar un identity map es importante porque asegura que los cambios realizas en una parte de la interfaz de usuario se propagan a otras partes de la interfaz. También significa que no tienes que sincronizar los registros manualmente—puedes solicitar un registro por ID y sin preocuparte de si otras partes de tu aplicación ya lo han solicitado y cargado.

Una desventaja de devolver un registro de la caché es que puede que el estado del registro haya cambiado desde que se cargó en el mapa de identidad del store. Para evitar este problema de datos obsoletos, Ember Data automáticamente hará una petición en segundo plano cada vez que un registro en la memoria caché se devuelva del store. Cuando llegan los datos nuevos, el registro se actualiza, y si el registro ha sufrido cambios desde el render inicial, se vuelva a cargar la plantilla con la nueva información.

## Architecture Overview

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