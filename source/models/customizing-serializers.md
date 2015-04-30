### RESTSerializer JSON Conventions

When requesting a record, the `RESTAdapter` expects your server to
return a JSON representation of the record that conforms to the
following conventions.


#### JSON Root

The primary record being returned should be in a named root. For
example, if you request a record from `/people/123`, the response should
be nested inside a property called `people`:

```js
{
  "people": [{
    "id": 123,
    "firstName": "Jeff",
    "lastName": "Atwood"
  }]
}
```


#### ID

In order to keep track of unique records in the store Ember Data
expects every record to have an `id` property in the payload. Ids
should be unique for every unique record of a specific type. If your
backend used a different key other then `id` you can use the
serializer's `primaryKey` property to correctly transform the id
property to `id` when serializing and deserializing data.

```app/serializer/application.js
export default DS.RESTSerializer.extend({
  primaryKey: '_id'
});
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
    "id": 44,
    "firstName": "Barack",
    "lastName": "Obama",
    "isPersonOfTheYear": true
  }
}
```

If your attributes do not match the attribute names on your model but
they all follow a similar patter you can use the serializer's
`keyForAttribute` method to convert an attribute name in your model to
a key in your JSON. For example, if your backend returned attributes
that are `under_scored` instead of `camelCased` you could override the
`keyForAttribute` method like this.

```app/serializer/application.js
export default DS.RESTSerializer.extend({
  keyForAttribute: function(attr) {
    return Ember.String.underscore(attr);
  }
});
```
Irregular keys can be mapped with a custom serializer. The `attrs`
object can be used to declare a simple mapping between property names
on DS.Model records and payload keys in the serialized JSON object
representing the record. An object with the property key can also be
used to designate the attribute's key on the response payload.


If the JSON for `person` has a key of `lastNameOfPerson`, and the
desired attribute name is simply `lastName`, then create a custom
Serializer for the model and override the `attrs` property.

```app/models/person.js
export default DS.Model.extend({
  lastName: DS.attr('string')
});
```

```app/serializers/person.js
export default DS.RESTSerializer.extend({
  attrs: {
    lastName: 'lastNameOfPerson',
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

`Comments` for a `post` can be loaded by `post.get('comments')`. The
REST adapter will send 3 `GET` request to `/comments/1/`,
`/comments/2/` and `/comments/3/`.

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

```json
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

