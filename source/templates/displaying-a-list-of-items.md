To iterate over a list of items, use the
[`{{#each}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=each)
helper. The first argument to this helper is the array to be iterated, and
the value being iterated is yielded as a block param. Block params are only
available inside the block of their helper.

For example, this template iterates an array named `people` that contains
objects. Each item in the array is provided as the block param `person`.

```handlebars
<ul>
  {{#each people as |person|}}
    <li>Hello, {{person.name}}!</li>
  {{/each}}
</ul>
```

Block params, like function arguments in JavaScript, are positional. `person`
is what each item is named in the above template, but `human` would work just
as well.

The template inside of the `{{#each}}` block will be repeated once for
each item in the array, with the each item set to the `person` block param.

Given an input array like:

```js
[
  { name: 'Yehuda' },
  { name: 'Tom' },
  { name: 'Trek' }
]
```

The above template will render HTML like this:

```html
<ul>
  <li>Hello, Yehuda!</li>
  <li>Hello, Tom!</li>
  <li>Hello, Trek!</li>
</ul>
```

Like other helpers, the `{{#each}}` helper is bound.  If a new item is added to
or removed from the iterated array, the DOM will be updated without having to
write any additional code. That said, Ember requires that you use [special
methods](../../object-model/enumerables/#toc_use-of-observable-methods-and-properties)
to update bound arrays. Also be aware that [using the `key` option with an each
helper](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=each)
can improve re-render performance when an array is replaced with another
containing similar items.

### Accessing an item's `index`

During iteration, the index of each item in the array is provided as a second
block param. Block params are space-separated, without commas. For example:

```handlebars
<ul>
  {{#each people as |person index|}}
    <li>Hello, {{person.name}}! You're number {{index}} in line</li>
  {{/each}}
</ul>
```

### Empty Lists

The [`{{#each}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=each)
helper can have a corresponding `{{else}}`. The contents of this block will
render if the array passed to `{{#each}}` is empty:

```handlebars
{{#each people as |person|}}
  Hello, {{person.name}}!
{{else}}
  Sorry, nobody is here.
{{/each}}
```
