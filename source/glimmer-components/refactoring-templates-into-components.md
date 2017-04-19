When writing code, our instinct is to break up long blocks of code into smaller
named functions. In Ember, Components serve a similar purpose for your
templates.

Imagine that you are building a blog. You might have a template for displaying
a list of blog posts:

```app/templates/posts/index.hbs
<h1>Welcome To My Blog</h1>

<h2>Subscribe to the <a href="/feed.xml">RSS feed</a> for updates!</h2>

{{#each model as |post|}}
  <article class="post">
    <h3 class="title">{{#link-to "posts.show" post}}{{post.title}}{{/link-to}}</h3>

    <h4>
      Posted by
      {{#if post.author.twitterHandle}}
        <a href="https://twitter.com/{{post.author.twitterHandle}}" class="author">
          {{post.author.name}}
        </a>
      {{else}}
        <span class="author">{{post.author.name}}</span>
      {{/if}}
      at <time class="published-at">{{post.publishedAt}}</time>
    </h4>

    <div class="body excerpt">
      {{excerpt post.body}}
    </div>

    {{#link-to "posts.show" post class="read-more"}}Read more...{{/link-to}}
  </article>
{{/each}}
```

Conceptually, this example is doing a very simple thing – render some header
content, loop through a bunch of blog posts and render an excerpt for each of
them. However, these logic are buried underneath a lot of structural markup,
making it quite difficult to understand at first glance.

We can solve this problem by extracting some of the details into a Component.
Looking at the template, we are doing a lot of work inside the `{{#each}}`
loop, making it a prime candidate for extraction:

```app/templates/posts/index.hbs
<h1>Welcome To My Blog</h1>

<h2>Subscribe to the <a href="/feed.xml">RSS feed</a> for updates!</h2>

{{#each model as |post|}}
  <blog-post-excerpt post={{post}} />
{{/each}}
```

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

Here, we moved the work inside the loop into a component named `<blog-post-excerpt>`.
We won't dive into the nitty-gritty of how this works just yet (don't worry, we will
get to it soon enough!), but we can already see some of the benefits for this
refactor.

When other developers look at `index.hbs`, they can immediately understand what
is happening at a high-level without looking at the exact details of the
`<blog-post-excerpt>` component. If all they wanted to do is to fix a typo in
the header, they might not care about the component at all! Just like how the
`<img>` tag hides the details of fetching, decoding and rendering image files,
the `<blog-post-excerpt>` component in this example *encapsulates* a logical
unit of work specific to this app.
