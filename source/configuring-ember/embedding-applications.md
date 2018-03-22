In most cases, your application's entire UI will be created by templates
that are managed by the router.

But what if you have an Ember.js app that you need to embed into an
existing page, or run alongside other JavaScript frameworks, or serve from the
same domain as another app?

### Changing the Root Element

By default, your application will render the [application template](../../routing/defining-your-routes/#toc_the-application-route)
and attach it to the document's `body` element.

You can tell the application to append the application template to a
different element by specifying its `rootElement` property:

```app/app.js{+4}
…

App = Ember.Application.extend({
  rootElement: '#app',
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver
});

…
```

This property can be specified as either an element or a
[jQuery-compatible selector
string](http://api.jquery.com/category/selectors/).

### Disabling URL Management

You can prevent Ember from making changes to the URL by [changing the
router's `location`](../specifying-url-type) to
`none`:

```config/environment.js{-8,+9}
/* eslint-env node */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'my-blog',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',
    locationType: 'none',
    …
  };

  …

  return ENV;
}
```

### Specifying a Root URL

If your Ember application is one of multiple web applications served from the same domain, it may be necessary to indicate to the router what the root URL for your Ember application is. By default, Ember will assume it is served from the root of your domain.

For example, if you wanted to serve your blogging application from `http://emberjs.com/blog/`, it would be necessary to specify a root URL of `/blog/`.

This can be achieved by configuring the `rootURL` property on `ENV`:

```config/environment.js{-7,+8}
/* eslint-env node */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'my-blog',
    environment: environment,
    rootURL: '/',
    rootURL: '/blog/',
    locationType: 'auto',
    …
  };
}
```

You will notice that this is then used to configure your application's router:

```app/router.js
import Router from '@ember/routing/router';
import config from './config/environment';

const Router = Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
});

export default Router;
```
