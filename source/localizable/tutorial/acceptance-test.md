Let's think through what we want to do on the home page of our Super Rentals application.

We want our application to:

* List available rentals.
* Link to information about the company.
* Link to contact information.
* Filter the list of rentals by city.

We can represent these goals as [ember acceptance tests](../../testing/acceptance/).
Acceptance tests interact with our app like an actual person would, but can be automated, ensuring that our app doesn't break in the future.

We'll start by using Ember CLI to generate a new acceptance test:

```shell
ember g acceptance-test list-rentals
```

The command will generate the following output, showing that it created a single file called `list-rentals-test`.

```shell
installing acceptance-test
  create tests/acceptance/list-rentals-test.js
```

Opening the new test file will reveal some boilerplate code that will try to go to the `list-rentals` route and verify that the route is loaded.
This boiler plat code is there to guide you into your first working acceptance test.
Since we are testing our index route, which is `/`, we'll replace occurrences of `/list-rentals` with `/`.

```javascript{-6,+7,-8,+9,-12,+13}
import { test } from 'qunit';
import moduleForAcceptance from 'super-rentals/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | list-rentals');

test('visiting /list-rentals', function(assert) {
test('visiting /', function(assert) {
  visit('/list-rentals');
  visit('/');

  andThen(function() {
    assert.equal(currentURL(), '/list-rentals');
    assert.equal(currentURL(), '/');
  });
});
```

Now run your test suite with `ember t -s` from the command line and you'll see one successful test!

As mentioned before, this test boilerplate is just for checking the environment, so now let's replace this test with our list of goals.

```/tests/acceptance/list-rentals-test.js
import { test } from 'qunit';
import moduleForAcceptance from 'super-rentals/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | homepage');

test('should list available rentals.', function (assert) {
});

test('should link to information about the company.', function (assert) {
});

test('should link to contact information.', function (assert) {
});

test('should filter the list of rentals by city.', function (assert) {
});
```

These tests will fail, since Ember tests will always fail without assertions.
Since we have an idea of what we want our application to look like, we can also add some details to the tests.

Ember acceptance tests provide test helpers to perform common tasks, such as visiting routes, filling in fields, clicking on elements, and waiting for pages to render.

To check that rentals are listed, we'll first visit the index route and check that the results show 3 listings.

```/tests/acceptance/list-rentals-test.js
test('should list available rentals.', function (assert) {
  visit('/');
  andThen(function () {
    assert.equal(this.$('.results .listing').length, 3, "should see 3 listings");
  });
});
```
The test assumes that we show the list of rentals in an element with class `results`, and that each rental will have an element with class `listing`.

The [`visit`](http://emberjs.com/api/classes/Ember.Test.html#method_visit) helper loads the route specified for the given URL.

The [`andThen`](../../testing/acceptance/#toc_wait-helpers) helper waits for all previously called test helpers to complete before executing the function you provide it.
In this case we need to wait for the page to load after `visit`, so that we can assert that the listings are displayed.

For the next two tests, we want to verify that clicking the about and contact page links successfully load the proper URLs.
We'll use the [`click`](http://emberjs.com/api/classes/Ember.Test.html#method_click) helper to simulate a user clicking these links.
After the new screen loads, we just verify that the new URL matches our expectation using the [`currentUrl`](http://emberjs.com/api/classes/Ember.Test.html#method_currentURL) helper.

```/tests/acceptance/list-rentals-test.js
test('should link to about page', function (assert) {
  visit('/');
  click('a:contains("About")');
  andThen(function () {
    assert.equal(currentURL(), '/about', "should navigate to about");
  });
});

test('should link to contacts page', function (assert) {
  visit('/');
  click('a:contains("Contact")');
  andThen(function () {
    assert.equal(currentURL(), '/contact', "should navigate to contact");
  });
});
```
Note that we can call 2 [asynchronous test helpers](../../testing/acceptance/#toc_asynchronous-helpers) in a row without needing to use `andThen` or a promise.
This is because each asynchronous test helper is made to wait until other test helpers are complete.

Finally, we'll test that we can filter the list down according to a city search criteria.
We anticipate having an input field in a container with a class of `list-filter`.
We will fill out "Seattle" as the search criteria in that field, and send a key up event to trigger our filtering action.
Since we control our data, we know that there is only one rental with a city of "Seattle", we assert that the number of listings is one, and that its location is "Seattle"

```/tests/acceptance/list-rentals-test.js
test('should list 1 rental when filtering by Seattle', function (assert) {
  visit('/');
  fillIn('.list-filter input', 'seattle');
  keyEvent('.list-filter input', 'keyup', 69);
  andThen(function () {
    assert.equal(this.$('.results .listing').length, 1, "should show 1 listing");
    assert.equal(this.$(".listing .location:contains('Seattle')").length, 1, "should contain 1 listing with location Seattle");
  });
});
```

Of course, because we have not implemented this functionality yet our tests will all fail.
Your test output should now show all failed tests, which gives us a todo list for the rest of the tutorial.

![failing tests](../../images/acceptance-test/failed-acceptance-tests.png)

As we walk through the tutorial, we'll use our acceptance tests as a checklist of functionality.
When all are green, we've accomplished our high level goals!
