In addition to normal text, you may also want to have your templates
contain HTML elements whose attributes are bound to the controller.

For example, imagine your controller has a property that contains a URL
to an image:

```handlebars
<div id="logo">
  <img src={{logoUrl}} alt="Logo">
</div>
```

This generates the following HTML when the `logoUrl` property is set in the controller:

```html
<div id="logo">
  <img src="http://www.example.com/images/logo.png" alt="Logo">
</div>
```

### Binding multiple values

Multiple values can also be bound to a single attribute:

```handlebars
<div class="{{priority}} {{placement}}"></div>
```

For further control over how these values are applied, see the [inline-if syntax
documentation on the Conditionals page](/templates/conditionals/#toc_inline-if-syntax).

### Adding data attributes

By default, view helpers do not accept *data attributes*. For example

```handlebars
{{#link-to "photos" data-toggle="dropdown"}}Photos{{/link-to}}

{{input type="text" data-toggle="tooltip" data-placement="bottom" title="Name"}}
```

renders the following HTML:

```html
<a id="ember239" class="ember-view" href="#/photos">Photos</a>

<input id="ember257" class="ember-view ember-text-field" type="text" title="Name">
```

There are two ways to enable support for data attributes. One way would be to add an
attribute binding on the view, e.g. `Ember.LinkView` or `Ember.TextField` for the specific attribute:

```javascript
export default Ember.LinkView.reopen({
  attributeBindings: ['data-toggle']
});

export default Ember.TextField.reopen({
  attributeBindings: ['data-toggle', 'data-placement']
});
```

Now the same handlebars code above renders the following HTML:

```html
<a id="ember240" class="ember-view" href="#/photos" data-toggle="dropdown">Photos</a>

<input id="ember259" class="ember-view ember-text-field"
       type="text" data-toggle="tooltip" data-placement="bottom" title="Name">
```

You can also automatically bind data attributes on the base view with the
following:

```javascript
export default Ember.View.reopen({
  init: function() {
    this._super();
    var self = this;

    // bind attributes beginning with 'data-'
    Em.keys(this).forEach(function(key) {
      if (key.substr(0, 5) === 'data-') {
        self.get('attributeBindings').pushObject(key);
      }
    });
  }
});
```

Now you can add as many data-attributes as you want without having to specify them by name.
