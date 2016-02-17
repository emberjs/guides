Imagine we are writing a web app for managing a blog. At any given time, we
should be able to answer questions like _What post are they looking at?_ and
_Are they editing it?_ In Ember.js, the answer to these questions is determined
by the URL.

The URL can be set in a few ways:

* The user loads the app for the first time.
* The user changes the URL manually, such as by clicking the back button or by
editing the address bar.
* The user clicks a link within the app.
* Some other event in the app causes the URL to change.

Regardless of how the URL becomes set, the Ember router then maps the current
URL to one or more route handlers. A route handler can do several things:

* It can render a template.
* It can load a model that is then available to the template.
* It can redirect to a new route, such as if the user isn't allowed to visit
that part of the app.
* It can handle actions that involve changing a model or transitioning to a new route.
