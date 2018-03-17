Currently, our app is using hard-coded data for our rental listings, defined in the `rentals` route handler.
As our application grows, we will want to persist our rental data on a server, and make it easier to do advanced operations on the data, such as querying.

Ember comes with a data management library called [Ember Data](https://github.com/emberjs/data) to help deal with persistent application data.

Ember Data requires you to define the structure of the data you wish to provide to your application by extending [`DS.Model`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model).

You can generate an Ember Data Model using Ember CLI.
We'll call our model `rental` and generate it as follows:

```shell
ember g model rental
```

This results in the creation of a model file and a test file:

```shell
installing model
  create app/models/rental.js
installing model-test
  create tests/unit/models/rental-test.js
```

When we open the model file, we can see a blank class extending [`DS.Model`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model):

```app/models/rental.js
import DS from 'ember-data';

export default DS.Model.extend({

});
```

Let's define the structure of a rental object using the same attributes for our rental that we [previously used](../model-hook/) in our hard-coded array of JavaScript objects -
_title_, _owner_, _city_, _category_, _image_, _bedrooms_ and _description_.
Define attributes by giving them the result of the function [`DS.attr()`](https://www.emberjs.com/api/ember-data/release/classes/DS/methods/attr?anchor=attr).
For more information on Ember Data Attributes, read the section called [Defining Attributes](../../models/defining-models/#toc_defining-attributes) in the guides.

```app/models/rental.js{+4,+5,+6,+7,+8,+9,+10}
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr(),
  owner: DS.attr(),
  city: DS.attr(),
  category: DS.attr(),
  image: DS.attr(),
  bedrooms: DS.attr(),
  description: DS.attr()
});
```

We now have a model object that we can use for our Ember Data implementation.

### Updating the Model Hook

To use our new Ember Data Model object, we need to update the `model` function we [previously defined](../model-hook/) in our route handler.
Delete the hard-coded JavaScript Array, and replace it with the following call to the [Ember Data Store service](../../models/#toc_the-store-and-a-single-source-of-truth).
The [store service](https://www.emberjs.com/api/ember-data/release/classes/DS.Store) is injected into all routes and their corresponding controllers in Ember.
It is the main interface you use to interact with Ember Data.
In this case, call the [`findAll`](https://www.emberjs.com/api/ember-data/release/classes/DS.Store/methods/findAll?anchor=findAll) function on the store and provide it with the name of your newly created rental model class.

```app/routes/rentals.js{+5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30,-31,-32,-33}
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    return this.get('store').findAll('rental');
    return [{
      id: 'grand-old-mansion',
      title: 'Grand Old Mansion',
      owner: 'Veruca Salt',
      city: 'San Francisco',
      category: 'Estate',
      bedrooms: 15,
      image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg',
      description: "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests."
    }, {
      id: 'urban-living',
      title: 'Urban Living',
      owner: 'Mike TV',
      city: 'Seattle',
      category: 'Condo',
      bedrooms: 1,
      image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg',
      description: "A commuters dream. This rental is within walking distance of 2 bus stops and the Metro."
    }, {
      id: 'downtown-charm',
      title: 'Downtown Charm',
      owner: 'Violet Beauregarde',
      city: 'Portland',
      category: 'Apartment',
      bedrooms: 3,
      image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg',
      description: "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet."
    }];
  }
});
```

When we call `findAll`, Ember Data will attempt to fetch rentals from `/api/rentals`.
If you recall, in the section titled [Installing Addons](../installing-addons/) we set up an adapter to route data requests through `/api`.

You can read more about Ember Data in the [Models section](../../models/).

Since we have already set up Ember Mirage in our development environment, Mirage will return the data we requested without actually making a network request.

When we deploy our app to a production server,
we will likely want to replace Mirage with a remote server for Ember Data to communicate with for storing and retrieving persisted data.
A remote server will allow for data to be shared and updated across users.

### Setting up Application Tests to use Mirage

If you remember back in the [Installing Addons](../installing-addons) section, we installed `ember-cli-mirage` for faking data coming from HTTP requests.
Now that we've hooked in Ember Data, which by default attempts to fetch data via HTTP request, we will need to tell our application test to use Mirage for data faking.

To tell our application tests to use Mirage, open `/tests/acceptance/list-rentals-test.js` and add the following code:

First Add the import for Mirage's test setup function.

```/tests/acceptance/list-rentals-test.js{+3}
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';
import setupMirage from 'ember-cli-mirage/test-support/setup-mirage';
import {
  click,
  currentURL,
  visit
} from '@ember/test-helpers'

```

Next, call the setup function immediately after your call to set up the application test.

```/tests/acceptance/list-rentals-test.js{+3}
module('Acceptance | list rentals', function(hooks) {
  setupApplicationTest(hooks);
  setupMirage(hooks);
  ...
}

```

Now your tests should behave as before, except that they are now using the data we've set up for Mirage.
