Before we start writing any Ember code, let's walk through an overview of how an
Ember application works.

![ember core concepts](../../images/ember-core-concepts/ember-core-concepts.png)

## Router and Route Handlers
Imagine we are writing a web app for a site that lets users list their properties to rent. At any given time, we should be able to answer questions about the current state like _What rental are they looking at?_ and _Are they editing it?_ In Ember.js, the answer to these questions is determined by the URL.
The URL can be set in a few ways:

* The user loads the app for the first time.
* The user changes the URL manually, such as by clicking the back button or by editing the address bar.
* The user clicks a link within the app.
* Some other event in the app causes the URL to change.

No matter how the URL gets set, the first thing that happens is that the Ember router maps the URL to a route handler.

The route handler then typically does two things:

* It renders a template.
* It loads a model that is then available to the template.

## Templates

Ember.js uses templates to organize the layout of HTML in an application.

Most templates in an Ember codebase are instantly familiar, and look like any
fragment of HTML. For example:

```handlebars
<div>Hi, this is a valid Ember template!</div>
```

Ember templates use the syntax of [Handlebars](http://handlebarsjs.com)
templates. Anything that is valid Handlebars syntax is valid Ember syntax.

Templates can also display properties provided to them from their context, which is either a component or a route (technically, a controller presents the model from the route to the template, but this is rarely used in modern Ember apps and will be deprecated soon). For example:

```handlebars
<div>Hi {{name}}, this is a valid Ember template!</div>
```

Here, `{{name}}` is a property provided by the template's context.

Besides properties, double curly braces (`{{}}`) may also contain
helpers and components, which we'll discuss later.

## Models

Models represent persistent state.

For example, a property rentals application would want to save the details of a rental when a user publishes it, and so a rental would have a model defining its details, perhaps called the _rental_ model.

A model typically persists information to a web server, although models can be configured to save to anywhere else, such as the browser's Local Storage.

## Components

While templates describe how a user interface looks, components control how the user interface _behaves_.

Components consist of two parts: a template written in Handlebars, and a source file written in JavaScript that defines the component's behavior. For example, our property rental application might have a component for displaying all the rentals called `all-rentals`, and another component for displaying an individual rental called `rental-tile`. The `rental-tile` component might define a behavior that lets the user hide and show the image property of the rental.

Let's see these core concepts in action by building a property rental application in the next lesson.
