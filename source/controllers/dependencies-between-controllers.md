Sometimes, especially when nesting resources, we find ourselves needing
to have some kind of connection between two controllers. Let's take this
router as an example:

```app/router.js
var Router = Ember.Router.extend({});

Router.map(function() {
  this.route("post", { path: "/posts/:post_id" }, function() {
    this.route("comments", { path: "/comments" });
  });
});

export default Router;
```

If we visit a `/posts/1/comments` URL, our `Post` model will get
loaded into a `PostController`'s model, which means it is not directly
accessible in the `CommentsController`. We might however want to display
some information about it in the `comments` template.

To be able to do this we define our `CommentsController` to `need` the `PostController`
which has our desired `Post` model.

```app/controllers/comments.js
export default Ember.ArrayController.extend({
  needs: "post"
});
```

This tells Ember that our `CommentsController` should be able to access
its parent `PostController`, which can be done via `controllers.post`
(either in the template or in the controller itself). In order to get the
actual `Post` model, we need to refer to `controllers.post.model`:

```app/controllers/comments.js
export default Ember.ArrayController.extend({
  needs: "post",
  post: Ember.computed.alias("controllers.post.model")
});
```

```app/templates/comments.hbs
<h1>Comments for {{post.title}}</h1>

<ul>
  {{#each comments as |comment|}}
    <li>{{comment.text}}</li>
  {{/each}}
</ul>
```

If you want to connect multiple controllers together, you can specify an
array of controller names:

```app/controllers/overview.js
export default Ember.Controller.extend({
  needs: ['post', 'comments']
});
```

For more information about dependecy injection and `needs` in Ember.js,
see the [dependency injection guide](../../understanding-ember/dependency-injection-and-service-lookup).
For more information about aliases, see the API docs for
[aliased properties](http://emberjs.com/api/#method_computed_alias).
