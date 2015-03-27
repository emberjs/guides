Sometimes you may only want to display part of your template if a property
exists.

We can use the `{{#if}}` helper to conditionally render a block:

```handlebars
{{#if person}}
  Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
{{/if}}
```

Handlebars will not render the block if the argument passed evaluates to
`false`, `undefined`, `null` or `[]` (i.e., any "falsy" value).

If the expression evaluates to falsy, we can also display an alternate template
using `{{else}}`:

```handlebars
{{#if person}}
  Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
{{else}}
  Please log in.
{{/if}}
```

To only render a block if a value is falsy, use `{{#unless}}`:

```handlebars
{{#unless hasPaid}}
  You owe: ${{total}}
{{/unless}}
```

`{{#if}}` and `{{#unless}}` are examples of block expressions. These allow you
to invoke a helper with a portion of your template. Block expressions look like
normal expressions except that they contain a hash (#) before the helper name,
and require a closing expression.

## Inline-if syntax

We can also use the inline-if to keep code terse:

```handlebars
This message is {{if isImportant 'important' 'unimportant'}}.
```

We can even use this inline-if syntax to bind values to attributes:

```handlebars
<div class="message {{if isImportant 'important' 'unimportant'}}"></div>
```

The inline-if syntax also support the inverse syntax using an inline-unless:

```handlebars
This message is {{unless isImportant 'unimportant' 'important'}}.
```
