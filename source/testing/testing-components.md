_Unit testing methods and computed properties follows previous patterns shown
in [Unit Testing Basics] because Ember.Component extends Ember.Object._

#### Setup

Create the component to test using `ember generate component pretty-color`:
This Ember component:

```app/components/pretty-color.js
import layout from '../templates/components/pretty-color';

export default Ember.Component.extend({
  layout: layout,
  classNames: ['pretty-color'],
  attributeBindings: ['style'],
  style: Ember.computed('name', function() {
    return 'color: ' + this.get('name') + ';';
  })
});
```

... with its accompanying Handlebars template:

```app/templates/components/pretty-color.hbs
Pretty Color: {{name}}
```

... can be unit tested using the `moduleForComponent` helper.
This helper will find the component by name (pretty-color) and its template (if
available).

```tests/unit/components/pretty-color-test.js
moduleForComponent('pretty-color', {
  // specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']
});
```

Now each test following the `moduleForComponent` call has a `subject()` function,
which aliases the create method on the component factory.

We can test to make sure that changing the component's color property updates
the rendered HTML:

```tests/unit/components/pretty-color-test.js
test('changing colors', function(assert) {

  // this.subject() is available because we used moduleForComponent
  var component = this.subject();

  // we wrap this with Ember.run because it is an async function
  Ember.run(function() {
    component.set('name','red');
  });

  // first call to $() renders the component.
  assert.equal(this.$().attr('style'), 'color: red;');

  // another async function, so we need to wrap it with Ember.run
  Ember.run(function() {
    component.set('name', 'green');
  });

  assert.equal(this.$().attr('style'), 'color: green;');
});
```

We might also test this component to ensure the template is being
rendered properly.

```tests/unit/components/pretty-color-test.js
test('template is rendered with the color name', function(assert) {

  // this.subject() is available because we used moduleForComponent
  var component = this.subject();

  // first call to $() renders the component.
  assert.equal($.trim(this.$().text()), 'Pretty Color:');

  // we wrap this with Ember.run because it is an async function
  Ember.run(function() {
    component.set('name', 'green');
  });

  assert.equal($.trim(this.$().text()), 'Pretty Color: green');
});
```

### Interacting with Components in the DOM

Ember Components are a great way to create powerful, interactive, self-contained
custom HTML elements. Because of this, it is important to test the
component's methods _and_ the user's interaction with the component.

Let's create a very simple component that simply sets its own
title when clicked. Run `ember generate component my-foo` and open the
component file:

```app/components/my-foo.js
import layout from '../templates/components/my-foo';

export default Ember.Component.extend({
  layout: layout,
  title:'Hello World',

  actions: {
    updateTitle: function() {
      this.set('title', 'Hello Ember World');
    }
  }
});
```

Whose template is:

```app/templates/components/my-foo.hbs
<h2>{{title}}</h2>
<button {{action "updateTitle"}}>
    Update Title
</button>
```

We would use jQuery triggers to interact with the rendered component
and test its behavior:

```tests/unit/components/my-foo-test.js
moduleForComponent('my-foo', 'MyFooComponent');

test('clicking link updates the title', function(assert) {
  var component = this.subject();

  // assert default state
  assert.equal(this.$().find('h2').text(), 'Hello World');

  // perform click action
  this.$().find('button').click();

  assert.equal(this.$().find('h2').text(), 'Hello Ember World');
});
```

### `sendAction` validation in components

Components often utilize `sendAction`, which is a way to interact with the Ember
application. Here's a simple component that sends the action `internalAction`
when a button is clicked:

```app/components/my-other-foo.js
import layout from '../templates/components/my-other-foo';

export default Ember.Component.extend({
  layout: layout,

  actions: {
    doSomething: function() {
      this.sendAction('internalAction');
    }
  }
});
```

The button can be found in the template:

```app/templates/components/my-other-foo.hbs
<button {{action "doSomething"}}>
    Do Something
</button>
```

In our test, we will create a test double (dummy object) that receives
the action being sent by the component.

```tests/unit/components/my-other-foo.js
test('trigger external action when button is clicked', function(assert) {
  assert.expect(1);

  // component instance
  var component = this.subject();

  // render it
  this.$();

  var targetObject = {
    externalAction: function() {
      // we have the assertion here which will be
      // called when the action is triggered
      assert.ok(true, 'external Action was called!');
    }
  };

  // setup a fake external action to be called when
  // button is clicked
  component.set('internalAction', 'externalAction');

  // set the targetObject to our dummy object (this
  // is where sendAction will send its action to)
  component.set('targetObject', targetObject);

  // click the button
  this.$().find('button').click();
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
