Los inicializadores permiten configurar la aplicación al arranque.

Hay dos tipos de inicializadores: inicializadores de la aplicación e inicializadores de la instancia de la aplicación.

Los inicializadores de la aplicación se ejecutan en el arranque y suponen el principal métido para poder [inyectar dependencias](../dependency-injection) en la aplicación.

Los inicializadores de la instancia de la aplicación se ejecutan cuando se carga una instancia de la aplicación. Proporcionan una manera de configurar el estado inicial de la aplicación, así como las inyecciones de dependencias que pertenecen únicamente a la instancia de la aplicación (por ejemplo configuraciones de tests A/B).

Las operaciones realizadas en los inicializadores deben ser tan ligeras como sea posible para minimizar un posible retraso en la carga de la aplicación. Apesar de que hay varias técnicas avanzadas para permitir asincronía en los inicializadores de la aplication (por ejemplo `deferReadiness` and `advanceReadiness`), estas técnicas generalmente se deberían evitar. Cualquier condición de carga asíncrona (p.ej. autorización de usuario) son casi siempre mejor manejadas en las conexiones de ruta de tu aplicación, lo que permite la interacción del DOM mientras esperas a que las condiciones se resuelvan.

## Inicializadores de Aplicación

Los inicializadores de aplicación pueden crearse con el generador `initializer` de la CLI de Ember:

```bash
ember generate initializer shopping-cart
```

Personalicemos el inicializador `shopping-cart` para inyectar una propiedad `cart` en todas las rutas en tu aplicación:

```app/initializers/shopping-cart.js export function initialize(application) { application.inject('route', 'cart', 'service:shopping-cart'); };

export default { name: 'shopping-cart', initialize: initialize };

    <br />## Inicializadores de Instance de Aplicación
    
    Los inicializadores de instancia de aplicación pueden ser creados con el generador `instance-initializer`de la CLI de Ember:
    
    ```bash
    ember generate instance-initializer logger
    

Agreguemos un registro simple para indicar que la instancia ha arrancado:

```app/instance-initializers/logger.js export function initialize(applicationInstance) { var logger = applicationInstance.lookup('logger:main'); logger.log('Hello from the instance initializer!'); }

export default { name: 'logger', initialize: initialize };

    <br />## Especificando el Orden del Inicializador
    
    Si te gustaría controlar el orden en el que el inicializador se ejecuta, puedes utilizar las opciones `antes` y/o `después`:
    
    ```app/initializers/config-reader.js
    export function initialize(application) {
      // ... tu código ...
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
    

Toma en cuenta que el ordenamiento sólo aplica a los inicializadores del mismo tipo (p.ej.: aplicación o instancia de aplicación). Los inicializadores de aplicación siempre funcionarán antes de los inicializadores de instancia de aplicación.