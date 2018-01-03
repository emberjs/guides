Components can be tested with integration tests using the `moduleForComponent` helper.

Let's assume we have a component with a `style` property that is updated
whenever the value of the `name` property changes. The `style` attribute of the
component is bound to its `style` property.

> You can follow along by generating your own component with `ember generate
> component pretty-color`.

```app/components/pretty-color.js
import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({
  attributeBindings: ['style'],

  style: computed('name', function() {
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
import { moduleForComponent, test } from 'ember-qunit';

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
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('pretty-color', 'Integration | Component | pretty color', {
  integration: true
});

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
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('pretty-color', 'Integration | Component | pretty color', {
  integration: true
});

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
import Component from '@ember/component';

export default Component.extend({
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

<button class="title-button" {{action "updateTitle"}}>
  Update Title
</button>
```

We recommend using native DOM events wrapped inside the run loop or the [`ember-native-dom-helpers`](https://github.com/cibernox/ember-native-dom-helpers) addon to simulate user interaction and test that the title is updated when the button is clicked.<br>
Using jQuery to simulate user click events might lead to unexpected test results as the action can potentially be called twice.

```tests/integration/components/magic-title-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { run } from '@ember/runloop';

moduleForComponent('magic-title', 'Integration | Component | magic title', {
  integration: true
});

test('should update title on button click', function(assert) {
  assert.expect(2);

  this.render(hbs`{{magic-title}}`);

  assert.equal(this.$('h2').text(), 'Hello World', 'initial text is hello world');

  //Click on the button
  run(() => document.querySelector('.title-button').click());

  assert.equal(this.$('h2').text(), 'This is Magic', 'title changes after click');
});
```

### Testing Actions

Components starting in Ember 2 utilize closure actions. Closure actions allow components
to directly invoke functions provided by outer components.

For example, imagine you have a comment form component that invokes a
`submitComment` action when the form is submitted, passing along the form's data:

> You can follow along by generating your own component with `ember generate
> component comment-form`.

```app/components/comment-form.js
import Component from '@ember/component';

export default Component.extend({
  comment: '',

  actions: {
    submitComment() {
      this.get('submitComment')({ comment: this.get('comment') });
    }
  }
});
```

```app/templates/components/comment-form.hbs
<form {{action "submitComment" on="submit"}}>
  <label>Comment:</label>
  {{textarea value=comment}}

  <input class="comment-input" type="submit" value="Submit"/>
</form>
```

Here's an example test that asserts that the specified `externalAction` function
is invoked when the component's internal `submitComment` action is triggered by making use
of a test double (dummy function).
`assert.expect(1)` at the top of the test makes sure that the assertion inside the
external action is called:

```tests/integration/components/comment-form-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { run } from '@ember/runloop';

moduleForComponent('comment-form', 'Integration | Component | comment form', {
  integration: true
});

test('should trigger external action on form submit', function(assert) {
  assert.expect(1);

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
   run(() => document.querySelector('.comment-input').click());
});
```

### Stubbing Services

In cases where components have dependencies on Ember services, it is possible to stub these
dependencies for integration tests. You stub Ember services by using the built-in `register()`
function to register your stub service in place of the default.

Imagine you have the following component that uses a location service to display the city
and country of your current location:

> You can follow along by generating your own component with `ember generate
> component location-indicator`.

```app/components/location-indicator.js
import Component from '@ember/component';
import { computed } from '@ember/object';
import { inject as service } from '@ember/service';

export default Component.extend({
  locationService: service('location-service'),

  // when the coordinates change, call the location service to get the current city and country
  city: computed('locationService.currentLocation', function () {
    return this.get('locationService').getCurrentCity();
  }),

  country: computed('locationService.currentLocation', function () {
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
import Service from '@ember/service';

//Stub location service
const locationStub = Service.extend({
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
    // Calling inject puts the service instance in the context of the test,
    // making it accessible as "locationService" within each test
    this.inject.service('location-service', { as: 'locationService' });
  }
});
```

Once the stub service is registered the test simply needs to check that the stub data that
is being returned from the service is reflected in the component output.

```tests/integration/components/location-indicator-test.js{+33,+34,+35,+36}
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Service from '@ember/service';

//Stub location service
const locationStub = Service.extend({
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
    // Calling inject puts the service instance in the context of the test,
    // making it accessible as "locationService" within each test
    this.inject.service('location-service', { as: 'locationService' });
  }
});

test('should reveal current location', function(assert) {
  this.render(hbs`{{location-indicator}}`);
  assert.equal(this.$().text().trim(), 'You currently are located in New York, USA');
});
```

In the next example, we'll add another test that validates that the display changes
when we modify the values on the service.

```tests/integration/components/location-indicator-test.js{+38,+39,+40,+41,+42,+43,+44,+45}
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Service from '@ember/service';

//Stub location service
const locationStub = Service.extend({
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
    // Calling inject puts the service instance in the context of the test,
    // making it accessible as "locationService" within each test
    this.inject.service('location-service', { as: 'locationService' });
  }
});

test('should reveal current location', function(assert) {
  this.render(hbs`{{location-indicator}}`);
  assert.equal(this.$().text().trim(), 'You currently are located in New York, USA');
});

test('should change displayed location when current location changes', function (assert) {
  this.render(hbs`{{location-indicator}}`);
  assert.equal(this.$().text().trim(), 'You currently are located in New York, USA', 'origin location should display');
  this.set('locationService.city', 'Beijing');
  this.set('locationService.country', 'China');
  this.set('locationService.currentLocation', { x: 11111, y: 222222 });
  assert.equal(this.$().text().trim(), 'You currently are located in Beijing, China', 'location display should change');
});
```

### Waiting on Asynchronous Behavior
Often, interacting with a component will cause asynchronous behavior to occur, such as HTTP requests, or timers.  The
`wait` helper is designed to handle these scenarios, by providing a hook to ensure assertions are made after
all Ajax requests and timers are complete.

Imagine you have a typeahead component that uses [`Ember.run.debounce`](https://www.emberjs.com/api/ember/2.16/classes/@ember%2Frunloop/methods/debounce?anchor=debounce)
to limit requests to the server, and you want to verify that results are displayed after typing a character.

> You can follow along by generating your own component with `ember generate
> component delayed-typeahead`.

```app/components/delayed-typeahead.js
import Component from '@ember/component';
import { debounce } from "@ember/runloop";

export default Component.extend({
  actions: {
    handleTyping() {
      //the fetchResults function is passed into the component from its parent
      debounce(this, this.get('fetchResults'), this.get('searchValue'), 250);
    }
  }
});
```

```app/templates/components/delayed-typeahead.hbs
{{input value=searchValue key-up=(action 'handleTyping')}}
<ul>
{{#each results as |result|}}
  <li class="result">{{result.name}}</li>
{{/each}}
</ul>
```

In your integration test, use the `wait` function to wait until your debounce timer is up and then assert
that the page is rendered appropriately.

```tests/integration/components/delayed-typeahead-test.js
import { moduleForComponent, test } from 'ember-qunit';
import wait from 'ember-test-helpers/wait';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('delayed-typeahead', 'Integration | Component | delayed typeahead', {
  integration: true
});

const stubResults = [
  { name: 'result 1' },
  { name: 'result 2' }
];

test('should render results after typing a term', function(assert) {
  assert.expect(2);

  this.set('results', []);
  this.set('fetchResults', (value) => {
    assert.equal(value, 'test', 'fetch closure action called with search value');
    this.set('results', stubResults);
  });

  this.render(hbs`{{delayed-typeahead fetchResults=fetchResults results=results}}`);
  this.$('input').val('test');
  this.$('input').trigger('keyup');

  return wait().then(() => {
    assert.equal(this.$('.result').length, 2, 'two results rendered');
  });

});
```
