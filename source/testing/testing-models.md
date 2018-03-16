_Container testing methods and computed properties follow previous patterns shown
in [Testing Basics] because DS.Model extends Ember.Object._

[Ember Data] Models can be tested in a module that uses the `setupTest` helper.

Let's assume we have a `Player` model that has `level` and `levelName`
attributes. We want to call `levelUp()` to increment the `level` and assign a
new `levelName` when the player reaches level 5.

> You can follow along by generating your own model with `ember generate
> model player`.

```app/models/player.js
import Model from 'ember-data/model';
import { attr } from 'ember-data/model';

export default Model.extend({
  level: attr('number', { defaultValue: 0 }),
  levelName: attr('string', { defaultValue: 'Noob' }),

  levelUp() {
    let newLevel = this.incrementProperty('level');
    if (newLevel === 5) {
      this.set('levelName', 'Professional');
    }
  }
});
```

Now let's create a test which will call `levelUp` on the player when they are
level 4 to assert that the `levelName` changes. We will use `module` together with the `setupTest` helper method:

```tests/unit/models/player-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import { run } from "@ember/runloop";

module('Unit | Model | player', function(hooks) {
  setupTest(hooks);

  // Specify the other units that are required for this test.
  test('should increment level when told to', function(assert) {
    const player = run(() => this.owner.lookup('service:store').createRecord('player'));

    // wrap asynchronous call in run loop
    run(() => player.levelUp());

    assert.equal(player.get('level'), 5, 'level gets incremented');
    assert.equal(player.get('levelName'), 'Professional', 'new level is called professional');
  });
});
```

Also note, how both creating a record and updating properties on the record through the `levelUp` method requires
us to wrap these operations into a `run` function. You can read more the Ember run loop [over here](../../applications/run-loop/).

## Testing Relationships

For relationships you probably only want to test that the relationship
declarations are setup properly.

Assume that a `User` can own a `Profile`.

> You can follow along by generating your own user and profile models with `ember
> generate model user` and `ember generate model profile`.

```app/models/profile.js
import Model from 'ember-data/model';

export default Model.extend({
});
```

```app/models/user.js
import Model from 'ember-data/model';
import { belongsTo } from 'ember-data/model';

export default Model.extend({
  profile: belongsTo('profile')
});
```

Then you could test that the relationship by looking it up on the `user` model which it is part of.

```tests/unit/models/user-test.js
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import { get } from '@ember/object';

module('Unit | Model | user', function(hooks) {
  setupTest(hooks);

  test('should own a profile', function(assert) {
    const User = this.owner.lookup('service:store').modelFor('user');

    // lookup the relationship on the user model
    const relationship = get(User, 'relationshipsByName').get('profile');

    assert.equal(relationship.key, 'profile', 'has relationship with profile');
    assert.equal(relationship.kind, 'belongsTo', 'kind of relationship is belongsTo');
  });
});
```

_Ember Data contains extensive tests around the functionality of
relationships, so you probably don't need to duplicate those tests.  You could
look at the [Ember Data tests] for examples of deeper relationship testing if you
feel the need to do it._

[Ember Data]: https://github.com/emberjs/data
[Testing Basics]: ../unit-testing-basics
[Ember Data tests]: https://github.com/emberjs/data/tree/master/tests
