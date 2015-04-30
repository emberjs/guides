You can create records by calling the `createRecord` method on the store.

```js
store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});
```

The store object is available in controllers and routes using `this.store`.

Although `createRecord` is fairly straightforward, the only thing to watch out for
is that you cannot assign a promise as a relationship, currently.

For example, if you want to set the `author` property of a post, this would **not** work
if the `user` with id isn't already loaded into the store:

```js
var store = this.store;

store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum',
  author: store.find('user', 1)
});
```

However, you can easily set the relationship after the promise has fulfilled:

```js
var store = this.store;

var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

store.find('user', 1).then(function(user) {
  post.set('author', user);
});
```

When records are first created they start off in the `new` state. This
means the record only exists on the client and it has yet to be
persisted to the backend. To persist the record to the backend you
need to call `record.save()`.

```js
var post = this.store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

post.save(); // POST to '/posts'
```

It is important to remember that whenever you create a new record it
will be added to Ember Data's store. This means even if you don't end
up persisting the record to the backend it will still show up in the
list of records returned by `store.all()`. A common pattern is to use
the route's `resetController` method to clean up records that may no
longer be needed in the store when exiting a route.

```app/routes/post/new.js
export default Ember.Route.extend({
  resetController: function() {
    var model = this.controller.get('model');
    if (model.get('isNew')) {
      model.unloadRecord();
    }
  },
  ...
});
```

#### CreateRecord Request

The `RESTAdapter` will attempt to build the URL by pluralizing and
camelCasing the record type name. Unlike finding or updating existing
records the `RESTAdapter` will not attempt to use the id property in
the url because it assumes the record is newly created on the client
side and the server doesn't know about the existence of a record with
this record yet. Another difference from the update request is the
adapter will use a `POST` request to signify that this is a new
record. For the post record the `RESTAdapter` will make a `POST`
request to the `/posts` url.

The default `RESTSerializer` will serialize the post record using the
same format that it expects to receive when loading the record. The
only difference is the `RESTSerializer` will not include any
sideloaded records in the create payload.

```json
{
  "posts": {
    "id": 1,
    "title": "A new post",
    "tag": "rails",
    "comments": [1, 2]
  }
}
```

#### Server Response to a createRecord request

The server is expected to respond with the serialized record now that
it has been created. You may also include sideloaded records in the
response to an update request.


```json
{
  "posts": {
    "id": 1,
    "title": "A new post",
    "tag": "rails",
    "comments": [1, 2]
  },
  "comments": [{
    "id": 1,
    "body": "FIRST",
    "post": 1,
  }, {
    "id": 2,
    "body": "Rails is unagi",
    "post": 1
  }]
}
```

#### Customizing the Adapter createRecord request

Ember Data's store calls the Adapter's `createRecord` method to update
a record that already exists on the backend server. You can override
this method to change how Ember Data talks with your backend when
creating a record.

```app/adapters/post.js
export default DS.Adapter.extend({
  createRecord: function(store, type, snapshot) {
    var data = {};
    var serializer = store.serializerFor(type.typeKey);

    serializer.serializeIntoHash(data, type, snapshot);

    // fictional backend that posts to a `/posts/create` url instead of `/posts`
    return this.ajax('posts/create', 'POST', { data: data });
  }
});
```

#### Customizing extracting the create response with the Serializer

Ember Data uses the RESTSerializer's `extractCreateRecord` method to
extract the payload returned by the server. You can override this
method on your serializer to transform the data into the format that
the `RESTSerializer` expects.

```app/serializer/post.js
export default DS.RESTSerializer.extend({
  extractCreateRecord: function(store, type, payload, id, requestType) {
    // Modify payload to make it match the format the RESTSerializer expects
    // Then call _super to let the RESTSerializer handle the rest for you
    return this._super(store, type, payload, id, requestType);
  }
});
```


#### Deleting Records

Deleting records is just as straightforward as creating records. Just
call `deleteRecord()` on any instance of `DS.Model`. This flags the
record as `isDeleted` and thus removes it from `all()` queries on the
`store`. To persist the delete to the backend you need to call
`save()`. If you decide you do not want to delete this record before
you call save you can allways call `rollback()` and the record will be
unflagged and returned to the list of records in the `all()` query. To
delete a record and persist it at the same time you can call
`destroyRecord`.

```js
store.find('post', 1).then(function (post) {
  post.deleteRecord();
  post.get('isDeleted'); // => true
  post.save(); // => DELETE to /posts/1
});

// OR
store.find('post', 2).then(function (post) {
  post.destroyRecord(); // => DELETE to /posts/2
});
```

#### DeleteRecord Request

The `RESTAdapter` will attempt to build the URL by pluralizing and
camelCasing the record type name. It will then add a slash followed by
the value of the id of the record. For a `post` record the
`RESTAdapter` would generate the a url `/posts/1`. There RESTAdapter
will then use the HTTP `DELETE` verb to send the serialized record to the
`/posts/1` url.

The default `RESTSerializer` will serialize the post record using the
same format that it expects to receive when loading the record. Just
like up the create and update requests the `RESTSerializer` will not
include any sideloaded records in the update payload.

```json
{
  "posts": {
    "id": 1,
    "title": "A new post",
    "tag": "rails",
    "comments": [1, 2]
  }
}
```

#### Server Response to a deleteRecord request

The server is expected to respond with the serialized record that has
just been deleted. Sideloaded records are not needed. Alternately, the
server could respond with an empty object.


```json
{
  "posts": {
    "id": 1,
    "title": "A new post",
    "tag": "rails",
    "comments": [1, 2]
  }
}
```

or

```json
{}
```

#### Customizing the Adapter deleteRecord request

Ember Data's store calls the Adapter's `deleteRecord` method to delete
a record from the backend server. You can override this method to
change how Ember Data talks with your backend when deleting.

```app/adapters/post.js
export default DS.Adapter.extend({
  deleteRecord: function(store, type, snapshot) {
    var data = {};
    var serializer = store.serializerFor(type.typeKey);

    serializer.serializeIntoHash(data, type, snapshot);

    var id = snapshot.id;

    // fictional backend that requires a POST and custom url
    return this.ajax('posts/' + id + '/delete', 'POST', { data: data });
  }
});
```

#### Customizing extracting the Delete response with the Serializer

Ember Data uses the RESTSerializer's `extractDeleteRecord` method to
extract the payload returned by the server. You can override this
method on your serializer to transform the data into the format that
the `RESTSerializer` expects.

```app/serializers/post.js
export default DS.RESTSerializer.extend({
  extractDeleteRecord: function(store, type, payload, id, requestType) {
    // Modify payload to make it match the format the RESTSerializer expects
    // Then call _super to let the RESTSerializer handle the rest for you
    return this._super(store, type, payload, id, requestType);
  }
});
```
