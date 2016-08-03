Ember 应用程序利用 [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection)（"DI"）设计模式来声明和实例化类对象以及它们之间的依赖。 每一个应用程序和应用程序实例都在 Ember 的 DI 实现中发挥着作用。

[`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html) 是依赖项声明的“注册表”。 工厂（即：类）注册于一个应用程序之中，同时依赖“注入”的相关规则在对象实例化时被应用于其上。

[`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html) 是那些通过注册工厂实例化来的对象的“所有者”。 应用程序实例提供了“查找”（即：实例化和／或检索）对象的实际能力。

> *注意：尽管 `Application` 是应用程序的主注册表，然而每个 `ApplicationInstance` 也可以兼任一个注册表。 实例级别的注册在提供实例级别的定制化时非常有用，比如说针对某功能的 A/B 测试。*

## 注册工厂（Factory）

一个工厂可以代表应用程序的任一部分，比如一个 *路由*，*模版*，或是自定义类。 每一个工厂都使用一个特定的键名（key）来注册。 比方说，索引模版（index template）注册时的键名是 `template:index`，应用程序路由（application route）注册时的键名是 `route:application`。.

注册键名用使用冒号（`:`）分割的两部分组成。 第一段是框架工厂类型，而第二段是特定工厂名称。 因此，`index` 模版的键名就是 `template:index`。 Ember 有几个内建的工厂类型，诸如 `service`，`route`，`template`，和 `component`。.

你也可以创建自己的工厂类型，只需要在注册工厂时使用新类型作为键名即可。 例如，要创建一个 `user` 类型，你应该用 `application.register('user:user-to-register')` 来注册你的工厂。.

注册工厂必须在应用程序初始化程序或应用程序实例的初始化程序中进行（前者更为常用）。

例如，用一个应用程序初始程序注册一个键名为 `logger:main` 的 `Logger` 工厂：

```app/initializers/logger.js import Ember from 'ember';

export function initialize(application) { var Logger = Ember.Object.extend({ log(m) { console.log(m); } });

application.register('logger:main', Logger); }

export default { name: 'logger', initialize: initialize };

    <br />### 注册已经初始化过的对象
    
    默认情况下，Ember 会在一个注册工厂被检索时尝试对其实例化。
    当注册一个已经被实例化的对象而不是一个类的时候，使用 `instantiate: false` 选项可以避免在检索时尝试重新实例化。
    
    在下面的例子中，`logger` 是一个单纯的 JavaScript 对象，因此在检索时应该原样返回而不是实例化：
    
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
    

### 注册单例 vs. 非单例

By default, registrations are treated as "singletons". This simply means that an instance will be created when it is first looked up, and this same instance will be cached and returned from subsequent lookups.

When you want fresh objects to be created for every lookup, register your factories as non-singletons using the `singleton: false` option.

In the following example, the `Message` class is registered as a non-singleton:

```app/initializers/notification.js import Ember from 'ember';

export function initialize(application) { var Message = Ember.Object.extend({ text: '' });

application.register('notification:message', Message, { singleton: false }); }

export default { name: 'notification', initialize: initialize };

    <br />## 工厂注入
    
    一旦工厂注册好了，它可以在需要它的地方“注入”使用。
    
    工厂可以*类型注入*的方式注入到某种”类型“的全部工厂之中。 For example:
    
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

    <br />注入也可以通过使用它的完整键名来作用于某个特定的工厂：
    
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
    
    // 用法：
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