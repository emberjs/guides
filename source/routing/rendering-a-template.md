One job of a route handler is rendering the appropriate template to the screen.

By default, a route handler will render the template with the same name as the
route. Take this router:

```app/router.js
Router.map(function() {
  this.route('posts', function() {
    this.route('new');
  });
});
```

Here, the `posts` route will render the `posts.hbs` template, and
the `posts.new` route will render `posts/new.hbs`.

Each template will be rendered into the `{{outlet}}` of its parent route's
template. For example, the `posts.new` route will render its template into the
`posts.hbs`'s `{{outlet}}`, and the `posts` route will render its template into
the `application.hbs`'s `{{outlet}}`.

If you want to render a template other than the default one, set the route's [`templateName`](https://www.emberjs.com/api/ember/release/classes/Route/properties/templateName?anchor=templateName) property to the name of
the template you want to render instead.

```app/routes/posts.js
import Route from '@ember/routing/route';

export default Route.extend({
  templateName: 'posts/favorite-posts'
});
```

You can override the [`renderTemplate()`](https://www.emberjs.com/api/ember/release/classes/Route/methods/renderTemplate?anchor=renderTemplate) hook if you want finer control over template rendering.
Among other things, it allows you to choose the controller used to configure the template and specific outlet to render it into.
