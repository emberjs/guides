As a user looks through our list of rentals, they may want to have some interactive options to help them make a decision.
Let's add the ability to toggle the size of the image for each rental.
To do this, we'll use a component.

Let's generate a `rental-listing` component that will manage the behavior for each of our rentals.
A dash is required in every component name to avoid conflicting with a possible HTML element,
so `rental-listing` is acceptable but `rental` isn't.

```shell
ember g component rental-listing
```

Ember CLI will then generate a handful of files for our component:


```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

A component consists of two parts:

* A template that defines how it will look (`app/templates/components/rental-listing.hbs`)
* A JavaScript source file (`app/components/rental-listing.js`) that defines how it will behave.

Our new `rental-listing` component will manage how a user sees and interacts with a rental.
To start, let's move the rental display details for a single rental from the `rentals.hbs` template into `rental-listing.hbs` and add the image field:

```app/templates/components/rental-listing.hbs{+2}
<article class="listing">
  <img src="{{rental.image}}" alt="">
  <h3>{{rental.title}}</h3>
  <div class="detail owner">
    <span>Owner:</span> {{rental.owner}}
  </div>
  <div class="detail type">
    <span>Type:</span> {{rental.propertyType}}
  </div>
  <div class="detail location">
    <span>Location:</span> {{rental.city}}
  </div>
  <div class="detail bedrooms">
    <span>Number of bedrooms:</span> {{rental.bedrooms}}
  </div>
