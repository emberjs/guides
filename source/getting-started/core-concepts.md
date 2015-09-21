Ember.js is a big framework with a large API surface. Learning a few core
concepts will help you be successful understanding more detailed sections of
the guides.

## Templates

Ember.js uses templates to organize the layout of HTML in an application. Most
templates in an Ember codebase are instantly familiar, and look like any
fragment of HTML. For example:

```handlebars
<div>Hi, this is a valid Ember template!</div>
```

Ember templates use the syntax of [Handlebars](http://handlebarsjs.com)
templates. Anything that is valid Handlebars syntax is valid Ember syntax.

Each template has a context, and properties you access are read off that context.
For example this template shows a welcome message with a name:

```handlebars
<div>Hi {{name}}, this is a valid Ember template!</div>
```

The Handlebars expression `{{name}}` refers to a bound property.
Besides properties, double curly braces (`{{}}`) may also contain
helpers and components.

## Components

Components are the primary way user interfaces are organized in Ember. They
consist of two parts:

* A template, for example `app/templates/components/welcome-message.hbs`
* Optionally a source file written in JavaScript, for example
  `app/components/welcome-message.js`.
* **Components must contain a - in their name**. More about that later.

Components differ from helpers in that they can output not only a value, but
also manage DOM. An important property of components is that they are **isolated**.
For example, a component's DOM is called "shadow" DOM.

In this example, a component's template adds a div around some other DOM:

```app/templates/components/my-component.hbs
<div class="inner">
  {{yield}}
</div>
```

```handlebars
<span>Hello</span>
<div class="outer">
  {{#my-component}}
    Hello there!
  {{/my-component}}
</div>
```

Because components deal with DOM, they are also responsible for maintaining
the bulk of an application's state. Additionally they handle events like
clicks, keyUp, and other more semantic actions.

## The Router and Routes

The router maps a URL to a template. For example, when a user visits the `/posts`
URL, a configured router may load the `posts` route and template. The router can also load
nested routes. For example, if a blogging app had a list of blog posts on the
left of the screen and showed the current blog post on the right, we'd say
that the `posts/show` route was nested inside the `posts` route.

Perhaps the most important thing to remember about Ember is that **the URL drives
the application state**. URLs determine what template and route to load, and
that in turn determines what model must be fetched.

Ember routes are classes responsible for describing the entrance and exit to
a specific URL path. For example, a route class may decide what data to load before
a route is rendered, or cancel navigation away from a route if a form is
unsaved.

## Models

Models represent persistent state. For example, a blog application would
persist the content of a blog post when a user publishes it. A blog post model
would represent the state of that persisted content (such as the post itself,
the title, and the author).

The data backing a model
is typically persisted to a server via AJAX, although models can be configured
to persist anywhere. For example, some applications will save data to
the localStorage API, or to IndexedDB.

When visiting a URL, Ember attempts to be smart about what models should be
loaded. For example, if you visit the `/posts/the-viral-one` URL Ember will
fetch a `Post` with the id `the-viral-one`.
