_Unit testing methods and computed properties follows previous patterns shown
in [Unit Testing Basics] because Ember.Component extends Ember.Object._

Components can be tested using the `moduleForComponent` helper.

Let's assume we have a component with a `style` property that is updated
whenever the value for its `name` property changes. The `style` attribute of the
component is bound to its `style` property.

> You can follow along by generating your own component with `ember generate
> component pretty-color`.

```app/components/pretty-color.js
export default Ember.Component.extend({
  attributeBindings: ['style'],

  style: Ember.computed('name', function() {
    return 'color: ' + this.get('name') + ';';
  })
});
```

```app/templates/components/pretty-color.hbs
Pretty Color: {{name}}
```

The `moduleForComponent` helper will find the component by name (`pretty-color`)
and its template (if available).

```tests/unit/components/pretty-color-test.js
moduleForComponent('pretty-color', {
  // specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']
});
```

Each test following the `moduleForComponent` call has access to the `subject()`
function, which lets us create a new instance of the component, as well as
provide any initial values we want it to have.

We can test that changing the component's `name` property updates the
component's `style` attribute and is reflected in the  rendered HTML:

```tests/unit/components/pretty-color-test.js
test('changing colors', function(assert) {
  assert.expect(2);

  // this.subject() is available because we used moduleForComponent
  var component = this.subject({ name: 'red' });

  // Renders the component to the page
  this.render();

  // Assert the initial style
  assert.equal(this.$().attr('style'), 'color: red;');

  // We wrap this with Ember.run because this.set is an async function
  Ember.run(function() {
    // Change the name
    component.set('name', 'green');
  });

  // Assert the style has changed
  assert.equal(this.$().attr('style'), 'color: green;');
});
```

We might also test this component to ensure that the content of its template is
being rendered properly:

```tests/unit/components/pretty-color-test.js
test('template is rendered with the color name', function(assert) {
  assert.expect(2);

  // this.subject() is available because we used moduleForComponent
  var component = this.subject();

  // Renders the component to the page
  this.render();

  // Assert initial content of the component
  var initialContent = $.trim(this.$().text());
  assert.equal(initialContent, 'Pretty Color:');

  // we wrap this with Ember.run because it is an async function
  Ember.run(function() {
    component.set('name', 'green');
  });

  // Assert content of the component has changed
  var finalContent = $.trim(this.$().text());
  assert.equal(finalContent, 'Pretty Color: green');
});
```

### Testing User Interaction

Components are a great way to create powerful, interactive, and self-contained
custom HTML elements. It is important to test the component's methods _and_ the
user's interaction with the component.

Imagine you have the following component that changes its title when a button is
clicked on:

> You can follow along by generating your own component with `ember generate
> component magic-title`.

```app/components/magic-title.js
export default Ember.Component.extend({
  title: 'Hello World',

  actions: {
    updateTitle() {
      this.set('title', 'This is Magic');
    }
  }
});
```

```app/templates/components/magic-title.hbs
<h2>{{title}}</h2>

<button {{action "updateTitle"}}>
  Update Title
</button>
```

jQuery triggers can be used to simulate user interaction and test that the title
is updated when the button is clicked on:

```tests/unit/components/magic-title-test.js
test('clicking the button updates the title', function(assert) {
  assert.expect(2);

  // Create the component instance
  var component = this.subject();

  // Assert the initial title
  var initialTitle = this.$().find('h2').text();
  assert.equal(initialTitle, 'Hello World');

  // Click on the button
  this.$().find('button').click();

  // Assert that the title has changed
  var finalTitle = this.$().find('h2').text();
  assert.equal(finalTitle, 'Hello Ember World');
});
```

### Testing Actions

Components often utilize the `sendAction()` method to send actions to other
objects in your application.

For example, imagine you have a comment form component that sends a specified
`submit` action when the form is submitted, passing along the form's data:

> You can follow along by generating your own component with `ember generate
> component comment-form`.

```app/components/comment-form.js
export default Ember.Component.extend({
  body: null,

  actions: {
    submit() {
      var body = this.get('body');

      this.sendAction('submit', { body: body });
    }
  }
});
```

```app/templates/components/comment-form.hbs
<form {{action "submit" on="submit"}}>
  <label>Comment:</label>
  {{textarea value=body}}

  <input type="submit" value="Submit">
</form>
```

You might use this component in your application like this:

```handlebars
{{comment-form submit="createComment"}}
```

Here's an example test that asserts that the specified `externalAction` action
is sent when the component's internal `submit` action is triggered by making use
of a test double (dummy object):

```tests/unit/components/comment-form-test.js
test('external action is triggered when form is submitted', function(assert) {
  // This is important to make sure that the test fails if
  // our assertion is never called
  assert.expect(1);

  // Create our test double
  var targetObject = {
    externalAction(attributes) {
      // This assertion will be called when the action is triggered
      assert.deepEqual(attributes, { body: 'You are not a wizard!' });
    }
  };

  // Creates the component
  var component = this.subject({
    // Sets sample data
    body: 'You are not a wizard!',

    // Sets the targetObject to our test double
    // (this is where sendAction will send its action)
    targetObject: targetObject,

    // Specifies which action to send to targetObject on submit
    submit: 'externalAction'
  });

  // Renders the component to the page
  this.render();

  // Submits the form
  this.$().find('input[type="submit"]').click();
});
```

<!---
### Components Using Other Components

Sometimes components are easier to maintain if they're broken up into parent and child
components. Here is a simple example:

```app/components/my-album.js
import layout from '../templates/components/my-kittens';

export default Ember.Component.extend({
  layout: layout,
  tagName: 'img',
  attributeBindings: ['width', 'height', 'src'],
  src: Ember.computed('width', 'height', function() {
    return 'http://placekitten.com/' + this.get('width') + '/' + this.get('height');
  })
});
```

```app/templates/components/my-album.hbs
<h3>{{title}}</h3>
{{yield}}
```

```app/components/my-kitten.js
import layout from '../templates/components/my-kitten';

export default Ember.Component.extend({
  layout: layout,
  tagName: 'img',
  attributeBindings: ['width', 'height', 'src'],
  src: Ember.computed('width', 'height', function() {
    return 'http://placekitten.com/' + this.get('width') + '/' + this.get('height');
  })
});
```

Usage of this component might look something like this:

```handlebars
{{#my-album title="Cats"}}
  {{my-kitten width="200" height="300"}}
  {{my-kitten width="100" height="100"}}
  {{my-kitten width="50" height="50"}}
{{/my-album}}
```

Using the `needs` callback greatly simplifies testing components
with a parent-child relationship.

```tests/unit/components/my-album-test.js
moduleForComponent('my-album', {
  // specify the other units that are required for this test
  needs: ['component:my-kitten']
});


test('renders kittens', function(assert) {
  assert.expect(2);

  // component instance
  var component = this.subject({
    title: 'Cats',
    template: Ember.Handlebars.compile(
      '{{my-kitten width="200" height="300"}}' +
      '{{my-kitten width="100" height="100"}}' +
      '{{my-kitten width="50" height="50"}}'
    )
  });

  // Render the component
  this.$();

  // perform assertions
  assert.equal(this.$().find('h3:contains("Cats")').length, 1);
  assert.equal(this.$().find('img').length, 3);
});
```
-->

[Unit Testing Basics]: ../unit-testing-basics
