If you need to enumerate over a list of objects, use Handlebars' `{{#each}}` helper:

```handlebars
<ul>
  {{#each people key="id" as |person|}}
    <li>Hello, {{person.name}}!</li>
  {{/each}}
</ul>
```

The template inside of the `{{#each}}` block will be repeated once for
each item in the array, with the each item set to the `person` keyword.

The above example will print a list like this:

```html
<ul>
  <li>Hello, Yehuda!</li>
  <li>Hello, Tom!</li>
  <li>Hello, Trek!</li>
</ul>
```

Like everything in Handlebars, the `{{#each}}` helper is bindings-aware.
If your application adds a new item to the array, or removes an item,
the DOM will be updated without having to write any code.

### Specifying Keys
  The `key` option is used to tell Ember how to determine if the array being
  iterated over with `{{#each}}` has changed between renders. By helping Ember
  detect that some elements in the array are the same, DOM elements can be
  re-used, significantly improving rendering speed and preventing unexpected
  results. For example, here's the `{{#each}}` helper with its `key` set to
  `id`:
  ```handlebars
  {{#each people key="id" as |person|}}
  {{/each}}
  ```
  When this `{{#each}}` re-renders, Ember will match up the previously rendered
  items (and reorder the generated DOM elements) based on each item's `id`
  property. Make sure the value you pass to `key` is unique!
  
  There are a few special values for `key`:
    * `@index` - The index of the item in the array.
    * `@item` - The item in the array itself.  This can only be used for arrays of strings
      or numbers.
    * `@guid` - Generate a unique identifier for each object (uses `Ember.guidFor`).


### Empty Lists
The `{{#each}}` helper can have a matching `{{else}}`.
The contents of this block will render if the collection is empty:

```handlebars
{{#each people key="id" as |person|}}
  Hello, {{person.name}}!
{{else}}
  Sorry, nobody is here.
{{/each}}
```
