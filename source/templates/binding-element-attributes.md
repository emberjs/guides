In addition to normal text, you may also want to have your templates
contain HTML elements whose attributes are bound to the controller.

For example, imagine your controller has a property that contains a URL
to an image:

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

If you use data binding with a Boolean value, it will add or remove
the specified attribute. For example, given this template:

```handlebars
<input type="checkbox" disabled={{isAdministrator}}>
```

If `isAdministrator` is `true`, Handlebars will produce the following
HTML element:

```html
<input type="checkbox" disabled>
```

If `isAdministrator` is `false`, Handlebars will produce the following:

```html
<input type="checkbox">
```

### Adding Other Attributes (Including Data Attributes)

By default, components only accept a limited number of HTML attributes.
This means that some uncommon but perfectly valid attributes, such as `lang` or
custom `data-*` attributes must be specifically enabled. For example, this template:

```handlebars
{{#link-to "photos" data-toggle="dropdown" lang="es"}}Fotos{{/link-to}}
```

Will render the following HTML:

```html
<a id="ember239" class="ember-view" href="#/photos">Fotos</a>
```

To enable support for these attributes, an attribute binding must be
added for each specific attribute on the component.
To do this, you can extend the appropriate components
in your application. For example, for `link-to` you would create your own version
of this component by extending
[`Ember.LinkComponent`](https://www.emberjs.com/api/ember/release/classes/LinkComponent)

```app/components/link-to/component.js
import LinkComponent from '@ember/routing/link-component';

export default LinkComponent.extend({
  attributeBindings: ['data-toggle', 'lang']
});
```

Now the same template above renders the following HTML:

```html
<a id="ember239" class="ember-view" href="#/photos" data-toggle="dropdown" lang="es">Fotos</a>
```
