Part of what makes components so useful is that they let you take
complete control of a section of the DOM.  This allows for direct DOM
manipulation, listening and responding to browser events, and using 3rd
party JavaScript libraries in your Ember app.

As components are rendered, re-rendered and finally removed, Ember
provides _lifecycle hooks_ that allow you to run code at specific
times in a component's life.

To get the most use out of a component, it is important to understand
these lifecycle methods. The following hooks are a few of the most
useful and commonly used in Ember apps.

## Attaching to the Component Element

Suppose you want to integrate your favorite date picker library into an
Ember project. Typically, 3rd party JS/jQuery libraries require a DOM
element to bind to. So, where is the best place to initialize and attach
the library?

After a component successfully renders its backing HTML element into the
DOM, it will trigger its [`didInsertElement()`][did-insert-element] hook.

Ember guarantees that, by the time `didInsertElement()` is called:

1. The component's element has been both created and inserted into the
   DOM.
2. The component's element is accessible via the component's
   [`$()`][dollar]
   method.

A component's [`$()`][dollar] method allows you to access the
component's DOM element via jQuery. For example, you can set an
attribute using jQuery's `attr()` method:

```js
didInsertElement() {
  this.$().attr('contenteditable', true);
}
```

[`$()`][dollar] will, by default, return a jQuery object for the
component's root element, but you can also target child elements within
the component's template by passing a selector:

```js
didInsertElement() {
  this.$('div p button').addClass('enabled');
}
```

Let's initialize our date picker by overriding the
[`didInsertElement()`][did-insert-element] method.

Date picker libraries usually attach to an `<input>` element, so we will
use jQuery to find an appropriate input within our component's template.

```js
didInsertElement() {
  this.$('input.date').myDatePickerLib();
}
```

[`didInsertElement()`][did-insert-element] is also a good place to
attach event listeners. This is particularly useful for custom events or
other browser events which do not have a [built-in event
handler][event-names].

For example, perhaps you have some custom CSS animations trigger when the component
is rendered and you want to handle some cleanup when it ends:

```js
didInsertElement() {
  this.$().on('animationend', () => {
    $(this).removeClass('.sliding-anim');
  });
}
```

There are a few things to note about the `didInsertElement()` hook:

- It is only triggered once when the component element is first rendered.
- In cases where you have components nested inside other components, the
  child component will always receive the `didInsertElement()` call
  before its parent does.
- Setting properties on the component in
  [`didInsertElement()`][did-insert-element] triggers a re-render, and
  for performance reasons, is not allowed.
- While [`didInsertElement()`][did-insert-element] is technically an
  event that can be listened for using [`on()`][on], it is encouraged to
  override the default method itself, particularly when order of execution
  is important.

[did-insert-element]: http://emberjs.com/api/classes/Ember.Component.html#event_didInsertElement
[dollar]: http://emberjs.com/api/classes/Ember.Component.html#method__
[event-names]: http://guides.emberjs.com/v2.1.0/components/handling-events/#toc_event-names
[on]: http://emberjs.com/api/classes/Ember.Component.html#method_on

## Detaching and Tearing Down Component Elements

When a component detects that it is time to remove itself from the DOM,
Ember will trigger the [`willDestroyElement()`][will-destroy-element]
method, allowing for any teardown logic to be performed.

Component teardown can be triggered by a number of different conditions.
For instance, the user may navigate to a different route, or a
conditional Handlebars block surrounding your component may change:

```hbs
{{#if falseBool}}
  {{my-component}}
{{/if}}
```

Let's use this hook to cleanup our date picker and event listener from above:

```js
willDestroyElement() {
  this.$().off('animationend');
  this.$('input.date').myDatepickerLib().destroy();
}
```

[will-destroy-element]: http://emberjs.com/api/classes/Ember.Component.html#event_willDestroyElement
