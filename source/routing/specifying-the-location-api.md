By default the Router uses the browser's hash to load the starting state of your
application and will keep it in sync as you move around. At present, this relies
on a [hashchange](http://caniuse.com/hashchange) event existing in the browser.

Given the following router, entering `/#/posts/new` will take you to the `posts.new`
route.

```app/router.js
Router.map(function() {
  this.route('posts', function() {
    this.route('new');
  });
});
```

If you want to remove the `#/` at the beginning so that the URL is simply `/posts/new`,
you can tell the Router to use the browser's [history](http://caniuse.com/history) API.

Keep in mind that your server must serve the Ember app from all the URLs defined in your
`Router.map` function.

```app/router.js
Ember.Router.extend({
  location: 'history'
});
```

You can tell Ember to use the best location option based on browser support by
specifying `auto` for the location. Ember will then use `history` if supported
by the user's browser and fall back to `hash` otherwise.

Finally, if you don't want the browser's URL to interact with your application
at all, you can disable the location API entirely. This is useful for
testing, or when you need to manage state with your Router, but temporarily
don't want it to muck with the URL (for example when you embed your
application in a larger page).

```app/router.js
Ember.Router.extend({
  location: 'none'
});
```
