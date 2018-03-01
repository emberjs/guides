For Super Rentals, we want to arrive at a home page which displays a list of rentals.
From there, we should be able to visit an about page and our contact page.

## An About Route

Let's start by building our "about" page.

In Ember, when we want to make a new page that can be visited using a URL,
we need to generate a "route" using Ember CLI. For a quick overview of how
Ember structures things, see [our diagram on the Core Concepts page](../../getting-started/core-concepts/).

Let's use Ember's route generator to start our `about` route.

```shell
ember generate route about
```

or for short,

```shell
ember g route about
```

_Note: Running `ember help generate` will list a number of other Ember resources you can create as well ..._

And here's what our generator prints out:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

An Ember route is built with three parts:

1. An entry in the Ember router (`/app/router.js`), which maps between our route name and a specific URI
2. A route handler file, which sets up what should happen when that route is loaded _`(app/routes/about.js)`_
3. A route template, which is where we display the actual content for the page _`(app/templates/about.hbs)`_

If we open `/app/router.js`, we'll see a new line of code for the **about** route, calling
`this.route('about')` in the `Router.map` function. That new line of code tells the Ember router
to run our `/app/routes/about.js` file when a visitor navigates to `/about`.

```app/router.js{+10}
import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('about');
});

export default Router;
```

Because we only plan to display static content on our about page, we won't adjust the `/app/routes/about.js`
route handler file right now. Instead, let's open our `/app/templates/about.hbs` template file and add some info about
Super Rentals:

```app/templates/about.hbs
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>About Super Rentals</h2>
  <p>
    The Super Rentals website is a delightful project created to explore Ember.
    By building a property rental site, we can simultaneously imagine traveling
    AND building Ember applications.
  </p>
</div>
```

