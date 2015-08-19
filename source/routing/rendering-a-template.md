One of the most important jobs of a route handler is rendering the
appropriate template to the screen.

By default, a route handler will render the template into the closest
parent with a template.

```app/router.js
Router.map(function() {
  this.route('post');
});
```

```app/routes/post.js
export default Ember.Route.extend();
```

If you want to render a template other than the one associated with the
route handler, implement the `renderTemplate` hook:

```app/routes/post.js
export default Ember.Route.extend({
  renderTemplate() {
    this.render('favoritePost');
  }
});
```

Ember allows you to name your outlets. For instance, this code allows
you to specify two outlets with distinct names:

```app/templates/application.hbs
<div class="toolbar">{{outlet "toolbar"}}</div>
<div class="sidebar">{{outlet "sidebar"}}</div>
```

So, if you want to render your posts into the `sidebar` outlet, use code
like this:

```app/routes/post.js
export default Ember.Route.extend({
  renderTemplate() {
    this.render({ outlet: 'sidebar' });
  }
});
```

If you want to render two different templates into outlets of two different rendered templates of a route:

```app/routes/post.js
export default Ember.Route.extend({
  renderTemplate() {
    this.render('favoritePost', {   // the template to render
      into: 'posts',                // the template to render into
      outlet: 'post',              // the name of the outlet in that template
    });
    this.render('comments', {
      into: 'favoritePost',
      outlet: 'comment',
    });
  }
});
```
