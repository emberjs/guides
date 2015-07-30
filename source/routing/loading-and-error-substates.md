In addition to the techniques described in the
[Asynchronous Routing Guide](../asynchronous-routing/),
the Ember Router provides powerful yet overridable
conventions for customizing asynchronous transitions
between routes by making use of `error` and `loading`
substates.

## `loading` substates

The Ember Router allows you to return promises from the various
`beforeModel`/`model`/`afterModel` hooks in the course of a transition
(described [here](../asynchronous-routing/)).
These promises pause the transition until they fulfill, at which point
the transition will resume.

Consider the following:

```app/router.js
Router.map(function() {
  this.route('foo', function() {
    this.route('slow-model');
  });
});
```

```app/routes/foo/slow-model.js
export default Ember.Route.extend({
  model() {
    return somePromiseThatTakesAWhileToResolve();
  }
});
```

If you navigate to `foo/slow-model`, and in the `model` hook,
you return an AJAX query promise that takes a long time to complete.
During this time, your UI isn't really giving you any feedback as to
what's happening; if you're entering this route after a full page
refresh, your UI will be entirely blank, as you have not actually
finished fully entering any route and haven't yet displayed any
templates; if you're navigating to `foo/slow-model` from another
route, you'll continue to see the templates from the previous route
until the model finish loading, and then, boom, suddenly all the
templates for `foo/slow-model` load.

So, how can we provide some visual feedback during the transition?

Ember provides a default implementation of the `loading` process that implements
the following loading substate behavior.

```app/router.js
Router.map(function() {
  this.route('foo', function() {
    this.route('bar', function() {
      this.route('baz');
    });
  });
});
```

If a route with the path `foo.bar.baz` returns a promise that doesn't immediately
resolve, Ember will try to find a `loading` route in the hierarchy
above `foo.bar.baz` that it can transition into, starting with
`foo.bar.baz`'s sibling:

1. `foo.bar.loading`
2. `foo.loading`
3. `loading`

Ember will find a loading route at the above location if either a) a
Route subclass has been defined for such a route, e.g.

1. `app/routes/foo/bar/loading.js`
2. `app/routes/foo/loading.js`
3. `app/routes/loading.js`

or b) a properly-named loading template has been found, e.g.

1. `app/templates/foo/bar/loading.hbs`
2. `app/templates/foo/loading.hbs`
3. `app/templates/loading.hbs`

During a slow asynchronous transition, Ember will transition into the
first loading sub-state/route that it finds, if one exists. The
intermediate transition into the loading substate happens immediately
(synchronously), the URL won't be updated, and, unlike other transitions
that happen while another asynchronous transition is active, the
currently active async transition won't be aborted.

After transitioning into a loading substate, the corresponding template
for that substate, if present, will be rendered into the main outlet of
the parent route, e.g. `foo.bar.loading`'s template would render into
`foo.bar`'s outlet. (This isn't particular to loading routes; all
routes behave this way by default.)

Once the main async transition into `foo.bar.baz` completes, the loading
substate will be exited, its template torn down, `foo.bar.baz` will be
entered, and its templates rendered.

### Eager vs. Lazy Async Transitions

Loading substates are optional, but if you provide one,
you are essentially telling Ember that you
want this async transition to be "eager"; in the absence of destination
route loading substates, the router will "lazily" remain on the pre-transition route
while all of the destination routes' promises resolve, and only fully
transition to the destination route (and renders its templates, etc.)
once the transition is complete. But once you provide a destination
route loading substate, you are opting into an "eager" transition, which
is to say that, unlike the "lazy" default, you will eagerly exit the
source routes (and tear down their templates, etc) in order to
transition into this substate. URLs always update immediately unless the
transition was aborted or redirected within the same run loop.

This has implications on error handling, i.e. when a transition into
another route fails, a lazy transition will (by default) just remain on the
previous route, whereas an eager transition will have already left the
pre-transition route to enter a loading substate.

### The `loading` event

