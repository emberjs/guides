应用程序启动时，初始化器提供了一个配置应用程序的机会。

有两种类型的初始化器：应用程序初始化和应用对象实例初始化。

应用程序初始器在启动应用程序时，提供了一个重要的手段，设定“依赖注入” [dependency injections](../dependency-injection) 注入对象到你的应用程序里。

对象实例初始化器时在运行应用对象实例时加载的。 Ember.js提供了一种方法来配置你的应用程序的初始状态，以及在本地的对象实例建立依赖注入（例如，A/B 测试配置）。

初始化中执行的操作应尽可能简洁，以减少加载应用程序的延误。 尽管已经有一些先进的技术可以在应用初始化中实现异步(例如 `deferReadiness` and `advanceReadiness`)，通常应该避免使用。 Any asynchronous loading conditions (e.g. user authorization) are almost always better handled in your application route's hooks, which allows for DOM interaction while waiting for conditions to resolve.

## 应用程序初始器

Application initializers can be created with Ember CLI's `initializer` generator:

```bash
ember generate initializer shopping-cart
```

Let's customize the `shopping-cart` initializer to inject a `cart` property into all the routes in your application:

```app/initializers/shopping-cart.js export function initialize(application) { application.inject('route', 'cart', 'service:shopping-cart'); };

export default { name: 'shopping-cart', initialize: initialize };

    <br />## Application Instance Initializers
    
    Application instance initializers can be created with Ember CLI's `instance-initializer` generator:
    
    ```bash
    ember generate instance-initializer logger
    

Let's add some simple logging to indicate that the instance has booted:

```app/instance-initializers/logger.js export function initialize(applicationInstance) { var logger = applicationInstance.lookup('logger:main'); logger.log('Hello from the instance initializer!'); }

export default { name: 'logger', initialize: initialize };

    <br />## Specifying Initializer Order
    
    If you'd like to control the order in which initializers run, you can use the `before` and/or `after` options:
    
    ```app/initializers/config-reader.js
    export function initialize(application) {
      // ... your code ...
    };
    
    export default {
      name: 'config-reader',
      before: 'websocket-init',
      initialize: initialize
    };
    

```app/initializers/websocket-init.js export function initialize(application) { // ... your code ... };

export default { name: 'websocket-init', after: 'config-reader', initialize: initialize };

    <br />```app/initializers/asset-init.js
    export function initialize(application) {
      // ... your code ...
    };
    
    export default {
      name: 'asset-init',
      after: ['config-reader', 'websocket-init'],
      initialize: initialize
    };
    

Note that ordering only applies to initializers of the same type (i.e. application or application instance). Application initializers will always run before application instance initializers.