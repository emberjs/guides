So far, we've discussed writing templates for a single view. However, as your application grows, you will often want to create a hierarchy of views to encapsulate different areas on the page. Each view is responsible for handling events and maintaining the properties needed to display it.

### {{view}}

To add a child view to a parent, use the `{{view}}` helper.
The `{{view}}` helper takes a string used to look up the view class.

```app/views/user.js
export default Ember.View.extend({
  firstName: "Albert",
  lastName: "Hofmann"
});
```

```app/views/info.js
export default Ember.View.extend({
  posts: 25,
  hobbies: "Riding bicycles"
});
```

```app/templates/user.hbs
User: {{view.firstName}} {{view.lastName}}
{{view "info"}}
```

```app/templates/info.hbs
<b>Posts:</b> {{view.posts}}
<br>
<b>Hobbies:</b> {{view.hobbies}}
```

If we were to create an instance of `view:user` and render it, we would get
a DOM representation like this:

```html
User: Albert Hofmann
<div>
  <b>Posts:</b> 25
  <br>
  <b>Hobbies:</b> Riding bicycles
</div>
```

### Setting Child View Templates

If you'd like to specify the template your child views use inline in
the main template, you can use the block form of the `{{view}}` helper.
We might rewrite the above example like this:

```app/views/user.js
export default Ember.View.extend({
  firstName: "Albert",
  lastName: "Hofmann"
});
```

```app/views/info.js
export default Ember.View.extend({
  posts: 25,
  hobbies: "Riding bicycles"
});
```

```handlebars
User: {{view.firstName}} {{view.lastName}}
{{#view "info"}}
  <b>Posts:</b> {{view.posts}}
  <br>
  <b>Hobbies:</b> {{view.hobbies}}
{{/view}}
```

When you do this, it may be helpful to think of it as assigning views to
portions of the page. This allows you to encapsulate event handling for just
that part of the page.

