Ember applications utilize the [dependency
injection](https://en.wikipedia.org/wiki/Dependency_injection) ("DI") design
pattern to declare and instantiate classes of objects and dependencies between
them. Applications and application instances each serve a role in Ember's DI
implementation.

An `Ember.Application` serves as a "registry" for dependency declarations.
Factories (i.e. classes) are registered with an application, as well as rules
about "injecting" dependencies that are applied when objects are instantiated.

An `Ember.ApplicationInstance` serves as a "container" for objects that are
instantiated from registered factories. Application instances provide a means to
"look up" (i.e. instantiate and / or retrieve) objects.

> _Note: Although an `Application` serves as the primary registry for an app,
each `ApplicationInstance` can also serve as a registry. Instance-level
registrations are useful for providing instance-level customizations, such as
A/B testing of a feature._

## Factory Registrations

A factory can represent any part of your application, like a _route_,
_template_, or custom class. Every factory is registered with a particular key.
For example, the index template is registered with the key `template:index`, and
the application route is registered with the key `route:application`.

Registration keys have two segments split by a colon (`:`). The first segment is
the framework factory type, and the second is the name of the particular
factory. Hence, the `index` template has the key `template:index`. Ember has
several built-in factory types, such as `service`, `route`, `template`, and
`component`.

You can create your own factory type by simply registering a factory with the
new type. For example, to create a `user` type, you'd simply register your
factory with `application.register('user:user-to-register')`.

Factory registrations must be performed either in application or application
instance initializers (with the former being much more common).

For example, an application initializer could register a `Logger` factory with
the key `logger:main`:

```app/initializers/logger.js
export function initialize(application) {
  var Logger = Ember.Object.extend({
    log(m) {
      console.log(m);
    }
  });

  application.register('logger:main', Logger);
}

export default {
  name: 'logger',
  initialize: initialize
};
```

### Registering Already Instantiated Objects

By default, Ember will attempt to instantiate a registered factory when it is
looked up. When registering an already instantiated object instead of a class,
use the `instantiate: false` option to avoid attempts to re-instantiate it
during lookups.

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
```

### Registering Singletons vs. Non-Singletons

By default, registrations are treated as "singletons". This simply means that
an instance will be created when it is first looked up, and this same instance
will be cached and returned from subsequent lookups.

When you want fresh objects to be created for every lookup, register your
factories as non-singletons using the `singleton: false` option.

In the following example, the `Message` class is registered as a non-singleton:

```app/initializers/logger.js
export function initialize(application) {
  var Message = Ember.Object.extend({
    text: ''
  });

  application.register('notification:message', Message, { singleton: false });
}

export default {
  name: 'logger',
  initialize: initialize
};
```

## Factory Injections

Once a factory is registered, it can be "injected" where it is needed.

Factories can be injected into whole "types" of factories with *type
injections*. For example:

```app/initializers/logger.js
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
```

As a result of this type injection, all factories of the type `route` will be
instantiated with the property `logger` injected. The value of `logger` will
come from the factory named `logger:main`.

Routes in this example application can now access the injected logger:

```app/routes/index.js
export default Ember.Route.extend({
  activate() {
    // The logger property is injected into all routes
    this.get('logger').log('Entered the index route!');
  }
});
```

Injections can also be made on a specific factory by using its full key:

```js
application.inject('route:index', 'logger', 'logger:main');
```

In this case, the logger will only be injected on the index route.

Injections can be made onto any class that requires instantiation. This includes
all of Ember's major framework classes, such as components, helpers, routes, and
the router.

### Ad Hoc Injections

Dependency injections can also be declared directly on Ember classes using
`Ember.inject`. Currently, `Ember.inject` supports injecting controllers (via
`Ember.inject.controller`) and services (via `Ember.inject.service`).

The following code injects the `shopping-cart` service on the `cart-contents`
component as the property `cart`:

```app/components/cart-contents.js
export default Ember.Component.extend({
  cart: Ember.inject.service('shopping-cart')
});
```

If you'd like to inject a service with the same name as the property, simply
leave off the service name (the dasherized version of the name will be used):

```app/components/cart-contents.js
export default Ember.Component.extend({
  shoppingCart: Ember.inject.service()
});
```

## Factory Lookups

The vast majority of Ember registrations and lookups are performed implicitly.

In the rare cases in which you want to perform an explicit lookup of a
registered factory, you can do so on an application instance in its associated
instance initializer. For example:

```app/instance-initializers/logger.js
export function initialize(applicationInstance) {
  var logger = applicationInstance.lookup('logger:main');

  logger.log('Hello from the instance initializer!');
}

export default {
  name: 'logger',
  initialize: initialize
};
```
