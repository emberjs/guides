Ember.js uses the [Handlebars templating library](http://www.handlebarsjs.com)
to power your app's user interface. Handlebars templates contain static HTML and
dynamic content inside Handlebars expressions, which are invoked with double
curly braces: `{{}}`.

Dynamic content inside a Handlebars expression is rendered with data-binding. This means if
you update a property, your usage of that property in a template will be
automatically updated to the latest value.

### Displaying Properties

Templates are backed with a context. A context is an object from which
Handlebars expressions read their properties. In Ember this is often a component. For
templates rendered by a route (like `application.hbs`), the context is a
controller.

For example, this `application.hbs` template will render a first and last name:

```app/templates/application.hbs
Hello, <strong>{{firstName}} {{lastName}}</strong>!
```

The `firstName` and `lastName` properties are read from the
context (the application controller in this case), and rendered inside the
`<strong>` HTML tag.

To provide a `firstName` and `lastName` to the above template, properties
must be added to the application controller. If you are following along with
an Ember CLI application, you may need to create this file:

```app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  firstName: 'Trek',
  lastName: 'Glowacki'
});
```

The above template and controller render as the following HTML:

```html
Hello, <strong>Trek Glowacki</strong>!
```

Remember that `{{firstName}}` and `{{lastName}}` are bound data. That means
if the value of one of those properties changes, the DOM will be updated
automatically.

As an application grows in size, it will have many templates backed by
controllers and components.

### Helpers

Helpers bring a minimum of logic into Ember templating. Ember ships with several
built-in helpers, which are explained in the following guides, and also allows
you to [write your own helpers](../writing-helpers/).
