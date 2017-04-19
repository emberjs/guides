## Defining a Component

The easiest way to define a component is by adding its template in the
`app/templates/components/` directory. In our example, we added the
`app/templates/components/blog-post-excerpt.hbs` template, which automatically
registers the `<blog-post-excerpt>` component with Ember:

```app/templates/components/blog-post-excerpt.hbs
<article class="post">
  <h3 class="title">{{#link-to "posts.show" attrs.post}}{{attrs.post.title}}{{/link-to}}</h3>

  <h4>
    Posted by
    {{#if attrs.post.author.twitterHandle}}
      <a href="https://twitter.com/{{attrs.post.author.twitterHandle}}" class="author">
        {{attrs.post.author.name}}
      </a>
    {{else}}
      <span class="author">{{attrs.post.author.name}}</span>
    {{/if}}
    at <time class="published-at">{{attrs.post.publishedAt}}</time>
  </h4>

  <div class="body excerpt">
    {{excerpt attrs.post.body}}
  </div>

  {{#link-to "posts.show" attrs.post class="read-more"}}Read more...{{/link-to}}
</article>
```

As you can see, a component's template is not very different from other
templates you would write in an Ember app. There are two main rules:

*   The component's name (the name of the template file) must contain at least
    one dash character ("-"). This allows Ember (and other human readers of the
    templates!) to distinguish between regular HTML elements and Components.

    For example, `<my-btn>`, `<x-select>` and `<profile-card>` are all valid
    names for a Component, but `<btn>`, `<select>` and `<profile>` are not.

*   The component's template must contain a single *top-level element* – in
    other words, the entire template must be wrapped inside a single HTML
    element or another Component.

    For example, `<div>...</div>`, `<hr>`, `<x-select>...</x-select>` and
    `<!-- coments and whitespaces are fine -->  <img src="...">` are all valid
    Component templates, but `<hr> <br> <hr>` is not.

    (**TODO:** Fix recurrsive invocation on Ember or remove it from here and
    document it as a known limitation.)

In our example, we named our component `<blog-post-excerpt>`, which fufilled
the dash requirement. Our template is also contained inside an `<article>` tag,
which satisfied the single top-level element rule.

In this case, our `<blog-post-excerpt>` component happens to represent content
that has a natural HTML element mapping – the `<article>` tag was created for
exactly this purpose.

However, this is not always possible. Sometimes the content you are extracting
simply does not have semantic meaning that matches an existing HTML element.
Instead of using a generic element (e.g. a `<div>` tag or a `<span>` tag) as
your Component's top-level element, you can also use the Component's name
instead:

```app/templates/components/hero-unit.hbs
<hero-unit>
  <h1>Black Friday Sales</h1>
  <h2>Check out our amazing deals!</h2>
</hero-unit>
```

In this example, we created a `<hero-unit>` Component, whose top-level element
is the custom `<hero-unit>` tag. This technique is sometimes referred to as the
*identity element* trick. By default, browsers would render an identity element
exactly like a `<div>` tag, but you can customize that to your liking using
regular CSS. Using the Component's name as the top-level element allows you to
easily visualize your Component hirachery in the browser's dev tools:

(**TODO:** add a screenshot of the Chrome inspector's DOM tree showing this)

## Invoking a Component

Once you have defined a Component, you can invoke them with the angle bracket
syntax just like any regular HTML elements:

```app/templates/posts/index.hbs
<h1>Welcome To My Blog</h1>

<h2>Subscribe to the <a href="/feed.xml">RSS feed</a> for updates!</h2>

{{#each model as |post|}}
  <blog-post-excerpt post={{post}} />
{{/each}}
```

Here, in each iteration of the loop, the `<blog-post-excerpt>` *invocation*
would be *replaced* with the Component's template at runtime. When rendered,
it would produce something like this:

```html
<h1>Welcome To My Blog</h1>

<h2>Subscribe to the <a href="/feed.xml">RSS feed</a> for updates!</h2>

<article class="post">
  <h3 class="title">Rails is Omakase</h3>
  ...
</article>

<article class="post">
  <h3 class="title">The Parley Letter</h3>
  ...
</article>

<article class="post">
  <h3 class="title">Dependency Injection is Not a Virtue</h3>
  ...
</article>
```

The invocation of a custom Component must be properly closed. You are free to
use either a pair of open/closing tag (`<my-foo></my-foo>`) or a self-closing
tag (`<my-foo />`) as shown in the example above.

Registered Components can be invoked in any templates inside an Ember app,
including inside another Component's template. This allows you to compose
arbitrarily Components using smaller sub-components, just as you can compose
complex functions from smaller functions to make your code easier to understand
and maintain.
