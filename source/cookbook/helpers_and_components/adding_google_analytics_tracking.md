### Problem

You want to add analytics to your Ember application.

### Solution
Subscribe to the `didTransition` event inside your application router.

In the following examples we're using Google Analytics but it could be any other analytics product.
Add google analytic's base code to the html file that renders your ember app.

```html
<html lang="en">
<head>
  <title>My Ember Site</title>
  <script type="text/javascript">

    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-XXXXX-Y', 'auto');

  </script>
</head>
<body>

</body>
</html>
```

Then reopen the application router and add this function. It will be called when
`didTransition` is fired by the router.

```app/router.js
var Router = Ember.Router.extend({
  // customization goes here
});

Router.reopen({
  notifyGoogleAnalytics: function() {
    return ga('send', 'pageview', {
        'page': this.get('url'),
        'title': this.get('url')
      });
  }.on('didTransition')
});

export default Router;
```

### Discussion

The `didTransition` event is responsible for notifying listeners of any URL
changes, in this example we are getting the path after the hash in the url so we
can notify Google Analytics about moving between areas of the site.


<!--[JSBin Example](http://jsbin.com/xebevu)-->
