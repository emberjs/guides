Currently, our app is using hard-coded data for our rental listings, defined in the `rentals` route handler. As our application grows, we will want to persist our rental data on a server, and make it easier to do do advanced operations on the data, such as querying.

Ember comes with a data management library called [Ember Data](https://github.com/emberjs/data) to held deal with persistent application data.

Ember Data requires you to define the structure of the data you wish to provide to your application by extending [`DS.Model`](http://emberjs.com/api/data/classes/DS.Model.html).

You can generate a Ember Data Model using Ember CLI. We'll call our model `rental` and generate it as follows:

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

When we open the model file reveals a blank class extending [`DS.Model`](http://emberjs.com/api/data/classes/DS.Model.html):

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />Let's define the structure of a rental object using the same attributes for our rental that we [previously used](../model-hook/) in our hard-coded array of JavaScript objects -
    _title_, _owner_, _city_, _type_, _image_, _bedrooms_ and _description_.
    Define attributes by giving them the result of the function [`DS.attr()`](http://emberjs.com/api/data/classes/DS.html#method_attr).
    For more information on Ember Data Attributes, read the section called [Defining Attributes](../../models/defining-models/#toc_defining-attributes) in the guides.
    
    ```app/models/rental.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      title: DS.attr(),
      owner: DS.attr(),
      city: DS.attr(),
      type: DS.attr(),
      image: DS.attr(),
      bedrooms: DS.attr(),
      description: DS.attr()
    });
    

Now we have a model object that we can use for our Ember Data store.

### Actualizando el Model Hook

To use our new Ember Data Model object, we need to update the `model` function we [previously defined](../model-hook/) in our route handler. Delete the hard-coded JavaScript Array, and replace it with the following call to the [Ember Data Store service](../../models/#toc_the-store-and-a-single-source-of-truth). The [store service](http://emberjs.com/api/data/classes/DS.Store.html) is injected into all routes and components in Ember. It is the main interface you use to interact with Ember Data. In this case, call the [`findAll`](http://emberjs.com/api/data/classes/DS.Store.html#method_findAll) function on the store and provide it with the name of your newly created rental model class.

```app/routes/rentals.js{+5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30,-31,-32,-33} import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('rental'); return [{ id: 'grand-old-mansion', title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg', description: "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests." }, { id: 'urban-living', title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg', description: "A commuters dream. This rental is within walking distance of 2 bus stops and the Metro." }, { id: 'downtown-charm', title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg', description: "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet." }]; } }); ```

When we call `findAll`, Ember Data will attempt to make a GET request to `/rentals`.

You can read more about Ember Data in the [Models section](../../models/).

Since we're using Mirage in our development environment, Mirage will return the data we've provided. When we deploy our app to a production server, we will need to provide a backend for Ember Data to communicate with.