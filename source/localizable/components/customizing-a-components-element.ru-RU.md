By default, each component is backed by a `<div>` element. If you were to look at a rendered component in your developer tools, you would see a DOM representation that looked something like:

```html
<div id="ember180" class="ember-view">
  <h1>My Component</h1>
</div>
```

You can customize what type of element Ember generates for your component, including its attributes and class names, by creating a subclass of `Ember.Component` in your JavaScript.

### Customizing the Element

To use a tag other than `div`, subclass `Ember.Component` and assign it a `tagName` property. This property can be any valid HTML5 tag name as a string.

```app/components/navigation-bar.js export default Ember.Component.extend({ tagName: 'nav' });

    <br />```app/templates/components/navigation-bar.hbs
    <ul>
      <li>{{#link-to "home"}}Home{{/link-to}}</li>
      <li>{{#link-to "about"}}About{{/link-to}}</li>
    </ul>
    

### Customizing the Element's Class

You can specify the class of a component's element at invocation time the same way you would for a regular HTML element:

```hbs
{{navigation-bar class="primary"}}
```

You can also specify which class names are applied to the component's element by setting its `classNames` property to an array of strings:

```app/components/navigation-bar.js export default Ember.Component.extend({ classNames: ['primary'] });

    <br />If you want class names to be determined by properties of the component,
    you can use class name bindings. If you bind to a Boolean property, the
    class name will be added or removed depending on the value:
    
    ```app/components/todo-item.js
    export default Ember.Component.extend({
      classNameBindings: ['isUrgent'],
      isUrgent: true
    });
    

This component would render the following:

```html
<div class="ember-view is-urgent"></div>
```

If `isUrgent` is changed to `false`, then the `is-urgent` class name will be removed.

By default, the name of the Boolean property is dasherized. You can customize the class name applied by delimiting it with a colon:

```app/components/todo-item.js export default Ember.Component.extend({ classNameBindings: ['isUrgent:urgent'], isUrgent: true });

    <br />This would render this HTML:
    
    ```html
    <div class="ember-view urgent">
    

Besides the custom class name for the value being `true`, you can also specify a class name which is used when the value is `false`:

```app/components/todo-item.js export default Ember.Component.extend({ classNameBindings: ['isEnabled:enabled:disabled'], isEnabled: false });

    <br />This would render this HTML:
    
    ```html
    <div class="ember-view disabled">
    

You can also specify a class which should only be added when the property is `false` by declaring `classNameBindings` like this:

```app/components/todo-item.js export default Ember.Component.extend({ classNameBindings: ['isEnabled::disabled'], isEnabled: false });

    <br />This would render this HTML:
    
    ```html
    <div class="ember-view disabled">
    

If the `isEnabled` property is set to `true`, no class name is added:

```html
<div class="ember-view">
```

If the bound property's value is a string, that value will be added as a class name without modification:

```app/components/todo-item.js export default Ember.Component.extend({ classNameBindings: ['priority'], priority: 'highestPriority' });

    <br />This would render this HTML:
    
    ```html
    <div class="ember-view highestPriority">
    

### Customizing Attributes

You can bind attributes to the DOM element that represents a component by using `attributeBindings`:

```app/components/link-item.js export default Ember.Component.extend({ tagName: 'a', attributeBindings: ['href'], href: 'http://emberjs.com' });

    <br />You can also bind these attributes to differently named properties:
    
    ```app/components/link-item.js
    export default Ember.Component.extend({
      tagName: 'a',
      attributeBindings: ['customHref:href'],
      customHref: 'http://emberjs.com'
    });
    

If the attribute is null, it won't be rendered:

```app/components/link-item.js export default Ember.Component.extend({ tagName: 'span', title: null, attributeBindings: ['title'], });

    This would render this HTML when no title is passed to the component:
    
    ```html
    <span class="ember-view">
    

...and this HTML when a title of "Ember JS" is passed to the component:

```html
<span class="ember-view" title="Ember JS">
```