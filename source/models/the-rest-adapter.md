By default, your store will use
[DS.RESTAdapter](http://emberjs.com/api/data/classes/DS.RESTAdapter.html) to load and
save records. The RESTAdapter assumes that the URLs and JSON
associated with each model are conventional; this means that, if you
follow the rules, you will not need to configure the adapter or write
any code in order to get started.

If you do need to customize the adapter for your application, you can create
an Application Adapter which subclasses [DS.RESTAdapter](http://emberjs.com/api/data/classes/DS.RESTAdapter.html) by running:

```bash
ember generate adapter application
```

### URL Conventions

The REST adapter is smart enough to determine the URLs it communicates
with based on the name of the model. For example, if you ask for a
`Post` by ID:

```js
store.findRecord('post', 1).then(function(post) {
});
```

The REST adapter will automatically send a `GET` request to `/posts/1`.

For multiple word names, the REST adapter will use `lower_snake_case`.

The actions you can take on a record map onto the following URLs in the
REST adapter:

<table>
  <thead>
    <tr><th>Action</th><th>HTTP Verb</th><th>URL</th></tr>
  </thead>
  <tbody>
    <tr><th>Find Record</th><td>GET</td><td>/posts/123</td></tr>
    <tr><th>Find All</th><td>GET</td><td>/posts</td></tr>
    <tr><th>Update</th><td>PUT</td><td>/posts/123</td></tr>
    <tr><th>Create</th><td>POST</td><td>/posts</td></tr>
    <tr><th>Delete</th><td>DELETE</td><td>/posts/123</td></tr>
  </tbody>
</table>

#### Pluralization Customization

Irregular or uncountable pluralizations can be specified via `Ember.Inflector.inflector`:

```js
var inflector = Ember.Inflector.inflector;

inflector.irregular('person', 'people');
inflector.uncountable('advice');
```

This will tell the REST adapter that requests for `person`
should go to `/people/1` instead of `/persons/1`.

#### Endpoint Path Customization

Endpoint paths can be prefixed with a namespace by setting the `namespace`
property on the adapter:

```app/adapters/application.js
export default DS.RESTAdapter.extend({
  namespace: 'api/1'
});
```

Requests for `person` would now target `http://emberjs.com/api/1/people/1`.

#### Host Customization

An adapter can target other hosts by setting the `host` property.

```app/adapters/application.js
export default DS.RESTAdapter.extend({
  host: 'https://api.example.com'
});
```

Requests for `person` would now target `https://api.example.com/people/1`.

### JSON Conventions

When requesting a record, the REST adapter expects your server to return
a JSON representation of the record that conforms to the following
conventions.

#### JSON Root

The primary record being returned should be in a named root. For
example, if you request a record from `/people/123`, the response should
be nested inside a property called `person`:

```js
{
  "person": {
    "firstName": "Jeff",
    "lastName": "Atwood"
  }
}
```

After `destroyRecord` or after `deleteRecord` and `save`, the adapter expects the server to return an empty object (`{}`).

If you don't have the option to change the data that the server responds with, you can override the
[DS.JSONSerializer#extractDeleteRecord](http://emberjs.com/api/data/classes/DS.JSONSerializer.html#method_extractDeleteRecord), like so:

```js
extractDeleteRecord: function(store, type, payload) {
  // If the payload is {delete: true}, Ember Data will try to set
  // the new properties. Return null so it doesn't try to do that.
  return null;
}
```

#### Attribute Names

Attribute names should be camelized.  For example, if you have a model like this:

```app/models/person.js
export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName:  DS.attr('string'),

  isPersonOfTheYear: DS.attr('boolean')
});
```

The JSON returned from your server should look like this:

```js
{
  "person": {
    "firstName": "Barack",
    "lastName": "Obama",
    "isPersonOfTheYear": true
  }
}
```

Irregular keys can be mapped with a custom serializer. If the JSON for
`person` has a key of `lastNameOfPerson`, and the desired
attribute name is simply `lastName`, then create a custom Serializer
for the model and override the `normalizeHash` property.

```app/models/person.js
export default DS.Model.extend({
  lastName: DS.attr('string')
});
```

```app/serializers/person.js
export default DS.RESTSerializer.extend({
  normalizeHash: {
    lastNameOfPerson: function(hash) {
      hash.lastName = hash.lastNameOfPerson;
      delete hash.lastNameOfPerson;

      return hash;
    }
  }
});
```

#### Relationships

References to other records should be done by ID. For example, if you
have a model with a `hasMany` relationship:

```app/models/post.js
export default DS.Model.extend({
  comments: DS.hasMany('comment', { async: true })
});
```

The JSON should encode the relationship as an array of IDs:

```js
{
  "post": {
    "comments": [1, 2, 3]
  }
}
```

`Comments` for a `post` can be loaded by `post.get('comments')`. The REST
adapter will send a `GET` request for each related comment.

```js
post.get('comments');

// GET /comments/1
// GET /comments/2
// GET /comments/3
```

You may prevent sending multiple requests by setting [coalesceFindRequests](http://emberjs.com/api/data/classes/DS.RESTAdapter.html#property_coalesceFindRequests)
to `true` in your adapter.

```app/adapters/application.js
export default DS.RESTAdapter.extend({
  coalesceFindRequests: true
});
```

The REST adapter will now send a `GET` request to `/comments?ids[]=1&ids[]=2&ids[]=3`.

Any `belongsTo` relationships in the JSON representation should be the
camelized version of the Ember Data model's name. For example, if you have
a model:

```app/models/comment.js
export default DS.Model.extend({
  post: DS.belongsTo('post')
});
```

The JSON should encode the relationship as an ID to another record:

```js
{
  "comment": {
    "post": 1
  }
}
```

If needed these naming conventions can be overwritten by implementing
the `keyForRelationship` method.

```app/serializers/application.js
export default DS.RESTSerializer.extend({
  keyForRelationship: function(key, relationship) {
    return key + 'Ids';
  }
});
```

#### Sideloaded Relationships

To reduce the number of HTTP requests necessary, you can sideload
additional records in your JSON response. Sideloaded records live
outside the JSON root, and are represented as an array of hashes:

```js
{
  "post": {
    "id": 1,
    "title": "Node is not omakase",
    "comments": [1, 2, 3]
  },

  "comments": [{
    "id": 1,
    "body": "But is it _lightweight_ omakase?"
  },
  {
    "id": 2,
    "body": "I for one welcome our new omakase overlords"
  },
  {
    "id": 3,
    "body": "Put me on the fast track to a delicious dinner"
  }]
}
```

### Creating Custom Transformations

In some circumstances, the built in attribute types of `string`,
`number`, `boolean`, and `date` may be inadequate. For example, a
server may return a non-standard date format.

Ember Data can have new JSON transforms
registered for use as attributes:

```app/transforms/coordinate-point.js
export default DS.Transform.extend({
  serialize: function(value) {
    return [value.get('x'), value.get('y')];
  },
  deserialize: function(value) {
    return Ember.create({ x: value[0], y: value[1] });
  }
});
```

```app/models/cursor.js
export default DS.Model.extend({
  position: DS.attr('coordinatePoint')
});
```

When `coordinatePoint` is received from the API, it is
expected to be an array:

```js
{
  cursor: {
    position: [4,9]
  }
}
```

But once loaded on a model instance, it will behave as an object:

```js
var cursor = this.store.findRecord('cursor', 1);
cursor.get('position.x'); //=> 4
cursor.get('position.y'); //=> 9
```

If `position` is modified and saved, it will pass through the
`serialize` function in the transform and again be presented as
an array in JSON.
