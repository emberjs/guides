Components are isolated from their surroundings, so any data that the component
needs has to be passed in.

For example, imagine you have a `blog-post` component that is used to
display a blog post:

```app/templates/components/blog-post.hbs
<article class="blog-post">
  <h1>{{title}}</h1>
  <p>{{body}}</p>
</article>
```

Now imagine we have the following template and route:

```app/routes/index.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('post');
  }
});
```

If we tried to use the component like this:

```app/templates/index.hbs
{{#each model as |post|}}
  {{blog-post}}
{{/each}}
```

The following HTML would be rendered:

```html
<article class="blog-post">
  <h1></h1>
  <p></p>
</article>
```

In order to make a property available to a component, you must pass it
in like this:

```app/templates/index.hbs
{{#each model as |post|}}
  {{blog-post title=post.title body=post.body}}
{{/each}}
```

It is important to note that these properties stay in sync (technically
known as being "bound"). That is, if the value of `componentProperty`
changes in the component, `outerProperty` will be updated to reflect that
change. The reverse is true as well.

## Positional Params

In addition to passing parameters in by name, you can pass them in by position.
In other words, you can invoke the above component example like this:

```app/templates/index.hbs
{{#each model as |post|}}
  {{blog-post post.title post.body}}
{{/each}}
```

To set the component up to receive parameters this way, you need
set the `positionalParams` attribute in your component class.

```app/components/blog-post.js
const BlogPostComponent = Ember.Component.extend({});

BlogPostComponent.reopenClass({
  positionalParams: ['title', 'body']
});

export default BlogPostComponent;
```

Then you can use the attributes in the component exactly as if they had been
passed in like `{{blog-post title=post.title body=post.body}}`.

Notice that the `positionalParams` property is added to the class as a
static variable via `reopenClass`. Positional params are always declared on
the component class and cannot be changed while an application runs.

Alternatively, you can accept an arbitrary number of parameters by
setting `positionalParams` to a string, e.g. `positionalParams: 'params'`. This
will allow you to access those params as an array like so:

```app/components/blog-post.js
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
