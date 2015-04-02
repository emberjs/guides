### Problem

You want to add CSS class names to your Ember Components.

### Solution

Set additional class names with the `classNames` property of subclassed components:

```app/components/awesome-input.js
export default Ember.Component.extend({
  classNames: ['css-framework-fancy-class']  
});
```

```handlebars
{{awesome-input}}
```

```html
<div class="css-framework-fancy-class"></div>
```

### Discussion

If desired, you can apply multiple class names.

```js
classNames: ['bold', 'italic', 'blue']
```

<!---#### Example

<a class="jsbin-embed" href="http://jsbin.com/gihupoqeja/2/embed?live">JS Bin</a>

See [Customizing a Component's Element](../../components/customizing-a-components-element/) for further examples. -->
