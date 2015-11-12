Previously, we used hard-coded data in the `rentals` route handler file to set the model.  This was good for demonstrating how routing and templates use model information, but very limited in practice.  As our application grows, we will want to be able to create new rentals, make updates to them, and delete them. Ember integrates with a model data management library called Ember Data that will provide this functionality.

Let's generate our first Ember Data model:

```shell
ember g model rental
```

which results in the creation of a model file and a test file:

```shell
version: 1.13.8
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
    owner: DS.attr(),
    city: DS.attr(),
    type: DS.attr(),
    image: DS.attr(),
    bedrooms: DS.attr()
});
```

Now we have a model in our Ember Data store.

## Using Ember-CLI-Mirage with Ember Data

Ember Data can be configured to save to any persistent data source. By default, it expects to use a server that you would have to set up yourself. So that we don't have to build a server as part of this tutorial, we are going to configure our app to use [Ember-CLI-Mirage](http://www.ember-cli-mirage.com) which will help us produce fake data easily for our system.

Let's start by installing it in our app directory:

```shell
ember install ember-cli-mirage@v0.2.0-beta.1
```
@TODO: we don't want to be installing a beta in the long-run, but we may want
to be doing a JSON-API payload here instead of a classic REST payload that we're
doing now ...

and we'll see:

```shell
version: 1.13.9
Installed packages for tooling via npm.
installing ember-cli-mirage
  create app/mirage/config.js
  create app/mirage/factories/contact.js
  create app/mirage/scenarios/default.js
Installing browser packages via Bower...
  not-cached git://github.com/trek/pretender.git#~0.10.1
  cached git://github.com/lodash/lodash.git#3.7.0
  cached git://github.com/Marak/Faker.js.git#3.0.1
  resolved git://github.com/trek/pretender.git#0.10.1
  not-cached git://github.com/trek/FakeXMLHttpRequest.git#~1.2.1
  not-cached git://github.com/tildeio/route-recognizer.git#~0.1.1
  resolved git://github.com/tildeio/route-recognizer.git#0.1.9
  resolved git://github.com/trek/FakeXMLHttpRequest.git#1.2.1
Installed browser packages via Bower.
Installed addon package.
```

Let's now configure Mirage to send back our rentals that we had defined above by
adding the below beneath the config section:

```mirage/config.js

  this.get('/rentals', function() {
    return {
      rentals: [{
        "owner": "Veruca Salt",
        "city": "San Francisco",
        "type": "Estate",
        "bedrooms": 15,
        "image": "https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg"
      }, {
        "owner": "Mike Teavee",
        "city": "Seattle",
        "type": "Condo",
        "bedrooms": 1,
        "image": "https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg"
      }, {
        "owner": "Violet Beauregarde",
        "city": "Portland",
        "type": "Apartment",
        "bedrooms": 3,
        "image": "https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg"
      }]
    }
  });

```

@TODO: We're assuming a DSRESTAdapter here, does this cause us problems?

### Updating the Model Hook

To use our new data store, we need to update the model hook in our route handler.

```app/routes/index.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('rental');
  },
});
```

This will go to the Ember Data store and find all records of the type `rental`.
Ember Data then talks to Ember-CLI-Mirage and they take care of the rest and
make the data available to our template.
