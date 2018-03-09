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
import Component from '@ember/component';

export default Component.extend({
  doubleClick() {
    alert('DoubleClickableComponent was clicked!');
  }
});
```

Browser events may bubble up the DOM which potentially target parent component(s)
in succession. To enable bubbling `return true;` from the event handler method
in your component.

```app/components/double-clickable.js
import Component from '@ember/component';
import Ember from 'ember';

export default Component.extend({
  doubleClick() {
    console.info('DoubleClickableComponent was clicked!');
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
{{drop-target action=(action "didDrop")}}
```

You can define the component's event handlers to manage the drop event.
And if you need to, you may also stop events from bubbling, by using
`return false;`.

```app/components/drop-target.js
import Component from '@ember/component';

export default Component.extend({
  attributeBindings: ['draggable'],
  draggable: 'true',

  dragOver() {
    return false;
  },

  drop(event) {
    let id = event.dataTransfer.getData('text/data');
    this.get('action')(id);
  }
});
```

In the above component, `didDrop` is the `action` passed in. This action is
called from the `drop` event handler and passes one argument to the action -
the `id` value found through the `drop` event object.


Another way to preserve native event behaviors and use an action, is to
assign a (closure) action to an inline event handler. Consider the
template below which includes an `onclick` handler on a `button` element:

```hbs
<button onclick={{action "signUp"}}>Sign Up</button>
```

The `signUp` action is simply a function defined on the `actions` hash
of a component. Since the action is assigned to an inline handler, the
function definition can define the event object as its first parameter.

```js
actions: {
  signUp(event){
  	// Only when assigning the action to an inline handler, the event object
    // is passed to the action as the first parameter.
  }
}
```

The normal behavior for a function defined in `actions` does not receive the
browser event as an argument. So, the function definition for the action cannot
define an event parameter. The following example demonstrates the
default behavior using an action.

```hbs
<button {{action "signUp"}}>Sign Up</button>
```

```js
actions: {
  signUp() {
    // No event object is passed to the action.
  }
}
```

To utilize an `event` object as a function parameter:

- Define the event handler in the component (which is designed to receive the
  browser event object).
- Or, assign an action to an inline event handler in the template (which
  creates a closure action and does receive the event object as an argument).


## Event Names

The event handling examples described above respond to one set of events.
The names of the built-in events are listed below. Custom events can be
registered by using [Application.customEvents](https://www.emberjs.com/api/ember/release/classes/Application/properties/customEvents?anchor=customEvents).

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
