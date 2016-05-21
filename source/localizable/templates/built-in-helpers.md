## Built-in Helpers

In the last section you learned how to write a helper.
A helper is usually a simple function that can be
used in any template.
Ember comes with a few helpers that can make developing your
templates a bit easier.
These helpers can allow you to be more dynamic in
passing data to another helper or component.

### Using a helper to get a property dynamically

The [`{{get}}`][1] helper makes it easy to dynamically send the value of a
variable to another helper or component.
This can be useful if you want
to output one of several values based on the result of a computed property.

[1]: http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_get

```handlebars
{{get address part}}
```

if the `part` computed property returns "zip", this will display the result of
`this.get('address.zip')`. If it returns "city", you get `this.get('address.city')`.

### Nesting built-in helpers

In the last section it was discussed that helpers can be nested.
This can be combined with these sorts of dynamic helpers.
For example, the [`{{concat}}`][1] helper makes it easy to dynamically send
a number of parameters to a component or helper as a single parameter in the
format of a concatenated string.

[1]: http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_concat

```handlebars
{{get "foo" (concat "item" index)}}
```

This will display the result of `this.get('foo.item1')` when index is 1,
and `this.get('foo.item2')` when index is 2, etc.
