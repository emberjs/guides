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

```app/app.js
export default Ember.Application.extend({
  rootElement: '#app'
});
```

This property can be specified as either an element or a
[jQuery-compatible selector
string](http://api.jquery.com/category/selectors/).

### Disabling URL Management

You can prevent Ember from making changes to the URL by [changing the
router's `location`](../specifying-url-type) to
`none`:

```config/environment.js
var ENV = {
  locationType: 'none'
};
```

### Specifying a Root URL

If your Ember application is one of multiple web applications served from the same domain, it may be necessary to indicate to the router what the root URL for your Ember application is. By default, Ember will assume it is served from the root of your domain.

For example, if you wanted to serve your blogging application from `http://emberjs.com/blog/`, it would be necessary to specify a root URL of `/blog/`.

This can be achieved by setting the `rootURL` on the router:

```app/router.js
Ember.Router.extend({
  rootURL: '/blog/'
});
```
