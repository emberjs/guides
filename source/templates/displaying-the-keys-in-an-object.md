If you need to display all of the keys or values of a JavaScript object in your template,
you can use the [`{{#each-in}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=each-in) helper:

```/app/components/store-categories.js
import Component from '@ember/component';

export default Component.extend({
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
        {{#each products as |product|}}
          <li>{{product}}</li>
        {{/each}}
      </ol>
    </li>
  {{/each-in}}
</ul>
```

The template inside of the `{{#each-in}}` block is repeated once for each key in the passed object.
The first block parameter (`category` in the above example) is the key for this iteration,
while the second block parameter (`products`) is the actual value of that key.

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

### Ordering

An object's keys will be listed in the same order as the array returned from calling `Object.keys` on that object.
If you want a different sort order, you should use `Object.keys` to get an array, sort that array with the built-in JavaScript tools,
and use the [`{{#each}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=each-in) helper instead.

### Empty Lists

The [`{{#each-in}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=each-in)
helper can have a matching `{{else}}`.
The contents of this block will render if the object is empty, null, or undefined:

```handlebars
{{#each-in people as |name person|}}
  Hello, {{name}}! You are {{person.age}} years old.
{{else}}
  Sorry, nobody is here.
{{/each-in}}
```
