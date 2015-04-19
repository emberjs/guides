When your application starts, the router is responsible for displaying
templates, loading data, and otherwise setting up application state.
It does so by matching the current URL to the _routes_ that you've
defined.

The [map](http://emberjs.com/api/classes/Ember.Router.html#method_map) method
of your Ember application's router can be invoked to define URL mappings. When
calling `map`, you should pass a function that will be invoked with the value
`this` set to an object which you can use to create
[routes](../defining-your-routes/).

```app/router.js
Router.map(function() {
  this.route('about', { path: '/about' });
  this.route('favorites', { path: '/favs' });
});
```

Now, when the user visits `/about`, Ember.js will render the `about`
template. Visiting `/favs` will render the `favorites` template.

**Heads up!** You get a few routes for free: the `route:application` and
`route:index` (corresponding to the `/` path).
[See below](#toc_initial-routes) for more details.

You can leave off the path if it is the same as the route
name. In this case, the following is equivalent to the above example:

```app/router.js
Router.map(function() {
  this.route('about');
  this.route('favorites', { path: '/favs' });
});
```

Inside your templates, you can use `{{link-to}}` to navigate between
routes, using the name that you provided to the `route` method (or, in
the case of `/`, the name `index`).

```handlebars
{{#link-to 'index'}}<img class="logo">{{/link-to}}

<nav>
  {{#link-to 'about'}}About{{/link-to}}
  {{#link-to 'favorites'}}Favorites{{/link-to}}
</nav>
```

The `{{link-to}}` helper will also add an `active` class to the link that
points to the currently active route.

You can customize the behavior of a route by creating an `Ember.Route`
subclass. For example, to customize what happens when your user visits
`/`, create an `route:index`:

```app/routes/index.js
export default Ember.Route.extend({
  setupController: function(controller) {
    // Set the IndexController's `title`
    controller.set('title', 'My App');
  }
});
```

`controller:index` is the starting context for the `index` template.
Now that you've set `title`, you can use it in the template:

```handlebars
<!-- get the title from the IndexController -->
<h1>{{title}}</h1>
```

(If you don't explicitly define an `controller:index`, Ember.js will
automatically generate one for you.)

Ember.js automatically figures out the names of the routes and controllers based on
the name you pass to `this.route`.

<table>
  <thead>
  <tr>
    <th>URL</th>
    <th>Route Name</th>
    <th>
      Controller<br/>
      <code>app/controllers/</code>
    </th>
    <th>
      Route<br/>
      <code>app/routes/</code>
    </th>
    <th>
      Template<br/>
      <code>app/templates/</code>
    </th>
  </tr>
  </thead>
  <tr>
    <td><code>/</code></td>
    <td><code>index</code></td>
    <td>↳<code>index.js</code></td>
    <td>↳<code>index.js</code></td>
    <td>↳<code>index.hbs</code></td>
  </tr>
  <tr>
    <td><code>/about</code></td>
    <td><code>about</code></td>
    <td>↳<code>about.js</code></td>
    <td>↳<code>about.js</code></td>
    <td>↳<code>about.hbs</code></td>
  </tr>
  <tr>
    <td><code>/favs</code></td>
    <td><code>favorites</code></td>
    <td>↳<code>favorites.js</code></td>
    <td>↳<code>favorites.js</code></td>
    <td>↳<code>favorites.hbs</code></td>
  </tr>
</table>

### Nested Routes

You can define nested routes by passing a callback to `this.route`:

```app/router.js
Router.map(function() {
  this.route('posts', { path: '/posts' }, function() {
    this.route('new');
  });
});
```

This router creates these routes:

<table>
  <thead>
  <tr>
   <th>URL</th>
   <th>Route Name</th>
   <th>
     Controller<br/>
     <code>app/controllers/</code>
   </th>
   <th>
     Route<br/>
     <code>app/routes/</code>
   </th>
   <th>
     Template<br/>
     <code>app/templates/</code>
   </th>
  </tr>
  </thead>
  <tr>
    <td><code>/</code></td>
    <td><code>index</code></td>
    <td>↳<code>index.js</code></td>
    <td>↳<code>index.js</code></td>
    <td>↳<code>index.js</code></td>
  </tr>
  <tr>
    <td>N/A</td>
    <td><code>posts</code><sup>1</sup></td>
    <td>↳<code>posts.js</code></td>
    <td>↳<code>posts.js</code></td>
    <td>↳<code>posts.hbs</code></td>
  </tr>
  <tr>
    <td><code>/posts</code></td>
    <td><code>posts.index</code></code></td>
    <td>↳<code>posts.js</code><br>↳<code>posts/index.js</code></td>
    <td>↳<code>posts.js</code><br>↳<code>posts/index.js</code></td>
    <td>↳<code>posts.hbs</code><br>↳<code>posts/index.hbs</code></td>
  </tr>
  <tr>
    <td><code>/posts/new</code></td>
    <td><code>posts.new</code></td>
    <td>↳<code>posts.js</code><br>↳<code>posts/new.js</code></td>
    <td>↳<code>posts.js</code><br>↳<code>posts/new.js</code></td>
    <td>↳<code>posts.hbs</code><br>↳<code>posts/new.hbs</code></td>
  </tr>
</table>

<small><sup>1</sup> Transitioning to `posts` or creating a link to
`posts` is equivalent to transitioning to `posts.index` or linking to
`posts.index`</small>

A nested route's names includes the names of its ancestors.
If you want to transition to a route (either
via `transitionTo` or `{{#link-to}}`), make sure to use the full route
name (`posts.new`, not `new`).

Visiting `/` renders the `index` template, as you would expect.

Visiting `/posts` is slightly different. It will first render the
`posts` template. Then, it will render the `posts/index` template into the
`posts` template's outlet.

Finally, visiting `/posts/new` will first render the `posts` template,
then render the `posts/new` template into its outlet.

### Multi-word Model Names

For multi-word models all the names are camel cased except for the dynamic segment. For example, a model named `BigMac` would have a resource path of `/bigMacs/:big_mac_id`, route named `bigMac`, template named `bigMac`.

### Dynamic Segments

One of the responsibilities of a route handler is to convert a URL
into a model.

For example, if we have the route `this.route('posts');`, our
route handler might look like this:

```app/posts/route.js
export default Ember.Route.extend({
  model: function() {
    return $.getJSON("/url/to/some/posts.json");
  }
});
```

The `posts` template will then receive a list of all available posts as
its context.

Because `/posts` represents a fixed model, we don't need any
additional information to know what to retrieve.  However, if we want a route
to represent a single post, we would not want to have to hardcode every
possible post into the router.

Enter _dynamic segments_.

A dynamic segment is a portion of a URL that starts with a `:` and is
followed by an identifier.

```app/router.js
Router.map(function() {
  this.route('posts');
  this.route('post', { path: '/post/:post_id' });
});
```

```app/routes/post.js
export default Ember.Route.extend({
  model: function(params) {
    return $.getJSON("/url/to/some/posts/" + params.post_id + ".json");
  }
});
```


If your model does not use the `id` property in the URL, you should
define a serialize method on your route:

```app/router.js
Router.map(function() {
  this.route('post', { path: '/posts/:post_slug' });
});
```

```app/routes/post.js
export default Ember.Route.extend({
  model: function(params) {
    // the server returns `{ slug: 'foo-post' }`
    return Ember.$.getJSON('/posts/' + params.post_slug);
  },

  serialize: function(model) {
    // this will make the URL `/posts/foo-post`
    return { post_slug: model.get('slug') };
  }
});
```

The default `serialize` method inserts the model's `id` into the route's
dynamic segment (in this case, `:post_id`).

### Initial routes

A few routes are immediately available within your application:

  - `route:application` is entered when your app first boots up. It renders
    the `application` template.

  - `route:index` is the default route, and will render the `index` template
    when the user visits `/` (unless `/` has been overridden by your own
    custom route).

These routes are part of every application, so you don't need to
specify them in your `app/router.js`.

### Wildcard / globbing routes

You can define wildcard routes that will match multiple routes. This could be used, for example,
if you'd like a catch-all route which is useful when the user enters an incorrect URL not managed
by your app.

```app/router.js
Router.map(function() {
  this.route('catchall', { path: '/*wildcard' });
});
```

Like all routes with a dynamic segment, you must provide a context when using a `{{link-to}}`
or `transitionTo` to programatically enter this route.

```app/routes/application.js
export default Ember.Route.extend({
  actions: {
    error: function() {
      this.transitionTo('catchall', 'application-error');
    }
  }
});
```

With this code, if an error bubbles up to the Application route, your application will enter
the `catchall` route and display `/application-error` in the URL.
