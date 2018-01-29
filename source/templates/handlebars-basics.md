Ember uses the [Handlebars templating library](http://www.handlebarsjs.com)
to power your app's user interface. Handlebars templates contain static HTML and dynamic content inside Handlebars expressions, which are invoked with double curly braces: `{{}}`.

Dynamic content inside a Handlebars expression is rendered with data-binding. This means if you update a property, your usage of that property in a template will be automatically updated to the latest value.

### Displaying Properties

Templates are backed with a context. A context is an object from which
Handlebars expressions read their properties. In Ember this is often a component. For templates rendered by a route (like `application.hbs`), the context is a controller.

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
import Controller from '@ember/controller';

export default Controller.extend({
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

Ember gives you the ability to [write your own helpers](../writing-helpers/), to bring a minimum of logic into Ember templating.

For example, let's say you would like the ability to add a few numbers together, without needing to define a computed property everywhere you would like to do so.

```app/helpers/sum.js
import { helper } from '@ember/component/helper';

export function sum(params) {
  return params.reduce((a, b) => {
    return a + b;
  });
};

export default helper(sum);
```

The above code will allow you invoke the `sum()` function as a `{{sum}}` handlebars "helper" in your templates:

```html
<p>Total: {{sum 1 2 3}}</p>
```

This helper will output a value of `6`.

Ember ships with several built-in helpers, which you will learn more about in the following guides.

#### Nested Helpers

Helpers have the ability to be nested within other helper invocations and also component invocations.

This gives you the flexibility to compute a value _before_ it is passed in as an argument or an attribute of another.

It is not possible to nest curly braces `{{}}`, so the correct way to nest a helper is by using parentheses `()`:

```html
{{sum (multiply 2 4) 2}}
```

In this example, we are using a helper to multiply `2` and `4` _before_ passing the value into `{{sum}}`.

Thus, the output of these combined helpers is `10`.

As you move forward with these template guides, keep in mind that a helper can be used anywhere a normal value can be used.

Thus, many of Ember's built-in helpers (as well as your custom helpers) can be used in nested form.
