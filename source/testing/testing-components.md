

Components can be tested with integration tests using the `moduleForComponent` helper.

Let's assume we have a component with a `style` property that is updated
whenever the value for its `name` property changes. The `style` attribute of the
component is bound to its `style` property.

> You can follow along by generating your own component with `ember generate
> component pretty-color`.

```app/components/pretty-color.js
export default Ember.Component.extend({
  attributeBindings: ['style'],

  style: Ember.computed('name', function() {
    const name = this.get('name');
    return `color: ${name}`;
  })
});
```

```app/templates/components/pretty-color.hbs
Pretty Color: {{name}}
```

The `moduleForComponent` helper will find the component by name (`pretty-color`)
and its template (if available).  Make sure to set `integration: true` to enable
integration test capability.

```tests/integration/components/pretty-color-test.js
moduleForComponent('pretty-color', 'Integration | Component | pretty color', {
  integration: true
});
```

Each test following the `moduleForComponent` call has access to the `render()`
function, which lets us create a new instance of the component by declaring
the component in template syntax, as we would in our application.

We can test that changing the component's `name` property updates the
component's `style` attribute and is reflected in the  rendered HTML:

```tests/integration/components/pretty-color-test.js
test('should change colors', function(assert) {
  assert.expect(2);

  // set the outer context to red
  this.set('colorValue', 'red');

  this.render(hbs`{{pretty-color name=colorValue}}`);

  assert.equal(this.$('div').attr('style'), 'color: red', 'starts as red');

  this.set('colorValue', 'blue');

  assert.equal(this.$('div').attr('style'), 'color: blue', 'updates to blue');
});
```

We might also test this component to ensure that the content of its template is
being rendered properly:

```tests/integration/components/pretty-color-test.js
test('should be rendered with its color name', function(assert) {
  assert.expect(2);

  this.set('colorValue', 'orange');

  this.render(hbs`{{pretty-color name=colorValue}}`);

  assert.equal(this.$().text().trim(), 'Pretty Color: orange', 'text starts as orange');

  this.set('colorValue', 'green');

  assert.equal(this.$().text().trim(), 'Pretty Color: green', 'text switches to green');

});
```

### Testing User Interaction

Components are a great way to create powerful, interactive, and self-contained
custom HTML elements. It is important to test the component's methods _and_ the
user's interaction with the component.

Imagine you have the following component that changes its title when a button is
clicked on:

> You can follow along by generating your own component with `ember generate
> component magic-title`.

```app/components/magic-title.js
export default Ember.Component.extend({
  title: 'Hello World',

  actions: {
    updateTitle() {
      this.set('title', 'This is Magic');
    }
  }
});
```

```app/templates/components/magic-title.hbs
<h2>{{title}}</h2>

<button {{action "updateTitle"}}>
  Update Title
</button>
```

jQuery triggers can be used to simulate user interaction and test that the title
is updated when the button is clicked on:

```tests/integration/components/magic-title-test.js
test('should update title on button click', function(assert) {
  assert.expect(2);

  this.render(hbs`{{magic-title}}`);

  assert.equal(this.$('h2').text(), 'Hello World', 'initial text is hello world');

  //Click on the button
  this.$('button').click();

  assert.equal(this.$('h2').text(), 'This is Magic', 'title changes after click');
});
```

### Testing Actions

Components starting in Ember 2 utilize closure actions. Closure actions allow components
to directly invoke functions provided outer components.

For example, imagine you have a comment form component that invokes a
`submitComment` action when the form is submitted, passing along the form's data:

> You can follow along by generating your own component with `ember generate
> component comment-form`.

```app/components/comment-form.js
export default Ember.Component.extend({
  comment: '',

  actions: {
    submitComment() {
      this.attrs.submitComment({ comment: this.get('comment') });
    }
  }
});
```

```app/templates/components/comment-form.hbs
<form {{action "submitComment" on="submit"}}>
  <label>Comment:</label>
  {{textarea value=comment}}

  <input type="submit" value="Submit"/>
</form>
```

Here's an example test that asserts that the specified `externalAction` function
is invoked when the component's internal `submitComment` action is triggered by making use
of a test double (dummy function):

```tests/integration/components/comment-form-test.js
test('should trigger external action on form submit', function(assert) {

  // test double for the external action
  this.set('externalAction', (attributes) => assert.deepEqual(attributes, { comment: 'You are not a wizard!' }, 'submitted input value gets passed to external action'));

  this.render(hbs`{{comment-form submitComment=(action externalAction)}}`);

  // fill out the form and force an onchange
  this.$('textarea').val('You are not a wizard!');
  this.$('textarea').change();

  // click the button to submit the form
  this.$('input').click();
});
```
