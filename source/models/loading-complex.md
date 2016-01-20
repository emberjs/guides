In the previous chapter, you have seen how to load a single record, using
```
store.findRecord('picture', 1);
```
and how to define the model class,
```app/models/picture.js
export default DS.Model.extend({
  title: DS.attr()
});
```

The Instagram clone we are building will also need to do more complex data loading.
If you want to load all the pictures, you can do
```
store.findAll('picture');
```
This call will return a promise that will try to retreive all the pictures. By default this call
will go to `/pictures`. If you are not using JSON API or need to modify the call, you can learn how to do that
in LINK HERE

`store.findRecord` and `store.findAll` are the primary methods for finding individual records and collections of records
in a RESTFul way. However, sometimes you might need to do a specific query for a record or a collection that is more complex
than a simple RESTFul GET call. You can use `store.queryRecord` and `store.query` to do that.


For example, we could search for all `picture` models made in Barcelona.

```javascript
// GET to /pictures?filter[location]=Barcelona
this.store.query('picture', { filter: { location: 'Barcelona' } }).then(function(pictures) {
  // Do something with `pictures`
});
```

For example, if we know that an email uniquely identifies a person, we could search for a `person` model that has an email address of
`tomster@example.com`:

```javascript
// GET to /persons?filter[email]=tomster@example.com
this.store.queryRecord('person', { filter: { email: 'tomster@example.com' } }).then(function(tomster) {
  // do something with `tomster`
});
```

Use [`store.peekRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_peekRecord) to retrieve a record by its type and ID, without making
a network request. This will return the record only if it is already present in
the store:

```javascript
var post = this.store.peekRecord('post', 1); // => no network request
```

### Retrieving Multiple Records
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
