Los inicializadores permiten configurar la aplicación al arranque.

Hay dos tipos de inicializadores: inicializadores de la aplicación e inicializadores de la instancia de la aplicación.

Los inicializadores de la aplicación se ejecutan en el arranque y suponen el principal métido para poder [inyectar dependencias](../dependency-injection) en la aplicación.

Los inicializadores de la instancia de la aplicación se ejecutan cuando se carga una instancia de la aplicación. Proporcionan una manera de configurar el estado inicial de la aplicación, así como las inyecciones de dependencias que pertenecen únicamente a la instancia de la aplicación (por ejemplo configuraciones de tests A/B).

Las operaciones realizadas en los inicializadores deben ser tan ligeras como sea posible para minimizar un posible retraso en la carga de la aplicación. Although advanced techniques exist for allowing asynchrony in application initializers (i.e. `deferReadiness` and `advanceReadiness`), these techniques should generally be avoided. Any asynchronous loading conditions (e.g. user authorization) are almost always better handled in your application route's hooks, which allows for DOM interaction while waiting for conditions to resolve.

## Application Initializers

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
      name: 'configReader',
      before: 'websocketInit',
      initialize: initialize
    };
    

```app/initializers/websocket-init.js export function initialize(application) { // ... your code ... };

export default { name: 'websocketInit', after: 'configReader', initialize: initialize }; ```

Note that ordering only applies to initializers of the same type (i.e. application or application instance). Application initializers will always run before application instance initializers.