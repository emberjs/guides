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

```app/models.rental.js
import DS from 'ember-data';

export default DS.Model.extend({

});
```

Let's add the same attributes for our rental that we used in our hard-coded array of JavaScript objects - owner, city, type, image, and bedrooms:

```app/models.rental.js
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

## Using Firebase with Ember Data

Ember Data can be configured to save to any persistent data source. By default, it expects to use a server that you would have to set up yourself. So that we don't have to build a server as part of this tutorial, we are going to configure Ember Data to use the [Firebase](https://www.firebase.com) service.

In order for Ember Data to communicate back and forth with our Firebase database, we will use an add-on called EmberFire. Let's install it from our app directory:

```shell
ember install emberfire
```
and we see:

```shell
version: 1.13.8
Installed packages for tooling via npm.
installing emberfire
  create app/adapters/application.js
Installing browser packages via Bower...
  cached git://github.com/firebase/firebase-bower.git#2.2.9
Installed browser packages via Bower.

EmberFire has been installed. Please configure your firebase URL in config/environment.js
```

Let's now configure our Firebase URL as instructed. In this example, I'm using the Firebase app called `super-rentals`, but as you're following along, you should visit [Firebase's website](https://www.firebase.com/) and set up your own Firebase app.

```config/environnment.js
firebase: 'https://super-rentals.firebaseio.com'
```

To begin, let's manually import the data that was in our hard-coded model hook into Firebase.

First, we'll create a file called `rentals.json` that holds our JavaScript rental objects in `json` format:

```text
{ "rentals": [{
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
```
In our Firebase app, we'll choose this file when instructed after we click the `Import Data` button.

![Firebase import data screenshot](../../images/ember-data/firebase-import-data-screenshot.png)

Now, our Firebase app is populated with our first rentals.

### Updating the Model Hook

To use our new data store, we need to update the model hook in our route handler.

```app/routes/index.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('rental');
  },
});
```

This will go to the Ember Data store and find all records of the type `rental`. Ember Data takes care of the rest and makes the data available to our template.
