Testing is a core part of the Ember framework and its development cycle.

Let's assume you are writing an Ember application which will serve as a blog. This application would likely include models such as `user` and `post`. It would also include interactions such as *login* and *create post*. Let's finally assume that you would like to have [automated tests](http://en.wikipedia.org/wiki/Test_automation) in place for your application.

There are three different classifications of tests that you will need: **Acceptance**, **Unit**, and **Integration**.

### Acceptance Tests

Acceptance tests are used to test user interaction and application flow. The tests interact with the application in the same ways that a user would, by doing things like filling out form fields and clicking buttons. Acceptance tests ensure that the features within a project are basically functional, and are valuable in ensuring the core features of a project have not regressed, and that the project's goals are being met.

In the example scenario above, some acceptance tests one might write are:

* A user is able to log in via the login form.
* A user is able to create a blog post.
* After saving a new post successfully, a user is then shown the list of prior posts.
* A visitor does not have access to the admin panel.

### Unit Tests

Unit tests are used to test isolated chunks of functionality, or "units". They can be written against any isolated application logic.

Some specific examples of units tests are:

* A fullname attribute is computed which is the aggregate of its first and last.
* The serializer properly converts the blog request payload into a blog post model object.
* Blog dates are properly formatted.

### Integration Tests

Integration tests serve as a middle ground between acceptance tests, which only interact with the full system through user endpoints, and unit tests, which interact with specific code algorithms on a micro level. Integration tests verify interactions between various parts of the application, such as behavior between UI controls. They are valuable in ensuring data and actions are properly passed between different parts of the system, and provide confidence that parts of the system will work within the application under multiple scenarios.

It is recommended that components be tested with integration tests because the component interacts with the system in the same way that it will within the context of the application, including being rendered from a template and receiving Ember's lifecycle hooks.

Examples of integration tests are:

* An author's full name and date are properly displayed in a blog post.
* A user is prevented from typing more than 50 characters into post's title field.
* Submitting a post without a title displays a red validation state on the field and gives the user text indicating that the title is required.
* The blog post list scrolls to position a new post at the top of the viewport.

### Testing Frameworks

[QUnit](http://qunitjs.com/) is the default testing framework for this guide, but others are supported through third-party addons.

### How to Run Your Tests

Run your tests with `ember test` on the command-line. You can re-run your tests on every file-change with `ember test --server`.

Tests can also be executed when you are running a local development server (started by running `ember server`), at the `/tests` URI which renders the `tests/index.html` template. A word of caution using this approach: Tests run using `ember server` have the environment configuration `development`, whereas tests executed under `ember test --server` are run with the configuration `test`. This could cause differences in execution, such as which libraries are loaded and available. Therefore its recommended that you use `ember test --server` for test execution.

These commands run your tests using [Testem](https://github.com/airportyh/testem) to make testing multiple browsers very easy. You can configure Testem using the `testem.js` file in your application root.

#### Choosing the Tests to Run

To run a subset of your tests by title use the `--filter` option. Quickly test your current work `ember test --filter="dashboard"`, or only run a certain type of test `ember test --filter="integration"`. When using QUnit it is possible to exclude tests by adding an exclamation point to the beginning of the filter `ember test --filter="!acceptance"`.