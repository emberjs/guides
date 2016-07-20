The Ember Data store provides an interface for retrieving records of a single
type.

### Retrieving a Single Record

Use [`store.findRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_findRecord)
to retrieve a record by its type and ID. This will return a promise that
fulfills with the requested record:

```javascript
var post = this.get('store').findRecord('post', 1); // => GET /posts/1
```

Use [`store.peekRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_peekRecord)
to retrieve a record by its type and ID, without making a network request.
This will return the record only if it is already present in the store:

```javascript
var post = this.get('store').peekRecord('post', 1); // => no network request
```

### Retrieving Multiple Records

Use [`store.findAll()`](http://emberjs.com/api/data/classes/DS.Store.html#method_findAll)
to retrieve all of the records for a given type:

```javascript
var posts = this.get('store').findAll('post'); // => GET /posts
```

Use [`store.peekAll()`](http://emberjs.com/api/data/classes/DS.Store.html#method_peekAll)
to retrieve all of the records for a given type that are already loaded into 
the store, without making a network request:

```javascript
var posts = this.get('store').peekAll('post'); // => no network request
```

`store.findAll()` returns a `PromiseArray` that fulfills to a
`RecordArray` and `store.peekAll` directly returns a `RecordArray`.

It's important to note that `RecordArray` is not a JavaScript array.  It is
an object that implements [`Ember.Enumerable`][1]. This is important because,
for example, if you want to retrieve records by index, the `[]` notation will
not work--you'll have to use `objectAt(index)` instead.

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html

### Querying for Multiple Records

Ember Data provides the ability to query for records that meet certain criteria. Calling
[`store.query()`](http://emberjs.com/api/data/classes/DS.Store.html#method_query)
will make a `GET` request with the passed object serialized as query params. This method returns
a `PromiseArray` in the same way as `findAll`.

For example, we could search for all `person` models who have the name of
`Peter`:

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

If you know your query will return only one result Ember Data provides
a convenience method that will return a promise that resolves with a
single record. Calling
[`store.queryRecord()`](http://emberjs.com/api/data/classes/DS.Store.html#method_queryRecord)
will make a `GET` request with the passed object serialized as query params.

For example, if we know that an email uniquely identifies a person, we could search for a `person` model that has an email address of
`tomster@example.com`:

```javascript
// GET to /persons?filter[email]=tomster@example.com
this.get('store').queryRecord('person', { 
  filter: {
    email: 'tomster@example.com' 
  } 
}).then(function(tomster) {
  // do something with `tomster`
});
```
