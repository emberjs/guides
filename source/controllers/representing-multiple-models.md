The model of a controller can represent several records as well as a single
one. Here we will customize the default routing logic and set the `model`
property in a route's `setupController` method.

In our route, we setup our `SongsController` to represent the songs in a
playlist:

```app/routes/songs.js
export default Ember.Route.extend({
  setupController(controller, playlist) {
    controller.set('model', playlist.get('songs'));
  }
});
```

In the `songs` template, we can use the `{{#each}}` helper to display
each song:

```app/templates/songs.hbs
<h1>Playlist</h1>

<ul>
  {{#each model as |song|}}
    <li>{{song.name}} by {{song.artist}}</li>
  {{/each}}
</ul>
```

You can use the controller to collect aggregate information about
the model it hosts. For example, imagine we want to display the
number of songs that are over 30 seconds long. We can add a new computed
property called `longSongCount` to the controller:

```app/controllers/songs.js
export default Ember.Controller.extend({
  longSongCount: Ember.computed('model.@each.duration', function() {
    let songs = this.get('model');
    let longSongs = songs.filter((song) => {
      return song.get('duration') > 30;
    });
    return longSongs.get('length');
  })
});
```

Now we can use this property in our template:

```app/templates/songs.hbs
<ul>
  {{#each model as |song|}}
    <li>{{song.name}} by {{song.artist}}</li>
  {{/each}}
</ul>

{{longSongCount}} songs over 30 seconds.
```
