Testing is a core part of the Ember framework and its development cycle.

Let's assume you are writing an Ember application which will serve as a blog.
This application would likely include models such as `user` and `post`.
It would also include interactions such as _login_ and _create post_.
Let's finally assume that you would like to have [automated tests] in place for your application.

There are four different types of test setups you can choose from:

### Application Tests

Some tests will require you to test user interaction and application flow.
In these kinds of tests, you interact with the application in the same ways that a user would, such as filling out form fields and clicking buttons. You might also want to check if the user navigates to different routes while interacting with the application.
Application tests ensure that the interactions within a project are basically functional, the core features of a project have not regressed, and the project's goals are being met.

In the example scenario above, some of the tests you might write are:

* A user is able to log in via the login form.
* A user is able to create a blog post.
* After saving a new post successfully, a user is then shown the list of prior posts.
* A visitor does not have access to the admin panel.

For tests that require a full application setup we can use the `setupApplicationTest` helper.
You can read more about how to create these kinds of tests in the [Application tests] section.

### Rendering Tests

Rendering tests will verify interactions between various parts of the application,
such as behavior between UI controls.
Typically they require the UI to be rendered to be able to execute user interactions in the testing scenario.
They are valuable in ensuring data and actions are properly passed between different parts of the system
and provide confidence that parts of the system will work within the application in multiple scenarios.

Rendering tests are especially useful for verifying the correct behavior of components and helpers.
The component or helper interacts with the system in the same way that it will within the context of the application,
including being rendered from a template and receiving Ember's lifecycle hooks.

Examples of these kinds of tests are:

* An author's full name and date are properly displayed in a blog post.
* A user is prevented from typing more than 50 characters into post's title field.
* Submitting a post without a title displays a red validation state on the field and gives the user text indicating that the title is required.
* The blog post list scrolls to position a new post at the top of the viewport.

We can create an isolated rendering test with the `setupRenderingTest` helper.
You can read more about it in the [Testing Components] or the [Testing Helpers] section.

### Container Tests

Container tests are useful if you are testing a small part of your app which doesn't require user interaction to be tested
but which requires the application's container to be setup.
If you would like to test the functionality regarding an Ember class instance,
e.g. a controller, service or route, you can create this kind of test to verify its behavior.

Some specific examples of these type of tests are:

* A `fullName` attribute on a controller is computed by combining its `firstName` and `lastName` attributes.
* A serializer properly converts the blog request payload into a blog post model object.
* Blog dates are properly formatted through a `time` service.

We can create these isolated container tests with the `setupTest` helper.
You can read more about these type of tests in the [Testing Routes] and [Testing Controllers] section.

### Simple Unit Tests

If you would like to test an isolated, small-scoped functionality, you can create a unit test.
Unit tests are the go-to testing type if you neither require user interactions nor an application container setup to create your test case.

Some specific examples of these type of tests are:

* The return value of a `getFullName` utility combines its `firstName` and `lastName` parameters correctly.
* A computed property macro formats a price depending on its `currency` and `cents` dependent keys.
* A helper computes the current date properly.

We can create these type of isolated tests without the use of any additional helpers,
as they neither require the application's container to be setup nor any user interaction.

### Testing Frameworks

[QUnit] is the default testing framework for this guide, but others are supported, too through addons, e.g. [ember-mocha](https://github.com/emberjs/ember-mocha).

### Testing Blueprints

By default whenever you are creating a new component, helper, service, or any another module in your app,
[Ember CLI](https://ember-cli.com/generators-and-blueprints) will automatically create a QUnit-based test file
based on the associated testing blueprint for you.
This blueprint will contain all the basic test setup necessary for testing the module you have just created
and help you get started writing your first test straight away.

Imagine we create a new `location` service by running `ember generate service location`.
If we have a look at the newly created blueprint under `tests/unit/services/location-test.js` we'll find the following:

```tests/unit/models/some-thing-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Service | location', function(hooks) {
  setupTest(hooks);

  // Replace this with your real tests.
  test('it exists', function(assert) {
    let service = this.owner.lookup('service:location');
    assert.ok(service);
  });
});
```

Note how this test setup follows a nested structure.
Each test case will be wrapped by a [QUnit.module](https://api.qunitjs.com/QUnit/module) function
which allows us to scope several tests into a group.
We can now apply the same testing setup to all tests in this test group easily,
or we can run those tests independently from the rest of the test suite.

### How to Run Your Tests

Run your tests with `ember test` on the command-line. You can re-run your tests on every file-change with `ember test --server`.

Tests can also be executed when you are running a local development server (started by running `ember server`),
at the `/tests` URI which renders the `tests/index.html` template.
A word of caution using this approach:
Tests run using `ember server` have the environment configuration `development`,
whereas tests executed under `ember test --server` are run with the configuration `test`.
This could cause differences in execution, such as which libraries are loaded and available.
Therefore it's recommended that you use `ember test --server` for test execution.

These commands run your tests using [Testem] to make testing multiple browsers very easy.
You can configure Testem using the `testem.js` file in your application root.

#### Choosing the Tests to Run

To run a subset of your tests by title use the `--filter` option.
Quickly test your current work `ember test --filter="dashboard"`, or only run a certain type of test `ember test --filter="integration"`.
When using QUnit it is possible to exclude tests by adding an exclamation point to the beginning of the filter `ember test --filter="!acceptance"`.

You can also run a group of tests which you have scoped with a `module` before; e.g. for testing the module called `Unit | Service | location` only,
run `ember test --module='Unit | Service | location'`.

[automated tests]: http://en.wikipedia.org/wiki/Test_automation
[QUnit]: http://qunitjs.com/
[Testem]: https://github.com/airportyh/testem
[Application tests]: ../acceptance
[Testing Basics]: ../unit-testing-basics
[Testing Components]: ../testing-components
[Testing Helpers]: ../testing-helpers
