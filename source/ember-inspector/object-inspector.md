The Inspector includes a panel that allows you to view and interact with your Ember objects. 
To open it, click on any Ember object. You can then view the object's properties.


### Viewing Objects

Here's what you see when you click on an object:


<img src="../../images/guides/ember-inspector/object-inspector-controller.png" width="450">


The Inspector displays the parent objects and mixins that are composed into the chosen object, including the inherited properties.

Each property value in this view is bound to your application, so if the value of a 
property updates in your app, it will be reflected in the Inspector.

If a property name is preceded by a calculator icon, that means it is a [computed property][computed-property]. If the value of a computed property hasn't yet been computed, you can
click on the calculator to compute it.
[computed-property]:../../object-model/computed-properties

### Exposing Objects to the Console

#### Sending from the Inspector to the Console

You can expose objects to the console by clicking on the `$E` button within the Inspector.
This will set the global `$E` variable to the chosen object.

<img src="../../images/guides/ember-inspector/object-inspector-$E.png"
width="450">

You can also expose properties to the console. When you hover over an object's properties, a `$E` button will appear
next to every property. Click on it to expose the property's value to the
console.

<img src="../../images/guides/ember-inspector/object-inspector-property-$E.png" width="450">


#### Sending from the Console to the Inspector

You can send Ember objects and arrays to the Inspector by using
`EmberInspector.inspect` within the console.

```javascript
var object = Ember.Object.create();
EmberInspector.inspect(object);
```

Make sure the Inspector is active when you call this method.



### Editing Properties

You can edit `String`, `Number`, and `Boolean` properties in the Inspector.
Your changes will be reflected immediately in your app. Click on a property's value to start editing it.

<img src="../../images/guides/ember-inspector/object-inspector-edit.png"
width="450">

Edit the property and press the `ENTER` key to commit the change, or `ESC` to cancel.

### Navigating the Inspector

In addition to inspecting the properties above, you can inspect properties that hold Ember objects or arrays.
Click on the property's value to inspect it.

<img src="../../images/guides/ember-inspector/object-inspector-object-property.png" width="450">

You can continue drill into the Inspector as long as properties contain either an
Ember object or an array.
In the image below, we clicked on the `model` property first, then clicked
on the `store` property.

<img src="../../images/guides/ember-inspector/object-inspector-nested-objects.png" width="450">

You can see the path to the current object at the top of the
Inspector. You can go back to the previous object by clicking on the
left-facing arrow at the top left.

### Custom Property Grouping

Some properties are not only grouped by inheritance, but also
by framework level semantics. For example, if you inspect an Ember Data
model, you can see `Attributes`, `Belongs To`, `Has Many`, and `Flags`
groups.

<img src="../../images/guides/ember-inspector/object-inspector-model.png"
width="450">

Library authors can customize how any object will display in the Inspector. 
By defining a `_debugInfo` method, an object can tell the Inspector how it should be rendered.
For an example on how to customize an object's properties, see [Ember Data's
customization][ember-data-debug-info].


[ember-data-debug-info]: https://github.com/emberjs/data/blob/f1be2af71d7402d034bc034d9502733647cad295/packages/ember-data/lib/system/debug/debug_info.js