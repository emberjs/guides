### Transitioning and Redirecting

Calling `transitionTo` from a route or `transitionToRoute` from a controller
will stop any transition currently in progress and start a new one, functioning
as a redirect. `transitionTo` takes parameters and behaves exactly like the [link-to](../../templates/links) helper:

* If you transition into a route without dynamic segments that route's `model` hook
will always run.

* If the new route has dynamic segments, you need to pass either a _model_ or an _identifier_ for each segment.
Passing a model will skip that segment's `model` hook.  Passing an identifier will run the `model` hook and you'll be able to access the identifier in the params. See [Links](../../templates/links) for more detail.

### Before the model is known

If you want to redirect from one route to another, you can do the transition in
the `beforeModel` hook of your route handler.

```app/router.js
Router.map(function() {
  this.route('posts');
});
```

```app/routes/index.js
export default Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('posts');
  }
});
```

### After the model is known

If you need information about the current model in order to decide about
redirection, you should either use the `afterModel` or the `redirect` hook.
They receive the resolved model as the first parameter and the transition as
the second one, and thus function as aliases. (In fact, the default
implementation of `afterModel` just calls `redirect`.)

```app/router.js
Router.map(function() {
  this.route('posts');
  this.route('post', { path: '/post/:post_id' });
});
```

```app/routes/post.js
export default Ember.Route.extend({
  afterModel: function(posts, transition) {
    if (posts.get('length') === 1) {
      this.transitionTo('post', posts.get('firstObject'));
    }
  }
});
```

When transitioning to the `posts` route if it turns out that there is only one post,
the current transition will be aborted in favor of redirecting to the `PostRoute`
with the single post object being its model.

### Based on other application state

You can conditionally transition based on some other application state.

```app/router.js
Router.map(function() {
  this.route('topCharts', function() {
    this.route('choose', { path: '/' });
    this.route('albums');
    this.route('songs');
    this.route('artists');
    this.route('playlists');
  });
});
```

```app/routes/top-charts/choose.js
export default Ember.Route.extend({
  beforeModel: function() {
    var lastFilter = this.controllerFor('application').get('lastFilter');
    this.transitionTo('topCharts.' + (lastFilter || 'songs'));
  }
});
```

```app/routes/filter.js
// Superclass to be used by all of the filter routes: albums, songs, artists, playlists
export default Ember.Route.extend({
  activate: function() {
    var controller = this.controllerFor('application');
    controller.set('lastFilter', this.templateName);
  }
});
```

In this example, navigating to the `/` URL immediately transitions into
the last filter URL that the user was at. The first time, it transitions
to the `/songs` URL.

Your route can also choose to transition only in some cases. If the
`beforeModel` hook does not abort or transition to a new route, the remaining
hooks (`model`, `afterModel`, `setupController`, `renderTemplate`) will execute
as usual.
