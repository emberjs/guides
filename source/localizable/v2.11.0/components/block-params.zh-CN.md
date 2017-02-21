Components can have properties passed in ([Passing Properties to a Component](../passing-properties-to-a-component/)), but they can also return output to be used in a block expression.

### Return values from a component with `yield`

```app/templates/index.hbs
{{blog-post post=model}}
```

<pre><code class="app/templates/components/blog-post.hbs">{{yield post.title post.body post.author}}
</code></pre>

Here an entire blog post model is being passed to the component as a single component property. In turn the component is returning values using `yield`. In this case the yielded values are pulled from the post being passed in but anything that the component has access to can be yielded, such as an internal property or something from a service.

### Consuming yielded values with block params

The block expression can then use block params to bind names to any yielded values for use in the block. This allows for template customization when using a component, where the markup is provided by the consuming template, but any event handling behavior implemented in the component is retained such as `click()` handlers.

```app/templates/index.hbs
{{#blog-post post=model as |title body author|}}
  <h2>{{title}}</h2>
  <p class="author">by {{author}}</p>
  <div class="post-body">{{body}}</p>
{{/blog-post}}
```

The names are bound in the order that they are passed to `yield` in the component template.

### Supporting both block and non-block component usage in one template

It is possible to support both block and non-block usage of a component from a single component template using the `hasBlock` property.

<pre><code class="app/templates/components/blog-post.hbs">{{#if hasBlock}}
  {{yield post.title}}
  {{yield post.body}}
  {{yield post.author}}
{{else}}
  &lt;h1&gt;{{post.title}}&lt;/h1&gt;
  &lt;p class="author"&gt;Authored by {{post.author}}&lt;/p&gt;
  &lt;p&gt;{{post.body}}&lt;/p&gt;
{{/if}}
</code></pre>

This has the effect of providing a default template when using a component in the non-block form but providing yielded values for use with block params when using a block expression.