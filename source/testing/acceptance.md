Acceptance tests are generally used to test important workflows within your application. They emulate user interaction and confirm expected results.

### Introduction

ember-cli comes with acceptance test support out of the box. For creating your
first test, you just need to run `ember generate acceptance-test <name>`. In
our case, `ember generate acceptance-test user-can-login-via-form`. ember-cli will
create a new test file under `tests/acceptance/`.

After a few imports, ember-cli adds two hooks to the module definition. In the 
beforeEach, a new Ember application is created and put in testing mode. This way, 
the readiness of the application is deferred until your tests are ready to run. 
The helper also sets the router's location to 'none' so that the window's location 
will not be modified. After each test run, the application is destroyed to assure your 
tests are run in isolation.

```tests/acceptance/user-can-login-via-form-test.js
var application;

module('Acceptance: UserCanLoginViaForm', {
  beforeEach: function() {
    application = startApp();
  },

  afterEach: function() {
    Ember.run(application, 'destroy');
  }
});
```

ember-cli also generates a sample test. In this case, we `visit` 
`'/user-can-login-via-form'` and `assert` we got there without any problem.

```tests/acceptance/user-can-login-via-form-test.js
test('visiting /user-can-login-via-form', function(assert) {
  visit('/user-can-login-via-form');

  andThen(function() {
    assert.equal(currentPath(), 'user-can-login-via-form');
  });
});
```

