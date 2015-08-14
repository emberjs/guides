### Representing Several Records

The model of a controller can represent several records as well as a single
one. Here, our route's `model` hook returns an array of songs:

```app/routes/songs.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('song');
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
    let longSongs = songs.filter(song => song.get('duration') > 30);
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

### Representing Several Models

Multiple models can be returned through `Ember.RSVP.hash`. We can return a hash from the `model` hook, but `Ember.RSVP.hash` takes parameters that return promises and when all parameter promises resolve then the `Ember.RSVP.hash` promise resolves. To continue with the above example, if we also wanted to return the `model:album` records then our `model` hook would look like:

```app/routes/songs.js
export default Ember.Route.extend({
  model() {
    return Ember.RSVP.hash({
      songs: this.store.findAll('song'),
      albums: this.store.findAll('album')
    });
  }
});
```

The controller with the computed property is:

```app/controllers/songs.js
export default Ember.Controller.extend({
  longSongCount: Ember.computed('model.songs.@each.duration', function() {
    let songs = this.get('model.songs');
    let longSongs = songs.filter(song => song.get('duration') > 30);
    return longSongs.get('length');
  }),
  largeAlbumCount: Ember.computed('model.albums.@each.duration', function() {
    let albums = this.get('model.albums');
    let largeAlbums = albums.filter(album => album.get('size') > 8);
    return largeAlbums.get('length');
  })
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

{{longSongCount}} songs over 30 seconds.

<h1>Albums</h1>

<ul>
  {{#each model.albums as |album|}}
    <li>{{album.title}} by {{album.artist}}</li>
  {{/each}}
</ul>

{{largeAlbumCount}} albums over 8 songs.
```
