To get started with Ember.js, there are a few core concepts you
should understand.

## Templates

Templates, written in the Handlebars language, describe the user interface of
your application. In addition to plain HTML, templates can contain expressions,
like `{{title}}` or `{{author}}`, which take information from a component or
controller and put it into HTML. They can also contain helpers, such as
`{{#if isAdmin}}30 people have viewed your blog today.{{/if}}.` Finally, they
can contain components such as a template listing blog posts rendering a
component for each post.

## Components

Components are the primary way user interfaces are organized in Ember. They
consist of two parts: a template, and a source file written in JavaScript that
defines the component's behavior. For example, a blog application might have a
component for displaying a list of blog posts called `all-posts`, and another
component for displaying an individual post called `view-post`. If users can
upvote a post, the `view-post` component might define a behavior like _when the
user clicks the upvote button, increase the `vote` property's value by 1_.

## Controllers

Controllers are very much like components, so much so that in future versions of
Ember, controllers will be replaced entirely with components. At the moment,
components cannot be routed to (see below), but when this changes, it will be
recommended to replace all controllers with components.

## Models

Models represent _persistent state_. For example, a blog application would want
to save the content of a blog post when a user publishes it, and so the blog
post would have a model defining it, perhaps called the `Post` model. A model
typically persists information to a server, although models can be configured to
save to anywhere else, such as the browser's Local Storage.

## Routes

Routes load a controller and a template. They can also load one or more models
to provide data to the controller that can then be displayed by the template.
For example, an `all-posts` route might load all the blog posts from the `Post`
model, load the `all-posts` controller, and render the `all-posts` template.
Similarly, a `view-post` route might load the model for the blog post to be
shown, load the `view-post` controller, and render the `view-post` template.

## The Router

The router maps a URL to a route. For example, when a user visits the `/posts`
URL, the router might load the `all-posts` route. The router can also load
nested routes. For example, if our blogging app had a list of blog posts on the
left of the screen and then showed the current blog post on the right, we'd say
that the `view-post` route was nested inside the `all-posts` route.

Perhaps the most important thing to remember about Ember is that the URL drives
the state of the application. The URL determines what route to load, which in
turn determines what model, controller, and template to load.
