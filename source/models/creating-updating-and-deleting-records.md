## Creating Records

You can create records by calling the
[`createRecord()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Store/methods/createRecord?anchor=createRecord)
method on the store.

```js
store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});
```

The store object is available in controllers and routes using `this.get('store')`.

## Updating Records

Making changes to Ember Data records is as simple as setting the attribute you
want to change:

```js
this.get('store').findRecord('person', 1).then(function(tyrion) {
  // ...after the record has loaded
  tyrion.set('firstName', 'Yollo');
});
```

All of the Ember.js conveniences are available for
modifying attributes. For example, you can use `Ember.Object`'s
[`incrementProperty`](https://emberjs.com/api/ember/2.15/classes/Ember.Object/methods/incrementProperty?anchor=incrementProperty) helper:

```js
person.incrementProperty('age'); // Happy birthday!
```

## Persisting Records

Records in Ember Data are persisted on a per-instance basis.
Call [`save()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/methods/save?anchor=save)
on any instance of `DS.Model` and it will make a network request.

Ember Data takes care of tracking the state of each record for
you. This allows Ember Data to treat newly created records differently
from existing records when saving.

By default, Ember Data will `POST` newly created records to their type url.

```javascript
let post = store.createRecord('post', {
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
saved by checking its
[`hasDirtyAttributes`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/properties/hasDirtyAttributes?anchor=hasDirtyAttributes)
property. You can also see what parts of
the record were changed and what the original value was using the
[`changedAttributes()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/methods/changedAttributes?anchor=changedAttributes)
method. `changedAttributes` returns an object, whose keys are the changed
properties and values are an array of values `[oldValue, newValue]`.

```js
person.get('isAdmin');            // => false
person.get('hasDirtyAttributes'); // => false
person.set('isAdmin', true);
person.get('hasDirtyAttributes'); // => true
person.changedAttributes();       // => { isAdmin: [false, true] }
```

At this point, you can either persist your changes via `save()` or you can roll
back your changes. Calling
[`rollbackAttributes()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/methods/rollbackAttributes?anchor=rollbackAttributes)
for a saved record reverts all the `changedAttributes` to their original value.
If the record `isNew` it will be removed from the store.

```js
person.get('hasDirtyAttributes'); // => true
person.changedAttributes();       // => { isAdmin: [false, true] }

person.rollbackAttributes();

person.get('hasDirtyAttributes'); // => false
person.get('isAdmin');            // => false
person.changedAttributes();       // => {}
```

## Handling Validation Errors

If the backend server returns validation errors after trying to save, they will
be available on the `errors` property of your model. Here's how you might display
the errors from saving a blog post in your template:

```handlebars
{{#each post.errors.title as |error|}}
  <div class="error">{{error.message}}</div>
{{/each}}
{{#each post.errors.body as |error|}}
  <div class="error">{{error.message}}</div>
{{/each}}
```

## Promises

[`save()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/methods/save?anchor=save) returns
a promise, which makes it easy to asynchronously handle success and failure
scenarios.  Here's a common pattern:

```javascript
let post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

let self = this;

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

Deleting records is as straightforward as creating records. Call [`deleteRecord()`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/methods/deleteRecord?anchor=deleteRecord)
on any instance of `DS.Model`. This flags the record as `isDeleted`. The
deletion can then be persisted using `save()`.  Alternatively, you can use
the [`destroyRecord`](https://www.emberjs.com/api/ember-data/release/classes/DS.Model/methods/deleteRecord?anchor=destroyRecord) method to delete and persist at the same time.

```js
store.findRecord('post', 1, { backgroundReload: false }).then(function(post) {
  post.deleteRecord();
  post.get('isDeleted'); // => true
  post.save(); // => DELETE to /posts/1
});

// OR
store.findRecord('post', 2, { backgroundReload: false }).then(function(post) {
  post.destroyRecord(); // => DELETE to /posts/2
});
```

The `backgroundReload` option is used to prevent the fetching of the destroyed record, since [`findRecord()`][findRecord] automatically schedules a fetch of the record from the adapter.

[findRecord]: <https://www.emberjs.com/api/ember-data/release/classes/DS.Store/methods/findRecord?anchor=findRecord>
