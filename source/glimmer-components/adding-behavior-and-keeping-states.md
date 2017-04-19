Most HTML elements fufills one or more of these purposes: describing the
semantic significance of its content, altering their presentation and adding
behavior.

Take the `<article>` tag for instance: it has no default style rules, but it
provides a semantic description its content. The `<b>` tag on the other hand,
changes the presentation of its content (bolding the text) without conveying
any semantic meanings. Of course, there are also many tags that serves both of
these purposes at the same time, such as the `<ol>` and `<li>` pair. All the
Components we have written so far fall into this category.

Besides semantic and presentational elements, there are also HTML elements
that add *behavior* for its content. For example, clicking on a `<label>` tag
would move the focus to the corresponding input field; likewise, clicking on an
`<a>` tag would navigate the browser to the URL specified in the `href`
attribute.

Ember allows us to add behavior to our Components using JavaScript. In
additional to a Handlebars template, each Component can also have a
corresponding JavaScript file in the `app/components/` directory.

As an example, let's implement a `<random-color>` Component gives its content
a solid fill or a "glow" effect in a different color everytime you click on it:

```app/templates/application.hbs
<random-color fill={{true}}>So</random-color>
<random-color glow={{true}}>many</random-color>
<random-color fill={{true}} glow={{true}}>colors</random-color>!!!
```

```app/templates/components/random-color.hbs
<span>{{yield}}</span>
```

```app/components/random-color.js
import Ember from 'ember';

// Returns a random integer from 0 up to (and excluding) max
function randomInteger(max) {
  return Math.floor( Math.random() * max );
}

// Returns a random color in rgb(x,y,z) format
function randomColor() {
  let r = randomInteger(256),
      g = randomInteger(256),
      b = randomInteger(256);

  return `rgb(${r},${g},${b})`;
}

// Returns a text-shadow for the "glow" effect
function randomGlow() {
  return `0px 0px 4px ${ randomColor() }`;
}

export default Ember.GlimmerComponent.extend({

  setColor() {
    if (this.attrs.fill) {
      this.element.style.color = randomColor();
    }

    if (this.attrs.glow) {
      this.element.style.textShadow = randomGlow();
    }
  },

  didInsertElement() {
    this.setColor();
  },

  click() {
    this.setColor();
  }

});
```

You can see the result [at this Ember twiddle](http://ember-twiddle.com/e55043ce86b0a7fd2117).

**TODO**: remove hax from twiddle

**TODO**: fix ember-cli-shims and use `import Component from 'blah'` here

There are quite a few things going on in this example, so let's break it down.
Like usual, we created a template for our Component in `app/templates/components`,
using a `<span>` as our top-level element and yielding any passed content. As
promised, we also created a JavaScript file for our Component in `app/components`
with a matching filename, `random-color.js`.

In the JavaScript file, we exported a class that inherits `Ember.GlimmerComponent`,
sometimes referred to as the *custom Component class*. We are required to
export one such class whenever we define a Component JavaScript file.

Inside our custom Component class, we defined a custom `setColor` method which
assigns a random color and/or glow to the Component's element (in our case, the
`<span>` tag) using standard [DOM APIs](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/style).
Finally, we defined a `click` handler and implmented the `didInsertElement`
hook to call our `setColor` method.

While this is a rather silly example, it illustrated a few important things
about a Component's JavaScript class:

*   Each Component has a corresponding HTML element (the top-level element)
    which can be accessed through its `element` property. (Technically, the
    element is only available after the Component has been rendered; we will
    get to that bit later.)

    On a related note, if you prefer jQuery, Ember also provides the `$` method
    as a jQuery proxy to the Component's element (it is roughly equivilant to
    calling `$(this.element)`). For example, we can rewrite `setColor` with the
    equivilant jQuery APIs, such as `this.$().css('color', randomColor())`.

*   Components have access to the attributes via the `attrs` hash.

*   Components can implement *event handlers* like `click`, `mouseEnter` and
    `change` to handle UI events.

*   Components can also implement *lifecycle hooks* like `didInsertElement`
    and `willDestroyElement` to get notified at specific points during the
    rendering process.

We will get into the details of each of these point in subsequent sections, but
if you are extra-curious, you can take a peek at [GlimmerComponent's API Docs](http://emberjs.com/api/classes/Ember.GlimmerComponent.html).

**TODO**: write said API Docs ;)

## Maintaining States

Admittedly, our `<random-color>` Component isn't particularly useful or
interesting. That's because we are missing a key ingredient to writing more
complex components: states.

Let's say we want to build a `<expandable-content>` Component. By default, the
Component limits its content to a fixed height and renders a "Show more..."
prompt. When clicked, the Component expands its content to their natural
length. Clicking on it toggles the Component between the two modes.

To do this, we would have to keep track of whether the Component is currently
in the expanded mode or not. Since `GlimmerComponent` is a subclass of
`Ember.Object`, we can just track this state as a property on the Component
instance like usual:

```app/templates/application.hbs
<expandable-content>
  <p>Lorem ipsum dolor sit amet, eu reque aperiam vix. Vel cu albucius
  cotidieque, ut mel admodum vivendo. Paulo populo vivendo vix ...</p>

  <p>Novum efficiendi eu ius...</p>

  <p>Ut eos eloquentiam...</p>

  <p>Dicta saperet perfecto...</p>

  <p>Ne utroque fabellas...</p>
</expandable-content>
```

```app/components/expandable-content.js
import Ember from 'ember';

export default Ember.GlimmerComponent.extend({
  isExpanded: false,

  click() {
    this.toggleProperty('isExpanded');
  }
});
```

```app/templates/components/expandable-content.hbs
<expandable-content class="{{if isExpanded 'expanded'}}">
  {{yield}}

  <button class="prompt">
    {{#if isExpanded}}
      Show Less...
    {{else}}
      Show More...
    {{/if}}
  </button>
</expandable-content>
```

```css
expandable-content {
  display: block;
  height: 200px;
  overflow: hidden;
}

expandable-content.expanded {
  height: auto;
}

/* More CSS to position the button, etc (see Ember Twiddle) */
```

You can see the complete example [at this Ember twiddle](http://ember-twiddle.com/42d98522232b59cb2e9c).

There isn't anything too interesting on the invoking side: we simply wrap the
content we want to display with our `<expandable-content>` Component.

On the Component's JavaScript class, we added an `isExpanded` property and set
its initial value to `false` (so our Componented starts off in the "folded"
mode).

Since we mostly relying on CSS to do the heavy lifting (showing and hiding the
extra content), all we need to do is to add and remove the "expanded" CSS class
on the top-level element depending on the `isExpanded` state and change the
button's label accordingly.

You might have observed that we were able to access the `isExpanded` property
directly from the template. This is because the context of the template is
the Component instance. As a result, all of its properties (including computed
properties) are "in-scope" for the template.

In fact, this is how we were able to access the `attrs` hash from the template
all along – if we don't explicitly define a JavaScript class for our Component,
Ember will automatically create an instance of the generic `GlimmerComponent`
class and use it as the context to run our templates.
