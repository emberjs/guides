## Creating an Application
Every Ember.js application has one instance of `Ember.Application`.
This object is located at `./app/app.js` inside your application.

What does creating an `Ember.Application` instance get you?

1. It adds event listeners to the document and is responsible for
   delegating events to your views. (See [The View
   Layer](../understanding-ember/the-view-layer)
  for a detailed description.)
1. It automatically renders the [application
   template](../templates/the-application-template).
1. It automatically creates a router and begins routing, choosing which
   template and model to display based on the current URL.
