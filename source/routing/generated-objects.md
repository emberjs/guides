As explained in the [routing guide](../defining-your-routes), whenever
you define a new path in your router, Ember.js attempts to find a
corresponding route, controller, and template, each named according to
naming conventions. If an implementation of any of these objects is not
found, appropriate objects will be generated for you.

#### Generated routes

Given you have the following route:

```app/router.js
Router.map(function() {
  this.route('posts');
});
```

When you navigate to `/posts`, Ember.js looks for `route:posts`.
If it doesn't find it, it will automatically generate `route:posts` for you.


#### Generated Controllers

If you navigate to route `posts`, Ember.js looks for a controller called `controller:posts`.
If you did not define it, one will be generated for you.

#### Generated Templates

A route also expects a template. If you don't provide a template, an
empty one will be generated for you.

The empty template includes an `{{outlet}}`, so nested routes will
render correctly even if the route does not explicitly provide a
template.

```handlebars
{{outlet}}
```
