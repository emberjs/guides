An HTML element's `class` attribute can be bound like any other
attribute:

```handlebars
<div class={{priority}}>
  Warning!
</div>
```

If the component's `priority` property is `"p4"`, this template will emit the following HTML:

```html
<div class="p4">
  Warning!
</div>
```

### Conditonal Values

If you want a class value based on a conditonal property, use the Handlebars `if` helper:

```handlebars
<div class={{if isUrgent 'is-urgent'}}>
  Warning!
</div>
```

If `isUrgent` is true, this emits the following HTML:

```html
<div class="is-urgent">
  Warning!
</div>
```

If `isUrgent` is false, no class name is added:

```html
<div>
  Warning!
</div>
```

You can also specify a class name to add when the property is `false`:

```handlebars
<div class={{if isEnabled 'enabled' 'disabled'}}>
  Warning!
</div>
```

In this case, if the `isEnabled` property is `true`, the `enabled`
class will be added. If the property is `false`, the class `disabled`
will be added.

