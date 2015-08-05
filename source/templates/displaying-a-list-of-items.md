If you need to enumerate over a list of objects, use Handlebars' `{{#each}}` helper:

```handlebars
<ul>
  {{#each people as |person|}}
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

The `{{#each}}` helper is bindings-aware.  If your
application adds a new item to the array, or removes an item, the DOM
will be updated without having to write any code. Note that a `[].push()`
will not update the helper. Adding items need to be done with `[].pushObject`,
and related [Ember Mutable Array methods](http://emberjs.com/api/classes/Ember.MutableArray.html) so that Ember can observe the change.

### Accessing the list item's `index`

If you would like to have access to the list item's index in your template, simply add it to the params list:

```handlebars
<ul>
  {{#each people as |person index|}}
    <li>Hello, {{person.name}}! You're number {{index}} in line</li>
  {{/each}}
</ul>
```

### Specifying Keys

Ember is able to determine if the array being iterated over with `{{#each}}` has
changed between renders and only touch the affected DOM elements. This
significantly improves rendering speeds by reducing unnecessary DOM
manipulation. It does so by keying the array to each item's `@identity`, which
for Numbers or Strings is the item itself or a generated guid for an object. For
most scenarios, there should be no need to change this.

The `{{#each}}` helper does provide the ability to override the `key` to use the
array's `@index` for situations where you would need this.

```handlebars
{{#each people key="@index" as |person|}}
{{/each}}
```

Remember: the `key` is only used in helping Ember determine how to re-render. It
is different from accessing the index as specified in the previous section.

### Empty Lists
The `{{#each}}` helper can have a matching `{{else}}`.
The contents of this block will render if the collection is empty:

```handlebars
{{#each people as |person|}}
  Hello, {{person.name}}!
{{else}}
  Sorry, nobody is here.
{{/each}}
```
