HTML was designed in a time when the browser was a simple document
viewer. Developers building great web apps need something more.

Instead of trying to replace HTML, however, Ember.js embraces it, then adds
powerful new features that modernize it for building web apps.

Currently, you are limited to the tags that are created for you by the
W3C. Wouldn't it be great if you could define your own,
application-specific HTML tags, then implement their behavior using
JavaScript?

That's exactly what components let you do. In fact, it's such a good
idea that the W3C is currently working on the [Custom
Elements](https://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/custom/index.html)
spec.

Ember's implementation of components hews as closely to the [Web
Components specification](http://www.w3.org/TR/components-intro/) as possible.
Once Custom Elements are widely available in browsers, you should be able to
easily migrate your Ember components to the W3C standard and have them be
usable by other frameworks.

This is so important to us that we are working closely with the
standards bodies to ensure our implementation of components matches the
roadmap of the web platform.

To highlight the power of components, here is a short example of turning a blog post into a reusable
`blog-post` custom element that you could use again and again in your
application. Keep reading this section for more details on building
components.

<!---<a class="jsbin-embed" href="http://jsbin.com/xexumomaru/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

The example above uses `<script>` tags to work inside of JSBin. Ember-cli works by file structure, so there are no `<script>` tags:-->

```app/templates/index.hbs

{{#each}}
   {{#blog-post title=title}}
     {{body}}
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
  model: function() {
  return posts;
  }
});
```

```app/components/blog-post.js

export default Ember.Component.extend({

});
```
