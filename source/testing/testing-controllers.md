_Unit testing methods and computed properties follows previous patterns shown
in [Unit Testing Basics] because Ember.Controller extends Ember.Object._

Unit testing controllers is very simple using the unit test helper which is part
of the ember-qunit framework.

### Testing Controller Actions

Here we have a controller `PostsController` with two properties, a method that
sets one of those properties, and an action named `setProps`.

> You can follow along by generating your own controller with `ember generate
> controller posts`.

```app/controllers/posts.js
import Controller from '@ember/controller';

export default Controller.extend({
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

The `setProps` action directly sets one property, and calls the method to set the other.
In our generated test, ember-cli already uses the `moduleFor` helper to set up a test
container:

```tests/unit/controllers/posts-test.js
import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:posts', {});
```

Next we use `this.subject()` to get an instance of the `PostsController` and
write a test to check the action. `this.subject()` is a helper method from the
`ember-qunit` library that returns a singleton instance of the module set up
using `moduleFor`.

```tests/unit/controllers/posts-test.js
import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:posts', {});

test('should update A and B on setProps action', function(assert) {
  assert.expect(4);

  // get the controller instance
  const ctrl = this.subject();

  // check the properties before the action is triggered
  assert.equal(ctrl.get('propA'), 'You need to write tests', 'propA initialized');
  assert.equal(ctrl.get('propB'), 'And write one for me too', 'propB initialized');

  // trigger the action on the controller by using the `send` method,
  // passing in any params that our action may be expecting
  ctrl.send('setProps', 'Testing Rocks!');

  // finally we assert that our values have been updated
  // by triggering our action.
  assert.equal(ctrl.get('propA'), 'Testing is cool', 'propA updated');
  assert.equal(ctrl.get('propB'), 'Testing Rocks!', 'propB updated');
});
```

### Testing Controller Needs

Sometimes controllers have dependencies on other controllers. This is
accomplished by injecting one controller into another. For example, here are two simple controllers. The
`CommentsController` uses the `PostController` via `inject`:

> You can follow along by generating your own controller with `ember generate
> controller post`, and `ember generate controller comments`.

```app/controllers/post.js
import Controller from '@ember/controller';
import { alias } from "@ember/object/computed";

export default Controller.extend({
  title: alias('model.title')
});
```

```app/controllers/comments.js
import Controller, { inject as controller } from '@ember/controller';
import { alias } from "@ember/object/computed";

export default Controller.extend({
  post: controller(),
  title: alias('post.title')
});
```

This time when we setup our `moduleFor` we need to pass an options object as
our third argument that has the controller's `needs`.

```tests/unit/controllers/comments-test.js
import { moduleFor, test } from 'ember-qunit';
import EmberObject from "@ember/object";
import { run } from '@ember/runloop';

moduleFor('controller:comments', 'Comments Controller', {
  needs: ['controller:post']
});
```

Now let's write a test that sets a property on our `post` model in the
`PostController` that would be available on the `CommentsController`.

```tests/unit/controllers/comments-test.js
import { moduleFor, test } from 'ember-qunit';
import EmberObject from "@ember/object";
import { run } from '@ember/runloop';

moduleFor('controller:comments', 'Comments Controller', {
  needs: ['controller:post']
});

test('should modify the post model', function(assert) {
  assert.expect(2);

  // grab an instance of `CommentsController` and `PostController`
  const ctrl = this.subject();
  const postCtrl = ctrl.get('post');

  // wrap the test in the run loop because we are dealing with async functions
  run(function() {

    // set a generic model on the post controller
    postCtrl.set('model', Ember.Object.create({ title: 'foo' }));

    // check the values before we modify the post
    assert.equal(ctrl.get('title'), 'foo', 'title is set');

    // modify the title of the post
    postCtrl.get('model').set('title', 'bar');

    // assert that the controllers title has changed
    assert.equal(ctrl.get('title'), 'bar', 'title is updated');
  });
});
```

[Unit Testing Basics]: ../unit-testing-basics
[needs]: ../../controllers/dependencies-between-controllers
