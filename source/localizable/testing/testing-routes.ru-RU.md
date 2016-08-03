*Unit testing methods and computed properties follows previous patterns shown in [Unit Testing Basics](../unit-testing-basics) because Ember.Route extends Ember.Object.*

Testing routes can be done both via acceptance or unit tests. Acceptance tests will likely provide better coverage for routes because routes are typically used to perform transitions and load data, both of which are tested more easily in full context rather than isolation.

That being said, sometimes it is important to unit test your routes. For example, let's say we'd like to have an alert that can be triggered from anywhere within our application. The alert function `displayAlert` should be put into the `ApplicationRoute` because all actions and events bubble up to it from sub-routes and controllers.

> By default, Ember CLI does not generate a file for its application route. To extend the behavior of the ember application route we will run the command `ember generate route application`. Ember CLI does however generate an application template, so when asked whether we want to overwrite `app/templates/application.hbs` we will answer 'n'.

```app/routes/application.js import Ember from 'ember';

export default Ember.Route.extend({ actions: { displayAlert(text) { this._displayAlert(text); } },

_displayAlert(text) { alert(text); } });

    <br />In this route we've [separated our concerns](http://en.wikipedia.org/wiki/Separation_of_concerns):
    The action `displayAlert` contains the code that is called when the action is 
    received, and the private function `_displayAlert` performs the work. While not 
    necessarily obvious here because of the small size of the functions, separating 
    code into smaller chunks (or "concerns"), allows it to be more readily isolated 
    for testing, which in turn allows you to catch bugs more easily.
    
    Here is an example of how to unit test this route:
    
    ```tests/unit/routes/application-test.js
    import { moduleFor, test } from 'ember-qunit';
    
    let originalAlert;
    
    moduleFor('route:application', 'Unit | Route | application', {
      beforeEach() {
        originalAlert = window.alert; // store a reference to window.alert
      },
    
      afterEach() {
        window.alert = originalAlert; // restore window.alert
      }
    });
    
    test('should display an alert', function(assert) {
      assert.expect(2);
    
      // with moduleFor, the subject returns an instance of the route
      let route = this.subject();
    
      // stub window.alert to perform a qunit test
      const expectedTextFoo = 'foo';
      window.alert = (text) => {
        assert.equal(text, expectedTextFoo, `expect alert to display ${expectedTextFoo}`);
      };
    
      // call the _displayAlert function which triggers the qunit test above
      route._displayAlert(expectedTextFoo);
    
      // set up a second stub to perform a test with the actual action
      const expectedTextBar = 'bar';
      window.alert = (text) => {
        assert.equal(text, expectedTextBar, `expected alert to display ${expectedTextBar}`);
      };
    
      // Now use the routes send method to test the actual action
      route.send('displayAlert', expectedTextBar);
    });