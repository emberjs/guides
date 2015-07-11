  Dependency injection and service lookup are two important framework concepts. The first, **dependency injection**, refers to a dependent object being injected onto another object during instantiation. For example, all route objects have the property `router` set on them during instantiation. We say that the dependency of the router has been injected onto the route object.

```app/routes/index.js
export default Ember.Route.extend({
  actions: {
    showPath() {
      // Dependency injection provides the router object to the route instance.
      alert(this.get('router.currentPath'));
    }
  }
});
```

Sometimes an Ember.js library will use dependency injection to expose its API to developers. An example of this is Ember-Data, which injects its store into all routes and controllers.

```app/controllers/index.js
export default Ember.Controller.extend({
  actions: {
    findItems() {
      // Dependency injection provides the store object to the controller instance.
      this.store.find('item').then((items) => {
        this.set('items', items);
      });
    }
  }
});
```

These are just two examples of how dependency injection, or DI, is used in Ember applications.

The second tool, **service lookup**, describes when a dependency is created or fetched on demand. Service lookup is the simpler pattern, and will be discussed first. Fundamentally, these two patterns share the same goals:

* Isolate responsibilities in an application
* Avoid the use of global variables and instances (important for testing)
* Allow a single object instance to represent state, but share that state with other objects.

### Lightweight Services with `Ember.inject`

A common use-case for service lookup is that of a singleton service. Often, these services will live near application state, and thus Ember provides an API that makes services easy to write.

For example, a session service can easily be made available to this index controller:

```app/services/session.js
export default Ember.Service.extend({
  isAuthenticated: false
});
```

```app/controllers/index.js
export default Ember.Controller.extend({
  session: Ember.inject.service(),
  // Using inject, the service instance will be available:
  isLoggedIn: Ember.computed.reads('session.isAuthenticated')
});
```

`Ember.inject` bases the service it injects on the name of the property is is
assigned to. If injecting a service with a different name than the property
is required, that name can be passed as an argument to `service()`.

For example, this component can take advantage of reading state from the
same singleton service instance:

```app/components/sign-in-button.js
export default Ember.Component.extend({
  sessionService: Ember.inject.service('session'),
  isLoggedIn: Ember.computed.alias('serviceService.isAuthenticated'),
  actions: {
    signIn() {
      // There is an alias to the session property, so this change propagates
      // to the session object then the IndexController.
      this.set('isLoggedIn', true);
    }
  }
});
```

The session object returned in both classes is the same.

### Services with DOM via components

Services can be combined with components to create a serivce backed with DOM.

Let's build a service that manages audio playback and makes it available to
other components.

First, we create an `audio-player` component and attach it to the DOM by using
it in the application template.

```handlebars
{{! application.hbs }}
{{audio-player}}
{{outlet}}
```

And we must create an `app/templates/components/audio-player.hbs` template to render:

```app/templates/components/audio-player.hbs
<audio id="audio" controls loop>
  <source src={{audioService.currentSrc}} type="audio/mpeg"></source>
</audio>
<div>{{audioService.currentSrc}}</div>
```

The JavaScript of this component registers itself to the service to control
play functionality.

```app/components/audio-player.js
export default Ember.Component.extend({
  audioService: Ember.inject.service('audio')
});
```

To allow other controllers to play audio, we author a service that can set
`currentSrc` to play audio:

```app/services/audio.js
export default Ember.Service.extend({
  currentSrc: null,
  selectSrc(src) {
    this.set('currentSrc', src);
  }
});
```

When another component injects the service `audio`, it has access to the same
singleton as the `audio-player` component. Those other components can call
`selectSrc` and pass a new URL to be played.

Services are a simple way to share behavior between controllers and isolate responsibilities in an application.

For a more powerful way to connect Ember.js components, let's look at **dependency injection**.

### Dependency Management in Ember.js

When an Ember application starts running, it will create and use a single instance of the
`Ember.Container` object. This container object is responsible for managing factories and the dependencies between them. At the level of the container, a factory can be any framework component. The index template is a factory with the name `template:index`, and the application route is a factory with the name `route:application`. The container understands how to use these factories (are they singleton? Should they be instantiated?) and manages their dependencies.

Factory names have two parts segmented by a `:`. The first segment is the framework component type, and the second is the name of the component requested. Hence, the `show-posts` component would be named `component:show-posts`.

If the container does not already have a requested factory, it uses a
resolver to discover that factory. The resolver is responsible for
mapping the name of `component:show-posts` to the JavaScript module
located in the filesystem at `app/components/show-posts.js`.  After
optionally adding dependencies to the requested factory, that factory is
cached and returned.

Ember's container should be viewed as an implementation detail, and is not part of the supported public API.

### Dependency Injection with `register/inject`

Instead of accessing the container directly, Ember provides an API for registering factories and managing injections on the application instance with an initializer

```app/initializers/logger.js
export function initialize(container, application) {
  var logger = {
    log(message) {
      console.log(message);
    }
  };

  application.register('logger:main', logger, { instantiate: false });
  application.inject('route', 'logger', 'logger:main');
}

export default {
  name: 'logger',
  initialize: initialize
};
```

Initializers can be declared at any time before an application is instantiated, making them easier to declare than directly registering factories on the application.

Any dependency injection is comprised of two parts. The first is the **factory registration**:

```app/initializers/logger.js
var logger = {
  log(m) {
    console.log(m);
  }
};

application.register('logger:main', logger, { instantiate: false });
```

The `register` function adds the factory (`logger`) into the container. It adds it with the full name of `logger:main`, and with the option not to instantiate. When the factory is injected onto another object, it will be injected "as-is".

Often, it is preferable to register a factory that can be instantiated:

```app/initializers/logger.js
var Logger = Ember.Object.extend({
  log(m) {
    console.log(m);
  }
});

application.register('logger:main', Logger);
```

This class will be instantiated before it is used by the container. This gives it the important benefit of being able to accept injections of its own.

The second part of dependency injection is, you guessed it, the **dependency injection**:

```app/initializers/logger.js
application.inject('route', 'logger', 'logger:main');
```

This is an example of a *type injection*. Onto all factories of the type `route` the property, `logger` will be injected with the factory named `logger:main`. Routes in this example application can now access the logger:

```app/routes/index.js
export default Ember.Route.extend({
  activate() {
    // The logger property is injected into all routes
    this.logger.log('Entered the index route!');
  }
});
```

Injections can also be made on a specific factory by using its full name:

```JavaScript
application.inject('route:index', 'logger', 'logger:main');
```

Injections can be made onto all of Ember's major framework classes including components, controllers, routes, and the router.

Dependency injection and service lookup are two powerful tools in your Ember.js toolset, and every mature Ember application will require their use.
