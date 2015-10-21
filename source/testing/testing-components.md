

Components can be tested with integration tests using the `moduleForComponent` helper.

Let's assume we have a component with a `style` property that is updated
whenever the value for its `name` property changes. The `style` attribute of the
component is bound to its `style` property.

> You can follow along by generating your own component with `ember generate
> component pretty-color`.

```app/components/pretty-color.js
export default Ember.Component.extend({
  attributeBindings: ['style'],

  style: Ember.computed('name', function() {
    const name = this.get('name');
    return `color: ${name}`;
  })
});
```

```app/templates/components/pretty-color.hbs
Pretty Color: {{name}}
```

The `moduleForComponent` helper will find the component by name (`pretty-color`)
and its template (if available).  Make sure to set `integration: true` to enable
integration test capability.

```tests/integration/components/pretty-color-test.js
moduleForComponent('pretty-color', 'Integration | Component | pretty color', {
  integration: true
});
```

Each test following the `moduleForComponent` call has access to the `render()`
function, which lets us create a new instance of the component by declaring
the component in template syntax, as we would in our application.

We can test that changing the component's `name` property updates the
component's `style` attribute and is reflected in the  rendered HTML:

```tests/integration/components/pretty-color-test.js
test('should change colors', function(assert) {
  assert.expect(2);

  // set the outer context to red
  this.set('colorValue', 'red');

  this.render(hbs`{{pretty-color name=colorValue}}`);

  assert.equal(this.$('div').attr('style'), 'color: red', 'starts as red');

  this.set('colorValue', 'blue');

  assert.equal(this.$('div').attr('style'), 'color: blue', 'updates to blue');
});
```

We might also test this component to ensure that the content of its template is
being rendered properly:

```tests/integration/components/pretty-color-test.js
test('should be rendered with its color name', function(assert) {
  assert.expect(2);

  this.set('colorValue', 'orange');

  this.render(hbs`{{pretty-color name=colorValue}}`);

  assert.equal(this.$().text().trim(), 'Pretty Color: orange', 'text starts as orange');

  this.set('colorValue', 'green');

  assert.equal(this.$().text().trim(), 'Pretty Color: green', 'text switches to green');

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

```tests/integration/components/magic-title-test.js
test('should update title on button click', function(assert) {
  assert.expect(2);

  this.render(hbs`{{magic-title}}`);

  assert.equal(this.$('h2').text(), 'Hello World', 'initial text is hello world');

  //Click on the button
  this.$('button').click();

  assert.equal(this.$('h2').text(), 'This is Magic', 'title changes after click');
});
```

### Testing Actions

Components starting in Ember 2 utilize closure actions. Closure actions allow components
to directly invoke functions provided outer components.

For example, imagine you have a comment form component that invokes a
`submitComment` action when the form is submitted, passing along the form's data:

> You can follow along by generating your own component with `ember generate
> component comment-form`.

```app/components/comment-form.js
export default Ember.Component.extend({
  comment: '',

  actions: {
    submitComment() {
      this.attrs.submitComment({ comment: this.get('comment') });
    }
  }
});
```

```app/templates/components/comment-form.hbs
<form {{action "submitComment" on="submit"}}>
  <label>Comment:</label>
  {{textarea value=comment}}

  <input type="submit" value="Submit"/>
</form>
```

Here's an example test that asserts that the specified `externalAction` function
is invoked when the component's internal `submitComment` action is triggered by making use
of a test double (dummy function):

```tests/integration/components/comment-form-test.js
test('should trigger external action on form submit', function(assert) {

  // test double for the external action
  this.set('externalAction', (actual) => {
    let expected = { comment: 'You are not a wizard!' };
    assert.deepEqual(actual, expected, 'submitted value is passed to external action');
  });

  this.render(hbs`{{comment-form submitComment=(action externalAction)}}`);

  // fill out the form and force an onchange
  this.$('textarea').val('You are not a wizard!');
  this.$('textarea').change();

  // click the button to submit the form
  this.$('input').click();
});
```
### Stubbing Services

In cases where components have dependencies on Ember services, it is possible to stub these
dependencies for integration tests. Stub Ember services by using the built-in register
function to register your stub service in place of the default.

Imagine you have the following component that uses a location service to display the city
and country of your current location:

> You can follow along by generating your own component with `ember generate
> component location-indicator`.

```app/components/location-indicator.js
export default Ember.Component.extend({
  locationService: Ember.inject.service('location-service'),

  //when the coordinates change, call the location service to evaluate what the city and country would be
  city: Ember.computed('locationService.currentLocation', function () {
    return this.get('locationService').getCurrentCity();
  }),

  country: Ember.computed('locationService.currentLocation', function () {
    return this.get('locationService').getCurrentCountry();
  })
});
```

```app/templates/components/location-indicator.hbs
You currently are located in {{city}}, {{country}}
```
To stub the location service in your test, create a local stub object that extends
`Ember.Service`, and register the stub as the service your tests need in the
beforeEach function.  In this case we initially force location to New York.


```tests/integration/components/location-indicator-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

//Stub location service
const locationStub = Ember.Service.extend({
  city: 'New York',
  country: 'USA',
  currentLocation: {
    x: 1234,
    y: 5678
  },

  getCurrentCity() {
    return this.get('city');
  },
  getCurrentCountry() {
    return this.get('country');
  }
});

moduleForComponent('location-indicator', 'Integration | Component | location indicator', {
  integration: true,

  beforeEach: function () {
    this.register('service:location-service', locationStub);
    this.inject.service('location-service', { as: 'location' });
  }
});
```

Once the stub service is registered the test simply needs to check that the stub data that
is being returned from the service is reflected in the component output.

```tests/integration/components/location-indicator-test.js
test('should reveal current location', function(assert) {
  this.render(hbs`{{location-indicator}}`);
  assert.equal(this.$().text().trim(), 'You currently are located in New York, USA');
});
```

In the next example, we'll add another test that validates that the display changes
when we modify the values on the service.

```tests/integration/components/location-indicator-test.js
test('should change displayed location when current location changes', function (assert) {
  this.render(hbs`{{location-indicator}}`);
  assert.equal(this.$().text().trim(), 'You currently are located in New York, USA', 'origin location should display');
  this.set('location.city', 'Beijing');
  this.set('location.country', 'China');
  this.set('location.currentLocation', { x: 11111, y: 222222 });
  assert.equal(this.$().text().trim(), 'You currently are located in Beijing, China', 'location display should change');
});
```
