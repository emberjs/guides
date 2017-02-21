The Ember router has four options to manage your application's URL: `history`, which uses the HTML5 History API; `hash`, which uses anchor-based URLs; `auto`, which uses `history` if supported by the user's browser, and falls back to `hash` otherwise; and `none`, which doesn't update the URL. By default, Ember CLI configures the router to use `auto`. You can change this option in `config/environment.js` under `ENV.locationType`.

## history

When using `history`, Ember uses the browser's [history](http://caniuse.com/history) API to produce URLs with a structure like `/posts/new`.

Given the following router, entering `/posts/new` will take you to the `posts.new` route.

    app/router.js
    Router.map(function() {
      this.route('posts', function() {
        this.route('new');
      });
    });

Keep in mind that your server must serve the Ember app from all the URLs defined in your `Router.map` function. In other words, if your user directly navigates to `/posts/new`, your server must be configured to serve your Ember app in response.

## hash

The `hash` option uses the URL's anchor to load the starting state of your application and will keep it in sync as you move around. At present, this relies on a [hashchange](http://caniuse.com/hashchange) event existing in the browser.

In the router example above, entering `/#/posts/new` will take you to the `posts.new` route.

## none

Finally, if you don't want the browser's URL to interact with your application at all, you can disable the location API entirely by setting `ENV.locationType` to `none`. This is useful for testing, or when you don't want Ember to muck with the URL (for example when you embed your application in a larger page).