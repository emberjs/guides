Un [`Ember.Service`](http://emberjs.com/api/classes/Ember.Service.html) es un objeto de Ember que vive mientras la aplicación es ejecutada y puede hacerse disponible en distintas partes de tu aplicación.

Los servicios son útiles para implementar funcionalidades que requieran mantener un estado compartido a lo largo de la aplicación. Por ejemplo:

* Autenticación de la sesión de usuario.
* Geolocalización.
* WebSockets.
* Eventos enviados por servidor o notificaciones.
* Llamadas a API por servidor que podrían no encajar con Ember Data.
* APIs de terceros.
* Registro.

### Definiendo Servicios

Los servicios pueden crearse usando el generador de `servicios` de Ember CLI. Por ejemplo, el siguiente comando creará el servicio `ShoppingCart`:

```bash
ember generate service shopping-cart
```

Los servicios deben extender de la clase base [`Ember.Service`](http://emberjs.com/api/classes/Ember.Service.html):

```app/services/shopping-cart.js import Ember from 'ember';

export default Ember.Service.extend({ });

    <br />Como cualquier objeto de Ember, un servicio es inicializado y puede tener propiedades y métodos de su propiedad.
    Below, the shopping cart service manages an items array that represents the items currently in the shopping cart.
    
    ```app/services/shopping-cart.js
    import Ember from 'ember';
    
    export default Ember.Service.extend({
      items: null,
    
      init() {
        this._super(...arguments);
        this.set('items', []);
      },
    
      add(item) {
        this.get('items').pushObject(item);
      },
    
      remove(item) {
        this.get('items').removeObject(item);
      },
    
      empty() {
        this.get('items').clear();
      }
    });
    

### Accediendo Servicios

Para acceder a un servicio, puedes inyectarlo en cualquier objeto resuelto por contenedor como un componente u otro servicio utilizando la función `Ember.inject.service`. Hay 2 maneras de utilizar esta función. Puedes invocarla sin argumentos o puedes pasarle el nombre registrado del servicio. Cuando no se pasan argumentos, el servicio se carga basándose en el nombre de la clave de la variable. Puedes cargar el servicio del carrito de compras sin argumentos como a continuación:

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js shoppingCart: Ember.inject.service() });

    <br />Another way to inject a service is to provide the name of the service as the argument.
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      //will load the service in file /app/services/shopping-cart.js
      cart: Ember.inject.service('shopping-cart')
    });
    

Esto inyecta el servicio del carrito de compras en el componente y lo hace disponible como la propiedad `cart`.

Sometimes a service may or may not exist, like when an initializer conditionally registers a service. Since normal injection will throw an error if the service doesn't exist, you must look up the service using Ember's [`getOwner`](https://emberjs.com/api/classes/Ember.html#method_getOwner) instead.

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js cart: Ember.computed(function() { return Ember.getOwner(this).lookup('service:shopping-cart'); }) });

    <br />Injected properties are lazy loaded; meaning the service will not be instantiated until the property is explicitly called.
    Therefore you need to access services in your component using the `get` function otherwise you might get an undefined.
    
    Once loaded, a service will persist until the application exits.
    
    Below we add a remove action to the `cart-contents` component.
    Notice that below we access the `cart` service with a call to`this.get`.
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      cart: Ember.inject.service('shopping-cart'),
    
      actions: {
        remove(item) {
          this.get('cart').remove(item);
        }
      }
    });
    

Once injected into a component, a service can also be used in the template. Note `cart` being used below to get data from the cart.

    app/templates/components/cart-contents.hbs
    <ul>
      {{#each cart.items as |item|}}
        <li>
          {{item.name}}
          <button {{action "remove" item}}>Remove</button>
        </li>
      {{/each}}
    </ul>