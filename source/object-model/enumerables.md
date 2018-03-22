In Ember.js, an enumerable is any object that contains a number of child
objects, and which allows you to work with those children using the
[`MutableArray`](https://emberjs.com/api/ember/release/classes/MutableArray) API. The most common
enumerable in the majority of apps is the native JavaScript array, which
Ember.js extends to conform to the enumerable interface.

By providing a standardized interface for dealing with enumerables,
Ember.js allows you to completely change the way your underlying data is
stored without having to modify the other parts of your application that
access it.

The enumerable API follows ECMAScript specifications as much as
possible. This minimizes incompatibility with other libraries, and
allows Ember.js to use the native browser implementations in arrays
where available.

## Use of Observable Methods and Properties

In order for Ember to observe when you make a change to an enumerable, you need
to use special methods that `MutableArray` provides. For example, if you add
an element to an array using the standard JavaScript method `push()`, Ember will
not be able to observe the change, but if you use the enumerable method
`pushObject()`, the change will propagate throughout your application.

Here is a list of standard JavaScript array methods and their observable
enumerable equivalents:

<table>
  <thead>
    <tr><th>Standard Method</th><th>Observable Equivalent</th></tr>
  </thead>
  <tbody>
    <tr><td>pop</td><td>popObject</td></tr>
    <tr><td>push</td><td>pushObject</td></tr>
    <tr><td>reverse</td><td>reverseObjects</td></tr>
    <tr><td>shift</td><td>shiftObject</td></tr>
    <tr><td>unshift</td><td>unshiftObject</td></tr>
  </tbody>
</table>

Additionally, to retrieve the first and last objects in an array
in an observable fashion, you should use `myArray.get('firstObject')` and
`myArray.get('lastObject')`, respectively.

## API Overview

In the rest of this guide, we'll explore some of the most common enumerable
conveniences. For the full list, please see the [`MutableArray API
reference documentation`](https://emberjs.com/api/ember/release/classes/MutableArray).

### Iterating Over an Enumerable

To enumerate all the values of an enumerable object, use the [`forEach()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/forEach?anchor=forEach)
method:


```javascript
let food = ['Poi', 'Ono', 'Adobo Chicken'];

food.forEach((item, index) => {
  console.log(`Menu Item ${index+1}: ${item}`);
});

// Menu Item 1: Poi
// Menu Item 2: Ono
// Menu Item 3: Adobo Chicken
```

### First and Last Objects

All enumerables expose [`firstObject`](https://emberjs.com/api/ember/release/classes/MutableArray/properties/firstObject?anchor=firstObject) and [`lastObject`](https://emberjs.com/api/ember/release/classes/MutableArray/properties/lastObject?anchor=lastObject) properties
that you can bind to.



```javascript
let animals = ['rooster', 'pig'];

animals.get('lastObject');
//=> "pig"

animals.pushObject('peacock');

animals.get('lastObject');
//=> "peacock"
```

### Map

You can easily transform each item in an enumerable using the
[`map()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/map?anchor=map) method, which creates a new array with results of calling a
function on each item in the enumerable.


```javascript
let words = ['goodbye', 'cruel', 'world'];

let emphaticWords = words.map(item => `${item}!`);
//=> ["goodbye!", "cruel!", "world!"]
```

If your enumerable is composed of objects, there is a [`mapBy()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/mapBy?anchor=mapBy)
method that will extract the named property from each of those objects
in turn and return a new array:


```javascript
import EmberObject from '@ember/object';

let hawaii = EmberObject.create({
  capital: 'Honolulu'
});

let california = EmberObject.create({
  capital: 'Sacramento'
});

let states = [hawaii, california];

states.mapBy('capital');
//=> ["Honolulu", "Sacramento"]
```

### Filtering

Another common task to perform on an enumerable is to take the
enumerable as input, and return an Array after filtering it based on
some criteria.

For arbitrary filtering, use the [`filter()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/filter?anchor=filter) method.  The filter method
expects the callback to return `true` if Ember should include it in the
final Array, and `false` or `undefined` if Ember should not.


```javascript
let arr = [1, 2, 3, 4, 5];

arr.filter((item, index, self) => item < 4);

//=> [1, 2, 3]
```

When working with a collection of Ember objects, you will often want to filter a set of objects based upon the value of some property. The [`filterBy()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/filterBy?anchor=filterBy) method provides a shortcut.


```javascript
import EmberObject from '@ember/object';

Todo = EmberObject.extend({
  title: null,
  isDone: false
});

let todos = [
  Todo.create({ title: 'Write code', isDone: true }),
  Todo.create({ title: 'Go to sleep' })
];

todos.filterBy('isDone', true);

// returns an Array containing only items with `isDone == true`
```

If you only want to return the first matched value, rather than an Array
containing all of the matched values, you can use [`find()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/find?anchor=find) and [`findBy()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/findBy?anchor=findBy),
which work like `filter()` and `filterBy()`, but return only one item.


### Aggregate Information (Every or Any)

To find out whether every item in an enumerable matches some condition, you can
use the [`every()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/every?anchor=every) method:


```javascript
import EmberObject from '@ember/object';

Person = EmberObject.extend({
  name: null,
  isHappy: false
});

let people = [
  Person.create({ name: 'Yehuda', isHappy: true }),
  Person.create({ name: 'Majd', isHappy: false })
];

people.every((person, index, self) => person.get('isHappy'));

//=> false
```

To find out whether at least one item in an enumerable matches some condition,
you can use the [`any()`](https://emberjs.com/api/ember/release/classes/MutableArray/methods/any?anchor=any) method:


```javascript
people.any((person, index, self) => person.get('isHappy'));

//=> true
```

Like the filtering methods, the `every()` and `any()` methods have
analogous `isEvery()` and `isAny()` methods.

```javascript
people.isEvery('isHappy', true); // false
people.isAny('isHappy', true);  // true
```
