The Ember Router allows you to provide feedback that a route is loading, as well
as when an error occurs in loading a route.

## `loading` substates

During the `beforeModel`, `model`, and `afterModel` hooks, data may take some
time to load. Technically, the router pauses the transition until the promises
returned from each hook fulfill.

Consider the following:

```app/router.js
Router.map(function() {
  this.route('slow-model');
});
```

```app/routes/slow-model.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('slowModel');
  }
});
```

If you navigate to `slow-model`, in the `model` hook,
the query may take a long time to complete.
During this time, your UI isn't really giving you any feedback as to
what's happening. If you're entering this route after a full page
refresh, your UI will be entirely blank, as you have not actually
finished fully entering any route and haven't yet displayed any
templates. If you're navigating to `slow-model` from another
route, you'll continue to see the templates from the previous route
until the model finish loading, and then, boom, suddenly all the
templates for `slow-model` load.

So, how can we provide some visual feedback during the transition?

Simply define a template called `loading` (and optionally a corresponding route)
that Ember will transition to. The
intermediate transition into the loading substate happens immediately
(synchronously), the URL won't be updated, and, unlike other transitions, the
currently active transition won't be aborted.

Once the main transition into `slow-model` completes, the `loading`
route will be exited and the transition to `slow-model` will continue.

For nested routes, like:

```app/router.js
Router.map(function() {
  this.route('foo', function() {
    this.route('bar', function() {
      this.route('slow-model');
    });
  });
});
```

Ember will try to find a `loading` route in the hierarchy
above `foo.bar.slow-model` that it can transition into, starting with
`foo.bar.slow-models`'s sibling:

1. `foo.bar.loading`
2. `foo.loading`
3. `loading`

### The `loading` event

If the various `beforeModel`/`model`/`afterModel` hooks
don't immediately resolve, a `loading` event will be fired on that route.

```app/routes/foo-slow-model.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('slowModel');
  },
  actions: {
    loading(transition, originRoute) {
      alert('Sorry this page is taking so long to load!');
    }
  }
});
```

If the `loading` handler is not defined at the specific route,
the event will continue to bubble above a transition's parent
route, providing the `route:application` the opportunity to manage it.

## `error` substates

Ember provides an analogous approach to `loading` substates in
the case of errors encountered during a transition.

Similar to how the default `loading` event handlers are implemented,
the default `error` handlers will look for an appropriate error substate to
enter, if one can be found.

```app/router.js
Router.map(function() {
  this.route('articles', function() {
    this.route('overview');
  });
});
```

For instance, an thrown error or rejected promise returned from
`route:articles/overview`'s `model` hook (or `beforeModel` or `afterModel`)
will look for:

1. Either `route:articles/error` or `articles/error` template
2. Either `route:error` or `error` template

If one of the above is found, the router will immediately transition into
that substate (without updating the URL). The "reason" for the error
(i.e. the exception thrown or the promise reject value) will be passed
to that error state as its `model`.

If no viable error substates can be found, an error message will be
logged.

### The `error` event

If `route:articles/overview`'s `model` hook returns a promise that rejects (for
instance the server returned an error, the user isn't logged in,
etc.), an `error` event will fire on `route:articles/overview` and bubble upward.
This `error` event can be handled and used to display an error message,
redirect to a login page, etc.


```app/routes/articles-overview.js
export default Ember.Route.extend({
  model(params) {
    return this.store.findAll('nonexistentModel');
  },
  actions: {
    error(error, transition) {
      if (error && error.status === 400) {
        return this.transitionTo('modelNotFound');
      }
    }
  }
});
```

Analogous to the `loading` event, you could manage the `error` event
at the application level to avoid writing the same code for multiple routes.
