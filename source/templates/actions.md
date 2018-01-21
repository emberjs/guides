Your app will often need a way to let users interact with controls that
change application state. For example, imagine that you have a template
that shows a blog title, and supports expanding the post to show the body.

If you add the
[`{{action}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/action?anchor=action)
helper to any HTML DOM element, when a user clicks the element, the named event
will be sent to the template's corresponding component or controller.

```app/templates/components/single-post.hbs
<h3><button {{action "toggleBody"}}>{{title}}</button></h3>
{{#if isShowingBody}}
  <p>{{{body}}}</p>
{{/if}}
```

In the component or controller, you can then define what the action does within
the `actions` hook:

```app/components/single-post.js
import Component from '@ember/component';

export default Component.extend({
  actions: {
    toggleBody() {
      this.toggleProperty('isShowingBody');
    }
  }
});
```

You will learn about more advanced usages in the Component's [Triggering Changes With Actions](../../components/triggering-changes-with-actions/) guide,
but you should familiarize yourself with the following basics first.

## Action Parameters

You can optionally pass arguments to the action handler. Any values
passed to the `{{action}}` helper after the action name will be passed to
the handler as arguments.

For example, if the `post` argument was passed:

```handlebars
<p><button {{action "select" post}}>✓</button> {{post.title}}</p>
```

The `select` action handler would be called with a single argument
containing the post model:

```app/components/single-post.js
import Component from '@ember/component';

export default Component.extend({
  actions: {
    select(post) {
      console.log(post.get('title'));
    }
  }
});
```

## Specifying the Type of Event

By default, the
[`{{action}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/action?anchor=action)
helper listens for click events and triggers the action when the user clicks
on the element.

You can specify an alternative event by using the `on` option.

```handlebars
<p>
  <button {{action "select" post on="mouseUp"}}>✓</button>
  {{post.title}}
</p>
```

You should use the <code>camelCased</code> event names, so two-word names like `keypress`
become `keyPress`.

## Allowing Modifier Keys

By default, the `{{action}}` helper will ignore click events with
pressed modifier keys. You can supply an `allowedKeys` option
to specify which keys should not be ignored.

```handlebars
<button {{action "anActionName" allowedKeys="alt"}}>
  click me
</button>
```

This way the `{{action}}` will fire when clicking with the alt key
pressed down.

## Allowing Default Browser Action

By default, the `{{action}}` helper prevents the default browser action of the
DOM event. If you want to allow the browser action, you can stop Ember from
preventing it.

For example, if you have a normal link tag and want the link to bring the user
to another page in addition to triggering an ember action when clicked, you can
use `preventDefault=false`:

```handlebars
<a href="newPage.htm" {{action "logClick" preventDefault=false}}>Go</a>
```

With `preventDefault=false` omitted, if the user clicked on the link, Ember.js
will trigger the action, but the user will remain on the current page.

With `preventDefault=false` present, if the user clicked on the link, Ember.js
will trigger the action *and* the user will be directed to the new page.

## Modifying the action's first parameter

If a `value` option for the
[`{{action}}`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/action?anchor=action)
helper is specified, its value will be considered a property path that will
be read off of the first parameter of the action. This comes very handy with
event listeners and enables to work with one-way bindings.

```handlebars
<label>What's your favorite band?</label>
<input type="text" value={{favoriteBand}} onblur={{action "bandDidChange"}} />
```

Let's assume we have an action handler that prints its first parameter:

```js
actions: {
  bandDidChange(newValue) {
    console.log(newValue);
  }
}
```

By default, the action handler receives the first parameter of the event
listener, the event object the browser passes to the handler, so
`bandDidChange` prints `Event {}`.

Using the `value` option modifies that behavior by extracting that property from
the event object:

```handlebars
<label>What's your favorite band?</label>
<input type="text" value={{favoriteBand}} onblur={{action "bandDidChange" value="target.value"}} />
```

The `newValue` parameter thus becomes the `target.value` property of the event
object, which is the value of the input field the user typed. (e.g 'Foo Fighters')

## Attaching Actions to Non-Clickable Elements

Note that actions may be attached to any element of the DOM, but not all
respond to the `click` event. For example, if an action is attached to an `a`
link without an `href` attribute, or to a `div`, some browsers won't execute
the associated function. If it's really needed to define actions over such
elements, a CSS workaround exists to make them clickable, `cursor: pointer`.
For example:

```css
[data-ember-action]:not(:disabled) {
  cursor: pointer;
}
```

Keep in mind that even with this workaround in place, the `click` event will
not automatically trigger via keyboard driven `click` equivalents (such as
the `enter` key when focused). Browsers will trigger this on clickable
elements only by default. This also doesn't make an element accessible to
users of assistive technology. You will need to add additional things like
`role` and/or `tabindex` to make this accessible for your users.
