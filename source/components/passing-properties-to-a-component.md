By default a component does not have access to properties in the
template scope in which it is used.

For example, imagine you have a `blog-post` component that is used to
display a blog post:

```app/templates/components/blog-post.hbs
<h1>Component: {{title}}</h1>
<p>Lorem ipsum dolor sit amet.</p>
```

You can see that it has a `{{title}}` Handlebars expression to print the
value of the `title` property inside the `<h1>`.

Now imagine we have the following template and route:

```app/routes/index.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('post').get('firstObject');
  }
});
```

```app/templates/index.hbs

<h1>Template: {{title}}</h1>
{{blog-post}}
```

Running this code, you will see that the first `<h1>` (from the outer
template) displays the `title` property, but the second `<h1>` (from
inside the component) is empty.

We can fix this by making the `title` property available to the
component:

```handlebars
{{blog-post title=title}}
```

This will make the `title` property in the outer template scope
available inside the component's template using the same name, `title`.

If, in the above example, the model's `title` property was instead
called `name`, we would change the component usage to:

```handlebars
{{blog-post title=name}}
```

In other words, you are binding a named property from the outer scope to
a named property in the component scope, with the syntax
`componentProperty=outerProperty`.

It is important to note that the value of these properties is bound.
Whether you change the value on the model or inside the component, the
values stay in sync. In the following example, type some text in the
text field either in the outer template or inside the component and note
how they stay in sync.

You can also bind properties from inside an `{{#each}}` loop. This will
create a component for each item and bind it to each model in the loop.

```handlebars
{{#each model as |post|}}
  {{blog-post title=post.title}}
{{/each}}
```
If you are using the `{{component}}` helper to render your component, you can
pass properties to the chosen component in the same manner:

```handlebars
{{component componentName title=title name=name}}
```

### Positional Params

Apart from passing attributes to a component, you can also pass in positional parameters, like we've seen with the `{{link-to}}`, e.g. `{{link-to "user" userModel}}`.

You can access these parameters by setting the `positionalParams` attribute in your component class.

```app/components/x-visit.js
const MyComponent = Ember.Component.extend();

MyComponent.reopenClass({
  positionalParams: ['name', 'model']
});

export default MyComponent;
```

This will expose the first parameter in your template as the `{{name}}` attribute and the second as `{{model}}`. They will also be available as regular attributes in your component via `this.get('name')` and `this.get('model')`.

In addition to mapping the parameters to attributes, you can also have an arbitrary number of parameters by setting `positionalParams`
to a string, e.g. `positionalParams: 'params'`. This will allow you to access those params as an array like so:

```app/templates/components/x-visit.hbs
{{#each params as |param|}}
  {{param}}
{{/each}}
```
