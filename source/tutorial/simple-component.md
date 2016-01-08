As a user looks through our list of rentals, they may want to have some interactive options to help them make a decision.
Let's add the ability to hide and show an image for each rental.
To do this, we'll use a component.

Let's generate a `rental-listing` component that will manage the behavior for each of our rentals.
A dash is required in every component name to avoid conflicting with a possible HTML element.
So `rental-listing` is acceptable but `rental` would not be.

```shell
ember g component rental-listing
```

Ember CLI will then generate a handful of files for our component:


```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

A component consists of two parts:
a Handlebars template that defines how it will look (`app/templates/components/rental-listing.hbs`)
and a JavaScript source file (`app/components/rental-listing.js`) that defines how it will behave.

Our new `rental-listing` component will manage how a user sees and interacts with a rental.
To start, let's move the rental display details for a single rental from the `index.hbs` template
into `rental-listing.hbs`:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
```

In our `index.hbs` template, let's replace the old HTML markup within our `{{#each}}` loop
with our new `rental-listing` component:

```app/templates/index.hbs
<h1> Welcome to Super Rentals </h1>

We hope you find exactly what you're looking for in a place to stay.

{{#each model as |rentalUnit|}}
  {{rental-listing rental=rentalUnit}}
{{/each}}
```
Here we invoke the `rental-listing` component by name,
and assign each `rentalUnit` as the `rental` attribute of the component.

## Hiding and Showing an Image

Now we can add functionality that will show the image of a rental when requested by the user.

Let's use the `{{#if}}` helper to show our current rental image only when `isImageShowing` is set to true.
Otherwise, let's show a button to allow our user to toggle this:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
{{#if isImageShowing}}
  <p><img src={{rental.image}} alt={{rental.type}} width="500"></p>
{{else}}
  <button>Show image</button>
{{/if}}
```

The value of `isImageShowing` comes from our component's JavaScript file, in this case `rental-listing.js`.
Since we do not want the image to be showing at first, we will set the property to start as `false`:

```app/components/rental-listing.js
import Ember from 'ember';

export default Ember.Component.extend({
  isImageShowing: false
});
```

To make it where clicking on the button shows the image to the user,
we will need to add an action that changes the value of `isImageShowing` to `true`.
Let's call this action `imageShow`

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
{{#if isImageShowing}}
  <p><img src={{rental.image}} alt={{rental.type}} width="500"></p>
{{else}}
  <button {{action "imageShow"}}>Show image</button>
{{/if}}
```

Clicking this button will send the action to the component.
Ember will then go into the `actions` hash and call the `imageShow` function.
Let's create the `imageShow` function and set `isImageShowing` to `true` on our component:

```app/components/rental-listing.js
export default Ember.Component.extend({
  isImageShowing: false,
  actions: {
    imageShow() {
      this.set('isImageShowing', true);
    }
  }
});
```

Now when we click the button in our browser, we can see our image.

We should also let users hide the image.
In our template, let's add a button with an `imageHide` action:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
{{#if isImageShowing}}
  <p><img src={{rental.image}} alt={{rental.type}} width="500"></p>
  <button {{action "imageHide"}}>Hide image</button>
{{else}}
  <button {{action "imageShow"}}>Show image</button>
{{/if}}
```

Then let's setup an `imageHide` action handler in our component to set `isImageShowing` to `false`:

```app/components/rental-listing.js
export default Ember.Component.extend({
  isImageShowing: false,
  actions: {
    imageShow() {
      this.set('isImageShowing', true);
    },
    imageHide() {
      this.set('isImageShowing', false);
    }
  }
});
```

Now our users can toggle images on and off using the "Show image" and "Hide image" buttons.
