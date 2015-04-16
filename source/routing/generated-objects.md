As explained in the [routing guide](../defining-your-routes), whenever you define a new route,
Ember.js attempts to find corresponding Route, Controller, View, and Template
classes named according to naming conventions. If an implementation of any of
these objects is not found, appropriate objects will be generated in memory for you.

#### Generated routes

Given you have the following route:

```app/router.js
Router.map(function() {
  this.route('posts');
});
```

When you navigate to `/posts`, Ember.js looks for `route:posts`.
If it doesn't find it, it will automatically generate an `route:posts` for you.


#### Generated Controllers

If you navigate to route `posts`, Ember.js looks for a controller called `controller:posts`.
If you did not define it, one will be generated for you.

#### Generated Views and Templates

A route also expects a view and a template.  If you don't define a view,
a view will be generated for you.

A generated template is empty.
If it's a resource template, the template will simply act
as an `outlet` so that nested routes can be seamlessly inserted.  It is equivalent to:

```handlebars
{{outlet}}
```

[deprecations guide]: http://emberjs.com/deprecations/v1.x/
