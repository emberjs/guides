If you need to display all of the keys or values of a
JavaScript object in your template, you can use the `{{#each-in}}`
helper:

```/app/components/store-categories.js
export Ember.Component.extend({
  willRender() {
    // Set the "categories" property to a JavaScript object
    // with the category name as the key and the value a list
    // of products.
    this.set('categories', {
      'Bourbons': ['Bulleit', 'Four Roses', 'Woodford Reserve'],
      'Ryes': ['WhistlePig', 'High West']
    });
  }
});
```

```/app/templates/components/store-categories.hbs
<ul>
  {{#each-in categories as |category products|}}
    <li>{{category}}
      <ol>
        {{#each products key="@item" as |product|}}
          <li>{{product}}</li>
        {{/each}}
      </ol>
    </li>
  {{/each-in}}
</ul>
```

The template inside of the `{{#each-in}}` block is repeated once for
each key in the passed object. The first block parameter (`category` in
the above example) is the key for this iteration, while the second block
parameter (`product`) is the actual value of that key.

The above example will print a list like this:

```html
<ul>
  <li>Bourbons
    <ol>
      <li>Bulleit</li>
      <li>Four Roses</li>
      <li>Woodford Reserve</li>
    </ol>
  </li>
  <li>Ryes
    <ol>
      <li>WhistlePig</li>
      <li>High West</li>
    </ol>
  </li>
</ul>
```

### Re-rendering

The `{{#each-in}}` helper **does not observe property
changes** to the object passed into it. In the above example, if you were
to add a key to the component's `categories` property after the
component had rendered, the template would **not** automatically update.

```/app/components/store-categories.js
export default Ember.Component.extend({
  willRender() {
    this.set('categories', {
      'Bourbons': ['Bulleit', 'Four Roses', 'Woodford Reserve'],
      'Ryes': ['WhistlePig', 'High West']
    });
  },

  actions: {
    addCategory(category) {
      // This won't work!
      let categories = this.get('categories');
      categories[category] = [];
    }
  }
});
```

In order to cause a component to re-render after you have added,
removed or changed a property from an object, you need to either `set()` the
property on the component again, or manually trigger a re-render of the
component via `rerender()`:

```/app/components/store-categories.js
export default Ember.Component.extend({
  willRender() {
    this.set('categories', {
      'Bourbons': ['Bulleit', 'Four Roses', 'Woodford Reserve'],
      'Ryes': ['WhistlePig', 'High West']
    });
  },

  actions: {
    addCategory(category) {
      let categories = this.get('categories');
      categories[category] = [];

      // A manual re-render causes the DOM to be updated
      this.rerender();
    }
  }
});
```

### Ordering

An object's keys will be listed in the same order as the array returned
from calling `Object.keys` on that object. If you want a different sort
order, you should use `Object.keys` to get an array, sort that array
with the built-in JavaScript tools, and use the `{{#each}}` helper
instead.

### Empty Lists
The `{{#each-in}}` helper can have a matching `{{else}}`.
The contents of this block will render if the object is empty, null, or
undefined:

```handlebars
{{#each-in people as |name person|}}
  Hello, {{name}}! You are {{person.age}} years old.
{{else}}
  Sorry, nobody is here.
{{/each-in}}
```
