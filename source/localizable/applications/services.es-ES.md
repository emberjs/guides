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
    A continuación el servicio de carrito de compras administra un arreglo de elementos que representa los elementos presentes en el carrito de compras.
    
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

    <br />La otra manera de inyectar un servicio es proveer el nombre del servicio como el argumento.
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      //will load the service in file /app/services/shopping-cart.js
      cart: Ember.inject.service('shopping-cart')
    });
    

Esto inyecta el servicio del carrito de compras en el componente y lo hace disponible como la propiedad `cart`.

Las propiedades inyectadas se cargan en desfase; lo que significa que el servicio no será instanciado hasta que la propiedad sea llamada explícitamente. Por lo tanto, necesitas acceder a los servicios en tu componente utilizando la función `get`, de otra forma podrías obtener un `undefined`.

Una vez cargado, un servicio persistirá hasta que la aplicación exista.

A continuación agregamos una acción para quitar el componente `cart-contents`. Observa que accedemos al servicio `cart` como una llamada a `this.get`.

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ cart: Ember.inject.service('shopping-cart'),

actions: { remove(item) { this.get('cart').remove(item); } } });

    Una vez inyectado en un componente, un servicio puede también ser utilizado en la plantilla.
    Nota que `cart` está siendo usado a continuación para obtener datos del carrito.
    
    ```app/templates/components/cart-contents.hbs
    <ul>
      {{#each cart.items as |item|}}
        <li>
          {{item.name}}
          <button {{action "remove" item}}>Remove</button>
        </li>
      {{/each}}
    </ul>