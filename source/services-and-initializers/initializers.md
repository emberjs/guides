Sometimes you'll want to have certain things happen as your application boots,
like starting services that should be available before the rest of your
application loads. For example, Ember Data uses this to give routes access to
the shared store.

This can be accomplished with an initializer. For example, say you have a
service that sets up a shopping cart, and you want to inject that cart into all
the routes in your application. You could do something like this:

```app/initializers/shopping-cart.js
export default {
  name: 'shopping-cart',
  initialize: function (container, application) {
    application.inject('route', 'cart', 'service:shopping-cart');
  }
};
```

The `shopping-cart` service will be injected as the `cart` property into every
`route` in your application, which they can access via
`this.get('shopping-cart')`.

You can also inject a service into a specific class:

```app/initializers/shopping-cart.js
application.inject('route:checkout', 'cart', 'service:shopping-cart');
```

## Specifying Initializer Order

If the order in which initializers load is important, you can use the `before`
and/or `after` options:

```app/initializers/config-reader.js
export default {
  name: "configReader",
  before: "websocketInit",

  initialize: function(container, application) {
    ... your code ...
  }
};
```


```app/initializers/websocket-init.js
export default {
  name: "websocketInit",
  after: "configReader",

  initialize: function(container, application) {
    ... your code ...
  }
};
```

## Pausing the Boot Process

If you need to make sure that the rest of your application doesn't load until
an initializer has finished loading, you can use the `deferReadiness` and
`advanceReadiness` methods, which will wait until all of the promises
are resolved until continuing.

For example, if you wanted to keep your application from booting until the
current user was set, you could do something like this:

```app/initializers/current-user.js
export default {
  name: "currentUserLoader",
  after: "store",

  initialize: function(container, application) {
    application.deferReadiness();

    container.lookup('store:main').find('user', 'current').then(function(user) {
      application.inject('route', 'currentUser', 'user:current');
      application.advanceReadiness();
    });
  }
};
