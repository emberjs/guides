Now, let's add a list of available rentals to the index template. We know that rentals will not be static: eventually, users will be able to add, update or delete them.  For this reason, we will need a _rentals_ model to save information about the rentals. However, to keep things simple at first, our model is just going to be a hard-coded array of JavaScript objects. Later, we'll switch to using Ember Data, so that we can let users create and modify their own rentals.

Here's what our homepage will look like when we're done:

![super rentals homepage with rentals list](../../images/models/super-rentals-index-with-list.png)

Since the route handler is responsible for loading model data, that's where we'll start. Let's open `app/routes/index.js` and add our hard-coded data as the model:

```app/routes/index.js
import Ember from 'ember';

var rentals = [{
  id: 1,
  title: "Grand Old Mansion",
  owner: "Veruca Salt",
  city: "San Francisco",
  type: "Estate",
  bedrooms: 15,
  image: "https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg"
}, {
  id: 2,
  title: "Urban Living",
  owner: "Mike TV",
  city: "Seattle",
  type: "Condo",
  bedrooms: 1,
  image: "https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg"
}, {
  id: 3,
  title: "Downtown Charm",
  owner: "Violet Beauregarde",
  city: "Portland",
  type: "Apartment",
  bedrooms: 3,
  image: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg"
}];

export default Ember.Route.extend({
  model() {
    return rentals;
  },
});
```

If you haven't used the ES6 shorthand method definition syntax before, `model()` is the same as writing `model: function()`.

When we add a method to a class as part of using the Ember framework, we often call it a `hook`. So here, we've added the model hook to our `index` route handler, which Ember will automatically call when a user enters the route.

The model hook returns our _rentals_ array, so that the data is now available to the _rentals_ template as the `model` property.

Now, let's switch over to our template. We can use the model data to display our list of rentals.  We'll use a new helper called `{{each}}` that will let us loop through each of the objects in our model.  Here is how our index template is updated:

```app/templates/index.hbs
<h1> Welcome to Super Rentals </h1>

We hope you find exactly what you're looking for in a place to stay.

{{#each model as |rental|}}
  <h2>{{rental.title}}</h2>
  <p>Owner: {{rental.owner}}</p>
  <p>Type: {{rental.type}}</p>
  <p>Location: {{rental.city}}</p>
  <p>Number of bedrooms: {{rental.bedrooms}}</p>
{{/each}}
```

Here we loop through each model object and identify it as _rental_. For each
rental, we create a listing with information about the property.
