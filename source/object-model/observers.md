*__Note:__ Observers are often over-used by new Ember developers. Observers are used
heavily within the Ember framework itself, but for most problems Ember app
developers face, computed properties are the appropriate solution.*

Ember supports observing any property, including computed properties.

Observers should contain behavior that reacts to changes in another property.
Observers are especially useful when you need to perform some behavior after a
binding has finished synchronizing.

You can set up an observer on an object by using `observer`:

```javascript
import EmberObject, {
  computed,
  observer
} from '@ember/object';

Person = EmberObject.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  }),

  fullNameChanged: observer('fullName', function() {
    // deal with the change
    console.log(`fullName changed to: ${this.get('fullName')}`);
  })
});

let person = Person.create({
  firstName: 'Yehuda',
  lastName: 'Katz'
});

// observer won't fire until `fullName` is consumed first
person.get('fullName'); // "Yehuda Katz"
person.set('firstName', 'Brohuda'); // fullName changed to: Brohuda Katz
```

Because the `fullName` computed property depends on `firstName`,
updating `firstName` will fire observers on `fullName` as well.

### Observers and asynchrony

Observers in Ember are currently synchronous. This means that they will fire
as soon as one of the properties they observe changes. Because of this, it
is easy to introduce bugs where properties are not yet synchronized:

```javascript
import { observer } from '@ember/object';

Person.reopen({
  lastNameChanged: observer('lastName', function() {
    // The observer depends on lastName and so does fullName. Because observers
    // are synchronous, when this function is called the value of fullName is
    // not updated yet so this will log the old value of fullName
    console.log(this.get('fullName'));
  })
});
```

This synchronous behavior can also lead to observers being fired multiple
times when observing multiple properties:

```javascript
import { observer } from '@ember/object';

Person.reopen({
  partOfNameChanged: observer('firstName', 'lastName', function() {
    // Because both firstName and lastName were set, this observer will fire twice.
  })
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

To get around these problems, you should make use of [`Ember.run.once()`](https://www.emberjs.com/api/ember/release/classes/@ember%2Frunloop/methods/once?anchor=once).
This will ensure that any processing you need to do only happens once, and
happens in the next run loop once all bindings are synchronized:


```javascript
import { observer } from '@ember/object';
import { once } from '@ember/runloop';

Person.reopen({
  partOfNameChanged: observer('firstName', 'lastName', function() {
    once(this, 'processFullName');
  }),

  processFullName() {
    // This will only fire once if you set two properties at the same time, and
    // will also happen in the next run loop once all properties are synchronized
    console.log(this.get('fullName'));
  }
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

### Observers and object initialization

Observers never fire until after the initialization of an object is complete.

If you need an observer to fire as part of the initialization process, you
cannot rely on the side effect of `set`. Instead, specify that the observer
should also run after `init` by using [`Ember.on()`](https://emberjs.com/api/ember/2.15/namespaces/Ember/methods/on?anchor=on):


```javascript
import EmberObject, { observer } from '@ember/object';
import { on } from '@ember/object/evented';

Person = EmberObject.extend({
  init() {
    this.set('salutation', 'Mr/Ms');
  },

  salutationDidChange: on('init', observer('salutation', function() {
    // some side effect of salutation changing
  }))
});
```

### Unconsumed Computed Properties Do Not Trigger Observers

If you never `get()` a computed property, its observers will not fire even if
its dependent keys change. You can think of the value changing from one unknown
value to another.

This doesn't usually affect application code because computed properties are
almost always observed at the same time as they are fetched. For example, you get
the value of a computed property, put it in DOM (or draw it with D3), and then
observe it so you can update the DOM once the property changes.

If you need to observe a computed property but aren't currently retrieving it,
get it in your `init()` method.

### Outside of class definitions

You can also add observers to an object outside of a class definition
using [`addObserver()`](https://www.emberjs.com/api/ember/release/classes/@ember%2Fobject%2Fobservers/methods/addObserver?anchor=addObserver):


```javascript
person.addObserver('fullName', function() {
  // deal with the change
});
```