#### Creating Custom Transformations

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
var cursor = App.Cursor.find(1);
cursor.get('position.x'); //=> 4
cursor.get('position.y'); //=> 9
```

If `position` is modified and saved, it will pass through the
`serialize` function in the transform and again be presented as
an array in JSON.



### JSONSerializer

Not all APIs follow the conventions that the `RESTSerializer` uses
with namespaced models and sideloaded relationship records. Some
legacy APIs may return a simple JSON payload that is just the resource
request or an array of serialized records. The `JSONSerializer` is a
serializer that ships with Ember Data that can be used along side the
`RESTAdapter` to serialize these simpler APIs.

To use it in your application you will need to define an
`adapter:application` that extends the `JSONSerializer`.

```app/serializer/application.js
export default DS.JSONSerializer.extend({
  // ...
});
```

For requests that are only expected to return 1 record
(e.g. `store.find('post', 1)`) the `JSONSerializer` expects the response
to be a JSON object that looks similar to this:

```json
{
    "id": 1,
    "title": "Rails is omakase",
    "tag": "rails",
    "comments": [1, 2]
}
```

For requests that are only expected to return 0 or more records
(e.g. `store.find('post')` or `store.find('post', {status: 'draft'})`)
the `JSONSerializer` expects the response to be a JSON array that
looks similar to this:

```json
[{
  "id": 1,
  "title": "Rails is omakase",
  "tag": "rails",
  "comments": [1, 2]
}, {
  "id": 2,
  "title": "I'm Running to Reform the W3C's Tag",
  "tag": "w3c",
  "comments": [3]
}]
```

The RESTSerializer is built on top of the JSONSerializer so they share
many of the same hooks for customizing the behavior of the
serialization process. Be sure to check out the
[API docs](http://emberjs.com/api/data/classes/DS.JSONSerializer.html)
for a full list of methods and properties.


### EmbeddedRecordMixin

Although Ember Data encourages you to sideload your relationships,
sometimes when working with legacy APIs you may discover you need to
deal with JSON that contains relationships embedded inside other
records. The `EmbeddedRecordsMixin` is ment to help with this problem.

To set up embedded records, include the mixin when extending a
serializer then define and configure embedded relationships.

For example if your `post` model contained an embedded `author` record
you would define your relationship like this:

```app/serializers/post.js
export default DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    author: {
      serialize: 'records',
      deserialize: 'records'
    }
  }
});
```

If you find yourself needing to both serialize and deserialize the
embedded relationship you can use the shorthand option of `{ embedded:
'always' }`. The following example and the one above are equivalent.

```app/serializers/post.js
export default DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    author: { embedded: 'always' }
  }
});
```


The `serialize` and `deserialize` keys support 3 options.
- `records` is uses to signal that the entire record is expected
- `ids` is uses to signal that only the id of the record is expected
- false is uses to signal that the record is not expected

For example you may find that you want to read an embedded record when
extracting a JSON payload but only include the relationship's id when
serializing the record. This is possible by using the `serialize:
'ids'` option. You can also opt out of serializing a relationship by
setting `serialize: false`.

```app/serializers/post.js
export default DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    author: {
      serialize: false,
      deserialize: 'records'
    },
    comments: {
      deserialize: 'records'
      serialize: 'ids'
    }
  }
});
```

#### EmbeddedRecordsMixin Defaults

If you do not overwrite `attrs` for a specific relationship, the
`EmbeddedRecordsMixin` will behave in the following way:

BelongsTo: `{ serialize: 'id', deserialize: 'id' }`
HasMany:   `{ serialize: false, deserialize: 'ids' }`


There is an option of not embedding JSON in the serialized payload by
using serialize: 'ids'. If you do not want the relationship sent at
all, you can use serialize: false.





### Authoring Serializers

If you would like to create a custom serializer its recommend that you
start with the `RESTSerializer` or `JSONSerializer` and extend one of
those to match your needs. However, if your payload is extreamly
different from one of these serializers you can create your own by
extending the `DS.Serializer` base class. There are 3 methods that
must be implemented on a serializer.

- [extract](http://emberjs.com/api/data/classes/DS.Serializer.html#method_extract)
- [serialize](http://emberjs.com/api/data/classes/DS.Serializer.html#method_serialize)
- [normalize](http://emberjs.com/api/data/classes/DS.Serializer.html#method_normalize)

Its also important to know about the `normalized` JSON form that Ember
Data expects as an argument to `store.push()`.

This normalized form of a record looks like this:

```json
{
    "id": 1,
    "title": "Rails is omakase",
    "tag": "rails",
    "comments": [1, 2],
    "links": {
      "relatedPosts": "/api/v1/posts/1/related-posts/"
    }
}
```

Every serialized record must follow this format for it to be correctly
converted into an Ember Data record.

- must have a unique `id` property
- to update an `attr` or relationships on the record you must have a matching property name in the normalized object
- `belongsTo` relationships contain a record id or null
- `hasMany` relationships contain an array of record ids.
- The `links` object can be used to describe async relationships that use a URL

Properties that are defined on the model but are omitted in the
normalized object will not be updated. Properties that are included in
the normalized object but not defined on the Model will be ignored.

## Community Serializers

If none of the builtin Ember Data Serializers work for your backend,
be sure to check out some of the community maintained Ember Data
Adapters and serializers. Some good places to look for Ember Data
Serializers include:

- [Ember Observer](http://emberobserver.com/categories/data)
- [GitHub](https://github.com/search?q=ember+data+serializers&ref=cmdform)
- [Bower](http://bower.io/search/?q=ember-data-)
