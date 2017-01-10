Initializers provide an opportunity to configure your application as it boots.

There are two types of initializers: application initializers and application instance initializers.

Application initializers are run as your application boots,
and provide the primary means to configure [dependency injections](../dependency-injection) in your application.

Application instance initializers are run as an application instance is loaded.
They provide a way to configure the initial state of your application,
as well as to set up dependency injections that are local to the application instance
(e.g. A/B testing configurations).

Operations performed in initializers should be kept as lightweight as possible
to minimize delays in loading your application.
Although advanced techniques exist for allowing asynchrony in application initializers
(i.e. `deferReadiness` and `advanceReadiness`), these techniques should generally be avoided.
Any asynchronous loading conditions (e.g. user authorization) are almost always
better handled in your application route's hooks,
which allows for DOM interaction while waiting for conditions to resolve.

## Application Initializers

Application initializers can be created with Ember CLI's `initializer` generator:

```bash
ember generate initializer shopping-cart
```

Let's customize the `shopping-cart` initializer to inject a `cart` property into all the routes in your application:

```app/initializers/shopping-cart.js
export function initialize(application) {
  application.inject('route', 'cart', 'service:shopping-cart');
};

export default {
  initialize
};
```

## Application Instance Initializers

Application instance initializers can be created with Ember CLI's `instance-initializer` generator:

```bash
ember generate instance-initializer logger
```

Let's add some simple logging to indicate that the instance has booted:

```app/instance-initializers/logger.js
export function initialize(applicationInstance) {
  let logger = applicationInstance.lookup('logger:main');
  logger.log('Hello from the instance initializer!');
}

export default {
  initialize
};
```

## Specifying Initializer Order

If you'd like to control the order in which initializers run, you can use the `before` and/or `after` options:

```app/initializers/config-reader.js
export function initialize(application) {
  // ... your code ...
};

export default {
  before: 'websocket-init',
  initialize
};
```

```app/initializers/websocket-init.js
export function initialize(application) {
  // ... your code ...
};

export default {
  after: 'config-reader',
  initialize
};
```

```app/initializers/asset-init.js
export function initialize(application) {
  // ... your code ...
};

export default {
  after: ['config-reader', 'websocket-init'],
  initialize
};
```

Note that ordering only applies to initializers of the same type (i.e. application or application instance).
Application initializers will always run before application instance initializers.

## Customizing Initializer Names

By default initializer names are derived from their module name. This initializer will be given the name `logger`:

```app/instance-initializers/logger.js
export function initialize(applicationInstance) {
  let logger = applicationInstance.lookup('logger:main');
  logger.log('Hello from the instance initializer!');
}

export default { initialize };
```

If you want to change the name you can simply rename the file, but if needed you can also specify the name explicitly:

```app/instance-initializers/logger.js
export function initialize(applicationInstance) {
  let logger = applicationInstance.lookup('logger:main');
  logger.log('Hello from the instance initializer!');
}

export default {
  name: 'my-logger',
  initialize
};
```

This initializer will now have the name `my-logger`.