Now run `ember serve` (or `ember server`, or even `ember s` for short) on your command line to start
the Ember development server and then go to [`http://localhost:4200/about`](http://localhost:4200/about) to
see our new page in action!

## A Contact Route

Now let's create another route with contact details for the company.
Once again, we'll start by generating a route:

```shell
ember g route contact
```

Here again, we add a new `contact` route in `app/router.js` and generate a route handler in `app/routes/contact.js`.

In the route template `/app/templates/contact.hbs`, let's add our contact details:

```app/templates/contact.hbs
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>Contact Us</h2>
  <p>Super Rentals Representatives would love to help you<br>choose a destination or answer
    any questions you may have.</p>
  <p>
    Super Rentals HQ
    <address>
      1212 Test Address Avenue<br>
      Testington, OR 97233
    </address>
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br>
    <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p>
</div>
```

Now when we go to [`http://localhost:4200/contact`](http://localhost:4200/contact), we'll see our contact page.

## Navigating with Links and the {{link-to}} Helper

Moving around our site is a bit of a pain right now, so let's make that easier.
We'll put a link to the contact page on the about page, and a corresponding link to the about
page on the contact page.

To do that, we'll use a [`{{link-to}}`](../../templates/links/) helper that Ember provides
that makes it easy to link between our routes.  Let's adjust our `about.hbs` file:

```app/templates/about.hbs{+9,+10,+11}
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>About Super Rentals</h2>
  <p>
    The Super Rentals website is a delightful project created to explore Ember.
    By building a property rental site, we can simultaneously imagine traveling
    AND building Ember applications.
  </p>
  {{#link-to "contact" class="button"}}
    Contact Us
  {{/link-to}}
</div>
```

In this case, we're telling the `{{link-to}}` helper the name of the route we want to link to: `contact`.
When we look at our about page at [`http://localhost:4200/about`](http://localhost:4200/about), we now have
a working link to our contact page:

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

Now, we'll add our corresponding link to the contact page so we can move back and forth between `about` and `contact`:

```app/templates/contact.hbs{+15,+16,+17}
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>Contact Us</h2>
  <p>Super Rentals Representatives would love to help you<br>choose a destination or answer
    any questions you may have.</p>
  <p>
    Super Rentals HQ
    <address>
      1212 Test Address Avenue<br>
      Testington, OR 97233
    </address>
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br>
    <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p>
  {{#link-to "about" class="button"}}
    About
  {{/link-to}}
</div>
```

## A Rentals Route
In addition to our `about` and `contact` pages, we want to show a list of rentals that
our visitors can look through. So let's add a third route and call it `rentals`:

```shell
ember g route rentals
```

And then let's update our new template (`/app/templates/rentals.hbs`) with some initial content.
We'll come back to this page in a bit to add in the actual rental properties.

```app/templates/rentals.hbs
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>Welcome!</h2>
  <p>We hope you find exactly what you're looking for in a place to stay.</p>
  {{#link-to "about" class="button"}}
    About Us
  {{/link-to}}
</div>
```

## An Index Route

With our three routes in place, we are ready to add an index route, which will handle requests to the root URI (`/`) of our site.
We'd like to make the rentals page the main page of our application, and we've already created a route.
Therefore, we want our index route to simply forward to the `rentals` route we've already created.

Using the same process we did for our about and contact pages, we will first generate a new route called `index`.

```shell
ember g route index
```

We can see the now familiar output for the route generator:

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

Unlike the other route handlers we've made so far, the `index` route is special:
it does NOT require an entry in the router's mapping.
We'll learn more about why the entry isn't required later on when we look at [nested routes](../subroutes) in Ember.

All we want to do when a user visits the root (`/`) URL is transition to `/rentals`.
To do this we will add code to our index route handler by implementing a route lifecycle hook,
called `beforeModel`.

Each route handler has a set of "lifecycle hooks", which are functions that are invoked at specific times during the loading of a page.
The [`beforeModel`](https://www.emberjs.com/api/ember/release/classes/Route/methods/beforeModel?anchor=beforeModel)
hook gets executed before the data gets fetched from the model hook, and before the page is rendered.
See [the next section](../model-hook) for an explanation of the model hook.

In our index route handler, we'll call the [`replaceWith`](https://www.emberjs.com/api/ember/release/classes/Route/methods/beforeModel?anchor=replaceWith) function.
The `replaceWith` function is similar to the route's [`transitionTo()`](https://www.emberjs.com/api/ember/release/classes/Route/methods/transitionTo?anchor=transitionTo) function,
the difference being that `replaceWith` will replace the current URL in the browser's history,
while `transitionTo` will add to the history.
Since we want our `rentals` route to serve as our home page, we will use the `replaceWith` function.

In our index route handler, we add the `replaceWith` invocation to `beforeModel`.

```app/routes/index.js{+4,+5,+6}
import Route from '@ember/routing/route';

export default Route.extend({
  beforeModel() {
    this.replaceWith('rentals');
  }
});
```

Now visiting the root route at `/` will result in the `/rentals` URL loading.

## Adding a Banner with Navigation

In addition to adding individual links to each route of our app, we'd like to
add a common header across the top of our page to display our app's title and its navigation bar.

To show something on every page, we can use the application template (which we edited earlier).
Let's open it again (`/app/templates/application.hbs`) and replace its contents with the following:

```app/templates/application.hbs
<div class="container">
  <div class="menu">
    {{#link-to "index"}}
      <h1>
        <em>SuperRentals</em>
      </h1>
    {{/link-to}}
    <div class="links">
      {{#link-to "about" class="menu-about"}}
        About
      {{/link-to}}
      {{#link-to "contact" class="menu-contact"}}
        Contact
      {{/link-to}}
    </div>
  </div>
  <div class="body">
    {{outlet}}
  </div>
</div>
```

We've seen most of this before, but the `{{outlet}}` beneath `<div class="body">` is new.
The `{{outlet}}` helper tells Ember where content for our current route (such as `about`
or `contact`) should be shown.

At this point, we should be able to navigate between our `about`, `contact`, and `rentals` pages.

From here you can move on to the [next page](../model-hook/) or dive into testing the new functionality we just added.

## Implementing Application Tests

Now that we have various pages in our application, let's walk through how to build tests for them.

As mentioned earlier on the [Planning the Application page](../acceptance-test/),
an Ember application test automates interacting with our app in a similar way to a visitor.

If you open the application test we created (`/tests/acceptance/list-rentals-test.js`), you'll see our
goals, which include the ability to navigate to an `about` page and a `contact` page. Let's start there.

First, we want to test that visiting `/` properly redirects to `/rentals`. We'll use the Ember `visit` helper
and then make sure our current URL is `/rentals` once the redirect occurs.

```/tests/acceptance/list-rentals-test.js{+9,+10}
import { module, test } from 'qunit';
import { visit, currentURL } from '@ember/test-helpers';
import { setupApplicationTest } from 'ember-qunit';

module('Acceptance | list rentals', function (hooks) {
  setupApplicationTest(hooks);

  test('should show rentals as the home page', async function (assert) {
    await visit('/');
    assert.equal(currentURL(), '/rentals', 'should redirect automatically');
  });
});
```

Now run the tests by typing `ember test --server` in the command line (or `ember t -s` for short).

Instead of 7 failures there should now be 6 (5 application failures and 1 ESLint).
You can also run our specific test by selecting the entry called "Acceptance | list rentals"
in the drop down input labeled "Module" on the test UI.

You can also toggle "Hide passed tests" to show your passing test case along with the tests that are still
failing (because we haven't yet built them).

![6_fail](../../images/routes-and-templates/routes-and-templates.gif)

### Ember's test helpers

Ember provides a variety of application test helpers to make common tasks easier,
such as visiting routes, filling in fields, clicking on links/buttons, and waiting for pages to display.

Some of the helpers we'll use commonly are:

* [`visit`](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#visit) - loads a given URL
* [`click`](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#click) - pretends to be a user clicking on a specific part of the screen
* [`currentURL`](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#currenturl) - returns the URL of the page we're currently on

Let's import these helpers into our application test:

```/tests/acceptance/list-rentals-test.js
import {
  click,
  currentURL,
  visit
} from '@ember/test-helpers'
```

### Test visiting our About and Contact pages
Now let's add code that simulates a visitor arriving on our homepage, clicking one of our links and then visiting a new page.

```/tests/acceptance/list-rentals-test.js{+2,+3,+4,+8,+9,+10}
test('should link to about page', async function(assert) {
  await visit('/');
  await click(".menu-about");
  assert.equal(currentURL(), '/about', 'should navigate to about');
});

test('should link to contacts page', async function(assert) {
  await visit('/');
  await click(".menu-contact");
  assert.equal(currentURL(), '/contact', 'should navigate to contact');
});
```

In the tests above, we're using [`assert.equal()`](https://api.qunitjs.com/assert/equal) to check if the first and second arguments equal each other.
If they don't, our test will fail.

The third optional argument allows us to provide a nicer message which will be shown if this test fails.

In our tests, we also call two helpers (`visit` and `click`) one after another. Although Ember does a number
of things when we make those calls, Ember hides those complexities by giving us these [asynchronous test helpers](../../testing/acceptance/#toc_asynchronous-helpers).

If you left `ember test` running, it should have automatically updated to show the three tests related to
navigating have now passed.

In the screen recording below, we run the tests, deselect "Hide passed tests", and set the module to our application test,
revealing the 3 tests we got passing.

![passing navigation tests](../../images/routes-and-templates/ember-route-tests.gif)
