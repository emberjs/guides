To show the basic setup of an Ember application, we'll walk through building an app for a property rental site called Super Rentals. We'll start with a homepage, an about page and a contact page.

Here's a look at what we want to build before we get started.

![super rentals homepage screenshot](../../images/service/style-super-rentals-maps.png)

Let's work through what we want to do on the home page. We want our application to:

* Show rentals on the home page
* Link to information about the company
* Link to contact information
* List the available rentals
* Filter the list of rentals by city
* Show more details for a selected rental

For the remainder of this page, we'll give you an introduction to testing in Ember and get you set up to add tests as we implement pieces of our app. On subsequent tutorial pages, the final sections of each page will be devoted to adding a test for the feature you just implemented. These sections aren't required for a working application and you may move on with the tutorial without writing them.

At this point, you can continue to the [next page](../routes-and-templates/) or read more about Ember testing below.

### Testing Our Application As We Go

We can represent the goals above as [Ember application tests](../../testing/acceptance/). Application tests interact with our app like an actual person would, but are automated, helping ensure that our app doesn't break as you make changes.
You might hear these tests sometimes referred to as "acceptance tests" in Ember, as that's what they have been called in the past.

When we create a new Ember Project using Ember CLI, it uses the [`QUnit`](https://qunitjs.com/) JavaScript test framework to define and run tests.

We'll start by using Ember CLI to generate a new application test:

```shell
ember g acceptance-test list-rentals
```

The command will generate the following output, showing that it created a single file called `tests/acceptance/list-rentals-test.js`.

```shell
installing acceptance-test
  create tests/acceptance/list-rentals-test.js
```

Opening that file will reveal some initial code that will try to go to the `list-rentals` route and verify that the route is loaded. The initial code is there to help us build our first application test.

Since we haven't added any functionality to our application yet, we'll use this first test to get started on running tests in our app.

To do that, replace occurrences of `/list-rentals` in the generated test with `/`. The test will start our app at the base url, `http://localhost:4200/`, and then do a basic check that the page has finished loading and that the url is what we want it to be.

```/tests/acceptance/list-rentals-test.js{-8,+9,-10,+11,-12,+13}
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';
import { visit, currentURL } from '@ember/test-helpers';

module('Acceptance | my acceptance test', function(hooks) {
  setupApplicationTest(hooks);

  test('visiting /list-rentals', async function(assert) {
  test('visiting /', async function(assert) {
    await visit('/list-rentals');
    await visit('/');
    assert.equal(currentURL(), '/list-rentals');
    assert.equal(currentURL(), '/');
  });
});
```

A few of things to note in this simple test:

* Application tests are setup by calling the function `setupApplicationTest`. This function ensures that your Ember application is started and shut down between each test.
* QUnit passes in an object called an [`assert`](https://api.qunitjs.com/assert/) to each test function. An `assert` has functions, such as `equal()`, that allow your test to check for conditions within the test environment. A test must have one passing assert to be successful.
* Ember application tests use a set of test helper functions, such as the `visit` and `currentURL` functions used above. We'll discuss those functions in more detail later in the tutorial.

Now run your test suite with the CLI command, `ember test --server`.

By default, when you run `ember test --server`, Ember CLI runs the [Testem test runner](https://github.com/testem/testem), which runs Qunit in Chrome.

Our launched Chrome web browser now shows 9 successful tests. If you toggle the box labeled "Hide passed tests", you should see our successful application test, along with 8 passing ESLint tests. Ember tests each file you create for syntax issues (known as "linting") using [ESLint](http://eslint.org/).

![Initial Tests Screenshot](../../images/acceptance-test/initial-tests.png)

### Adding Your Application Goals as Tests

As mentioned before, our initial test just made sure everything was running properly. Now let's replace that test with the list of tasks we want our app to handle (described up above).

```/tests/acceptance/list-rentals-test.js{+8,+9,+10,+11,+12,+13,+14,+15,+16,+17,+18,+19,+20,+21,+22,+23,+24,+25,-26,-27,-28,-29}
import { module, test } from 'qunit';
import { visit, currentURL } from '@ember/test-helpers';
import { setupApplicationTest } from 'ember-qunit';

module('Acceptance | list-rentals', function(hooks) {
  setupApplicationTest(hooks);

  test('should show rentals as the home page', async function (assert) {
  });

  test('should link to information about the company.', async function (assert) {
  });

  test('should link to contact information.', async function (assert) {
  });

  test('should list available rentals.', async function (assert) {
  });

  test('should filter the list of rentals by city.', async function (assert) {
  });

  test('should show details for a selected rental', async function (assert) {
  });

  test('visiting /', async function(assert) {
    await visit('/');
    assert.equal(currentURL(), '/');
  });

});
```

Running `ember test --server` will now show 7 failing tests (out of 14). Each of the 6 tests we setup above will fail, plus one ESLint test will fail saying, `assert is defined but never used`. The tests above fail because QUnit requires at least one check for a specific condition (known as an `assert`).

As we continue through this tutorial, we'll use these application tests as our checklist. Once all the tests are passing, we'll have accomplished our high level goals.

![Initial Tests Screenshot](../../images/acceptance-test/acceptance-test.png)
