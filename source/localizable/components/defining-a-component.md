A component is a section of content defined independently from the page context in which it appears, allowing it to be reused in multiple places, e.g. on multiple pages, in multiple places within a page,
or even in multiple applications.

To define a component, run:

```shell
ember generate component my-component-name
```

Components must have at least one dash in their name. So `blog-post` is an acceptable
name, and so is `audio-player-controls`, but `post` is not. This prevents clashes with
current or future HTML element names, aligns Ember components with the W3C [Custom
Elements](https://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/custom/index.html)
spec, and ensures Ember detects the components automatically.

A component consists of both a handlebars template and a javascript file that defines a subclass of [`Ember.Component`][1] specific to the component.
The `ember generate component` command above will create skeleton files for both of these.
The `Ember.Component` subclass that is created allows you to customize the behavior of the component,
for example by defining actions to respond to browser events as discussed previously in [Templates - Actions](../../templates/actions).
Ember knows which subclass powers a component based on its filename.
For example, if you have a component called `blog-post`,
it would look for the subclass definition in a file `app/components/blog-post.js`.

[1]: http://emberjs.com/api/classes/Ember.Component.html

In the simplest case, a component's template could consist of just static HTML. For example:

```app/templates/components/main-menu.hbs
<ul>
  <li><a href='/about'>About</a></li>
  <li><a href='/contact'>Contact</a></li>
</ul>
```

The component can then be inserted wherever it is required using the notation `{{...}}`:

```app/templates/index.hbs
  {{main-menu}}

  <!-- additional content... -->
```
More often though, you will want the content rendered by the component to depend on the context in which it is used.
One way to do this is by passing properties to the component when it is invoked. Consider, for example,
a ` blog-post` component defined like this:

```app/templates/components/blog-post.hbs
<article class="blog-post">
  <h1>{{title}}</h1>
  <p>{{body}}</p>
</article>
```
Here `{{title}}` and `{{body}}` represent properties passed to the component from the template in which it appears, for example like this:

```app/templates/index.hbs
{{#each model as |post|}}
  {{blog-post title=post.title body=post.body}}
{{/each}}
```

The model is populated by the `model` hook in the route handler:

```app/routes/index.js
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.get('store').findAll('post');
  }
});
```
Note that the properties passed to the component stay in sync (technically known as being "bound").
For example, if the value of `title` in the `blog-post` component described above changes inside the component,
the value of `post.title` in the containing template will be updated to reflect that change.
The reverse is true as well.

Each component, under the hood, is backed by an element. By default
Ember will use a `<div>` element to contain your component's template.
To learn how to change the element Ember uses for your component, see
[Customizing a Component's
Element](../customizing-a-components-element).

## Positional Parameters

In addition to passing parameters in by name, you can pass them in by position.
In other words, you can invoke the above component example like this:

```app/templates/index.hbs
{{#each model as |post|}}
  {{blog-post post.title post.body}}
{{/each}}
```

To set the component up to receive parameters this way, you need
set the [`positionalParams`][2] attribute in your component class.

[2]: http://emberjs.com/api/classes/Ember.Component.html#property_positionalParams

```app/components/blog-post.js
import Ember from 'ember';

const BlogPostComponent = Ember.Component.extend({});

BlogPostComponent.reopenClass({
  positionalParams: ['title', 'body']
});

export default BlogPostComponent;
```

Then you can use the attributes in the component exactly as if they had been
passed in like `{{blog-post title=post.title body=post.body}}`.

Notice that the `positionalParams` property is added to the class as a
static variable via `reopenClass`. Positional parameters are always declared on
the component class and cannot be changed while an application runs.

Alternatively, you can accept an arbitrary number of parameters by
setting `positionalParams` to a string, e.g. `positionalParams: 'params'`. This
will allow you to access the parameters as an array like so:

```app/components/blog-post.js
import Ember from 'ember';

const BlogPostComponent = Ember.Component.extend({
  title: Ember.computed('params.[]', function(){
    return this.get('params')[0];
  }),
  body: Ember.computed('params.[]', function(){
    return this.get('params')[1];
  })
});

BlogPostComponent.reopenClass({
  positionalParams: 'params'
});

export default BlogPostComponent;
```

## Dynamically Rendering a Component

The [`{{component}}`][2] helper can be used to defer the selection of a component to
run time. The `{{my-component}}` syntax always renders the same component,
while using the `{{component}}` helper allows choosing a component to render on
the fly. This is useful in cases where you want to interact with different
external libraries depending on the data. Using the `{{component}}` helper would
allow you to keep different logic well separated.

The first parameter of the helper is the name of a component to render, as a string.
So `{{component 'blog-post'}}` is the same as using `{{blog-post}}`.
This may be followed by any properties that should be passed to the component when it is rendered.

The real value of [`{{component}}`][2] comes from being able to dynamically pick
the component being rendered. Below is an example of using the helper as a
means of choosing different components for displaying different kinds of posts:

[2]: http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_component

```app/templates/components/foo-component.hbs
<h3>Hello from foo!</h3>
<p>{{post.body}}</p>
```

```app/templates/components/bar-component.hbs
<h3>Hello from bar!</h3>
<div>{{post.author}}</div>
```

```app/routes/index.js
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.get('store').findAll('post');
  }
});
```

```app/templates/index.hbs
{{#each model as |post|}}
  {{!-- either foo-component or bar-component --}}
  {{component post.componentName post=post}}
{{/each}}
```

When the parameter passed to `{{component}}` evaluates to `null` or `undefined`,
the helper renders nothing. When the parameter changes, the currently rendered
component is destroyed and the new component is created and brought in.

Picking different components to render in response to the data allows you to
have a different template and behavior for each case. The `{{component}}` helper
is a powerful tool for improving code modularity.
