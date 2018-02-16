The [`{{input}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=input)
and [`{{textarea}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=textarea)
helpers in Ember.js are the easiest way to create common form controls.
Using these helpers, you can create form controls that are almost identical to the native HTML `<input>` or `<textarea>` elements, but are aware of Ember's two-way bindings and can automatically update.

## Text fields

```handlebars
{{input value="http://www.facebook.com"}}
```

Will become:

```html
<input type="text" value="http://www.facebook.com"/>
```

You can pass the following standard `<input>` attributes within the input
helper:

<table>
  <tr><td>`readonly`</td><td>`required`</td><td>`autofocus`</td></tr>
  <tr><td>`value`</td><td>`placeholder`</td><td>`disabled`</td></tr>
  <tr><td>`size`</td><td>`tabindex`</td><td>`maxlength`</td></tr>
  <tr><td>`name`</td><td>`min`</td><td>`max`</td></tr>
  <tr><td>`pattern`</td><td>`accept`</td><td>`autocomplete`</td></tr>
  <tr><td>`autosave`</td><td>`formaction`</td><td>`formenctype`</td></tr>
  <tr><td>`formmethod`</td><td>`formnovalidate`</td><td>`formtarget`</td></tr>
  <tr><td>`height`</td><td>`inputmode`</td><td>`multiple`</td></tr>
  <tr><td>`step`</td><td>`width`</td><td>`form`</td></tr>
  <tr><td>`selectionDirection`</td><td>`spellcheck`</td><td>`type`</td></tr>
</table>

If these attributes are set to a quoted string, their values will be set
directly on the element, as in the previous example. However, when left
unquoted, these values will be bound to a property on the template's current
rendering context. For example:

```handlebars
{{input type="text" value=firstName disabled=entryNotAllowed size="50"}}
```

Will bind the `disabled` attribute to the value of `entryNotAllowed` in the
current context.

## Actions

To dispatch an action on specific events, such as `enter` or `key-press`, use the following

```handlebars
{{input value=firstName key-press="updateFirstName"}}
```

[Event Names](https://www.emberjs.com/api/ember/release/classes/Component) must be dasherized.

## Checkboxes

You can also use the
[`{{input}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/if?anchor=input)
helper to create a checkbox by setting its `type`:

```handlebars
{{input type="checkbox" name="isAdmin" checked=isAdmin}}
```

Checkboxes support the following properties:

* `checked`
* `disabled`
* `tabindex`
* `indeterminate`
* `name`
* `autofocus`
* `form`


Which can be bound or set as described in the previous section.

## Text Areas

```handlebars
{{textarea value=name cols="80" rows="6"}}
```

Will bind the value of the text area to `name` on the current context.

[`{{textarea}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/textarea?anchor=textarea) supports binding and/or setting the following properties:

* `value`
* `name`
* `rows`
* `cols`
* `placeholder`
* `disabled`
* `maxlength`
* `tabindex`
* `selectionEnd`
* `selectionStart`
* `selectionDirection`
* `wrap`
* `readonly`
* `autofocus`
* `form`
* `spellcheck`
* `required`

### Binding dynamic attribute

You might need to bind a property dynamically to an input if you're building a flexible form, for example. To achieve this you need to use the [`{{get}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/get?anchor=get) and [`{{mut}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/mut?anchor=mut) in conjunction like shown in the following example:

```handlebars
{{input value=(mut (get person field))}}
```

The `{{get}}` helper allows you to dynamically specify which property to bind, while the `{{mut}}` helper allows the binding to be updated from the input. See the respective helper documentation for more detail.
