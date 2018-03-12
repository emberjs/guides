Often, you'll want a template to display data from a model. Loading the
appropriate model is one job of a route.

For example, take this router:

```app/router.js
Router.map(function() {
  this.route('favorite-posts');
});
```

To load a model for the `favorite-posts` route, you would use the [`model()`](https://www.emberjs.com/api/ember/release/classes/Route/methods/model?anchor=model)
hook in the `favorite-posts` route handler:

```app/routes/favorite-posts.js
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    return this.get('store').query('post', { favorite: true });
  }
});
```

Typically, the `model` [hook](../../getting-started/core-concepts/#toc_hooks) should return an [Ember Data](../../models/) record,
but it can also return any [promise](https://www.promisejs.org/) object (Ember Data records are promises),
or a plain JavaScript object or array.
Ember will wait until the data finishes loading (until the promise is resolved) before rendering the template.

The route will then set the return value from the `model` hook as the `model` property of the controller.
You will then be able to access the controller's `model` property in your template:

```app/templates/favorite-posts.hbs
<h1>Favorite Posts</h1>
{{#each model as |post|}}
  <p>{{post.body}}</p>
{{/each}}
```

## Dynamic Models

Some routes always display the same model. For example, the `/photos`
route will always display the same list of photos available in the
application. If your user leaves this route and comes back later, the
model does not change.

However, you will often have a route whose model will change depending
on user interaction. For example, imagine a photo viewer app. The
`/photos` route will render the `photos` template with the list of
photos as the model, which never changes. But when the user clicks on a
particular photo, we want to display that model with the `photo`
template. If the user goes back and clicks on a different photo, we want
to display the `photo` template again, this time with a different model.

In cases like this, it's important that we include some information in
the URL about not only which template to display, but also which model.

In Ember, this is accomplished by defining routes with [dynamic
segments](../defining-your-routes/#toc_dynamic-segments).

Once you have defined a route with a dynamic segment,
Ember will extract the value of the dynamic segment from the URL for
you and pass them as a hash to the `model` hook as the first argument:

```app/router.js
Router.map(function() {
  this.route('photo', { path: '/photos/:photo_id' });
});
```

```app/routes/photo.js
import Route from '@ember/routing/route';

export default Route.extend({
  model(params) {
    return this.get('store').findRecord('photo', params.photo_id);
  }
});
```

In the `model` hook for routes with dynamic segments, it's your job to
turn the ID (something like `47` or `post-slug`) into a model that can
be rendered by the route's template. In the above example, we use the
photo's ID (`params.photo_id`) as an argument to Ember Data's `findRecord`
method.

Note: A route with a dynamic segment will always have its `model` hook called when it is entered via the URL.
If the route is entered through a transition (e.g. when using the [link-to](../../templates/links) Handlebars helper),
and a model context is provided (second argument to `link-to`), then the hook is not executed.
If an identifier (such as an id or slug) is provided instead then the model hook will be executed.

For example, transitioning to the `photo` route this way won't cause the `model` hook to be executed (because `link-to`
was passed a model):

```app/templates/photos.hbs
<h1>Photos</h1>
{{#each model as |photo|}}
  <p>
    {{#link-to "photo" photo}}
      <img src="{{photo.thumbnailUrl}}" alt="{{photo.title}}" />
    {{/link-to}}
  </p>
{{/each}}
```

while transitioning this way will cause the `model` hook to be executed (because `link-to` was passed `photo.id`, an
identifier, instead):

```app/templates/photos.hbs
<h1>Photos</h1>
{{#each model as |photo|}}
  <p>
    {{#link-to "photo" photo.id}}
      <img src="{{photo.thumbnailUrl}}" alt="{{photo.title}}" />
    {{/link-to}}
  </p>
{{/each}}
```

Routes without dynamic segments will always execute the model hook.

## Multiple Models

Multiple models can be returned through an
[RSVP.hash](https://www.emberjs.com/api/ember/release/classes/rsvp/methods/hash?anchor=hash).
The `RSVP.hash` method takes an object with promises or values as properties as an argument, and returns a single promise.
When all of the promises in the object resolve, the returned promise will resolve with an object of all of the promise values. For example:

```app/routes/songs.js
import Route from '@ember/routing/route';
import RSVP from 'rsvp';

export default Route.extend({
  model() {
    return RSVP.hash({
      songs: this.get('store').findAll('song'),
      albums: this.get('store').findAll('album')
    });
  }
});
```

In the `songs` template, we can specify both models and use the `{{#each}}` helper to display
each record in the song model and album model:

```app/templates/songs.hbs
<h1>Playlist</h1>

<ul>
  {{#each model.songs as |song|}}
    <li>{{song.name}} by {{song.artist}}</li>
  {{/each}}
</ul>

<h1>Albums</h1>

<ul>
  {{#each model.albums as |album|}}
    <li>{{album.title}} by {{album.artist}}</li>
  {{/each}}
</ul>
```

If you use [Ember Data](../../models/) and you are building an `RSVP.hash` with the model's relationship, consider instead properly setting up your [relationships](../../models/relationships) and letting Ember Data take care of loading them.

## Reusing Route Context

Sometimes you need to fetch a model, but your route doesn't have the parameters, because it's
a child route and the route directly above or a few levels above has the parameters that your route
needs.

In this scenario, you can use the `paramsFor` method to get the parameters of a parent route.

```app/routes/album/index.js
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    let { album_id } = this.paramsFor('album');

    return this.store.query('song', { album: album_id });
  }
});
```

This is guaranteed to work because the parent route is loaded. But if you tried to
do `paramsFor` on a sibling route, you wouldn't have the results you expected.

This is a great way to use the parent context to load something that you want.
Using `paramsFor` will also give you the query params defined on that route's controller.
This method could also be used to look up the current route's parameters from an action
or another method on the route, and in that case we have a shortcut: `this.paramsFor(this.routeName)`.

In our case, the parent route had already loaded its songs, so we would be writing unnecessary fetching logic.
Let's rewrite the same route, but use `modelFor`, which works the same way, but returns the model
from the parent route.

```app/routes/album/index.js
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    let { songs } = this.modelFor('album');

    return songs;
  }
});
```

In the case above, the parent route looked something like this:

```app/routes/album.js
import Route from '@ember/routing/route';
import RSVP from 'rsvp';

export default Route.extend({
  model({ album_id }) {
    return RSVP.hash({
      album: this.store.findRecord('album', album_id),
      songs: this.store.query('songs', { album: album_id })
    });
  }
});
```

And calling `modelFor` returned the result of the `model` hook.
