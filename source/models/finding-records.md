The Ember Data store provides an interface for retrieving records of a single
type.

### Retrieving a Single Record

Use `store.findRecord()` to retrieve a record by its type and ID. This will
return a promise that fulfills with the requested record:

```javascript
var post = this.store.findRecord('post', 1); // => GET /posts/1
```

Use `store.peekRecord()` to retrieve a record by its type and ID, without making
a network request. This will return the record only if it is already present in
the store:

```javascript
var post = this.store.peekRecord('post', 1); // => no network request
```

### Retrieving Multiple Records

Use `store.findAll()` to retrieve all of the records for a given type:

```javascript
var posts = this.store.findAll('post'); // => GET /posts
```

Use `store.peekAll()` to retrieve all of the records for a given type that are
already loaded into the store, without making a network request:

```javascript
var posts = this.store.peekAll('post'); // => no network request
```

`store.findAll()` returns a `DS.PromiseArray` that fulfills to a
`DS.RecordArray` and `store.peekAll` directly returns a `DS.RecordArray`.

It's important to note that `DS.RecordArray` is not a JavaScript array.  It is
an object that implements [`Ember.Enumerable`][1]. This is important because,
for example, if you want to retrieve records by index, the `[]` notation will
not work--you'll have to use `objectAt(index)` instead.

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html

### Querying for Multiple Records

Ember Data provides the ability to query for records that meet certain criteria. Calling `store.query()`
will make a `GET` request with the passed object serialized as query params. This method returns
`DS.PromiseArray` in the same way as `find`.

For example, we could search for all `person` models who have the name of
`Peter`:

```javascript
var peters = this.store.query('person', { name: 'Peter' }); // => GET to /persons?name=Peter
```

### Integrating with the Route's Model Hook

As discussed in [Specifying a Route's Model][3], routes are
responsible for telling their template which model to render.

[3]: ../../routing/specifying-a-routes-model

`Ember.Route`'s `model` hook supports asynchronous values
out-of-the-box. If you return a promise from the `model` hook, the
router will wait until the promise has fulfilled to render the
template.

This makes it easy to write apps with asynchronous data using Ember
Data. Just return the requested record from the `model` hook, and let
Ember deal with figuring out whether a network request is needed or not.

```app/router.js
var Router = Ember.Router.extend({});

Router.map(function() {
  this.route('posts');
  this.route('post', { path: ':post_id' });
});

export default Router;
```

```app/routes/posts.js
export default Ember.Route.extend({
  model: function() {
    return this.store.findAll('post');
  }
});
```

```app/routes/post.js
export default Ember.Route.extend({
  model: function(params) {
    return this.store.findRecord('post', params.post_id);
  }
})
```
