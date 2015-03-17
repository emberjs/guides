Views can have a secondary template that wraps their main template. Like templates,
layouts are Handlebars templates that will be inserted inside the
view's tag.

To tell a view which layout template to use, set its `layoutName` property.

To tell the layout template where to insert the main template, use the Handlebars `{{yield}}` helper.
The HTML contents of a view's rendered `template` will be inserted where the `{{yield}}` helper is.

First, you define the following layout template:

```app/templates/my-layout.hbs
<div class="content-wrapper">
  {{yield}}
</div>
```

And then the following main template:

```app/templates/has-a-layout.hbs
  Hello, <b>{{view.name}}</b>!
```

Finally, you define a view, and instruct it to wrap the template with the defined layout:

```app/views/with-a-layout.js
export default Ember.View.extend({
  name: 'Teddy',
  layoutName: 'my-layout',
  templateName: 'has-a-layout'
});
```

This will result in view instances containing the following HTML

```html
<div class="content-wrapper">
  Hello, <b>Teddy</b>!
</div>
```
