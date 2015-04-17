Ember.js provides several helpers that allow you to render other views and templates in different ways.

### The `{{partial}}` Helper

`{{partial}}` takes the template to be rendered as an argument, and renders that template in place.

`{{partial}}` does not change context or scope.  It simply drops the given template into place with the current scope.

```app/templates/author.hbs
Written by {{author.firstName}} {{author.lastName}}
```

```app/templates/post.hbs
<h1>{{title}}</h1>
<div>{{body}}</div>
{{partial "author"}}
```
Output:

```html
<div>
  <h1>Why You Should Use Ember.js</h1>
  <div>Because it's awesome!</div>
  Written by Yehuda Katz
</div>
```
### The `{{view}}` Helper

This helper works like the partial helper, except instead of providing a template to be rendered within the current template, you provide a view class.  The view controls what template is rendered.

```app/views/author.js
export default Ember.View.extend({
  // We are setting templateName manually here to the default value
  templateName: "author",

  // A fullName property should probably go on the model,
  // but we're doing it here for the sake of example
  fullName: (function() {
    return this.get("author.firstName") + " " + this.get("author.lastName");
  }).property("firstName","lastName")
})
```

```app/views/author.hbs
Written by {{view.fullName}}
```

```app/templates/author.hbs
<h1>{{title}}</h1>
<div>{{body}}</div>
{{view "author"}}
```

Output:

```html
<div>
  <h1>Why You Should Use Ember.js</h1>
  <div>Because it's awesome!</div>
  Written by Yehuda Katz
</div>
```

When using `{{partial "author"}}`:

* No instance of author view will be created
* The given template will be rendered

When using `{{view "author"}}`:

* An instance of author view will be created
* It will be rendered here, using the template associated with that view (the default template being "author")

For more information, see [Inserting Views in Templates](../../views/inserting-views-in-templates).

### The `{{render}}` Helper

`{{render}}` takes two parameters:

* The first parameter describes the context to be setup
* The optional second parameter is a model, which will be passed to the controller if provided

`{{render}}` does several things:

* When no model is provided it gets the singleton instance of the corresponding controller
* When a model is provided it gets a unique instance of the corresponding controller
* Renders the named template using this controller
* Sets the model of the corresponding controller

Modifying the post / author example slightly:

```app/templates/author.hbs
Written by {{firstName}} {{lastName}}.
Total Posts: {{postCount}}
```

```app/templates/post.hbs
<h1>{{title}}</h1>
<div>{{body}}</div>
{{render "author" author}}
```

```app/controllers/author.js
export default Ember.Controller.extend({
  postCount: function() {
    return this.get("model.posts.length");
  }.property("model.posts.[]")
})
```

In this example, render will:

* Get an instance of author view if that class exists, otherwise uses a default generated view
* Use the corresponding template (in this case the default of "author")
* Get (or generate) the singleton instance of AuthorController
* Set the AuthorController's model to the 2nd argument passed to render, here the author field on the post
* Render the template in place, with the context created in the previous steps.

`{{render}}` does not require the presence of a matching route.

`{{render}}` is similar to `{{outlet}}`. Both tell Ember.js to devote this portion of the page to something.

`{{outlet}}`: The router determines the route and sets up the appropriate controllers/views/models.
`{{render}}`: You specify (directly and indirectly) the appropriate controllers/views/models.



Note: `{{render}}` cannot be called multiple times for the same route when not specifying a model.

### Comparison Table

#### General

<table>
  <thead>
  <tr>
    <th>Helper</th>
    <th>Template</th>
    <th>Model</th>
    <th>View</th>
    <th>Controller</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>{{partial}}</code></td>
    <td>Specified Template</td>
    <td>Current Model</td>
    <td>Current View</td>
    <td>Current Controller</td>
  </tr>
  <tr>
    <td><code>{{view}}</code></td>
    <td>View's Template</td>
    <td>Current Model</td>
    <td>Specified View</td>
    <td>Current Controller</td>
  </tr>
  <tr>
    <td><code>{{render}}</code></td>
    <td>View's Template</td>
    <td>Specified Model</td>
    <td>Specified View</td>
    <td>Specified Controller</td>
  </tr>
  </tbody>
</table>

#### Specific

<table class='specific'>
  <thead>
  <tr>
    <th>Helper</th>
    <th>Template</th>
    <th>Model</th>
    <th>View</th>
    <th>Controller</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>{{partial "author"}}</code></td>
    <td><code>templates/author.hbs</code></td>
    <td><code>models/post.js</code></td>
    <td><code>views/post.js</code></td>
    <td><code>controllers/post.js</code></td>
  </tr>
  <tr>
    <td><code>{{view "author"}}</code></td>
    <td><code>templates/author.hbs</code></td>
    <td><code>models/post.js</code></td>
    <td><code>views/author.js</code></td>
    <td><code>controllers/post.js</code></td>
  </tr>
  <tr>
    <td><code>{{render "author" author}}</code></td>
    <td><code>templates/author.hbs</code></td>
    <td><code>models/author.js</code></td>
    <td><code>views/author.js</code></td>
    <td><code>controllers/author.js</code></td>
  </tr>
  </tbody>
</table>
