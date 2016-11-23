In [Defining a Component](../defining-a-component/) we saw how to customize the content a component displays by passing properties to it from the parent template in which it appears.
This is the example we used:

```app/templates/components/blog-post.hbs
<article class="blog-post">
  <h1>{{title}}</h1>
  <p>{{body}}</p>
</article>
```

```app/templates/index.hbs
{{blog-post title=post.title body=post.body}}
```

For simplicity we've omitted the `{{#each}}` loop around the component that yields individual posts.
Passing parameters to the component like this is useful if we want to describe how the content of the component should be customized just in terms of data available in the parent template.
Sometimes, however,
you may wish to allow the developer using the component to provide portions of custom HTML or handlebars content to be inserted within the component's template.
In this case an alternative **block form** of usage is available that describes how the component should wrap the custom content.

The block form syntax follows the same pattern as Ember's internal helpers discussed in [Templates - Conditionals](../../templates/conditionals).
In the parent template add a `#` character to the beginning of the component name prior to the content to be wrapped and add a closing tag after it.
(See the Handlebars documentation on [block expressions](http://handlebarsjs.com/#block-expressions) for more.)

```app/templates/index.hbs
{{#blog-post title=post.title}}
  <p class="author">by {{post.author}}</p>
  {{post.body}}
{{/blog-post}}
```

In the component template, we tell Ember where the block content should be inserted using the `{{yield}}` helper:

```app/templates/components/blog-post.hbs
<h1>{{title}}</h1>
<div class="body">{{yield}}</div>
```

The template scope inside the component block is the same as outside.
If a property is available in the template outside the component, it is also available inside the component block.

## Supporting Both Block and Non-block Component Usage

It is possible to support both block and non-block usage of a component from a single component template
using the `hasBlock` property.

```app/templates/components/blog-post.hbs
{{#if hasBlock}}
  {{yield}}
{{else}}
  <h1>{{post.title}}</h1>
  <p class="author">Authored by {{post.author}}</p>
  <p>{{post.body}}</p>
{{/if}}
```

## Sharing Component Data with its Wrapped Content

We can pass data from the parent template to the component in the form of either named or positional parameters.
However,
in the block form of component usage it is sometimes also useful to be able to pass data *from* the component to the content that it wraps.
To illustrate,
we will modify the previous example by passing the entire `post` object to the component rather than just its `title` property and we will modify the use of `{{yield}}` inside the component:

```app/templates/components/blog-post.hbs
<div class="body">{{yield post.title post.body post.author}}</div>
```

The properties `post.title`,
`post.body` and `post.author` that follow `yield` are passed into the block of content wrapped by the template and are made available for use in that block using the `as` keyword: 

```app/templates/index.hbs
{{#blog-post post=post as |title body author|}}
  <h2>{{title}}</h2>
  <p class="author">by {{author}}</p>
  <div class="post-body">{{body}}</p>
{{/blog-post}}
```
The *block parameters*  `title`,
`body` and `author` following `as` are bound to those within the component in the same order they are listed after `yield` in the component template.

## Contextual Components

It's common for content wrapped by a component to itself contain other components.
In these cases it's sometimes useful for the outer or containing component to be able to control which components are used within the block,
for example to reflect different configuration settings.
We've seen already how block parameters allow us to pass data from the component to the content it wraps.
However they also allow us to pass *components* to be used within the block,
thereby providing greater control over how content is rendered within it.

To illustrate, imagine that we want our `blog-post` component to provide a way for the user to configure the style they want to write their post in, e.g. markdown or HTML.
Supporting this will require different components to be used to display the post inside the block wrapped by `blog-post` depending on which selection is made,
in order to provide special validation and highlighting.
We'll show this below hard-coded for the markdown case,
but it's easy to see how this could be generalized to use a configuration variable.
We'll first pass the name of the editor component we wish to use in the variable `editor`,
along with a model of the data the user fills out for the post in `postData`.

```app/templates/index.hbs
{{#blog-post postData=postData editor="markdown-editor"}}
  <p class="author">by {{author}}</p>
  {{!-- Additional body content using the selected editing style ... --}}
{{/blog-post}}
```

In the component template, in order to load the required body component based on editing style,
we yield the component using the `component` and `hash` helpers.

```app/templates/components/blog-post.hbs
<h2>{{title}}</h2>
<div class="body">{{yield (hash body=(component editor postData=postData))}}</div>
```

The `hash` helper creates an object containing a set of named properties, in this case just one property,
`body` with the value `component editor postData=postData`.
The `component` helper, introduced earlier in [Defining a Component](../defining-a-component/#toc_dynamically-rendering-a-component), creates a reference to the component named by `editor`, in this case `"markdown-editor"`,
and specifies that when it is rendered data will be passed to that component in the variable `postData`.

By yielding the hash to the wrapped content in a block variable named `post`,
we can then access the selected component inside the block as `post.body`:

```app/templates/index.hbs
{{#blog-post postData=postData editor="markdown-editor" as |post|}}
  <p class="author">by {{author}}</p>
  {{post.body}}
{{/blog-post}}
```

Since the component isn't instantiated until the component block content is rendered,
we can add additional arguments within the block.
In this case we'll add a text style option which will dictate the style of body text we want in our post.
When `{{post.body}}` is instantiated,
the selected editing component will have access to both the text style and the `postData` given by its wrapping component.

```app/templates/index.hbs
{{#blog-post postData=postData editor="markdown-editor" as |post|}}
  <p class="author">by {{author}}</p>
  {{post.body textStyle="compact"}}
{{/blog-post}}
```
Sharing components this way is commonly referred to as "Contextual Components",
because the component is shared only with the context of the parent component's block area.

