_Unit testing methods and computed properties follows previous patterns shown 
in [Unit Testing Basics] because Ember.Route extends Ember.Object._

Testing routes can be done both via acceptance or unit tests. Acceptance tests 
will likely provide better coverage for routes because routes are typically used 
to perform transitions and load data, both of which are tested more easily in 
full context rather than isolation.

That being said, sometimes it is important to unit test your routes. For example, 
let's say we'd like to have an alert that can be triggered from anywhere within 
our application. The alert function `displayAlert` should be put into the 
`ApplicationRoute` because all actions and events bubble up to it from 
sub-routes, controllers and views.

```app/routes/application.js
export default Ember.Route.extend({
  actions: {
    displayAlert: function(text) {
      this._displayAlert(text);
    }
  },

  _displayAlert: function(text) {
    alert(text);
  }
});
```

This is made possible by using `moduleFor`.

In this route we've [separated our concerns](http://en.wikipedia.org/wiki/Separation_of_concerns):
The action `displayAlert` contains the code that is called when the action is 
received, and the private function `_displayAlert` performs the work. While not 
necessarily obvious here because of the small size of the functions, separating 
code into smaller chunks (or "concerns"), allows it to be more readily isolated 
for testing, which in turn allows you to catch bugs more easily.

Here is an example of how to unit test this route:

```tests/unit/routes/application-test.js
let originalAlert;

moduleFor('route:application', {
  beforeEach: function() {
    originalAlert = window.alert; // store a reference to window.alert
  },

  afterEach: function() {
    window.alert = originalAlert; // restore window.alert
  }
});

test('Alert is called on displayAlert', function(assert) {
  assert.expect(1);

  // with moduleFor, the subject returns an instance of the route
  var route = this.subject();
  var expectedText = 'foo';

  // stub window.alert to perform a qunit test
  window.alert = function(text) {
    assert.equal(text, expectedText, 'expected ' + text + ' to be ' + expectedText);
  };

  // call the _displayAlert function which triggers the qunit test above
  route._displayAlert(expectedText);
});
```

[Unit Testing Basics]: ../unit-testing-basics
[separated our concerns]: http://en.wikipedia.org/wiki/Separation_of_concerns
