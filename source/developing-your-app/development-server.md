
Ember CLI comes with a bundled development server that automatically reloads your app when a file changes. Starts up the server using `ember serve`.
Default port is 4200. Use --proxy flag to proxy all ajax requests to the given address. For example ember server --proxy http://127.0.0.1:8080 will proxy all your apps XHR to your server running at port 8080.

### Mock API Responses

Ember-CLI comes with basic setup for HTTPServer using [express](http://expressjs.com/).
This simple example will help you how to get started with `express`.
`Note:This example does not use ember-data library. `

Suppose when user visits`/songs` client makes a `GET` request to the server for `fav/songs`.
Your server is not ready yet and you want to test this new route. You can easily add an route to `express` to test this new route.
`Note:/songs is a route defined on ember while /fav/songs is a route defined on express.`

To test it this is the first step as in ember everything starts with router.

```app/router.js

Router.map(function() {
  this.route('songs');

...
```

Next step could be to define a route on express which will respond with Mock data when appropriate request is made.

```server/routes/songs.js
module.exports = function(app) {
  app.get('/fav/songs', function(req, res) {
  res.json( [{"name":"Foo"},{"name":"Bar"}] );
  });
};
```

```app/adapters/RESTadapter.js
import ajax from 'ic-ajax';

var Adapter = Ember.Object.extend( {} );

Adapter.reopenClass( {
  get: function( url ) {
    return ajax( { url: url, type: 'GET' } );
  }
} );
```

```app/routes/songs.js
import Adapter from 'app/adapters/RESTadapter';

export default Ember.Route.extend( {
  model: function() {
    return Adapter.get( '/fav/songs' );
  }
```

`ember build` and then `ember server`. And now if you visit `/songs` you should see server response with appropriate json.

### Proxy API Requests

Ember CLI also allows you to forward requests to a proxy server. Set the following
properties in your `package.json`:

```package.json
{
  "APIMethod": "proxy",
  "proxyURL": "http://apiserver.dev:3000",
  "proxyPath": "/api"
}
```

This proxies all requests for a URL starting with `proxyPath` to the proxy server.
`proxyPath` defaults to `/api` when the option is not set.

So the request made in the `model` hook is forwarded to
`http://apiserver.dev:3000/api/posts`:

```js
export default Ember.Route.extend({
  model: function() {
    return ic.ajax('/api/posts');
  }
});
```
