Sometimes, especially when nesting resources, we find ourselves needing
to have some kind of connection between two controllers. Let's take this
router as an example:

```app/router.js
Router.map(function() {
  this.route('post', { path: '/posts/:post_id' }, function() {
    this.route('comments', { path: '/comments' });
  });
});
```

If we visit a `/posts/1/comments` URL, our `Post` model will get
loaded into a `PostController`'s model, which means it is not directly
accessible in the `CommentsController`. We might however want to display
some information about it in the `comments` template.

To be able to do this we inject the `PostController` into the
`CommentsController` (which has the desired `Post` model).

```app/controllers/comments.js
export default Ember.Controller.extend({
  postController: Ember.inject.controller('post')
});
```

Once comments has access to the `PostController`, a read-only alias can be
used to read the model from that controller. In order to get the
`Post` model, we refer to `postController.model`:

```app/controllers/comments.js
export default Ember.Controller.extend({
  postController: Ember.inject.controller('post'),
  post: Ember.computed.reads('postController.model')
});
```

```app/templates/comments.hbs
<h1>Comments for {{post.title}}</h1>

<ul>
  {{#each model as |comment|}}
    <li>{{comment.text}}</li>
  {{/each}}
</ul>
```

For more information about aliases, see the API docs for
[aliased properties](http://emberjs.com/api/#method_computed_alias). If you need have more extensive "data sharing" needs across your app, see the [services page](../../services/), which largely replaces injected controllers.
