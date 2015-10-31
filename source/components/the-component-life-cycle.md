Part of what makes a component such a useful tool is that it is closely tied to your app's templates and the DOM itself.

Components are your primary means for direct DOM manipulation, listening and responding to browser events, and attaching 3rd party JS libraries into your Ember app.

To get the most use out of a component, it is important to understand its "life-cycle" methods. The following hooks are a few of the most useful and commonly used in current apps.

## Attaching to the Component Element

Suppose you want to integrate your favorite date picker library into an Ember project. Typically, 3rd party JS/Jquery libraries require a DOM element to bind itself to. So, where is the best place to initialize and attach the library?

When a component successfully renders its backing html element into the DOM, it will trigger its [`didInsertElement()`][1] hook.

It is at this point in the component life-cycle, when [`this.$()`][2] will become available to target with jQuery.

[`this.$()`][2] will, by default, return the component's main element, but it is also valid to target child elements within the component's template as well: `this.$('.some-css-selector')`.

So let's initialize our date picker by overriding the [`didInsertElement()`][1] method with `_super()`.

Date picker libraries usually attach to an `<input>` so we will use jQuery to find an appropriate input within our component's template.

```js
didInsertElement() {
  this._super(...arguments);
  this.$('input.date').myDatepickerLib();
}
```

[`didInsertElement()`][1] is also a place to attach event listeners. This is particularly useful for custom events or other browser events which do not have a [built-in event handler][3].

Perhaps you have some custom CSS animations trigger when the component is rendered and you want to handle some cleanup when it ends?

```js
didInsertElement() {
  this._super(...arguments);
  this.$().on('animationend', () => {
    $(this).removeClass('.sliding-anim');
  });
}
```

**There are a few things to note about the `didInsertElement()` hook:**

- It is only triggered once when the component element is first rendered.
- In the case wherein a parent component is rendering child components, child components trigger their respective [`didInsertElement()`][1] first, and then bubble up to the parent.
- Setting properties in [`didInsertElement()`][1] triggers a re-render, and for performance reasons, is not allowed.
- While [`didInsertElement()`][1] is technically an event that can be listened for using [`on()`][4], it is encouraged to override the default method itself, particularly when order of execution is important.

[1]: http://emberjs.com/api/classes/Ember.Component.html#event_didInsertElement
[2]: http://emberjs.com/api/classes/Ember.Component.html#method__
[3]: http://guides.emberjs.com/v2.1.0/components/handling-events/#toc_event-names
[4]: http://emberjs.com/api/classes/Ember.Component.html#method_on

## Detaching and Tearing Down Component Elements

When a component detects that it is time to remove itself from the DOM, [`willDestroyElement()`][1] will trigger, allowing for any teardown logic to be performed.

This can be triggered by number of conditions, for instance, a conditional htmlbars block closing around your component: `{{#if falseBool}}{{my-component}}{{/if}}`, or a parent template being torn down in response to a route transition.

Let's use that hook to cleanup our date picker and event listener from above:

```js
willDestroyElement() {
  this.$().off('animationend');
  this.$('input.date').myDatepickerLib().destroy();
}
```
There is no default implementation for [`willDestroyElement()`][1] so `_super` is not necessary.

[1]: http://emberjs.com/api/classes/Ember.Component.html#event_willDestroyElement
