Components allow you to define UI controls that can be reused throughout
your application. If they're generic enough, they can even be shared across
multiple applications.

In order to make a useful control, we would need to allow our users to
interact with our Components and handle these interaction somehow. Let's
look at two ways to handle UI events in Ember Components.

## Event Handlers

The first way to handle UI events in Components is to implement event handler
methods on the Component's JavaScript class. We have already seen this in
action in the previous section – the `click` method we implemented on both of
our Components are an example of this.

More generally, when an UI event fires inside your Component (i.e. on the top-
level element itself or any of its children, including any yielded content),
Ember would try to invoke the corresponding event handler method on the
Component instance if one exists.

You can refer to [GlimmerComponent's API Docs](http://emberjs.com/api/classes/Ember.GlimmerComponent.html)
for the full list of available events.

**TODO**: write said API Docs T___T

Your event handler methods are called with the jQuery Event object as an
argument, which allows you to supress the browser's default behavior for
the event or inspect its target.

For exmaple, we can write a `<link-supressor>` Component that censors
certain hyperlinks:

```app/templates/application.hbs
<link-supressor pattern="(facebook|twitter)" message="Get back to work!">
  <ul>
    <li>Not censored: <a href="http://emberjs.com">http://emberjs.com</a></li>
    <li>Censored: <a href="http://facebook.com">http://facebook.com</a></li>
    <li>Censored: <a href="http://twitter.com">http://twitter.com</a></li>
    <li>Not censored: <a href="http://wikipedia.org">http://wikipedia.org</a></li>
  </ul>
</link-supressor>
```

```app/components/link-supressor.js
import Ember from 'ember';

export default Ember.GlimmerComponent.extend({

  click(event) {
    var pattern = new RegExp(this.attrs.pattern || ".*");
    var href = (event.target.tagName === "A") && (event.target.href);

    if (href && pattern.test(href)) {
      alert(this.attrs.message || "Link blocked!");
      event.preventDefault();
    }
  }

});
```

You can try this Component in action over [at this Ember twiddle](https://gist.github.com/chancancode/a92d7a68d438d7acdfa2).

(You might have noticed that we didn't specify a template for the Component –
in this case Ember will generate a default template for us that resembles
`<link-supressor>{{yield}}</link-supressor>`.)

**TODO**: make the default template use IDEs.

## Actions

Sometimes, you might want to react to UI events from specific child elements
in your Component's template. While you can do by inspecting the event's target
in your event handler methods, that seems unnecessarily cumbersome.

Instead, we can use actions instead. You might remember [learning about them in
the templates chapter](../../templates/actions). Indeed, we are talking about
the same `{{action}}` helper that you already know about, but there are two
important differences.

First, `{{action}}`s in Components do not bubble; instead, they must be handled
directly by the Component itself. Second, you cannot use the `{{action}}`
helper on the Component's top-level element.

For example, this is how we could refactor `<expandable-content>` to limit the
toggling behavior to the "Show more/less..." button instead of the entire
Component:

```app/components/expandable-content.js
import Ember from 'ember';

expnort default Ember.GlimmerComponent.extend({
  isExpanded: false,

  actions: {
    toggle() {
      this.toggleProperty('isExpanded');
    }
  }
});
```

```app/templates/components/expandable-content.hbs
<expandable-content class="{{if isExpanded 'expanded'}}">
  {{yield}}

  <button class="prompt" {{action "toggle"}}>
    {{#if isExpanded}}
      Show Less...
    {{else}}
      Show More...
    {{/if}}
  </button>
</expandable-content>
```

You can play with the complete example [at this Ember twitter](http://ember-twiddle.com/e67f77c0fb49e61648a9).

The `{{action}}` helper can accept arguments, listen for different event
types and more. For details about using the `{{action}}` helper, see the
[Actions section](../../templates/actions) of the Templates chapter.
