Before moving to more focused topics, it is important to review several
high-level Ember.js concepts.

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

The mustache of this template (the `{{}}`) refers to some dynamic content.
Besides properties, you can also use helpers and components inside a mustache.

## Helpers

Ember Helpers are another way to generate a value in templates. A helper
is a piece of logic that returns a single value (much like a property
has only a single value).

For example, this helper and accompanying usage create a full name:

```app/helpers/full-name.js
import Ember from 'ember';

export default Ember.Helper.helper(function([firstName, lastName]) {
  return `Mrs. ${firstName} ${secondName}`;
});
```

```handlebars
{{full-name firstName "Doe"}}
```

You can read more about helpers in [this API documentation](http://emberjs.com/api/classes/Ember.Helper.html).

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
clicks, keyUp, and other more semtantic actions.

## The Router

The router maps a URL to a template. For example, when a user visits the `/posts`
URL, a configured router may load the `posts` route and template. The router can also load
nested routes. For example, if a blogging app had a list of blog posts on the
left of the screen and showed the current blog post on the right, we'd say
that the `posts/show` route was nested inside the `posts` route.

Perhaps the most important thing to remember about Ember is that **the URL drives
the application state**. URLs determine what template and route to load, and
that in turn determines what model must be fetched.

## Models

Models represent persistent state. For example, a blog application would
persist the content of a blog post when a user publishes it. A blog post model
would represent the state of that persisted content (such as the post itself,
the title, and the author).

A model
typically persists information to a server, although models can be configured to
save to anywhere. For example to the localStorage API, or IndexedDB.

When visiting a URL, Ember attempts to be smart about what models should be
loaded. For example, if you visit the `/posts` URL an index of all existing
`Post` models will be fetched.

## Routes

When Ember's default data loading intuition is insufficient, routes come
into play.

Routes load one or more models
to provide data to a controller, and to a corresponding template.
For example, the `posts` route will load all `Post` models and render the
`app/templates/posts.hbs` template. To load a subset of posts, such as only
one page, a custom route would be appropriate.
