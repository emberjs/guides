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
the DOM will be updated without having to write any code. Because
Glimmer (Ember's rendering engine) will try to re-use DOM whenever
possible, it needs a way to uniquely identify each loop item in order
to prevent unexpected results. This is done by passing the `key`
attribute to the `{{#each}}` helper. The value of the `key` attribute
will be the property Ember looks up on the loop object, in this case
`person`. So `{{#each people key="id" as |person|}}` means Ember will
look up `person.id` to determine the unique identity of the current
item in the loop. Make sure the value you pass to `key` is unique!

The `{{#each}}` helper can have a matching `{{else}}`.
The contents of this block will render if the collection is empty:

```handlebars
{{#each people key="id" as |person|}}
  Hello, {{person.name}}!
{{else}}
  Sorry, nobody is here.
{{/each}}
```
