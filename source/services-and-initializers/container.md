When an Ember application starts running, it will create and use a single
instance of the `Ember.Container` object. This container object is responsible
for managing factories and the dependencies between them. At the level of the
container, a factory can be any part of the framework, like _route_ or
_template_. For example, the index template is a factory with the name
`template:index`, and the application route is a factory with the name
`route:application`. The container understands how to use these factories
(Are they singleton? Should they be instantiated?) and manages their
dependencies.

Factory names have two parts segmented by a `:`. The first segment is the
framework factory type, and the second is the name of the factory requested.
Hence, the `index` template would be named `template:index`. Ember has several
built-in factory types, and you can also create your own by simply naming your
factory appropriately. For example, to create a `user` type, you'd simply
register your factory with `application.register('user:user-to-register')`.

If the container does not already have a requested factory, it uses a
resolver to discover that factory. For example, the resolver is responsible for
mapping the name of `component:show-posts` to the JavaScript module
located in the filesystem at `app/components/show-posts.js`. After
optionally adding dependencies to the requested factory, that factory is
cached and returned.

Ember's container should be viewed as an implementation detail, and is not
part of the supported public API. Instead, you should use initializers to
register factories on the container:

```app/initializers/logger.js
export function initialize(container, application) {
  var Logger = Ember.Object.extend({
    log(m) {
      console.log(m);
    }
  });

  application.register('logger:main', Logger);
}
```

The `register` function adds the factory (`logger`) into the container. It adds
it with the full name of `logger:main`.

By default, Ember will instantiate the object being injected. If you'd prefer
not to have it instantiated (such as when working with a plain JavaScript
object), you can tell Ember not to instantiate it:

```app/initializers/logger.js
export function initialize(container, application) {
  var logger = {
    log(m) {
      console.log(m);
    }
  };

  application.register('logger:main', logger, { instantiate: false });
}
```

Once a factory is registered, it can be injected:

```app/initializers/logger.js
export function initialize(container, application) {
  var Logger = Ember.Object.extend({
    log(m) {
      console.log(m);
    }
  });

  application.register('logger:main', logger, { instantiate: false });
  application.inject('route', 'logger', 'logger:main');
}
```

This is an example of a *type injection*. Onto all factories of the type
`route`, the property, `logger` will be injected with the factory named
`logger:main`. Routes in this example application can now access the logger:

```app/routes/index.js
export default Ember.Route.extend({
  activate() {
    // The logger property is injected into all routes
    this.logger.log('Entered the index route!');
  }
});
```

Injections can also be made on a specific factory by using its full name:

```js
application.inject('route:index', 'logger', 'logger:main');
```

Injections can be made onto all of Ember's major framework classes including
components, routes, and the router.
