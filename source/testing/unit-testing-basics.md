Unit tests (as well as container tests) are generally used to test a small piece of code
and ensure that it is doing what was intended.
Unlike application tests, they are narrow in scope and do not require the Ember application to be running.


Let's have a look at a common use case - testing a service - to understand the basic principles of testing in Ember.
This will set the foundation for other parts of your Ember application such as controllers, components, helpers and others.
Testing a service is as simple as creating a container test,
looking up the service on the application's container and running assertions against it.

### Testing Computed Properties

Let's start by creating a service that has a `computedFoo` computed property
based on a `foo` property.

```app/services/some-thing.js
import Service from '@ember/service';
import { computed } from '@ember/object';

export default Service.extend({
  foo: 'bar',

  computedFoo: computed('foo', function() {
    const foo = this.get('foo');

    return `computed ${foo}`;
  })
});
```

Within the test for this object, we'll lookup the service instance, update the `foo` property (which
should trigger the computed property), and assert that the logic in our
computed property is working correctly.

```tests/unit/service/some-thing-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Service | some thing', function(hooks) {
  setupTest(hooks);

  test('should correctly concat foo', function(assert) {
    const someThing = this.owner.lookup('service:some-thing');
    someThing.set('foo', 'baz');

    assert.equal(someThing.get('computedFoo'), 'computed baz');
  });
});
```

See that first, we are creating a new testing module using the [`QUnit.module`](http://api.qunitjs.com/QUnit/module) function.
This will scope all of our tests together into one group that can be configured
and run independently from other modules defined in our test suite.
Also, we have used `setupTest`, one of the several test helpers provided by [ember-qunit](https://github.com/emberjs/ember-qunit).
The `setupTest` helper provides us with some conveniences, such as the `this.owner` object, that helps us to create or lookup objects
which are needed to setup our test.
In this example, we use the `this.owner` object to lookup the service instance that becomes our test subject: `someThing`.
Note that in a unit test you can customize any object under test by setting its properties accordingly.
We can use the `set` method of the test object to achieve this.

### Testing Object Methods

Next let's look at testing logic found within an object's method. In this case
the `testMethod` method alters some internal state of the object (by updating
the `foo` property).

```app/services/some-thing.js
import Service from '@ember/service';

export default Service.extend({
  foo: 'bar',

  testMethod() {
    this.set('foo', 'baz');
  }
});
```

To test it, we create an instance of our class `SomeThing` as defined above,
call the `testMethod` method and assert that the internal state is correct as a
result of the method call.

```tests/unit/services/some-thing-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Service | some thing', function(hooks) {
  setupTest(hooks);

  test('should update foo on testMethod', function(assert) {
    const someThing = this.owner.lookup('service:some-thing');

    someThing.testMethod();

    assert.equal(someThing.get('foo'), 'baz');
  });
});
```

In case the object's method returns a value, you can simply assert that the
return value is calculated correctly. Suppose our object has a `calc` method
that returns a value based on some internal state.

```app/services/some-thing.js
import Service from '@ember/service';

export default Service.extend({
  count: 0,

  calc() {
    this.incrementProperty('count');
    let count = this.get('count');

    return `count: ${count}`;
  }
});
```

The test would call the `calc` method and assert it gets back the correct value.

```tests/unit/services/some-thing-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Service | some thing', function(hooks) {
  setupTest(hooks);

  test('should return incremented count on calc', function(assert) {
    const someThing = this.owner.lookup('service:some-thing');

    assert.equal(someThing.calc(), 'count: 1');
    assert.equal(someThing.calc(), 'count: 2');
  });
});
```

### Testing Observers

Suppose we have an object that has a property and a method observing that property.

```app/services/some-thing.js
import Service from '@ember/service';
import { observer } from "@ember/object";

export default Service.extend({
  foo: 'bar',
  other: 'no',

  doSomething: observer('foo', function() {
    this.set('other', 'yes');
  })
});
```

In order to test the `doSomething` method we create an instance of `SomeThing`,
update the observed property (`foo`), and assert that the expected effects are present.

```tests/unit/services/some-thing-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Service | some thing', function(hooks) {
  setupTest(hooks);

  test('should set other prop to yes when foo changes', function(assert) {
    const someThing = this.owner.lookup('service:some-thing');

    someThing.set('foo', 'baz');
    assert.equal(someThing.get('other'), 'yes');
  });
});
```

### Skipping tests

Some times you might be working on a feature, but know that a certain test will fail so you might want to skip it.
You can do it by using `skip`:

```javascript
import { test, skip } from 'qunit';

test('run this test', function(assert) {
    assert.ok(true)
});

skip('skip this test', function(assert) {
    assert.ok(true)
});
```
