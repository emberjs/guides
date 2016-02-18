An [`Ember.Service`](http://emberjs.com/api/classes/Ember.Service.html) is a long-lived Ember object that can be made available in different parts of your application.

Services are useful for features that require shared state or persistent connections. Example uses of services might include:

* User/session authentication
* Geolocation
* Web Sockets
* Server-sent events or notifications
* Server-backed API calls that may not fit Ember Data
* Third-party APIs
* Logging

### Defining Services

Services can be generated using Ember CLI's `service` generator. For example, the following command will create the `ShoppingCart` service:

```bash
ember generate service shopping-cart
```

Services must extend the [`Ember.Service`](http://emberjs.com/api/classes/Ember.Service.html) base class:

```app/services/shopping-cart.js export default Ember.Service.extend({ });

    <br />Like any Ember object, a service is initialized and can have properties and methods of its own.
    Below the shopping cart service manages an items array that represents the items currently in the shopping cart.
    
    ```app/services/shopping-cart.js
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
        this.get('items').setObjects([]);
      }
    });
    

### Accessing Services

To access a service, you can inject it in any container-resolved object such as a component or another service using the `Ember.inject.service` function. There are 2 ways to use this function. You can either invoke it with no arguments, or you can pass it the registered name of the service. When no arguments are passed the services is loaded based in the name of the variable key. You can load the shopping cart service with no arguments like below.

```app/components/cart-contents.js export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js shoppingCart: Ember.inject.service() });

    <br />The other way to inject a service is to provide the name of the service as the argument.
    
    
    ```app/components/cart-contents.js
    export default Ember.Component.extend({
      //will load the service in file /app/services/shopping-cart.js
      cart: Ember.inject.service('shopping-cart')
    });
    

This injects the shopping cart service into the component and makes it available as the `cart` property.

Injected properties are lazy loaded; meaning the service will not be instantiated until the property is explicitly called. Therefore you need to access services in your component using the `get` function otherwise you might get an undefined.

Once loaded, a service will persist until the application exits.

Below we add a remove action to the `cart-contacts` component. Notice that below we access the `cart` service with a call to`this.get`.

```app/components/cart-contents.js export default Ember.Component.extend({ cart: Ember.inject.service('shopping-cart'),

actions: { remove(item) { this.get('cart').remove(item); } } });

    Once injected into a component, a service can also be used in the template.
    Note `cart` being used below to get data from the cart.
    
    ```app/templates/components/cart-contents.hbs
    <ul>
      {{#each cart.items as |item|}}
        <li>
          {{item.name}}
          <button {{action "remove" item}}>Remove</button>
        </li>
      {{/each}}
    </ul>