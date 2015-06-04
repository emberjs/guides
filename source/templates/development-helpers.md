## Development Helpers

Handlebars and Ember come with a few helpers that can make developing your
templates a bit easier. These helpers make it simple to output variables into
your browser's console, or activate the debugger from your templates.

### Logging

The `{{log}}` helper makes it easy to output variables or expressions in the
current rendering context into your browser's console:

```handlebars
{{log 'Name is:' name}}
```

The `{{log}}` helper also accepts primitive types such as strings or numbers.

### Adding a breakpoint

The ``{{debugger}}`` helper provides a handlebars equivalent to JavaScript's
`debugger` keyword.  It will halt execution inside the debugger helper and give
you the ability to inspect the current rendering context:

```handlebars
{{debugger}}
```
Just before the helper is invoked two useful variables and a helper are defined:

* `view` The current view.
* `context` The current context. This is likely a controller.
* 'get(<path>)` A helper to lookup properties.

For example, if you are wondering why a specific variable isn't displaying in
your template, you could use the `{{debugger}}` helper. When the breakpoint is
hit, you can use the `get(<path>) in your console to lookup properties:

```javascript
> get('name')
"Bruce Lee"
```
