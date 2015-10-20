An [`Ember.Service`][1] is a long-lived Ember object that can be made available in
different parts of your application.

[1]: http://emberjs.com/api/classes/Ember.Service.html

Example uses of services include:

* Logging
* User/session authentication
* Geolocation
* Third-party APIs
* Web Sockets
* Server-sent events or notifications
* Server-backed API calls that may not fit Ember Data

### Defining Services

Services can be generated using Ember CLI's `service` generator. For example,
the following command will create the `ShoppingCart` service:

```bash
ember generate service shopping-cart
```

Services must extend the [`Ember.Service`][1] base class:

[1]: http://emberjs.com/api/classes/Ember.Service.html

```app/services/shopping-cart.js
export default Ember.Service.extend({
});
```

Like any Ember object, a service is initialized and can have properties and
methods of its own.

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
```

### Accessing Services

To access a service, inject it either in an initializer or with `Ember.inject`:

```app/components/cart-contents.js
export default Ember.Component.extend({
  cart: Ember.inject.service('shopping-cart')
});
```

This injects the shopping cart service into the component and makes it available
as the `cart` property.

You can then access properties and methods on the service:

```app/components/cart-contents.js
export default Ember.Component.extend({
  cart: Ember.inject.service('shopping-cart'),

  actions: {
    remove(item) {
      this.get('cart').remove(item);
    }
  }
});
```

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

The injected property is lazy; the service will not be instantiated until the
property is explicitly called. It will then persist until the application exits.

If no argument is provided to `service()`, Ember will use the dasherized version
of the property name:

```app/components/cart-contents.js
export default Ember.Component.extend({
  shoppingCart: Ember.inject.service()
});
```

This also injects the shopping cart service, as the `shoppingCart` property.
