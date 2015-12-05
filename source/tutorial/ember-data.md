Currently, we're using hard-coded data in the `rentals` route handler file to set the model. As our application grows, we will want to be able to create new rentals, make updates to them, and delete them, and store them on a backend server. Ember integrates with a model data management library called Ember Data that makes this easy.

Let's generate our first Ember Data model:

```shell
ember g model rental
```

which results in the creation of a model file and a test file:

```shell
installing model
  create app/models/rental.js
installing model-test
  create tests/unit/models/rental-test.js
```

When we open the model file, we see :

```app/models/rental.js
import DS from 'ember-data';

export default DS.Model.extend({

});
```

Let's add the same attributes for our rental that we used in our hard-coded array of JavaScript objects - owner, city, type, image, and bedrooms:

```app/models/rental.js
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr(),
  owner: DS.attr(),
  city: DS.attr(),
  type: DS.attr(),
  image: DS.attr(),
  bedrooms: DS.attr()
});
```

Now we have a model in our Ember Data store.

## Using Mirage with Ember Data

Ember Data can be configured to save data in a variety of ways, but often is setup to work with a backend API server. So that we don't have to build a server as part of this tutorial, we are going to configure our app to use [Mirage](http://www.ember-cli-mirage.com) which will help us produce fake data easily for our system.

Let's start by installing Mirage:

```shell
ember install ember-cli-mirage
```

Let's now configure Mirage to send back our rentals that we had defined above by
updating `mirage/config.js` like this:

```mirage/config.js
export default function() {
  this.get('/rentals', function() {
    return {
      data: [{
        type: 'rentals',
        id: 1,
        attributes: {
          title: 'Grand Old Mansion',
          owner: 'Veruca Salt',
          city: 'San Francisco',
          type: 'Estate',
          bedrooms: 15,
          image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg'
        }
      }, {
        type: 'rentals',
        id: 2,
        attributes: {
          title: 'Urban Living',
          owner: 'Mike Teavee',
          city: 'Seattle',
          type: 'Condo',
          bedrooms: 1,
          image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg'
        }
      }, {
        type: 'rentals',
        id: 3,
        attributes: {
          title: 'Downtown Charm',
          owner: 'Violet Beauregarde',
          city: 'Portland',
          type: 'Apartment',
          bedrooms: 3,
          image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg'
        }
      }]
    }
  });
}
```

Now, whenever Ember Data makes a GET request to `/rentals`, Mirage will return
this JavaScript object as JSON.

### Updating the Model Hook

To use our new data store, we need to update the model hook in our route handler.

```app/routes/index.js
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('rental');
  },
});
```

When we call `this.store.findAll('rental')`, Ember Data will make a GET request
to `/rentals`. Since we're using Mirage in our development environment, Mirage
will return the data we've provided. When you deploy your app to a production
web server, you will need to provide a backend for Ember Data to communicate with.
