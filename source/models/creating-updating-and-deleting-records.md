## Creating Records

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

## Updating Records

Making changes to Ember Data records is as simple as setting the attribute you
want to change:

```js
this.store.findRecord('person', 1).then(function(tyrion) {
  // ...after the record has loaded
  tyrion.set('firstName', "Yollo");
});
```

All of the Ember.js conveniences are available for
modifying attributes. For example, you can use `Ember.Object`'s
`incrementProperty` helper:

```js
person.incrementProperty('age'); // Happy birthday!
```

## Persisting Records

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

Records that already exist on the backend are updated using the HTTP `PATCH` verb.

```javascript
store.findRecord('post', 1).then(function(post) {
  post.get('title'); // => "Rails is Omakase"

  post.set('title', 'A new post');

  post.save(); // => PATCH to '/posts/1'
});
```

You can tell if a record has outstanding changes that have not yet been
saved by checking its `hasDirtyAttributes` property. You can also see what parts of
the record were changed and what the original value was using the
`changedAttributes` function.  `changedAttributes` returns an object,
whose keys are the changed properties and values are an array of values
`[oldValue, newValue]`.

```js
person.get('isAdmin');            //=> false
person.get('hasDirtyAttributes'); //=> false
person.set('isAdmin', true);
person.get('hasDirtyAttributes'); //=> true
person.changedAttributes();       //=> { isAdmin: [false, true] }
```

At this point, you can either persist your changes via `save()` or you can roll
back your changes. Calling `rollbackAttributes()` reverts all the
`changedAttributes` to their original value.

```js
person.get('hasDirtyAttributes'); //=> true
person.changedAttributes();       //=> { isAdmin: [false, true] }

person.rollbackAttributes();

person.get('hasDirtyAttributes'); //=> false
person.get('isAdmin');            //=> false
person.changedAttributes();       //=> {}
```

## Promises

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

## Deleting Records

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

Deleted records will still show up in RecordArrays returned by
`store.peekAll` and `hasMany` relationships until they have been
successfully saved.
