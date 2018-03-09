Sometimes, you may want to define a component that wraps content provided by other templates.

For example, imagine we are building a `blog-post` component that we can use in our application to display a blog post:

```app/templates/components/blog-post.hbs
<h1>{{title}}</h1>
<div class="body">{{body}}</div>
```

Now, we can use the `{{blog-post}}` component and pass it properties in another template:

```handlebars
{{blog-post title=title body=body}}
```

See [Passing Properties to a Component](../passing-properties-to-a-component/) for more.

In this case, the content we wanted to display came from the model.
But what if we want the developer using our component to be able to provide custom HTML content?

In addition to the simple form you've learned so far,
components also support being used in **block form**.
In block form, components can be passed a Handlebars template that is rendered inside the component's template wherever the `{{yield}}` expression appears.

To use the block form, add a `#` character to the beginning of the component name,
then make sure to add a closing tag.

See the Handlebars documentation on [block expressions](http://handlebarsjs.com/#block-expressions) for more.

In that case, we can use the `{{blog-post}}` component in **block form** and tell Ember where the block content should be rendered using the `{{yield}}` helper.
To update the example above, we'll first change the component's template:

```app/templates/components/blog-post.hbs
<h1>{{title}}</h1>
<div class="body">{{yield}}</div>
```

You can see that we've replaced `{{body}}` with `{{yield}}`.
This tells Ember that this content will be provided when the component is used.

Next, we'll update the template using the component to use the block form:

```app/templates/index.hbs
{{#blog-post title=title}}
  <p class="author">by {{author}}</p>
  {{body}}
{{/blog-post}}
```

It's important to note that the template scope inside the component block is the same as outside.
If a property is available in the template outside the component, it is also available inside the component block.

## Sharing Component Data with its Wrapped Content

There is also a way to share data within your blog post component with the content it is wrapping.
In our blog post component we want to provide a way for the user to configure what type of style they want to write their post in.
We will give them the option to specify either `markdown-style` or `html-style`.

```app/templates/index.hbs
{{#blog-post editStyle="markdown-style"}}
  <p class="author">by {{author}}</p>
  {{body}}
{{/blog-post}}
```

Supporting different editing styles will require different body components to provide special validation and highlighting.
To load a different body component based on editing style,
you can yield the component using the [`component helper`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/component?anchor=component) and [`hash helper`](https://www.emberjs.com/api/ember/release/classes/Ember.Templates.helpers/methods/hash?anchor=hash). 
Here, the appropriate component is assigned to a hash using nested helpers and yielded to the template.
Notice `editStyle` being used as an argument to the component helper.

```app/templates/components/blog-post.hbs
<h2>{{title}}</h2>
<div class="body">{{yield (hash body=(component editStyle))}}</div>
```

Once yielded, the data can be accessed by the wrapped content by referencing the `post` variable.
Now a component called `markdown-style` will be rendered in `{{post.body}}`.

```app/templates/index.hbs
{{#blog-post editStyle="markdown-style" postData=myText as |post|}}
  <p class="author">by {{author}}</p>
  {{post.body}}
{{/blog-post}}
```

Finally, we need to share `myText` with the body in order to have it display.
To pass the blog text to the body component, we'll add a `postData` argument to the component helper.

```app/templates/components/blog-post.hbs
<h2>{{title}}</h2>
<div class="body">
  {{yield (hash
    body=(component editStyle postData=postData)
  )}}
</div>
```

At this point, our block content has access to everything it needs to render,
via the wrapping `blog-post` component's template helpers.

Additionally, since the component isn't instantiated until the block content is rendered,
we can add arguments within the block.
In this case we'll add a text style option which will dictate the style of the body text we want in our post.
When `{{post.body}}` is instantiated, it will have both the `editStyle` and `postData` given by its wrapping component,
as well as the `bodyStyle` declared in the template.

```app/templates/index.hbs
{{#blog-post editStyle="markdown-style" postData=myText as |post|}}
  <p class="author">by {{author}}</p>
  {{post.body bodyStyle="compact-style"}}
{{/blog-post}}
```

Components built this way are commonly referred to as "Contextual Components",
allowing inner components to be wrapped within the context of outer components without breaking encapsulation.
