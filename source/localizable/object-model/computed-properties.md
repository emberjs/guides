## What are Computed Properties?

In a nutshell, computed properties let you declare functions as properties. You create one by defining a computed property as a function, which Ember will automatically call when you ask for the property. You can then use it the same way you would any normal, static property.

It's super handy for taking one or more normal properties and transforming or manipulating their data to create a new value.

### Computed properties in action

We'll start with a simple example:

```javascript
Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  })
});

var ironMan = Person.create({
  firstName: 'Tony',
  lastName:  'Stark'
});

ironMan.get('fullName'); // "Tony Stark"
```

This declares the function to be a computed property, and the arguments tell Ember that it depends on the `firstName` and `lastName` attributes.

Whenever you access the `fullName` property, this function gets called, and it returns the value of the function, which simply calls `firstName` + `lastName`.

When you want to depend on a property which belongs to an object, you can setup multiple dependent keys by using brace expansion:

```javascript
var obj = Ember.Object.extend({
  baz: {foo: 'BLAMMO', bar: 'BLAZORZ'},

  something: Ember.computed('baz.{foo, bar}') {
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  }
```

This allows you to observe both `foo` and `bar` on `baz` with much less duplication/redundancy
when your dependent keys are mostly similar.

### Chaining computed properties

You can use computed properties as values to create new computed properties. Let's add a `description` computed property to the previous example, and use the existing `fullName` property and add in some other properties:

```javascript
Person = Ember.Object.extend({
  firstName: null,
  lastName: null,
  age: null,
  country: null,

  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  }),

  description: Ember.computed('fullName', 'age', 'country', function() {
    return `${this.get('fullName')}; Age: ${this.get('age')}; Country: ${this.get('country')}`;
  })
});

var captainAmerica = Person.create({
  firstName: 'Steve',
  lastName: 'Rogers',
  age: 80,
  country: 'USA'
});

captainAmerica.get('description'); // "Steve Rogers; Age: 80; Country: USA"
```

### Dynamic updating

Computed properties, by default, observe any changes made to the properties they depend on and are dynamically updated when they're called. Let's use computed properties to dynamically update.

```javascript
captainAmerica.set('firstName', 'William');

captainAmerica.get('description'); // "William Rogers; Age: 80; Country: USA"
```

So this change to `firstName` was observed by `fullName` computed property, which was itself observed by the `description` property.

Setting any dependent property will propagate changes through any computed properties that depend on them, all the way down the chain of computed properties you've created.

### Setting Computed Properties

You can also define what Ember should do when setting a computed property. If you try to set a computed property, it will be invoked with the key (property name), and the value you want to set it to.

```javascript
Person = Ember.Object.extend({
  firstName: null,
  lastName: null,

  fullName: Ember.computed('firstName', 'lastName', {
    get(key) {
      return `${this.get('firstName')} ${this.get('lastName')}`;
    },
    set(key, value) {
      var [firstName, lastName] = value.split(/\s+/);
      this.set('firstName', firstName);
      this.set('lastName',  lastName);
      return value;
    }
  })
});


var captainAmerica = Person.create();
captainAmerica.set('fullName', 'William Burnside');
captainAmerica.get('firstName'); // William
captainAmerica.get('lastName'); // Burnside
```
