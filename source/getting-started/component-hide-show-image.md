## Adding a Component

As a user looks through our list of rentals, they may want to have some interactive options to help them make a decision. Let's add the ability to hide and show an image for each rental.  To do this, we'll use a component.

Let's generate a `rental-tile` component that will manage the behavior for each of our rentals. A dash is required in every component name to avoid conflicting with a possible HTML element.  So `rental-tile` is acceptable but `rental` would not be.

```shell
ember g component rental-tile
```

and we'll see what is generated:

```shell
version: 1.13.8
installing component
  create app/components/rental-tile.js
  create app/templates/components/rental-tile.hbs
installing component-test
  create tests/integration/components/rental-tile-test.js
```

A component consists of two parts: a Handlebars template that defines the display (`app/templates/components/rental-tile.hbs`) and a JavaScript source file (`app/components/rental-tile.js`) that defines how it will behave.

Since our `rental-tile` component will be taking over management for how a user sees and interacts with a rental, we will move the rental display details from the `index.hbs` template into `rental-tile.hbs` and have our index just render the component.

```app/templates/index.hbs
…
<ul>
  {{#each model as |rental-unit|}}
    {{rental-tile rental=rental-unit}}
  {{/each}}
</ul>
…
```
We call the component by name, `rental-tile`, and assign each `rental-unit` as the `rental` attribute of the component.

In the component template, we'll add the line previously in the index template for displaying an individual rental's information:

```app/templates/components/rental-tile.hbs
<li>{{rental.owner}}'s {{rental.type}} in {{rental.city}}</li>
```

## Hiding and Showing an Image

Now, we can add functionality that will show the image of a rental when requested by the user.

Let's allow the user to show and hide a rental image:

```app/templates/components/rental-tile.hbs
<li>{{rental.owner}}'s {{rental.type}} in {{rental.city}}
    {{#if isImageShowing }}
       <p><img src={{listing.image}} alt={{listing.type}} ></p>
     {{else}}
       <button>Show image</button>
    {{/if}}
</li>
```

When 'isImageShowing' is set to `false`, the user will see a `Show image` button as an option.  When `isImageShowing` is `true`, they'll see the image.  

The value of `isImageShowing` comes from the component's JavaScript file, in our case `rental-tile.js`.  Since we do not want the image to be showing at first, we will set the property to false:

```app/components/rental-tile.js
export default Ember.Component.extend({
  isImageShowing: false
});
```

For the button to make the image show, we will need to add an action that changes the value of `isImageShowing` to `true`:

```app/templates/components/rental-tile.hbs
...
<button {{action 'imageShow'}}>Show image</button>
...
```

Clicking this button will send the action to the component:

```app/components/rental-tile.js
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

We should let users hide the image again. In our template component:

``app/templates/components/rental-tile.hbs
<li>{{#link-to 'listing' listing.id}}{{listing.owner}}'s {{listing.type}}{{/link-to}}
  {{#if isImageShowing}}
    <p><img src={{listing.image}} alt={{listing.type}} {{action 'imageHide'}}></p>
  {{else}}
    <button {{action 'imageShow'}}>Image</button>
  {{/if}}
</li>
```

In our JavaScript file:

```app/components/rental-tile.js
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
