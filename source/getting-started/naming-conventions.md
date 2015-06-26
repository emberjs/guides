Ember.js uses a runtime resolver to wire up your objects without a
lot of boilerplate. As a developer, this resolver will work automatically
if you place code in conventional locations within your project.

You can usually guess the names and locations, but this guide outlines, in one place,
all of the naming conventions.

## The Application

When your application boots, Ember will look for the objects exported
by these modules in your project:

* `app/app.js`
* `app/controllers/application.js`
* `app/templates/application.hbs`

Ember.js will render the `application` template as the main template.
If `controller:application` is provided, Ember.js will set an
instance of `controller:application` as the controller for the
template. This means that the template will get its properties from
the controller.

If your app provides a route at `app/routes/application.js` Ember.js will invoke
[the][1] [router's][2] [hooks][3] first, before rendering the
`application` template. Hooks are implemented as methods and provide
you access points within an Ember object's lifecycle to intercept and
execute code to modify the default behavior at these points to meet
your needs. Ember provides several hooks for you to utilize for various
purposes (e.g. `model`, `setupController`, etc). In the example below
`route:application` Route, which is an `Ember.Route` object, implements
the `setupController` hook.

[1]: ../../routing/specifying-a-routes-model
[2]: ../../routing/setting-up-a-controller
[3]: ../../routing/rendering-a-template

Here's a simple example that uses a route, controller, and template:

```app/routes/application.js
export default Ember.Route.extend({
  setupController: function(controller) {
    // `controller` is the instance of ApplicationController
    controller.set('title', "Hello world!");
  }
});
```

```app/controllers/application.js
export default Ember.Controller.extend({
  appName: 'My First Example'
});
```

```app/templates/application.hbs
<h1>{{appName}}</h1>
<h2>{{title}}</h2>
```

In Ember.js applications, you will always provide your objects
as **classes**, and the framework is responsible for instantiating
them and providing them to your templates at runtime through the resolver.



## Simple Routes

Each of your routes will have a controller and a template with the
same name as the route.

Let's start with a simple router:

```app/router.js
export default Ember.Router.extend().map(function(){
  this.route('favorites');
});
```

If your user navigates to `/favorites`, Ember.js will look for these
classes in your project:

* `app/routes/favorites.js`
* `app/controllers/favorites.js`
* `app/templates/favorites.hbs`

Ember.js will render the `favorites` template into the `{{outlet}}`
in the `application` template. It will set an instance of the
`controller:favorites` as the controller for the template.

If your app provides a `route:favorites`, the framework will
invoke it before rendering the template. Yes, this is a bit
repetitive.

For a route like `route:favorites`, you will probably implement
the `model` hook to specify what model your controller will present
to the template.

Here's an example:

```app/routes/favorites.js
export default Ember.Route.extend({
  model: function() {
    // the model is an Array of all of the posts
    // fetched from this url
    return $.ajax('/a/service/url/where/posts/live');
  }
});
```

In this example, we didn't provide a `controller:favorites`. Because
the model is an Array, Ember.js will automatically supply an instance
of `Ember.ArrayController`, which will present the backing Array as
its model.

You can treat the `Ember.ArrayController` as if it was the model itself.
The benefit of this is that you can replace the controller's model at
any time without having to directly notify templates and components of
the change.

The template can iterate over the elements of the controller:

```handlebars
<ul>
{{#each controller as |item|}}
  <li>{{item.title}}</li>
{{/each}}
</ul>
```

## Dynamic Segments

If a route uses a dynamic segment (a URL that includes a parameter), the route's model will be based
on the value of that segment provided by the user.

Consider this router definition:

```javascript
export default Ember.Router.extend().map(function(){
  this.route('post', { path: '/posts/:post_id' });
});
```

In this case, the route's name is `post`, so Ember.js will look for
these objects:

* `app/routes/post.js`
* `app/controllers/post.js`
* `app/templates/post.hbs`

Your route handler's `model` hook converts the dynamic `:post_id`
parameter into a model. The `serialize` hook converts a model object
back into the URL parameters for this route (for example, when
generating a link for a model object).

```app/routes/post.js
export default Ember.Route.extend({
  model: function(params) {
    return $.ajax('/my-service/posts/' + params.post_id);
  },

  serialize: function(post) {
    return { post_id: Ember.get(post, 'id') };
  }
});
```

Because this pattern is so common, it is the default for route
handlers.

* If your dynamic segment ends in `_id`, the default `model`
  hook will convert the first part into a model class on the
  application's namespace (`post` looks for `app/models/post.js`). It will
  then call `find` on that class with the value of the dynamic
  segment.
* The default behaviour of the `serialize` hook is to replace
  the route's dynamic segment with the value of the model
  object's `id` property.

## Route, Controller and Template Defaults

If you don't specify a route handler for the `post` route
(`app/routes/post.js`), Ember.js  will still render the `app/templates/post.hbs`
template with the app's instance of `app/controllers/post.js`.

If you don't specify the controller (`app/controllers/post.js`),
Ember will automatically make one for you based on the return value
of the route's `model` hook. If the model is an Array, you get an
`ArrayController`. Otherwise, you get an `ObjectController`. As of 1.11,
`ObjectController`s are deprecated and if you try to use its proxy feature you
will get a warning. Please, take a look at the [deprecations guide](http://emberjs.com/deprecations/v1.x/) for more
detailed information.

If you don't specify a `post` template, Ember.js won't render
anything!

## Nesting

You can nest routes:

```javascript
export default Ember.Router.extend().map(function(){
  this.route('posts', function() {    // the `posts` route
    this.route('favorites');          // the `posts.favorites` route
    this.route('post');               // the `posts.post` route
  });
});
```

Here are the naming conventions for each of the routes defined in
this router:

<table class="extensive">
  <thead>
  <tr>
    <th>Route Name</th>
    <th>Controller</th>
    <th>Route</th>
    <th>Template</th>
  </tr>
  </thead>
  <tr>
    <td><code>posts</code></td>
    <td><code>app/controllers/posts.js</code></td>
    <td><code>app/routes/posts.js</code></td>
    <td><code>app/templates/posts.hbs</code></td>
  </tr>
  <tr>
    <td><code>posts.favorites</code></td>
    <td><code>app/controllers/posts/favorites.js</code></td>
    <td><code>app/routes/posts/favorites.js</code></td>
    <td><code>app/templates/posts/favorites.hbs</code></td>
  </tr>
  <tr>
    <td><code>posts.post</code></td>
    <td><code>app/controllers/posts/post.js</code></td>
    <td><code>app/routes/posts/post.js</code></td>
    <td><code>app/templates/posts/post.hbs</code></td>
  </tr>
</table>

## The Index Route

At every level of nesting (including the top level), Ember.js
automatically provides a route for the `/` path named `index`.

For example, if you write a simple router like this:

```app/router.js
export default Ember.Router.extend().map(function(){
  this.route('favorites');
});
```

It is the equivalent of:

```app/router.js
export default Ember.Router.extend().map(function(){
  this.route('index', { path: '/' });
  this.route('favorites');
});
```

If the user visits `/`, Ember.js will look for these objects:

* `app/routes/index.js`
* `app/controllers/index.js`
* `app/templates/index.hbs`

The `index` template will be rendered into the `{{outlet}}` in the
`application` template. If the user navigates to `/favorites`,
Ember.js will replace the `index` template with the `favorites`
template.

A nested router like this:

```app/router.js
export default Ember.Router.extend().map(function(){
  this.route('posts', function() {
    this.route('favorites');
  });
});
```

Is the equivalent of:

```app/router.js
export default Ember.Router.extend().map(function(){
  this.route('index', { path: '/' });
  this.route('posts', function() {
    this.route('index', { path: '/' });
    this.route('favorites');
  });
});
```

If the user navigates to `/posts`, the current route will be
`posts.index`. Ember.js will look for objects named:

* `app/routes/posts/index.js`
* `app/controllers/posts/index.js`
* `app/templates/posts/index.hbs`

First, the `posts` template will be rendered into the `{{outlet}}`
in the `application` template. Then, the `posts/index` template
will be rendered into the `{{outlet}}` in the `posts` template.

If the user then navigates to `/posts/favorites`, Ember.js will
replace the `{{outlet}}` in the `posts` template with the
`posts/favorites` template.
