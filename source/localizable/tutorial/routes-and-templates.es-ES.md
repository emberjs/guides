Para demostrar la configuración básica y procesamiento de una aplicación de Ember, esta sección te guiará a través de una aplicación de Ember para un sitio de alquiler de propiedades llamado Super Rentals. Iniciará con una página, una página "acerca de" y una página de contacto. Echemos un vistazo a la aplicación desde la perspectiva del usuario antes de empezar.

![captura de pantalla de la página de inicio de super rentals](../../images/service/style-super-rentals-maps.png)

Llegamos a la página de inicio que muestra una lista de alquileres. Desde aquí, podremos navegar a la página "acerca de" y a la página de contacto.

Now, let's start by building our "about" page. Remember, when the URL path `/about` is loaded, the router will map the URL to the route handler of the same name, *about.js*. The route handler then loads a template.

## Route (ruta) "acerca de"

If we run `ember help generate`, we can see a variety of tools that come with Ember for automatically generating files for various Ember resources. Let's use the route generator to start our `about` route.

```shell
ember generate route about
```

or for short,

```shell
ember g route about
```

We can then see what actions were taken by the generator:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

Three new files are created: one for the route handler, one for the template the route handler will render, and a test file. The fourth file that is touched is the router.

When we open the router, we can see that the generator has mapped a new *about* route for us. This route will load the `about` route handler.

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType, rootURL: config.rootURL });

Router.map(function() { this.route('about'); });

export default Router;

    <br />By default, the `about` route handler loads the `about.hbs` template.
    This means we don't actually have to change anything in the new `app/routes/about.js` file for the `about.hbs` template to render as we want.
    
    With all of the routing in place from the generator, we can get right to work on coding our template.
    For our `about` page, we'll add some HTML that has a bit of information about the site:
    
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
    

Run `ember serve` (or `ember s` for short) from the shell to start the Ember development server, and then go to [`http://localhost:4200/about`](http://localhost:4200/about) to see our new app in action!

## La ruta de contacto

Let's create another route with details for contacting the company. Once again, we'll start by generating a route, a route handler, and a template.

```shell
ember g route contact
```

We see that our generator has created a `contact` route in the `app/router.js` file, and a corresponding route handler in `app/routes/contact.js`. Since we will be using the `contact` template, the `contact` route does not need any additional changes.

In `contact.hbs`, we can add the details for contacting our Super Rentals HQ:

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Contact Us
  </h2>
  
  <p>
    Super Rentals Representatives would love to help you<br />choose a destination or answer any questions you may have.
  </p>
  
  <p>
    Super Rentals HQ 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p>
</div>

    <br />Now we have completed our second route.
    If we go to the URL [`http://localhost:4200/contact`](http://localhost:4200/contact), we'll arrive on our contact page.
    
    ## Navigating with Links and the {{link-to}} Helper
    
    We really don't want users to have to know our URLs in order to move around our site,
    so let's add some navigational links at the bottom of each page.
    Let's make a contact link on the about page and an about link on the contact page.
    
    Ember has built-in **helpers** that provide functionality such as linking to other routes.
    Here we will use the `{{link-to}}` helper in our code to link between routes:
    
    ```app/templates/about.hbs{+9,+10,+11}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      </p>
      {{#link-to 'contact' class="button"}}
        Get Started!
      {{/link-to}}
    </div>
    

The `{{link-to}}` helper takes an argument with the name of the route to link to, in this case: `contact`. When we look at our about page at [`http://localhost:4200/about`](http://localhost:4200/about), we now have a working link to our contact page.

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

Now, we'll add a link to our contact page so we can navigate from back and forth between `about` and `contact`.

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Contact Us
  </h2>
  
  <p>
    Super Rentals Representatives would love to help you<br />choose a destination or answer any questions you may have.
  </p>
  
  <p>
    Super Rentals HQ 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p> {{#link-to 'about' class="button"}} About {{/link-to}}
</div>

    <br />## An Index Route
    
    With our two static pages in place, we are ready to add our home page which welcomes users to the site.
    Using the same process we did for our about and contact pages, we will first generate a new route called `index`.
    
    ```shell
    ember g route index
    

We can see the now familiar output for the route generator:

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

Unlike the other route handlers we've made so far, the `index` route is special: it does NOT require an entry in the router's mapping. We'll learn more about why the entry isn't required when we look at nested routes in Ember.

Let's update our `index.hbs` with some HTML for our home page and our links to the other routes in our application:

```app/templates/index.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Welcome!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay. <br />Browse our listings, or use the search box above to narrow your search.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

    <br />## Adding a Banner with Navigation
    
    In addition to providing button-style links in each route of our application, we would like to provide a common banner to display both the title of our application, as well as its main pages.
    
    First, create the application by typing `ember g template application`.
    
    ```shell
    installing template
      create app/templates/application.hbs
    

When `application.hbs` exists, anything you put in it is shown for every page in the application. Now add the following banner navigation markup:

    app/templates/application.hbs
    <div class="container">
      <div class="menu">
        {{#link-to 'index'}}
          <h1 class="left">
            <em>SuperRentals</em>
          </h1>
        {{/link-to}}
        <div class="left links">
          {{#link-to 'about'}}
            About
          {{/link-to}}
          {{#link-to 'contact'}}
            Contact
          {{/link-to}}
        </div>
      </div>
      <div class="body">
        {{outlet}}
      </div>
    </div>

Notice the inclusion of an `{{outlet}}` within the body `div` element. The [`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet) defers to the router, which will render in its place the markup for the current route, meaning the different routes we develop for our application will get rendered there.

Now that we've added routes and linkages between them, the two acceptance tests we created for navigating the about and contact links will now pass:

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)