In addition to normal text, you may also want to have your templates contain HTML elements whose attributes are bound to the controller.

For example, imagine your controller has a property that contains a URL to an image:

```handlebars
<div id="logo">
  <img src={{logoUrl}} alt="Logo">
</div>
```

This generates the following HTML:

```html
<div id="logo">
  <img src="http://www.example.com/images/logo.png" alt="Logo">
</div>
```

If you use data binding with a Boolean value, it will add or remove the specified attribute. For example, given this template:

```handlebars
<input type="checkbox" disabled={{isAdministrator}}>
```

If `isAdministrator` is `true`, Handlebars will produce the following HTML element:

```html
<input type="checkbox" disabled>
```

If `isAdministrator` is `false`, Handlebars will produce the following:

```html
<input type="checkbox">
```

### Adding Data Attributes

By default, view helpers do not accept *data attributes*. For example

```handlebars
{{#link-to "photos" data-toggle="dropdown"}}Photos{{/link-to}}

{{input type="text" data-toggle="tooltip" data-placement="bottom" title="Name"}}
```

renders the following HTML:

```html
<a id="ember239" class="ember-view" href="#/photos">Photos</a>

<input id="ember257" class="ember-view ember-text-field" type="text"
       title="Name">
```

To enable support for data attributes an attribute binding must be added to the component, e.g. [`Ember.LinkComponent`](http://emberjs.com/api/classes/Ember.LinkComponent.html) or [`Ember.TextField`](http://emberjs.com/api/classes/Ember.TextField.html) for the specific attribute:

```javascript
Ember.LinkComponent.reopen({
  attributeBindings: ['data-toggle']
});

Ember.TextField.reopen({
  attributeBindings: ['data-toggle', 'data-placement']
});
```

Now the same handlebars code above renders the following HTML:

```html
<a id="ember240" class="ember-view" href="#/photos" data-toggle="dropdown">Photos</a>

<input id="ember259" class="ember-view ember-text-field"
       type="text" data-toggle="tooltip" data-placement="bottom" title="Name">
```