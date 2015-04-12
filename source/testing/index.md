Testing is a core part of the Ember framework and its development cycle.

Let's assume you are writing an Ember application which will serve as a blog. 
This application would likely include models such as `user` and `post`. It would 
also include interactions such as _login_ and _create post_. Let's finally 
assume that you would like to have [automated tests] in place for your application. 

There are two different classifications of tests that you will need: 
**Acceptance** and **Unit**.

### Acceptance Tests

Acceptance tests are used to test user interaction and application flow. With 
the example scenario above, some acceptance tests you might write are:

* A user is able to log in via the login form.
* A user is able to create a blog post.
* A visitor does not have access to the admin panel.

### Unit Tests

Unit tests are used to test isolated chunks of functionality, or "units", without 
worrying about their dependencies. Some examples of unit tests for the scenario 
above might be:

* A user has a role
* A user has a username
* A user has a fullname attribute which is the aggregate of its first and last 
  names with a space between
* A post has a title
* A post's title must be no longer than 50 characters

### Testing Frameworks

[QUnit] is the default testing framework for this guide, but others are 
supported through third-party addons.

### How to Run Your Tests

Ember CLI provides three main ways of running your tests. You can run your tests from the command-line, once, with `ember test`. You can re-run your tests on every file-change with `ember test --server`. And when your development server is running with `ember serve`, you can visit `http://localhost:4200/tests` to run your tests with QUnit’s browser interface. For more details, see [Ember CLI – Testing](http://www.ember-cli.com/#testing) and `ember help test`.

### Contributing

The Ember testing guide provides best practices and examples on how to test your
Ember applications. If you find any errors or believe the documentation can be
improved, please feel free to [contribute].

[automated tests]: http://en.wikipedia.org/wiki/Test_automation
[QUnit]: http://qunitjs.com/
[contribute]: https://github.com/emberjs/guides
