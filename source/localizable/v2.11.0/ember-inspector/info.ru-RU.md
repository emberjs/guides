To see a list of libraries used in your application, click on the `Info` menu. This view displays the libraries used, along with their version.

<img src="../../images/guides/ember-inspector/info-screenshot.png" width="680" />

### Registering a Library

If you would like to add your own application or library to the list, you can register it using:

```javascript
Ember.libraries.register(libraryName, libraryVersion);
```

#### Ember Cli

If you're using the [ember-cli-app-version](https://github.com/embersherpa/ember-cli-app-version) addon, your application's name and version will be added to the list automatically.