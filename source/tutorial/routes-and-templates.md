To demonstrate the basic setup and processing of an Ember application, this section will walk through building an Ember application for a property rental site called Super Rentals.  It will start with just a homepage, an about page and a contact page.  Let's take a look at the application from the user perspective before we get started.

![super rentals homepage screenshot](../../images/routes-and-templates/ember-super-rentals-index.png)

We arrive at the home page which shows a list of rentals.  From here, we will be able to navigate to an about page and a contact page.  

If you haven't already, create a new Ember app called `super-rentals`.

Before we start building the three pages for our app, we are going to clear out the contents of the `app/templates/application.hbs` file and only leave the `{{outlet}}` code in place.  We'll talk more about the role of the `application.hbs` file after our site has a few routes.

Now, let's start with building our "about" page. Remember, when the URL path `/about` is loaded, the router will map the URL to the route handler of the same name, _about.js_.  The route handler then loads a template.  

## An About Route

If we run `ember help generate`, we can see a variety of tools that come with Ember for automatically generating files for various Ember resources.  We'll use the route generator to start our `about` route.

```shell
ember generate route about
```

or for short,

```shell
ember g route about
```

We can see what actions are taken by the generator:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

Three new files are created: one for the route handler, one for the template the route handler will render, and a test file.  The fourth file that is touched is the router.  

When we open the router, we can see that the generator has mapped a new _about_ route for us. This route will load the `about` route handler.

```app/router.js
import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('about');
});

export default Router;
```

By default, the `about` route handler loads the `about.hbs` template. So we don't actually have to change anything in the new `app/routes/about.js` file for the `about.hbs` template to render as we want.

With all of the routing in place from the generator, we can get right to work on coding our template.  For our `about` page, we'll add some HTML that just says a little about the site:

```app/templates/about.hbs
<h2>About Super Rentals</h2>

<p>The Super Rentals website is a delightful project created to explore Ember.
By building a property rental site, we can simultaneously imagine traveling
AND building Ember applications.</p>
```

Run `ember s` from your shell to start the Ember development server, and then go to `localhost:4200` to see your new app in action!

## A Contact Route

Let's create another route with details for contacting the company.  Once again, we'll start by generating a route, a route handler, and a template.

```shell
ember g route contact
```

We see that our generator has created a `contact` route and corresponding route handler in `app/routes/contact.js`.  We will be using the `contact` template, so the `contact` route does not need any additional changes.

In `contact.hbs`, we can add the details for contacting our Super Rentals HQ:

```app/templates/contact.hbs
<p>Super Rentals Representatives would love to help you choose a destination or answer
any questions you may have.</p>

<p>Contact us today:</p>

<p>
  Super Rentals HQ<br>
  1212 Test Address Avenue<br>
  Testington, OR 97233
</p>

<p>(503)555-1212</p>

<p>superrentalsrep@superrentals.com</p>
```

Now we have completed our second route.  If we go to the URL `localhost:4200/contact`, we arrive on our contact page.

## Navigating with Links and the {{link-to}} Helper

We really don't want users to have to know our URLs in order to move around our site, so let's add some navigational links at the bottom of each page.  Let's make a contact link on the about page and an about link on the contact page.

Ember has built-in **helpers** that provide functionality such as linking to other routes.  Here is how to use the `{{link-to}}` helper in our code:

```app/templates/about.hbs
<h2>About Super Rentals</h2>

<p>The Super Rentals website is a delightful project created to explore Ember.<br>
  By building a property rental site, we can simultaneously imagine traveling<br>
  AND building Ember applications simultaneously.</p>

{{#link-to 'contact'}}Click here to contact us.{{/link-to}}
```

The helper takes an argument with the name of the route to link to, in this case, `contact`.  When we look at our about page, we now have a link to our contact page.

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

Now, we'll add one to link to our about page so we can navigate from back and forth from `about` to `contact`.

```app/templates/contact.hbs
<p>Super Rentals Representatives would love to help you <br>
  choose a destination or answer any questions you may have.</p>

<p>Contact us today:</p>

<p>
  Super Rentals HQ<br>
  1212 Test Address Avenue<br>
  Testington, OR 97233
</p>

<p>(503)555-1212</p>

<p>superrentalsrep@superrentals.com</p>

{{#link-to 'about'}}About{{/link-to}}
```

## An Index Route

With our two static pages in place, we are ready to add our home page which welcomes users to the site.  Using the same process we did for our about and contact pages, we will first generate a new route called "index".

```shell
ember g route index

installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

Unlike the other route handlers we've made so far, the `index` route is special: it does NOT require an entry in the router's mapping, and you'll notice that the action of updating the router was not taken by the generator. We'll learn more about why the entry isn't required when we touch on nested routes.

We can update our `index.hbs` with some HTML and we have our welcome home page and our links to the other routes in our application:

```hbs
<h1>Welcome to Super Rentals</h1>

We hope you find exactly what you're looking for in a place to stay.

{{#link-to 'about'}}About{{/link-to}}
{{#link-to 'contact'}}Click here to contact us.{{/link-to}}
```
