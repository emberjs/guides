Ember applications utilize the [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) ("DI") design pattern to declare and instantiate classes of objects and dependencies between them. Applications and application instances each serve a role in Ember's DI implementation.

An [`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html) serves as a "registry" for dependency declarations. Factories (i.e. classes) are registered with an application, as well as rules about "injecting" dependencies that are applied when objects are instantiated.

An [`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html) serves as the "owner" for objects that are instantiated from registered factories. Application instances provide a means to "look up" (i.e. instantiate and / or retrieve) objects.

> *Note: Although an `Application` serves as the primary registry for an app, each `ApplicationInstance` can also serve as a registry. Instance-level registrations are useful for providing instance-level customizations, such as A/B testing of a feature.*

## Factory Registrations

A factory can represent any part of your application, like a *route*, *template*, or custom class. Every factory is registered with a particular key. For example, the index template is registered with the key `template:index`, and the application route is registered with the key `route:application`.

Registration keys have two segments split by a colon (`:`). The first segment is the framework factory type, and the second is the name of the particular factory. Hence, the `index` template has the key `template:index`. Ember has several built-in factory types, such as `service`, `route`, `template`, and `component`.

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
    
    En el siguiente ejemplo, `logger` es un objeto de Javascript que debería ser retornado "como es", cuando se busca:
    
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
    
    Factories can be injected into whole "types" of factories with *type injections*. For example:
    
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

    <br />Las inyecciones también se pueden hacer en una fábrica específica utilizando su mediante su llave completa:
    
    ```js
    application.inject('route:index', 'logger', 'logger:main');
    

In this case, the logger will only be injected on the index route.

Injections can be made onto any class that requires instantiation. This includes all of Ember's major framework classes, such as components, helpers, routes, and the router.

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