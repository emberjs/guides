One of the main advantages of Single Page Javascript apps when compared to server
side rendered applications is their perceived speed and lack of latency. Ember enables us
to build apps which rival native in terms of how fast and responsive the UI is.

One of the main benefits of using Ember Data is that it automatically caches records for in memory.

If you have a simple Ember Instagram Application with two routes, one for loading
all images and one for loading a specific image

```js routes/images.js
model: function() {
  return $.GET('/images);
}

```js routes/image
model: function(params) {
  return $.GET('/images/' + params.id);
}
```
By default, unless you implemented caching manually, when the user went to `/images/` and then to
`/images/1`, you would make two network calls, and would force the user to wait for the call
to `/images/1` to finish, even though you have already fetched all the images.
Moreover, by using defaults, every time the user went to `/images/1` they would have to wait all over
again for it to load, and if they happen to be offline or have a spotty connection at the moment, your
application would break.

Ember Data solves these problems for you by caching all the record data in an *identityMap` and keeping
track of already loaded records.

## Caching

If you implement the above routes in Ember Data:

```js routes/images.js
model: function() {
  return this.store.findAll('image');
}

```js routes/image
model: function(params) {
  return this.store.findRecord('image', params.id);
}
```

The first time the user goes to `/images` Ember Data will return a promise which will resolve
once the call to `/images` has returned. Then when the user goes to `/images/1`, the call to
`this.store.findRecord('image', params.id)` will return a promise that will immediately resolve with
the cached value of the Image record, which we got from the original call to `/images`, making your UI
Transition finish immediately.


## Identity Map

The store will automatically cache records for you. If a record had already
been loaded, asking for it a second time will always return the same
object instance. This minimizes the number of round-trips to the
server, and allows your application to render its UI to the user as fast as
possible.

For example, the first time your application asks the store for a
`person` record with an ID of `1`, it will fetch that information from
your server.

However, the next time your app asks for a `person` with ID `1`, the
store will notice that it had already retrieved and cached that
information from the server. Instead of sending another request for the
same information, it will give your application the same record it had
provided it the first time.  This feature—always returning the same
record object, no matter how many times you look it up—is sometimes
called an _identity map_.

Using an identity map is important because it ensures that changes you
make in one part of your UI are propagated to other parts of the UI. It
also means that you don't have to manually keep records in sync—you can
ask for a record by ID and not have to worry about whether other parts
of your application have already asked for and loaded it.


## Dealing With Stale Data
FINISH
One downside to returning a cached record is you may find the state of
the data has changed since it was first loaded into the store's
identity map. In order to prevent this stale data from being a problem
for long, Ember Data will automatically make a request in the
background each time a cached record is returned from the store. When
the new data comes in, the record is updated, and if there have been
changes to the record since the initial render, the template is
re-rendered with the new information.

Flags GO here
