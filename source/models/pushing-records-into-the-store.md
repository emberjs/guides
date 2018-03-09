One way to think about the store is as a cache of all of the records
that have been loaded by your application. If a route or a controller in
your app asks for a record, the store can return it immediately if it is
in the cache. Otherwise, the store must ask the adapter to load it,
which usually means a trip over the network to retrieve it from the
server.

Instead of waiting for the app to request a record, however, you can
push records into the store's cache ahead of time.

This is useful if you have a good sense of what records the user
will need next. When they click on a link, instead of waiting for a
network request to finish, Ember.js can render the new template
immediately. It feels instantaneous.

Another use case for pushing in records is if your application has a
streaming connection to a backend. If a record is created or modified,
you want to update the UI immediately.

### Pushing Records

To push a record into the store, call the store's [`push()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Store/methods/push?anchor=push) method.

For example, imagine we want to preload some data into the store when
the application boots for the first time.

We can use the `route:application` to do so. The `route:application` is
the top-most route in the route hierarchy, and its `model` hook gets
called once when the app starts up.

```app/models/album.js
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr(),
  artist: DS.attr(),
  songCount: DS.attr()
});
```

```app/routes/application.js
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    this.get('store').push({
      data: [{
        id: 1,
        type: 'album',
        attributes: {
          title: 'Fewer Moving Parts',
          artist: 'David Bazan',
          songCount: 10
        },
        relationships: {}
      }, {
        id: 2,
        type: 'album',
        attributes: {
          title: 'Calgary b/w I Can\'t Make You Love Me/Nick Of Time',
          artist: 'Bon Iver',
          songCount: 2
        },
        relationships: {}
      }]
    });
  }
});
```

The store's `push()` method is a low level API which accepts a JSON
API document with a few important differences from the JSON API
document that the JSONAPISerializer accepts. The type name in the JSON
API document must match the type name of the model exactly (In the
example above the type is `album` because the model is defined in
`app/models/album.js`). Attributes and relationship names must match
the casing of the properties defined on the Model class.

If you would like the data to be normalized by the model's default
serializer before pushing it into the store, you can use the
[`store.pushPayload()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Store/methods/push?anchor=pushPayload) method.

```app/serializers/album.js
import DS from 'ember-data';

export default DS.RestSerializer.extend({
  normalize(typeHash, hash) {
    hash['songCount'] = hash['song_count']
    delete hash['song_count']
    return this._super(typeHash, hash);
  }
});
```

```app/routes/application.js
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    this.get('store').pushPayload({
      albums: [
        {
          id: 1,
          title: 'Fever Moving Parts',
          artist: 'David Bazan',
          song_count: 10
        },
        {
          id: 2,
          title: 'Calgary b/w I Can\'t Make You Love Me/Nick Of Time',
          artist: 'Bon Iver',
          song_count: 2
        }
      ]
    });
  }
});
```

The `push()` method is also important when working with complex
endpoints. You may find your application has an endpoint that performs
some business logic then creates several records. This likely does not
map cleanly to Ember Data's existing `save()` API which is structured
around persisting a single record. Instead you should make your own
custom AJAX request and push the resulting model data into the store
so it can be accessed by other parts of your application.


```app/routes/confirm-payment.js
import Route from '@ember/routing/route';
import $ from 'jquery';

export default Route.extend({
  actions: {
    confirm(data) {
      $.ajax({
        data: data,
        method: 'POST',
        url: 'process-payment'
      }).then((digitalInventory) => {
        this.get('store').pushPayload(digitalInventory);
        this.transitionTo('thank-you');
      });
    }
  }
});
```

Properties that are defined on the model but are omitted in the
normalized JSON API document object will not be updated. Properties
that are included in the normalized JSON API document object but not
defined on the Model will be ignored.
