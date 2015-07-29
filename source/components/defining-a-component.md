To define a component, create a template whose name starts with
`components/`. To define a new component, `{{blog-post}}` for example,
create a `components/blog-post` template.

**Note:** Components must have at least one dash in their name. So `blog-post` is an acceptable name, so is `audio-player-controls`, but `post` is not. This prevents clashes with current or future HTML element names, and
ensures Ember detects the components automatically.

A sample component template would look like this:

```app/templates/components/blog-post.hbs
<h1>Blog Post</h1>
<p>Lorem ipsum dolor sit amet.</p>
```

Having a template whose name starts with `components/` creates a
component of the same name. Given the above template, you can now use the
`{{blog-post}}` custom element:

```app/templates/index.hbs
{{#each model as |post|}}
  {{#blog-post title=post.title}}
    {{post.body}}
  {{/blog-post}}
{{/each}}
```

```app/templates/components/blog-post.hbs
<article class="blog-post">
  <h1>{{title}}</h1>
  <p>{{yield}}</p>
  <p>Edit title: {{input type="text" value=title}}</p>
</article>
```

```app/routes/index.js
var posts = [{
    title: "Rails is omakase",
    body: "There are lots of à la carte software environments in this world."
  }, {
    title: "Broken Promises",
    body: "James Coglan wrote a lengthy article about Promises in node.js."
}];

export default Ember.Route.extend({
  model() {
    return posts;
  }
});
```

```app/components/blog-post.js
export default Ember.Component.extend({
});
```

Each component, under the hood, is backed by an element. By default
Ember will use a `<div>` element to contain your component's template.
To learn how to change the element Ember uses for your component, see
[Customizing a Component's
Element](../customizing-a-components-element).


### Defining a Component Subclass

Often times, your components will just encapsulate certain snippets of
Handlebars templates that you find yourself using over and over. In
those cases, you do not need to write any JavaScript at all. Just define
the Handlebars template as described above and use the component that is
created.

If you need to customize the behavior of the component you'll
need to define a subclass of `Ember.Component`. For example, you would
need a custom subclass if you wanted to change a component's element,
respond to actions from the component's template, or manually make
changes to the component's element using JavaScript.

Ember knows which subclass powers a component based on its filename. For
example, if you have a component called `blog-post`, you would create a
file at `app/components/blog-post.js`. If your component was called
`audio-player-controls`, the file name would be at
`app/components/audio-player-controls.js`.

### Dynamically rendering a component

The `{{component}}` helper can be used to defer the selection of a component to
run time. The `{{my-component}}` syntax would always render the same component,
whereas using the `{{component}}` helper allows swapping the component rendered
on the fly. This is useful in cases where, for example, you want to interact
with different external libraries depending on the data. Using the `{{component}}`
helper would allow you to keep those different logic well-separated.

The first parameter of the helper is the name of a component to render, as a string. So if you have `{{component 'blog-post'}}`, that is just the same as just `{{blog-post}}`.

The real value of `{{component}}` comes from being able to dynamically pick
the component being rendered. Below is an example of using the helper as a
mean to dispatch to different components for displaying different kinds of posts:


```app/templates/components/foo-component.hbs
<h3>Hello from foo!</h3>
<p>{{post.body}}</p>
```

```app/templates/components/bar-component.hbs
<h3>Hello from bar!</h3>
<div>{{post.author}}</div>
```

```app/routes/index.js
var posts = [{
    componentName: 'foo-component',  // key used to determine the rendered component
    body: "There are lots of à la carte software environments in this world."
  }, {
    componentName: 'bar-component',
    author: "Drew Crawford"
}];

export default Ember.Route.extend({
  model() {
    return posts;
  }
});
```

```app/templates/index.hbs
{{#each model as |post|}}
  {{!-- either foo-component or bar-component --}}
  {{component post.componentName post=post}}
{{/each}}
```

For brevity, `componentName` is hardcoded inside each post, but it can very
well be a computed property that deduces the target component based on the data.

When the parameter passed to `{{component}}` evaluates to `null` or `undefined`,
the helper renders nothing. When the parameter changes, the currently rendered
component is destroyed and the new component is created and brought in.

Picking different components to render in response to the data allows you to
have different template and behavior for each case. The `{{component}}` helper
is a powerful tool for improving code modularity.