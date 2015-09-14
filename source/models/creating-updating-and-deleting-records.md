#### Creating Records

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
  author: store.findRecord('user', 1)
});
```

However, you can easily set the relationship after the promise has fulfilled:

```js
var store = this.store;

var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

store.findRecord('user', 1).then(function(user) {
  post.set('author', user);
});
```

#### Persisting Records

Records in Ember Data are persisted on a per-instance basis.
Call `save()` on any instance of `DS.Model` and it will make a network request.

Ember Data takes care of tracking the state of each record for
you. This allows Ember Data to treat newly created records differently
from existing records when saving.

By default, Ember Data will `POST` newly created records to their type url.

```javascript
var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

post.save(); // => POST to '/posts'
```

While records that already exist on the backend are updated using the
HTTP `PATCH` verb when saved.

```javascript
store.findRecord('post', 1).then(function(post) {
  post.get('title'); // => "Rails is Omakase"

  post.set('title', 'A new post');

  post.save(); // => PUT to '/posts/1'
});
```

### Promises

`save()` returns a promise, which makes easy to asynchronously handle
 success and failure scenarios.  Here's a common pattern:

```javascript
var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

var self = this;

function transitionToPost(post) {
  self.transitionToRoute('posts.show', post);
}

function failure(reason) {
  // handle the error
}

post.save().then(transitionToPost).catch(failure);

// => POST to '/posts'
// => transitioning to posts.show route
```

### Deleting Records

Deleting records is just as straightforward as creating records. Just
call `deleteRecord()` on any instance of `DS.Model`. This flags the
record as `isDeleted`. The deletion can then be persisted using
`save()`.  Alternatively, you can use the `destroyRecord` method to
delete and persist at the same time.

```js
store.findRecord('post', 1).then(function(post) {
  post.deleteRecord();
  post.get('isDeleted'); // => true
  post.save(); // => DELETE to /posts/1
});

// OR
store.findRecord('post', 2).then(function(post) {
  post.destroyRecord(); // => DELETE to /posts/2
});
```

Deleted records will still showup in RecordArrays returned by
`store.peekAll` and `hasMany` relationships until they have been
successfully saved.

