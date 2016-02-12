Your app will often need a way to let users interact with controls that change application state. For example, imagine that you have a template that shows a blog title, and supports expanding the post to show the body.

If you add the [`{{action}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_action) helper to an HTML element, when a user clicks the element, the named event will be sent to the template's corresponding component or controller.

```app/templates/components/single-post.hbs <h3 {{action "togglebody"}}>{{title}}</h3> {{#if isShowingBody}} 

{{{body}}} {{/if}}

    <br />In the component or controller, you can then define what the action does within
    the `actions` hook:
    
    ```app/components/single-post.js
    export default Ember.Component.extend({
      actions: {
        toggleBody() {
          this.toggleProperty('isShowingBody');
        }
      }
    });
    

## Action Parameters

You can optionally pass arguments to the action handler. Any values passed to the `{{action}}` helper after the action name will be passed to the handler as arguments.

For example, if the `post` argument was passed:

```handlebars
<p><button {{action "select" post}}>✓</button> {{post.title}}</p>
```

The `select` action handler would be called with a single argument containing the post model:

```app/components/single-post.js export default Ember.Component.extend({ actions: { select(post) { console.log(post.get('title')); } } });

    <br />## Specifying the Type of Event
    
    By default, the
    [`{{action}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_action)
    helper listens for click events and triggers the action when the user clicks
    on the element.
    
    You can specify an alternative event by using the `on` option.
    
    ```handlebars
    <p>
      <button {{action "select" post on="mouseUp"}}>✓</button>
      {{post.title}}
    </p>
    

You should use the `camelCased` event names, so two-word names like `keypress` become `keyPress`.

## Allowing Modifier Keys

By default the `{{action}}` helper will ignore click events with pressed modifier keys. You can supply an `allowedKeys` option to specify which keys should not be ignored.

```handlebars
<button {{action "anActionName" allowedKeys="alt"}}>
  click me
</button>
```

This way the `{{action}}` will fire when clicking with the alt key pressed down.

## Allowing Default Browser Action

By default, the `{{action}}` helper prevents the default browser action of the DOM event. If you want to allow the browser action, you can stop Ember from preventing it.

For example, if you have a normal link tag and want the link to bring the user to another page in addition to triggering an ember action when clicked, you can use `preventDefault=false`:

```handlebars
<a href="newPage.htm" {{action "logClick" preventDefault=false}}>Go</a>
```

Without `preventDefault=false`, if the user clicked on the link, Ember.js will trigger the action, but the user will remain on the current page.

With `preventDefault=false`, if the user clicked on the link, Ember.js will trigger the action *and* the user will be directed to the new page.

## Modifying the action's first parameter

If a `value` option for the [`{{action}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_action) helper is specified, its value will be considered a property path that will be read off of the first parameter of the action. This comes very handy with event listeners and enables to work with one-way bindings.

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

By default, the action handler receives the first parameter of the event listener, the event object the browser passes to the handler, so `bandDidChange` prints `Event {}`.

Using the `value` option modifies that behavior by extracting that property from the event object:

```handlebars
<label>What's your favorite band?</label>
<input type="text" value={{favoriteBand}} onblur={{action "bandDidChange" value="target.value"}} />
```

The `newValue` parameter thus becomes the `target.value` property of the event object, which is the value of the input field the user typed. (e.g 'Foo Fighters')

## Attaching Actions to Non-Clickable Elements

Note that actions may be attached to any element of the DOM, but not all respond to the `click` event. For example, if an action is attached to an `a` link without an `href` attribute, or to a `div`, some browsers won't execute the associated function. If it's really needed to define actions over such elements, a CSS workaround exists to make them clickable, `cursor: pointer`. For example:

```css
[data-ember-action]:not(:disabled) {
  cursor: pointer;
}
```