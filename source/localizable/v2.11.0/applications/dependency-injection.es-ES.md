Las aplicaciones basadas en Ember utilizan el patrón de diseño [Inyección de Dependencias](https://en.wikipedia.org/wiki/Dependency_injection) ("DI" por sus siglas en inglés) para declarar e instanciar clases de objetos y dependencias entre ellas. Cada aplicación y cada instancia de aplicación juegan un papel en la implementación de la Inyección de Dependencias en Ember.

Un [`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html) funciona como un "registro" para las declaraciones de dependencias. Las Fábricas (p.ej. clases) son registradas con una aplicación, así como las reglas sobre "inyectar" las dependencias que son aplicadas cuando los objetos son instanciados.

Una [`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html) funciona como el "propietario" de los objetos que son instanciados desde las fábricas registradas. Las instancias de aplicación proveen una manera de "buscar" (p.ej. instanciar y / o regresar) objetos.

> *Nota: Aunque una `Aplicación` funciona como el registro primario para una aplicación, cada `ApplicationInstance` puede también fungir como un registro. Los registro a nivel de Instance son útiles para proveer personalizaciones a nivel de instancia, como las pruebas A/B de una característica.*

## Registro de Fábricas

Una fábrica puede representar cualquier parte de tu aplicación, como una *ruta*, *plantilla* o clase a medida. Cada fábrica se registra con una clave particular. Por ejemplo, la plantilla de índice es registrada con la clave `template:index`, y la ruta de aplicación es registrada con la clave `route:application`.

Las claves de registro tienen 2 segmentos divididos por dos puntos(`:`). El primer segmento es el tipo de fábrica del framework, mientras que el segundo es el nombre de la fábrica en particular. Por tanto, la plantilla `índice` tiene el clave `template:index`. Ember tiene muchos tipos de fábrica incluidos, como `service` para servicio, `route` para ruta, `template` para plantilla y `component` para componente.

Puedes crear tu propio tipo de fábrica simplemente registrando un fábrica con el nuevo tipo. Por ejemplo, para crear un tipo `user`, simplemente registras tu fábrica con `application.register('user:user-to-register')`.

El registro de fábricas debe realizarse ya sea en los iniciadores de la aplicación o de la instancia de la aplicación (siendo el primero mucho más común).

Por ejemplo, un iniciador de aplicación podría registrar una fábrica `Logger` con la clave `logger:main`:

```app/initializers/logger.js import Ember from 'ember';

export function initialize(application) { var Logger = Ember.Object.extend({ log(m) { console.log(m); } });

application.register('logger:main', Logger); }

export default { name: 'logger', initialize: initialize };

    <br />###Registrando Objetos Ya Inicializados
    
    De manera predeterminada, Ember intentará instanciar una fábrica registrada cuando sea buscada.
    Cuando se esté registrando un objeto ya instanciado en lugar de una clase, utiliza la opción `instantiate: false` para evitar intentar re-instanciarlo durante las búsquedas.
    
    En el siguiente ejemplo, `logger` es un objeto plano de Javascript que debería ser retornado "tal cual", cuando se busca:
    
    ```app/initializers/logger.js
    export function initialize(application) {
      var logger = {
        log(m) {
          console.log(m);
        }
      };
    
      application.register('logger:main', logger, { instantiate: false });
    }
    
    export default {
      name: 'logger',
      initialize: initialize
    };
    

### Registrando Singletons versus No Singletons

De manera predeterminada, los registros son tratos como "singletons". Esto simplemente significa que una instancia será creada cuando sea referenciada por primera vez, y esta misma instancia será cacheada y retornada en referencias subsecuentes.

Cuando quieras que sean creados objetos frescos por cada referencia, registra tus fábricas como non-singletons utilizando la opción `singleton: false`.

En el ejemplo siguiente, la clase `Mensaje` está registrada como un non-singleton:

```app/initializers/notification.js import Ember from 'ember';

export function initialize(application) { var Message = Ember.Object.extend({ text: '' });

application.register('notification:message', Message, { singleton: false }); }

export default { name: 'notification', initialize: initialize };

    <br />## Inyección de Fábricas
    
    Una vez que se registra una fábrica, puede ser "inyectada" donde se necesite.
    
    Las fábricas pueden ser inyectadas en "tipos" completos de fábricas con *inyecciones de tipo*. For example:
    
    ```app/initializers/logger.js
    import Ember from 'ember';
    
    export function initialize(application) {
      var Logger = Ember.Object.extend({
        log(m) {
          console.log(m);
        }
      });
    
      application.register('logger:main', Logger);
      application.inject('route', 'logger', 'logger:main');
    }
    
    export default {
      name: 'logger',
      initialize: initialize
    };
    

Como resultado de esta inyección de tipo, todas las fábricas del tipo `route` serán instanciadas con la propiedad `logger` inyectada. El valor de `logger` vendrá de la fábrica nombrada `logger:main`.

Las rutas en esta aplicación de ejemplo pueden ahora acceder al logger inyectado:

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ activate() { // The logger property is injected into all routes this.get('logger').log('Entered the index route!'); } });

    <br />Las inyecciones también se pueden hacer en una fábrica específica utilizando su llave completa:
    
    ```js
    application.inject('route:index', 'logger', 'logger:main');
    

En este caso, el logger será inyectado únicamente en la ruta índice.

Las inyecciones pueden hacerse a cualquier clase que requiera instanciarse. Esto incluye todas las clases mayores del framework Ember, como 'components', 'helpers', 'routes' y el 'router'.

### Inyecciones Determinadas

La inyección de dependencias puede también declararse directamente sobre las clases de Ember utilizando `Ember.inject`. A la fecha, `Ember.inject` realiza la inyección a los controladores (a través de `Ember.inject.controller`) y servicios (a través de `Ember.inject.service`).

El código siguiente inyecta el servicio `shopping-cart` en el componente `cart-contents` como la propiedad `cart`:

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ cart: Ember.inject.service('shopping-cart') });

    <br />Si tienes considerado inyectar un servicio con el mismo nombre que la propiedad, simplemente deja el nombre del servicio (se utilizará la versión con guiones del nombre):
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      shoppingCart: Ember.inject.service()
    });
    

## Referencias de Instancia de Fábrica

Para obtener la instancia de una fábrica en la aplicación en ejecución puedes llamar al método [`lookup`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html#method_lookup) en una instancia de aplicación. Este método recibe una cadena para identificar una fábrica y regresar el objeto apropiado.

```javascript
applicationInstance.lookup('factory-type:factory-name');
```

La instancia de aplicación se pasa a las conexiones del iniciador de instancia de Ember y es agregado como el "propietario" de cada objeto que fue instanciado por la instancia de aplicación.

### Utilizando una Instancia de Aplicación Dentro de un Iniciador de Instancia

Los iniciadores de instancia reciben una instancia de aplicación como un argumento, proporcionando una oportunidad de encontrar una instancia de una fábrica registrada.

```app/instance-initializers/logger.js export function initialize(applicationInstance) { let logger = applicationInstance.lookup('logger:main');

logger.log('Hello from the instance initializer!'); }

export default { name: 'logger', initialize: initialize };

    <br />###Obteniendo una Instancia de Aplicación desde una Instancia de Fábrica
    
    [`Ember.getOwner`][4] recuperará la instancia de aplicación de "posee" un objeto. Esto significa que los objetos del framework como 'components', 'helpers' y 'routes' pueden usar [`Ember.getOwner`][4] para realizar búsquedas a través de su instancia de aplicación en tiempo de ejecución.
    
    Por ejemplo, este componente reproduce canciones con diferentes servicios de audio basados en un `audioType` de una canción.
    
    ```app/components/play-audio.js
    import Ember from 'ember';
    const {
      Component,
      computed,
      getOwner
    } = Ember;
    
    // Usage:
    //
    //   {{play-audio song=song}}
    //
    export default Component.extend({
      audioService: computed('song.audioType', function() {
        let applicationInstance = getOwner(this);
        let audioType = this.get('song.audioType');
        return applicationInstance.lookup(`service:audio-${audioType}`);
      }),
    
      click() {
        let player = this.get('audioService');
        player.play(this.get('song.file'));
      }
    });