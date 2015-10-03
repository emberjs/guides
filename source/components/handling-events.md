You can respond to user events on your component like double-clicking, hovering,
and key presses through event handlers. Simply implement the name of the event
you want to respond to as a method on your component.

For example, imagine we have a template like this:

```hbs
{{#double-clickable}}
  This is a double clickable area!
{{/double-clickable}}
```

Let's implement `double-clickable` such that when it is
clicked, an alert is displayed:

```app/components/double-clickable.js
export default Ember.Component.extend({
  doubleClick: function() {
    alert("DoubleClickableComponent was clicked!");
  }
});
```

Browser events may bubble up the DOM which potentially target parent component(s)
in succession. To enable bubbling `return true;` from the event handler method
in your component.

```app/components/double-clickable.js
export default Ember.Component.extend({
  doubleClick: function() {
    Ember.Logger.info("DoubleClickableComponent was clicked!");
    return true;
  }
});
```

See the list of event names at the end of this page. Any event can be defined
as an event handler in your component.

## Sending Actions

In some cases your component needs to define event handlers, perhaps to support
various draggable behaviors. For example, a component may need to send an `id`
when it receives a drop event:

```hbs
{{drop-target action="didDrop"}}
```

You can define the component's event handlers to manage the drop event.
And if you need to, you may also stop events from bubbling, by using
`return false;`.

```app/components/drop-target.js
export default Ember.Component.extend({
  attributeBindings: ['draggable'],
  draggable: 'true',

  dragOver: function() {
    return false;
  },

  drop: function(event) {
    let id = event.dataTransfer.getData('text/data');
    this.sendAction('action', id);
  }
});
```

## Event Names

The event handling examples described above respond to one set of events.
The names of the built-in events are listed below. Custom events can be
registered by using [Ember.Application.customEvents][customEvents].

Touch events:

* `touchStart`
* `touchMove`
* `touchEnd`
* `touchCancel`

Keyboard events

* `keyDown`
* `keyUp`
* `keyPress`

Mouse events

* `mouseDown`
* `mouseUp`
* `contextMenu`
* `click`
* `doubleClick`
* `mouseMove`
* `focusIn`
* `focusOut`
* `mouseEnter`
* `mouseLeave`

Form events:

* `submit`
* `change`
* `focusIn`
* `focusOut`
* `input`

HTML5 drag and drop events:

* `dragStart`
* `drag`
* `dragEnter`
* `dragLeave`
* `dragOver`
* `dragEnd`
* `drop`

[customEvents]: http://emberjs.com/api/classes/Ember.Application.html#property_customEvents
