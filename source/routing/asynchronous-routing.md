This section covers some more advanced features of the router and its
capability for handling complex async logic within your app.

### A Word on Promises...

Ember's approach to handling asynchronous logic in the router makes
heavy use of the concept of Promises. In short, promises are objects that
represent an eventual value. A promise can either _fulfill_
(successfully resolve the value) or _reject_ (fail to resolve the
value). The way to retrieve this eventual value, or handle the cases
when the promise rejects, is via the promise's [`then()`](https://www.emberjs.com/api/ember/release/classes/Promise/methods/then?anchor=then) method, which
accepts two optional callbacks, one for fulfillment and one for
rejection. If the promise fulfills, the fulfillment handler gets called
with the fulfilled value as its sole argument, and if the promise rejects,
the rejection handler gets called with a reason for the rejection as its
sole argument. For example:


```js
let promise = fetchTheAnswer();

promise.then(fulfill, reject);

function fulfill(answer) {
  console.log(`The answer is ${answer}`);
}

function reject(reason) {
  console.log(`Couldn't get the answer! Reason: ${reason}`);
}
```

Much of the power of promises comes from the fact that they can be
chained together to perform sequential asynchronous operations:

```js
// Note: jQuery AJAX methods return promises
let usernamesPromise = Ember.$.getJSON('/usernames.json');

usernamesPromise.then(fetchPhotosOfUsers)
                .then(applyInstagramFilters)
                .then(uploadTrendyPhotoAlbum)
                .then(displaySuccessMessage, handleErrors);
```

In the above example, if any of the methods
`fetchPhotosOfUsers`, `applyInstagramFilters`, or
`uploadTrendyPhotoAlbum` returns a promise that rejects,
`handleErrors` will be called with
the reason for the failure. In this manner, promises approximate an
asynchronous form of try-catch statements that prevent the rightward
flow of nested callback after nested callback and facilitate a saner
approach to managing complex asynchronous logic in your applications.

This guide doesn't intend to fully delve into all the different ways
promises can be used, but if you'd like a more thorough introduction,
take a look at the readme for [RSVP](https://github.com/tildeio/rsvp.js),
the promise library that Ember uses.

### The Router Pauses for Promises

When transitioning between routes, the Ember router collects all of the
models (via the `model` hook) that will be passed to the route's
controllers at the end of the transition. If the `model` hook (or the related
`beforeModel` or `afterModel` hooks) return normal (non-promise) objects or
arrays, the transition will complete immediately. But if the `model` hook
(or the related `beforeModel` or `afterModel` hooks) returns a promise (or
if a promise was provided as an argument to `transitionTo`), the transition
will pause until that promise fulfills or rejects.

The router considers any object with a `then()` method
defined on it to be a promise.

If the promise fulfills, the transition will pick up where it left off and
begin resolving the next (child) route's model, pausing if it too is a
promise, and so on, until all destination route models have been
resolved. The values passed to the [`setupController()`](https://www.emberjs.com/api/ember/release/classes/Route/methods/setupController?anchor=setupController) hook for each route
will be the fulfilled values from the promises.


A basic example:

```app/routes/tardy.js
import Route from '@ember/routing/route';
import RSVP from 'rsvp';
import { later } from '@ember/runloop';

export default Route.extend({
  model() {
    return new RSVP.Promise(function(resolve) {
      later(function() {
        resolve({ msg: 'Hold Your Horses' });
      }, 3000);
    });
  },

  setupController(controller, model) {
    console.log(model.msg); // "Hold Your Horses"
  }
});
```

When transitioning into `route:tardy`, the `model()` hook will be called and
return a promise that won't resolve until 3 seconds later, during which time
the router will be paused in mid-transition. When the promise eventually
fulfills, the router will continue transitioning and eventually call
`route:tardy`'s `setupController()` hook with the resolved object.

This pause-on-promise behavior is extremely valuable for when you need
to guarantee that a route's data has fully loaded before displaying a
new template.

### When Promises Reject...

We've covered the case when a model promise fulfills, but what if it rejects?

By default, if a model promise rejects during a transition, the transition is
aborted, no new destination route templates are rendered, and an error
is logged to the console.

You can configure this error-handling logic via the `error` handler on
the route's `actions` hash. When a promise rejects, an `error` event
will be fired on that route and bubble up to `route:application`'s
default error handler unless it is handled by a custom error handler
along the way, e.g.:

```app/routes/good-for-nothing.js
import Route from '@ember/routing/route';
import RSVP from 'rsvp';

export default Route.extend({
  model() {
    return RSVP.reject("FAIL");
  },

  actions: {
    error(reason) {
      alert(reason); // "FAIL"

      // Can transition to another route here, e.g.
      // this.transitionTo('index');

      // Uncomment the line below to bubble this error event:
      // return true;
    }
  }
});
```

In the above example, the error event would stop right at
`route:good-for-nothing`'s error handler and not continue to bubble. To
make the event continue bubbling up to `route:application`, you can
return true from the error handler.

### Recovering from Rejection

Rejected model promises halt transitions, but because promises are chainable,
you can catch promise rejects within the `model` hook itself and convert
them into fulfills that won't halt the transition.

```app/routes/funky.js
import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    return iHopeThisWorks().catch(function() {
      // Promise rejected, fulfill with some default value to
      // use as the route's model and continue on with the transition
      return { msg: 'Recovered from rejected promise' };
    });
  }
});
```
