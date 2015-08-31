Almost every test has a pattern of visiting a route, interacting with the page
(using the helpers), and checking for expected changes in the DOM.

Example:

```tests/acceptance/root-lists-first-page-of-posts-test.js
test('root lists first page of posts', function(assert){
  visit('/posts');
  andThen(function() {
    assert.equal(find('ul.posts li').length, 3, 'The first page should have 3 posts');
  });
});
```

The helpers that perform actions use a global promise object and automatically
chain onto that promise object if it exists. This allows you to write your tests
without worrying about async behaviour your helper might trigger.

```tests/acceptance/new-post-appears-first-test.js
var application;
module('Acceptance: New Post Appears First', {
  beforeEach() {
    application = startApp();
  },
  afterEach() {
    Ember.run(application, 'destroy');
  }
});

test('add new post', function(assert) {
  visit('/posts/new');
  fillIn('input.title', 'My new post');
  click('button.submit');

  andThen(function() {
    assert.equal(find('ul.posts li:first').text(), 'My new post');
  });
});
```

### Testing Transitions

Suppose we have an application which requires authentication. If an unauthenticated user
tries to visit a restricted URL, we generally want to transition them to a login page.  For
example:

```app/routes/profile.js
export default Ember.Route.extend({
  beforeModel() {
    var user = this.modelFor('application');
    if (Ember.isEmpty(user)) {
      this.transitionTo('login');
    }
  }
});
```

To test this transition, we can use the `visit` helper with a restricted URL, and verify
that the user gets redirected to the login page:

```tests/acceptance/transitions-test.js
var application;

module('Acceptance: Transitions', {
  beforeEach() {
    application = startApp();
  },

  afterEach() {
    Ember.run(application, 'destroy');
  }
});

test('visiting /profile', function(assert) {
  visit('/profile');

  andThen(function() {
    assert.equal(currentRouteName(), 'login');
    assert.equal(currentPath(), 'login');
    assert.equal(currentURL(), '/login');
  });
});
```