If you return a promise from the various `beforeModel`/`model`/`afterModel` hooks,
and it doesn't immediately resolve, a `loading` event will be fired on that route
and bubble upward to `route:application`.

If the `loading` handler is not defined at the specific route,
the event will continue to bubble above a transition's pivot
route, providing the `route:application` the opportunity to manage it.

```app/routes/foo-slow-model.js
export default Ember.Route.extend({
  model() {
    return somePromiseThatTakesAWhileToResolve();
  },
  actions: {
    loading(transition, originRoute) {
      //displayLoadingSpinner();
      this.router.one('didTransition', function () {
        // hideLoadingSpinner();
      });

      // Return true to bubble this event to `FooRoute`
      // or `ApplicationRoute`.
      return true;
    }
  }
});
```

The `loading` handler provides the ability to decide what to do during
the loading process. If the last loading handler is not defined
or returns `true`, Ember will perform the loading substate behavior.

```app/routes/application.js
export default Ember.Route.extend({
  actions: {
    loading(transition, originRoute) {
      displayLoadingSpinner();

      // substate implementation when returning `true`
      return true;
    }
  }
});
```

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
`route:articles/overview`'s `#model` hook (or `beforeModel` or `afterModel`)
will look for:

1. Either `route:articles/error` or `articles/error` template
2. Either `route:error` or `error` template

If one of the above is found, the router will immediately transition into
that substate (without updating the URL). The "reason" for the error
(i.e. the exception thrown or the promise reject value) will be passed
to that error state as its `model`.

If no viable error substates can be found, an error message will be
logged.


### `error` substates with dynamic segments

Routes with dynamic segments are often mapped to a mental model of "two
separate levels." Take for example:

```app/router.js
Router.map(function() {
  this.route('foo', { path: '/foo/:id' }, function() {
    this.route('baz');
  });
});
```

```app/routes/foo.js
export default Ember.Route.extend({
  model(params) {
    return new Ember.RSVP.Promise(function(resolve, reject) {
       reject("Error");
    });
  }
});
```

In the URL hierarchy you would visit `/foo/12` which would result in rendering
the `foo` template into the `application` template's `outlet`. In the event of
an error while attempting to load the `foo` route you would also render the
top-level `error` template into the `application` template's `outlet`. This is
intentionally parallel behavior as the `foo` route is never successfully
entered. In order to create a `foo` scope for errors and render `foo/error`
into `foo`'s `outlet` you would need to split the dynamic segment:

```app/router.js
Router.map(function() {
  this.route('foo', {path: '/foo'}, function() {
    this.route('elem', {path: ':id'}, function() {
      this.route('baz');
    });
  });
});
```

```app/routes/foo-elem.js
export default Ember.Route.extend({
  model: function(params) {
    return new Ember.RSVP.Promise(function(x, reject) {
       reject("Foo Error");
    });
  }
});
```


### The `error` event

If `route:articles/overview`'s `model` hook returns a promise that rejects (for
instance the server returned an error, the user isn't logged in,
etc.), an `error` event will fire on `route:articles/overview` and bubble upward.
This `error` event can be handled and used to display an error message,
redirect to a login page, etc.


```app/routes/articles-overview.js
export default Ember.Route.extend({
  model(params) {
    return new Ember.RSVP.Promise(function(resolve, reject) {
       reject("Error");
    });
  },
  actions: {
    error(error, transition) {

      if (error && error.status === 400) {
        // error substate and parent routes do not handle this error
        return this.transitionTo('modelNotFound');
      }

      // Return true to bubble this event to any parent route.
      return true;
    }
  }
});
```

Analogous to the `loading` event, you could manage the `error` event
at the Application level to perform any application logic and based on the
result of the last `error` handler, Ember will decide if substate behavior
must be performed or not.

```app/routes/application.js
export default Ember.Route.extend({
  actions: {
    error(error, transition) {

      // Manage your errors
      Ember.onerror(error);

      // substate implementation when returning `true`
      return true;

    }
  }
});
```
