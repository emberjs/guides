_Unit testing methods and computed properties follows previous patterns shown
in [Unit Testing Basics] because Ember.Controller extends Ember.Object._

Unit testing controllers is very simple using the unit test helper which is part
of the ember-qunit framework.

### Testing Controller Actions

Here we have a controller `PostsController` with some computed properties and an
action `setProps`.

```app/controllers/posts.js
export default Ember.Controller.extend({

  propA: 'You need to write tests',
  propB: 'And write one for me too',

  setPropB(str) {
    this.set('propB', str);
  },

  actions: {
    setProps(str) {
      this.set('propA', 'Testing is cool');
      this.setPropB(str);
    }
  }
});
```

`setProps` sets a property on the controller and also calls a method. In our 
generated test, ember-cli already uses the `moduleFor` helper to setup a test 
container:

```tests/unit/controllers/posts-test.js
moduleFor('controller:posts', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
});
```

Next we use `this.subject()` to get an instance of the `PostsController` and
write a test to check the action. `this.subject()` is a helper method from the
`ember-qunit` library that returns a singleton instance of the module set up
using `moduleFor`.

```tests/unit/controllers/posts-test.js
test('calling the action setProps updates props A and B', function(assert) {
  assert.expect(4);

  // get the controller instance
  var ctrl = this.subject();

  // check the properties before the action is triggered
  assert.equal(ctrl.get('propA'), 'You need to write tests');
  assert.equal(ctrl.get('propB'), 'And write one for me too');

  // trigger the action on the controller by using the `send` method,
  // passing in any params that our action may be expecting
  ctrl.send('setProps', 'Testing Rocks!');

  // finally we assert that our values have been updated
  // by triggering our action.
  assert.equal(ctrl.get('propA'), 'Testing is cool');
  assert.equal(ctrl.get('propB'), 'Testing Rocks!');
});
```

### Testing Controller Needs

Sometimes controllers have dependencies on other controllers. This is
accomplished by using [needs]. For example, here are two simple controllers. The
`PostController` is a dependency of the `CommentsController`:

```app/controllers/post.js
export default Ember.Controller.extend({
  title: Ember.computed.alias('model.title')
});
```

```app/controllers/comments.js
export default Ember.Controller.extend({
  needs: 'post',
  title: Ember.computed.alias('controllers.post.title'),
});
```

This time when we setup our `moduleFor` we need to pass an options object as
our third argument that has the controller's `needs`.

```tests/unit/controllers/comments-test.js
moduleFor('controller:comments', 'Comments Controller', {
  needs: ['controller:post']
});
```

Now let's write a test that sets a property on our `post` model in the
`PostController` that would be available on the `CommentsController`.

```tests/unit/controllers/comments-test.js
test('modify the post', function(assert) {
  assert.expect(2);

  // grab an instance of `CommentsController` and `PostController`
  var ctrl = this.subject();
  var postCtrl = ctrl.get('controllers.post');

  // wrap the test in the run loop because we are dealing with async functions
  Ember.run(function() {

    // set a generic model on the post controller
    postCtrl.set('model', Ember.Object.create({ title: 'foo' }));

    // check the values before we modify the post
    assert.equal(ctrl.get('title'), 'foo');

    // modify the title of the post
    postCtrl.get('model').set('title', 'bar');

    // assert that the controllers title has changed
    assert.equal(ctrl.get('title'), 'bar');
  });
});
```

[Unit Testing Basics]: ../unit-testing-basics
[needs]: ../../controllers/dependencies-between-controllers
