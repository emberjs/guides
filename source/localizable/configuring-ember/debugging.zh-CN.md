Ember provides several configuration options that can help you debug problems with your application.

## Routing

#### Log router transitions

```app/app.js import Ember from 'ember';

export default Ember.Application.extend({ // Basic logging, e.g. "Transitioned into 'post'" LOG_TRANSITIONS: true,

// Extremely detailed logging, highlighting every internal // step made while transitioning into a route, including // `beforeModel`, `model`, and `afterModel` hooks, and // information about redirects and aborted transitions LOG_TRANSITIONS_INTERNAL: true });

    ## Views / Templates
    
    #### Log view lookups
    
    ```config/environment.js
    ENV.APP.LOG_VIEW_LOOKUPS = true;
    

#### View all registered templates

```javascript
Ember.keys(Ember.TEMPLATES)
```

## Controllers

#### Log generated controller

```config/environment.js ENV.APP.LOG_ACTIVE_GENERATION = true;

    <br />## Observers / Binding
    
    #### See all observers for an object, key
    
    ```javascript
    Ember.observersFor(comments, keyName);
    

#### Log object bindings

```config/environments.js ENV.APP.LOG_BINDINGS = true

    <br />## Miscellaneous
    
    #### Turn on resolver resolution logging
    
    This option logs all the lookups that are done to the console. Custom objects
    you've created yourself have a tick, and Ember generated ones don't.
    
    It's useful for understanding which objects Ember is finding when it does a lookup
    and which it is generating automatically for you.
    
    ```app/app.js
    import Ember from 'ember';
    
    export default Ember.Application.extend({
      LOG_RESOLVER: true
    });
    

#### Dealing with deprecations

```javascript
Ember.ENV.RAISE_ON_DEPRECATION = true
Ember.ENV.LOG_STACKTRACE_ON_DEPRECATION = true
```

#### Implement an Ember.onerror hook to log all errors in production

```javascript
Ember.onerror = function(error) {
  Ember.$.ajax('/error-notification', {
    type: 'POST',
    data: {
      stack: error.stack,
      otherInformation: 'exception message'
    }
  });
}
```

#### Import the console

If you are using imports with Ember, be sure to import the console:

```javascript
Ember = {
  imports: {
    Handlebars: Handlebars,
    jQuery: $,
    console: window.console
  }
};
```

#### Errors within an `RSVP.Promise`

There are times when dealing with promises that it seems like any errors are being 'swallowed', and not properly raised. This makes it extremely difficult to track down where a given issue is coming from. Thankfully, `RSVP` has a solution for this problem built in.

You can provide an `onerror` function that will be called with the error details if any errors occur within your promise. This function can be anything, but a common practice is to call `console.assert` to dump the error to the console.

```app/app.js import Ember from 'ember'; import RSVP from 'rsvp';

RSVP.on('error', function(error) { Ember.assert(false, error); });

    <br />#### Errors within `Ember.run.later` ([Backburner.js](https://github.com/ebryn/backburner.js))
    
    Backburner has support for stitching the stacktraces together so that you can
    track down where an erroring `Ember.run.later` is being initiated from. Unfortunately,
    this is quite slow and is not appropriate for production or even normal development.
    
    To enable this mode you can set:
    
    ```javascript
    Ember.run.backburner.DEBUG = true;
