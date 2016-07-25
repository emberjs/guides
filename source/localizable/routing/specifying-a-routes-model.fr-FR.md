Often, you'll want a template to display data from a model. Loading the appropriate model is one job of a route.

For example, take this router:

```app/router.js Router.map(function() { this.route('favorite-posts'); });

    <br />To load a model for the `favorite-posts` route, you would use the [`model()`][1]
    hook in the `favorite-posts` route handler:
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#method_model
    
    ```app/routes/favorite-posts.js
    export default Ember.Route.extend({
      model() {
        return this.get('store').query('post', { favorite: true });
      }
    });
    

Typically, the `model` hook should return an [Ember Data](../../models/) record, but it can also return any [promise](https://www.promisejs.org/) object (Ember Data records are promises), or a plain JavaScript object or array. Ember will wait until the data finishes loading (until the promise is resolved) before rendering the template.

The route will then set the return value from the `model` hook as the `model` property of the controller. You will then be able to access the controller's `model` property in your template:

```app/templates/favorite-posts.hbs 

# Favorite Posts {{#each model as |post|}} 

{{post.body}} {{/each}}

    <br />## Dynamic Models
    
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
    

```app/routes/photo.js export default Ember.Route.extend({ model(params) { return this.get('store').findRecord('photo', params.photo_id); } });

    <br />In the `model` hook for routes with dynamic segments, it's your job to
    turn the ID (something like `47` or `post-slug`) into a model that can
    be rendered by the route's template. In the above example, we use the
    photo's ID (`params.photo_id`) as an argument to Ember Data's `findRecord`
    method.
    
    Note: A route with a dynamic segment will only have its `model` hook called
    when it is entered via the URL. If the route is entered through a transition
    (e.g. when using the [link-to](../../templates/links) Handlebars helper), then a model context is
    already provided and the hook is not executed. Routes without dynamic segments
    will always execute the model hook.
    
    ## Multiple Models
    
    Multiple models can be returned through an
    [Ember.RSVP.hash](http://emberjs.com/api/classes/RSVP.html#method_hash).
    The `Ember.RSVP.hash` takes
    parameters that return promises, and when all parameter promises resolve, then
    the `Ember.RSVP.hash` promise resolves. For example:
    
    ```app/routes/songs.js
    export default Ember.Route.extend({
      model() {
        return Ember.RSVP.hash({
          songs: this.get('store').findAll('song'),
          albums: this.get('store').findAll('album')
        });
      }
    });
    

In the `songs` template, we can specify both models and use the `{{#each}}` helper to display each record in the song model and album model:

```app/templates/songs.hbs 

# Playlist

{{#each model.songs as |song|}} 

- {{song.name}} by {{song.artist}} {{/each}} 

# Albums

{{#each model.albums as |album|}} 

- {{album.title}} by {{album.artist}} {{/each}}  ```