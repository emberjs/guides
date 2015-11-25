As a user looks through our list of rentals, they may want to have some interactive options to help them make a decision. Let's add the ability to hide and show an image for each rental.  To do this, we'll use a component.

Let's generate a `rental-listing` component that will manage the behavior for each of our rentals. A dash is required in every component name to avoid conflicting with a possible HTML element.  So `rental-listing` is acceptable but `rental` would not be.

```shell
ember g component rental-listing
```

and we'll see what is generated:

```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

A component consists of two parts: a Handlebars template that defines how it will look (`app/templates/components/rental-listing.hbs`) and a JavaScript source file (`app/components/rental-listing.js`) that defines how it will behave.

Since our `rental-listing` component will be taking over management for how a user sees and interacts with a rental, we will move the rental display details from the `index.hbs` template into `rental-listing.hbs` and have our index just render the component.

```app/templates/index.hbs
…
{{#each model as |rental-unit|}}
  {{rental-listing rental=rental-unit}}
{{/each}}
…
```
We call the component by name, `rental-listing`, and assign each `rental-unit` as the `rental` attribute of the component.

In the component template, we'll add the content previously in the index template for displaying an individual rental's listing:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
```

## Hiding and Showing an Image

Now, we can add functionality that will show the image of a rental when requested by the user.

Let's allow the user to show and hide a rental image:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
{{#if isImageShowing }}
  <p><img src={{rental.image}} alt={{rental.type}} width="500px"></p>
{{else}}
  <button>Show image</button>
{{/if}}
```

When 'isImageShowing' is set to `false`, the user will see a `Show image` button as an option.  When `isImageShowing` is `true`, they'll see the image.

The value of `isImageShowing` comes from the component's JavaScript file, in our case `rental-listing.js`.  Since we do not want the image to be showing at first, we will set the property to false:

```app/components/rental-listing.js
import Ember from 'ember';

export default Ember.Component.extend({
  isImageShowing: false
});
```

For the button to make the image show, we will need to add an action that changes the value of `isImageShowing` to `true`:

```app/templates/components/rental-listing.hbs
...
<button {{action 'imageShow'}}>Show image</button>
...
```

Clicking this button will send the action to the component:

```app/components/rental-listing.js
export default Ember.Component.extend({
  isImageShowing: false,
  actions: {
    imageShow: function() {
      this.set('isImageShowing', true);
    }
  }
});
```

Now the image will be shown when the button is clicked.

We should let users hide the image again. In our template:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
{{#if isImageShowing }}
  <p><img src={{rental.image}} alt={{rental.type}} width="500px"></p>
  <button {{action 'imageHide'}}>Hide image</button>
{{else}}
  <button {{action 'imageShow'}}>Show image</button>
{{/if}}
```

In our JavaScript file:

```app/components/rental-listing.js
export default Ember.Component.extend({
  isImageShowing: false,
 actions: {
    imageShow: function() {
      this.set('isImageShowing', true);
    },
    imageHide: function() {
      this.set('isImageShowing', false)
    }
  }
});
```

If the image is clicked, it will hide it again.
