The Ember Data store provides an interface for retrieving records of a single type.

### Retrieving a Single Record

Use [`store.findRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_findRecord) to retrieve a record by its type and ID. This will return a promise that fulfills with the requested record:

```javascript
var blogPost = this.get('store').findRecord('blog-post', 1); // => GET /blog-posts/1
```

Use [`store.peekRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_peekRecord) to retrieve a record by its type and ID, without making a network request. This will return the record only if it is already present in the store:

```javascript
var blogPost = this.get('store').peekRecord('blog-post', 1); // => no network request
```

### Retrieving Multiple Records

Use [`store.findAll()`](http://emberjs.com/api/data/classes/DS.Store.html#method_findAll) to retrieve all of the records for a given type:

```javascript
var blogPosts = this.get('store').findAll('blog-post'); // => GET /blog-posts
```

Use [`store.peekAll()`](http://emberjs.com/api/data/classes/DS.Store.html#method_peekAll) to retrieve all of the records for a given type that are already loaded into the store, without making a network request:

```javascript
var blogPosts = this.get('store').peekAll('blog-post'); // => no network request
```

`store.findAll()` returns a `DS.PromiseArray` that fulfills to a `DS.RecordArray` and `store.peekAll` directly returns a `DS.RecordArray`.

It's important to note that `DS.RecordArray` is not a JavaScript array, it's an object that implements [`Ember.Enumerable`](http://emberjs.com/api/classes/Ember.Enumerable.html). This is important because, for example, if you want to retrieve records by index, the `[]` notation will not work--you'll have to use `objectAt(index)` instead.

### Querying for Multiple Records

Ember Data provides the ability to query for records that meet certain criteria. Calling [`store.query()`](http://emberjs.com/api/data/classes/DS.Store.html#method_query) will make a `GET` request with the passed object serialized as query params. This method returns a `DS.PromiseArray` in the same way as `findAll`.

For example, we could search for all `person` models who have the name of `Peter`:

```javascript
// GET to /persons?filter[name]=Peter
this.get('store').query('person', {
  filter: {
    name: 'Peter'
  }
}).then(function(peters) {
  // Do something with `peters`
});
```

### Querying for A Single Record

If you are using an adapter that supports server requests capable of returning a single model object, Ember Data provides a convenience method [`store.queryRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_queryRecord)that will return a promise that resolves with that single record. The request is made via a method `queryRecord()` defined by the adapter.

For example, if your server API provides an endpoint for the currently logged in user:

```text
// GET /api/current_user
{
  user: {
    id: 1234,
    username: 'admin'
  }
}
```

and the adapter for the `User` model defines a `queryRecord()` method that targets that endpoint:

```app/adapters/user.js // app/adapters/user.js import DS from "ember-data";

export default DS.Adapter.extend({ queryRecord(modelName, query) { return Ember.$.getJSON("/api/current_user"); } });

    <br />then calling [`store.queryRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_queryRecord) will retrieve that object from the server:
    
    ```javascript
    store.queryRecord('user', {}).then(function(user) {
      let username = user.get('username');
      console.log(`Currently logged in as ${username}`);
    });
    

As in the case of `store.query()`, a query object can also be passed to `store.queryRecord()` and is available for the adapter's `queryRecord()` to use to qualify the request. However the adapter must return a single model object, not an array containing one element, otherwise Ember Data will throw an exception.

Note that Ember's default [JSON API adapter](http://emberjs.com/api/data/classes/DS.JSONAPIAdapter.html) does not provide the functionality needed to support `queryRecord()` directly as it relies on REST request definitions that return result data in the form of an array.

If your server API or your adapter only provides array responses but you wish to retrieve just a single record, you can alternatively use the `query()` method as follows:

```javascript
// GET to /users?filter[email]=tomster@example.com
tom = store.query('user', {
  filter: {
    email: 'tomster@example.com'
  }
}).then(function(users) {
  return users.get("firstObject");
});
```