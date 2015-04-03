Records in Ember Data are persisted on a per-instance basis.
Call `save()` on any instance of `DS.Model` and it will make a network request.

Here are a few examples:

```javascript
var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

post.save(); // => POST to '/posts'
```

```javascript
store.find('post', 1).then(function (post) {
  post.get('title'); // => "Rails is Omakase"

  post.set('title', 'A new post');

  post.save(); // => PUT to '/posts/1'
});
```

### Promises

`save()` returns a
[promise](../../routing/asynchronous-routing/#toc_a-word-on-promises),
that will resolve with the record if the record is successfully saved
to the server or reject with the error if there is any error (for
example a network error or validation error from your backend)
preventing the record from saving successful.

 Here's a common pattern where an application will redirect the user
 to a new page after a successful save or display an error if the save
 fails:

```javascript
store.find('post', 1).then(function (post) {
  post.get('title'); // => "Rails is Omakase"

  post.set('title', 'A new post');

  function transitionToPost(post) {
    self.transitionToRoute('posts.show', post);
  }

  function failure(reason) {
    // handle the error
  }

  post.save().then(transitionToPost).catch(failure);
});

// => POST to '/posts'
// => transitioning to posts.show route
```

#### UpdateRecord Request

Just like with the find requests the `RESTAdapter` will attempt to
build the URL by pluralizing and camelCasing the record type name. It
will then add a slash followed by the value of the id of the
record. For a `post` record the `RESTAdapter` would generate the a url
`/posts/1`. Ther RESTAdapter will then use the HTTP `PUT` verb to send
the serialized record to the `/posts/1` url.

The default `RESTSerializer` will serialize the post record using the
same format that it expects to receive when loading the record. The
only difference is the `RESTSerializer` will not include any
sideloaded records in the update payload.

```json
{
  "post": [{
    "id": 1,
    "title": "A new post",
    "tag": "rails",
    "comments": [1, 2]
  }]
}
```

#### Server Response to a updateRecord request

The server is expected to respond with the serialized record now that
it has been updated. You may also include sideloaded records in the
response to an update request.


```json
{
  "post": [{
    "id": 1,
    "title": "A new post",
    "tag": "rails",
    "comments": [1, 2]
  }],
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


#### Customizing the Adapter updateRecord request

Ember Data's store calls the Adapter's `updateRecord` method to update
a record that already exists on the backend server. You can override
this method to change how Ember Data talks with your backend when
updating a record.

```app/adapters/post.js
export default DS.Adapter.extend({
  updateRecord: function(store, type, snapshot) {
    var data = {};
    var serializer = store.serializerFor(type.typeKey);

    serializer.serializeIntoHash(data, type, snapshot);

    var id = get(record, 'id');

    // fictional backend that requires a PATCH instead of a PUT
    return this.ajax('posts/' + id, "PATCH", { data: data });
  }
});
```

#### Customizing extracting the Find response with the Serializer

Ember Data uses the RESTSerializer's `extractUpdateRecord` method to
extract the payload returned by the server. You can override this
method on your serializer to transform the data into the format that
the `RESTSerializer` expects.

```app/serializers/post.js
export default DS.RESTSerializer.extend({
  extractUpdateRecord: function(store, type, payload, id, requestType) {
    // Modify payload to make it match the format the RESTSerializer expects
    // Then call _super to let the RESTSerializer handle the rest for you
    return this._super(store, type, payload, id, requestType);
  }
});
```
