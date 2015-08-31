An `Ember.Service` is a long-lived Ember object that can be injected as needed.

Example uses of services include:

* Logging
* User/session authentication
* Geolocation
* Third-party APIs
* Web Sockets
* Server-sent events or notifications
* Server-backed API calls that may not fit Ember Data

### Defining Services

To define a service, extend the `Ember.Service` base class:

```app/services/shopping-cart.js
export default Ember.Service.extend({
});
```

Like any Ember object, a service can have properties and methods of its own.

```app/services/shopping-cart.js
export default Ember.Service.extend({
  items: [],

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

To access a service, inject it with `Ember.inject`:

```app/components/cart-contents.js
export default Ember.Component.extend({
  cart: Ember.inject.service('shopping-cart')
});
```

This injects the shopping cart service into the component and makes it available as the `cart` property.

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

The injected property is lazy; the service will not be instantiated until the property is explicitly called. It will then persist until the application exits.

If no argument is provided to `service()`, Ember will use the dasherized version of the property name:

```app/components/cart-contents.js
export default Ember.Component.extend({
  shoppingCart: Ember.inject.service()
});
```

This also injects the shopping cart service, as the `shoppingCart` property.

### Injecting Services Eagerly

Sometimes it makes sense for a service to be available throughout your application without having to inject it into each class individually. Ember Data uses this to give routes access to the shared store.

This can be accomplished with an initializer:

```app/initializers/shopping-cart.js
export default {
  name: 'shopping-cart',
  initialize: function (container, application) {
    application.inject('route', 'cart', 'service:shopping-cart');
  } 
};
```

The `shopping-cart` service will be injected as the `cart` property into every `route` in your application.

You can also inject a service into a specific class:

```app/initializers/shopping-cart.js
application.inject('route:checkout', 'cart', 'service:shopping-cart');
```

If your eagerly-injected service requires some first-time setup that depends on other services, you can set this up in an instance-initializer:

```app/instance-initializers/shopping-cart.js
export default {
  name: 'shopping-cart',
  initialize: function (instance) {
    var store = instance.container.lookup('service:store');
    var cart = instance.container.lookup('service:shopping-cart');
    cart.add(store.findRecord('item', 'plunger'));
  }
};
```