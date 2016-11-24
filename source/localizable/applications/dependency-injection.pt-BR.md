Aplicações em Ember utilizam o padrão de projeto de [injeção de dependência](https://en.wikipedia.org/wiki/Dependency_injection) ("DI") para declarar e instanciar classes de objetos e dependências entre eles. Aplicações e instâncias de aplicações tem um papel na implementação de DI em Ember.

Um [`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html) serve como um "registro" para declarações de dependência. Fábricas (ou seja, classes) são registradas com um aplicativo, assim como regras sobre "injetar" dependências que são aplicadas quando os objetos são instanciados.

Um [`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html) serve como o "dono" para objetos que são instanciados a partir de fábricas registradas. Instâncias de aplicativo fornecem um meio para "procurar" (ou seja, criar uma instância e / ou recuperar) objetos.

> *Nota: Embora um `Ember.Application` serve como o registro primário para um app, cada `Ember.ApplicationInstance` também pode servir como um registro. Os registros em nível de instância são úteis para fornecer personalizações em nível de instância, como teste A/B de um recurso.*

## Registros de Fábrica

Uma fábrica pode representar qualquer parte do seu aplicativo, como uma classe personalizada, *template* ou *route*. Cada fábrica é registrada com uma chave particular. Por exemplo, o "template" para "index" é registrado com a chave `template:index`, e a "route" para "application" é registrada com o chave `route:application`.

As chaves de registo tem dois segmentos divididos por dois-pontos (`:`). O primeiro segmento é o tipo de fábrica da aplicacao, e o segundo é o nome da fábrica. Portanto, o "template" para `index` tem a chave `template:index`. Ember has several built-in factory types, such as `service`, `route`, `template`, and `component`.

You can create your own factory type by simply registering a factory with the new type. For example, to create a `user` type, you'd simply register your factory with `application.register('user:user-to-register')`.

Factory registrations must be performed either in application or application instance initializers (with the former being much more common).

For example, an application initializer could register a `Logger` factory with the key `logger:main`:

```app/initializers/logger.js import Ember from 'ember';

export function initialize(application) { var Logger = Ember.Object.extend({ log(m) { console.log(m); } });

application.register('logger:main', Logger); }

export default { name: 'logger', initialize: initialize };

    <br />### Registering Already Instantiated Objects
    
    By default, Ember will attempt to instantiate a registered factory when it is looked up.
    When registering an already instantiated object instead of a class,
    use the `instantiate: false` option to avoid attempts to re-instantiate it during lookups.
    
    In the following example, the `logger` is a plain JavaScript object that should
    be returned "as is" when it's looked up:
    
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
    

### Registering Singletons vs. Non-Singletons

By default, registrations are treated as "singletons". This simply means that an instance will be created when it is first looked up, and this same instance will be cached and returned from subsequent lookups.

When you want fresh objects to be created for every lookup, register your factories as non-singletons using the `singleton: false` option.

In the following example, the `Message` class is registered as a non-singleton:

```app/initializers/notification.js import Ember from 'ember';

export function initialize(application) { var Message = Ember.Object.extend({ text: '' });

application.register('notification:message', Message, { singleton: false }); }

export default { name: 'notification', initialize: initialize };

    <br />## Factory Injections
    
    Once a factory is registered, it can be "injected" where it is needed.
    
    Factories can be injected into whole "types" of factories with *type injections*. Por exemplo:
    
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
    

As a result of this type injection, all factories of the type `route` will be instantiated with the property `logger` injected. The value of `logger` will come from the factory named `logger:main`.

Routes in this example application can now access the injected logger:

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ activate() { // The logger property is injected into all routes this.get('logger').log('Entered the index route!'); } });

    <br />Injections can also be made on a specific factory by using its full key:
    
    ```js
    application.inject('route:index', 'logger', 'logger:main');
    

In this case, the logger will only be injected on the index route.

Injections can be made into any class that requires instantiation. This includes all of Ember's major framework classes, such as components, helpers, routes, and the router.

### Ad Hoc Injections

Dependency injections can also be declared directly on Ember classes using `Ember.inject`. Currently, `Ember.inject` supports injecting controllers (via `Ember.inject.controller`) and services (via `Ember.inject.service`).

The following code injects the `shopping-cart` service on the `cart-contents` component as the property `cart`:

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ cart: Ember.inject.service('shopping-cart') });

    <br />If you'd like to inject a service with the same name as the property,
    simply leave off the service name (the dasherized version of the name will be used):
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      shoppingCart: Ember.inject.service()
    });
    

## Factory Instance Lookups

To fetch an instantiated factory from the running application you can call the [`lookup`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html#method_lookup) method on an application instance. This method takes a string to identify a factory and returns the appropriate object.

```javascript
applicationInstance.lookup('factory-type:factory-name');
```

The application instance is passed to Ember's instance initializer hooks and it is added as the "owner" of each object that was instantiated by the application instance.

### Using an Application Instance Within an Instance Initializer

Instance initializers receive an application instance as an argument, providing an opportunity to look up an instance of a registered factory.

```app/instance-initializers/logger.js export function initialize(applicationInstance) { let logger = applicationInstance.lookup('logger:main');

logger.log('Hello from the instance initializer!'); }

export default { name: 'logger', initialize: initialize };

    <br />### Getting an Application Instance from a Factory Instance
    
    [`Ember.getOwner`][4] will retrieve the application instance that "owns" an
    object. This means that framework objects like components, helpers, and routes
    can use [`Ember.getOwner`][4] to perform lookups through their application
    instance at runtime.
    
    For example, this component plays songs with different audio services based
    on a song's `audioType`.
    
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