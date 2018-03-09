A [`Service`](https://www.emberjs.com/api/ember/release/modules/@ember%2Fservice) is an Ember object that lives for the duration of the application, and can be made available in different parts of your application.

Services are useful for features that require shared state or persistent connections. Example uses of services might
include:

* User/session authentication.
* Geolocation.
* WebSockets.
* Server-sent events or notifications.
* Server-backed API calls that may not fit Ember Data.
* Third-party APIs.
* Logging.

### Defining Services

Services can be generated using Ember CLI's `service` generator.
For example, the following command will create the `ShoppingCart` service:

```bash
ember generate service shopping-cart
```

Services must extend the [`Service`](https://www.emberjs.com/api/ember/release/modules/@ember%2Fservice) base class:

```app/services/shopping-cart.js
import Service from '@ember/service';

export default Service.extend({
});
```

Like any Ember object, a service is initialized and can have properties and methods of its own.
Below, the shopping cart service manages an items array that represents the items currently in the shopping cart.

```app/services/shopping-cart.js
import Service from '@ember/service';

export default Service.extend({
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
```

### Accessing Services

To access a service,
you can inject it in any container-resolved object such as a component or another service using the `inject` function from the `@ember/service` module.
There are two ways to use this function.
You can either invoke it with no arguments, or you can pass it the registered name of the service.
When no arguments are passed, the service is loaded based on the name of the variable key.
You can load the shopping cart service with no arguments like below.

```app/components/cart-contents.js
import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  //will load the service in file /app/services/shopping-cart.js
  shoppingCart: service()
});
```

Another way to inject a service is to provide the name of the service as the argument.

```app/components/cart-contents.js
import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  //will load the service in file /app/services/shopping-cart.js
  cart: service('shopping-cart')
});
```

This injects the shopping cart service into the component and makes it available as the `cart` property.

Sometimes a service may or may not exist, like when an initializer conditionally registers a service.
Since normal injection will throw an error if the service doesn't exist,
you must look up the service using Ember's [`getOwner`](https://emberjs.com/api/ember/release/classes/@ember%2Fapplication/methods/getOwner?anchor=getOwner) instead.

```app/components/cart-contents.js
import Component from '@ember/component';
import { computed } from '@ember/object';
import { getOwner } from '@ember/application';

export default Component.extend({
  //will load the service in file /app/services/shopping-cart.js
  cart: computed(function() {
    return getOwner(this).lookup('service:shopping-cart');
  })
});
```

Injected properties are lazy loaded; meaning the service will not be instantiated until the property is explicitly called.
Therefore you need to access services in your component using the `get` function otherwise you might get an undefined.

Once loaded, a service will persist until the application exits.

Below we add a remove action to the `cart-contents` component.
Notice that below we access the `cart` service with a call to`this.get`.

```app/components/cart-contents.js
import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  cart: service('shopping-cart'),

  actions: {
    remove(item) {
      this.get('cart').remove(item);
    }
  }
});
```
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
```