</article>
```

Now in our `rentals.hbs` template, let's replace the old HTML markup within our `{{#each}}` loop
with our new `rental-listing` component:

```app/templates/rentals.hbs{+12,+13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29}
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>Welcome!</h2>
  <p>
    We hope you find exactly what you're looking for in a place to stay.
  </p>
  {{#link-to 'about' class="button"}}
    About Us
  {{/link-to}}
</div>

{{#each model as |rentalUnit|}}
  {{rental-listing rental=rentalUnit}}
{{#each model as |rental|}}
  <article class="listing">
    <h3>{{rental.title}}</h3>
    <div class="detail owner">
      <span>Owner:</span> {{rental.owner}}
    </div>
    <div class="detail type">
      <span>Type:</span> {{rental.propertyType}}
    </div>
    <div class="detail location">
      <span>Location:</span> {{rental.city}}
    </div>
    <div class="detail bedrooms">
      <span>Number of bedrooms:</span> {{rental.bedrooms}}
    </div>
  </article>
{{/each}}
```
Here we invoke the `rental-listing` component by name, and assign each `rentalUnit` as the `rental` attribute of the component.

Our app should behave now as before, with the addition of an image for each rental item.

![App with component and images](../../images/simple-component/app-with-images.png)

## Hiding and Showing an Image

Now we can add functionality that will show the image of a rental when requested by the user.

Let's use the `{{if}}` helper to show our current rental image larger only when `isWide` is set to true, by setting the element class name to `wide`.
We'll also add some text to indicate that the image can be clicked on,
and wrap both with an anchor element,
giving it the `image` class name so that our test can find it.

```app/templates/components/rental-listing.hbs{+2,+4,+5}
<article class="listing">
  <a class="image {{if isWide "wide"}}">
    <img src="{{rental.image}}" alt="">
    <small>View Larger</small>
  </a>
  <h3>{{rental.title}}</h3>
  <div class="detail owner">
    <span>Owner:</span> {{rental.owner}}
  </div>
  <div class="detail type">
    <span>Type:</span> {{rental.propertyType}}
  </div>
  <div class="detail location">
    <span>Location:</span> {{rental.city}}
  </div>
  <div class="detail bedrooms">
    <span>Number of bedrooms:</span> {{rental.bedrooms}}
  </div>
</article>
```

The value of `isWide` comes from our component's JavaScript file, in this case `rental-listing.js`.
Since we want the image to be smaller at first, we will set the property to start as `false`:

```app/components/rental-listing.js{+4}
import Ember from 'ember';

export default Ember.Component.extend({
  isWide: false
});
```

To allow the user to widen the image, we will need to add an action that toggles the value of `isWide`.
Let's call this action `toggleImageSize`

```app/templates/components/rental-listing.hbs{+2}
<article class="listing">
  <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
    <img src="{{rental.image}}" alt="">
    <small>View Larger</small>
  </a>
  <h3>{{rental.title}}</h3>
  <div class="detail owner">
    <span>Owner:</span> {{rental.owner}}
  </div>
  <div class="detail type">
    <span>Type:</span> {{rental.propertyType}}
  </div>
  <div class="detail location">
    <span>Location:</span> {{rental.city}}
  </div>
  <div class="detail bedrooms">
    <span>Number of bedrooms:</span> {{rental.bedrooms}}
  </div>
</article>
```

Clicking the anchor element will send the action to the component.
Ember will then go into the `actions` hash and call the `toggleImageSize` function.

An [actions hash](../../templates/actions/) is an object in the component that contains functions.
These functions are called when the user interacts with the UI, such as clicking.

Let's create the `toggleImageSize` function and toggle the `isWide` property on our component:

```app/components/rental-listing.js{+5,+6,+7,+8,+9}
import Ember from 'ember';

export default Ember.Component.extend({
  isWide: false,
  actions: {
    toggleImageSize() {
      this.toggleProperty('isWide');
    }
  }
});
```


Now when we click the image or the `View Larger` link in our browser, we  see our image show larger.
When we click the enlarged image again, we see it smaller.

![rental listing with expand](../../images/simple-component/styled-rental-listings.png)

Move on to the [next page](../hbs-helper/) for the next feature, or continue on here to test what you just wrote.

### An Integration Test

Ember components are commonly tested with [component integration tests](../../testing/testing-components/).
Component integration tests verify the behavior of a component within the context of Ember's rendering engine.
When running in an integration test, the component goes through its regular [render lifecycle](../../components/the-component-lifecycle/),
and has access to dependent objects, loaded through Ember's resolver.

Our component integration test will test two different behaviors:

* The component should show details about the rental
* The component should toggle the existence of a wide class on click, to expand and shrink the photo of the rental.

Let's update the default test to contain the scenarios we want to verify:

```tests/integration/components/rental-listing-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('rental-listing', 'Integration | Component | rental listing', {
  integration: true
});

test('should display rental details', function(assert) {

});

test('should toggle wide class on click', function(assert) {

});
```

For the test we'll pass the component a fake object that has all the properties that our rental model has.
We'll give the variable the name `rental`, and in each test we'll set `rental` to our local scope, represented by the `this` object.
The render template can access values in local scope.

```tests/integration/components/rental-listing-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

let rental = Ember.Object.create({
  image: 'fake.png',
  title: 'test-title',
  owner: 'test-owner',
  propertyType: 'test-type',
  city: 'test-city',
  bedrooms: 3
});

moduleForComponent('rental-listing', 'Integration | Component | rental listing', {
  integration: true
});

test('should display rental details', function(assert) {
  this.set('rentalObj', rental);
});

test('should toggle wide class on click', function(assert) {
  this.set('rentalObj', rental);
});
```

Now lets render our component using the `render` function.
The `render` function allows us to pass a template string, so that we can declare the component in the same way we do in our templates.
Since we set the `rentalObj` variable to our local scope, we can access it as part of our render string.

```tests/integration/components/rental-listing-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

let rental = Ember.Object.create({
  image: 'fake.png',
  title: 'test-title',
  owner: 'test-owner',
  propertyType: 'test-type',
  city: 'test-city',
  bedrooms: 3
});

moduleForComponent('rental-listing', 'Integration | Component | rental listing', {
  integration: true
});

test('should display rental details', function(assert) {
  this.set('rentalObj', rental);
  this.render(hbs`{{rental-listing rental=rentalObj}}`);
});

test('should toggle wide class on click', function(assert) {
  this.set('rentalObj', rental);
  this.render(hbs`{{rental-listing rental=rentalObj}}`);
});
```

Finally, lets add our actions and assertions.

In the first test, we just want to verify the output of the component, so we just assert that the title and owner text match what we provided in the fake `rental`.

```tests/integration/components/rental-listing-test.js
test('should display rental details', function(assert) {
  this.set('rentalObj', rental);
  this.render(hbs`{{rental-listing rental=rentalObj}}`);
  assert.equal(this.$('.listing h3').text(), 'test-title', 'Title: test-title');
  assert.equal(this.$('.listing .owner').text().trim(), 'Owner: test-owner', 'Owner: test-owner');
});
```
In the second test, we verify that clicking on the image toggles the size.
We will assert that the component is initially rendered without the `wide` class name.
Clicking the image will add the class `wide` to our element, and clicking it a second time will take the `wide` class away.
Note that we find the image element using the CSS selector `.image`.

```tests/integration/components/rental-listing-test.js
test('should toggle wide class on click', function(assert) {
  this.set('rentalObj', rental);
  this.render(hbs`{{rental-listing rental=rentalObj}}`);
  assert.equal(this.$('.image.wide').length, 0, 'initially rendered small');
  this.$('.image').click();
  assert.equal(this.$('.image.wide').length, 1, 'rendered wide after click');
  this.$('.image').click();
  assert.equal(this.$('.image.wide').length, 0, 'rendered small after second click');
});
```
The final test should look as follows:

```tests/integration/components/rental-listing-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

let rental = Ember.Object.create({
  image: 'fake.png',
  title: 'test-title',
  owner: 'test-owner',
  propertyType: 'test-type',
  city: 'test-city',
  bedrooms: 3
});

moduleForComponent('rental-listing', 'Integration | Component | rental listing', {
  integration: true
});

test('should display rental details', function(assert) {
  this.set('rentalObj', rental);
  this.render(hbs`{{rental-listing rental=rentalObj}}`);
  assert.equal(this.$('.listing h3').text(), 'test-title');
  assert.equal(this.$('.listing .owner').text().trim(), 'Owner: test-owner');
});

test('should toggle wide class on click', function(assert) {
  this.set('rentalObj', rental);
  this.render(hbs`{{rental-listing rental=rentalObj}}`);
  assert.equal(this.$('.image.wide').length, 0, 'initially rendered small');
  this.$('.image').click();
  assert.equal(this.$('.image.wide').length, 1, 'rendered wide after click');
  this.$('.image').click();
  assert.equal(this.$('.image.wide').length, 0, 'rendered small after second click');
});
```

Run `ember t -s` to verify that our new test is passing.
To find the new test, locate "Integration | Component | rental listing" in the "Module" field of the test UI.
