Testing is a core part of the Ember framework and its development cycle.

[QUnit](http://qunitjs.com/) is the default testing framework for this guide, but others are supported too, through addons such as [ember-mocha](https://github.com/emberjs/ember-mocha).

The testing pattern presented below is consistent across different testing frameworks. Only the setup test functions from [ember-qunit](https://github.com/emberjs/ember-qunit) needs to be replaced with the respective setup functions in the testing addon used in order to use other testing frameworks.

### Unit Tests

To get started writing tests, we start with a plain unit test. In the example below, we are testing the function `relativeDate()` by passing a mock value into the function and asserting if the output is what we expected.

```utils/tests/relative-date-test.js
import { module, test } from 'qunit';

module('relativeDate', function(hooks) {
  test('format relative dates correctly', function(assert) {
    assert.equal(relativeDate('2018/01/28 22:24:30'), 'just now');
    assert.equal(relativeDate('2018/01/28 22:23:30'), '1 minute ago');
    assert.equal(relativeDate('2018/01/28 21:23:30'), '1 hour ago');
    assert.equal(relativeDate('2018/01/27 22:23:30'), 'Yesterday');
    assert.equal(relativeDate('2018/01/26 22:23:30'), '2 days ago');
  });
});
```

Notice how there is nothing Ember specific about the test, it is just a straightforward assertion with only QUnit test code in isolation. There is no need to add any Ember specific logic since it does not require the application's container to be setup nor any user interaction.

Examples of Unit Tests are:

* The return value of a `getFullName` utility combines its `firstName` and `lastName` parameters correctly.
* A computed property macro formats a price depending on its `currency` and `cents` dependent keys.
* A utility function that adds padding on a string based on the value passed.

Unit Tests are useful for testing pure functions where the return value is only determined by its input values, without any observable side effects.

### Container Tests

If we need to test the functionality around an Ember class instance, such as a Controller, Service, or Route, we can use a container test to do that by setting up the application's container.

To setup the application’s container, we import the [ember-qunit](https://github.com/emberjs/ember-qunit) addon which provides us with QUnit-specific wrappers around the helpers contained in [ember-test-helpers](https://github.com/emberjs/ember-test-helpers).

In the example below, we import the `setupTest` function from `ember-qunit` and call it with the `hooks` object to setup the test context with access to the `this.owner` property. This provides us direct container access to interact with Ember's [Dependency Injection](https://guides.emberjs.com/v3.0.0/applications/dependency-injection/) system. Direct container access allows us to [lookup](https://emberjs.com/api/ember/release/classes/ApplicationInstance/methods/lookup?anchor=lookup) everything in the application container, like Controllers, Routes, or Services in order to have an instance of it to test in our QUnit test module.

For example, the following is a Container Test for the `flash-messages` service:

```services/tests/flash-messages-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Service | flash-messages', function(hooks) {
  setupTest(hooks);

  test('it buffers messages', function(assert) {
    let service = this.owner.lookup('service:flash-messages');

    service.add('Hello');
    service.add('World!');

    assert.deepEqual(service.get('messages'), ['Hello', 'World!']);
  });
});
```

Container Tests are ideal for testing Controllers, Routes, or Services where we can look up the item we want to test, apply some action unto it, and test its result.

Examples of Container Tests are:

* A `fullName` attribute on a controller is computed by combining its `firstName` and `lastName` attributes.
* A serializer properly converts the blog request payload into a blog post model object.
* Blog dates are properly formatted through a `time` service.

You can read more about these type of tests in the [Testing Routes] and [Testing Controllers] section.

### Rendering Tests

If we need to test the interactions between various parts of the application, such as behaviour between UI controls we can utilize Rendering Tests. 

Rendering Tests are, as the name suggests, rendering components and helpers by verifying the correct behaviour when the component or helper interacts with the system in the same way that it will within the context of the application, including being rendered from a template and receiving Ember's lifecycle hooks.

In terms of setting up the test – Rendering Tests are roughly similar to Container Tests but instead of using `setupTest` from ember-qunit, we import and invoke `setupRendingTest` to render arbitrary templates, including components and helpers (`setupRendingTest` is actually using `setupTest` underneath so everything we had from Container Tests are still applicable.)

For the example below, we also import the `render` and `click` functions from ember-test-helpers to show and interact with the component being tested as well as `hbs` from [htmlbars-inline-precompile](https://github.com/ember-cli/ember-cli-htmlbars-inline-precompile) to help with inline template definitions. With these APIs, we can test clicking on this component and check if the text is successfully updated with each click.

```components/tests/x-counter-test.js
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Component | counter', function(hooks) {
  setupRenderingTest(hooks);

  test('it should count clicks', async function(assert) {
    this.set('value', 0);

    await render(hbs`{{x-counter value=value onUpdate=( … )}}`);
    assert.equal(this.element.textContent, '0 clicks');

    await click('.counter');
    assert.equal(this.element.textContent, '1 click');
  });
});
```

Rendering Tests provides confidence that parts of the system will work within the application in multiple scenarios from data and actions being properly passed between different parts of the system to having the UI rendered as expected.

Examples of Rendering Tests are:

* An author's full name and date are properly displayed in a blog post.
* A user is prevented from typing more than 50 characters into post's title field.
* Submitting a post without a title displays a red validation state on the field and gives the user text indicating that the title is required.
* The blog post list scrolls to position a new post at the top of the viewport.

Rendering Tests are used to test Components and Helpers where we need to render a layout and assert some interaction byproduct occurs.

You can read more about it in the [Testing Components] or the [Testing Helpers] section.

### Application Tests

Finally if we are looking to test user interaction and application flow in order to verify user stories or a feature from an end-user perspective, we can use Application Tests. In these kinds of tests, we interact with the application in the same ways that a user would, such as filling out form fields and clicking buttons. Application tests ensure that the interactions within a project are basically functional, the core features of a project have not regressed, and the project's goals are being met.

Similar to how Rendering Tests builds on top of Container Tests, to setup Application Tests, we import a setup method called `setupApplicationTest` from `ember-qunit` (this also uses `setupTest` underneath.) Unlike Rendering Tests, however, we import the `visit` helper from ember-test-helpers instead of the `render` helper. The visit helper is used to visit a route in the application where we need to assert some end-user behaviour.

```tests/acceptance/post-creation-test.js
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';
import { visit, fillIn, click } from '@ember/test-helpers';

module('Acceptance | posts', function(hooks) {
  setupApplicationTest(hooks);

  test('should add new post', async function(assert) {
    await visit('/posts/new');
    await fillIn('input.title', 'My new post');
    await click('button.submit');

    const title = this.element.querySelector('ul.posts li:first').textContent;
    assert.equal(title, 'My new post');
  });
});
```

In the example above – the Application Test visits a route of the application, and then it fills in some information required, and then it clicks on a button. Afterwards, we are testing that this sequence of events in a certain route creates the desired effect that we want. In this case, our test looks to see if the text in the first element in a list matches what we filled in.

Examples of Application Tests are:

* A user being able to log in via the login form
* A user is able to create a blog post.
* After saving a new post successfully, a user is then shown the list of prior posts.
* A visitor does not have access to the admin panel.

You can read more about how to create these kinds of tests in the [Application tests] section.

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

These commands run your tests using [Testem] to make testing multiple browsers very easy.
You can configure Testem using the `testem.js` file in your application root.

#### Choosing the Tests to Run

To run a subset of your tests by title use the `--filter` option.
Quickly test your current work `ember test --filter="dashboard"`, or only run a certain type of test `ember test --filter="integration"`.
When using QUnit it is possible to exclude tests by adding an exclamation point to the beginning of the filter `ember test --filter="!acceptance"`.

You can also run a group of tests which you have scoped with a `module` before; e.g. for testing the module called `Unit | Service | location` only,
run `ember test --module='Unit | Service | location'`.

[QUnit]: http://qunitjs.com/
[Testem]: https://github.com/airportyh/testem
[Application tests]: ./acceptance
[Testing Basics]: ./unit-testing-basics
[Testing Components]: ./testing-components
[Testing Controllers]: ./testing-controllers
[Testing Routes]: ./testing-routes
[Testing Helpers]: ./testing-helpers
