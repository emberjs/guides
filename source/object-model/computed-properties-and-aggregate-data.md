When a computed property depends on the contents of an array, there are a few
extra methods you'll need to use in order to correctly recognize when the
contents of the array change. Arrays have two special keys you can append to
array properties to track changes on them, `[]` and `@each`.

## `[]`

Sometimes a computed property needs to update when items are added to, removed from, or replaced in an array.
In those cases we can use the `[]` array key to tell the property to update at the right time.
We'll use the familiar todo list for our examples:

```app/components/todo-list.js
import EmberObject, { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  todos: null,

  init() {
    this.set('todos', [
      EmberObject.create({ title: 'Buy food', isDone: true }),
      EmberObject.create({ title: 'Eat food', isDone: false }),
      EmberObject.create({ title: 'Catalog Tomster collection', isDone: true }),
    ]);
  },

  titles: computed('todos.[]', function() {
    let todos = this.get('todos');
    return todos.mapBy('title');
  })
});
```

The dependent key `todos.[]` instructs Ember.js to update bindings
and fire observers when any of the following events occurs:

1. The `todos` property of the component is changed to a different array.
2. An item is added to the `todos` array.
3. An item is removed from the `todos` array.
4. An item is replaced in the `todos` array.

Notably, the computed property will not update if an individual todo is mutated.
For that to happen, we need to use the special `@each` key.

## `@each`

Sometimes you have a computed property whose value depends on the properties of
items in an array. For example, you may have an array of todo items, and want
to calculate the incomplete todo's based on their `isDone` property.

To facilitate this, Ember provides the `@each` key illustrated below:

```app/components/todo-list.js
import EmberObject, { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  todos: null,

  init() {
    this.set('todos', [
      EmberObject.create({ isDone: true }),
      EmberObject.create({ isDone: false }),
      EmberObject.create({ isDone: true }),
    ]);
  },

  incomplete: computed('todos.@each.isDone', function() {
    let todos = this.get('todos');
    return todos.filterBy('isDone', false);
  })
});
```

Here, the dependent key `todos.@each.isDone` instructs Ember.js to update bindings
and fire observers when any of the following events occurs:

1. The `todos` property of the component is changed to a different array.
2. An item is added to the `todos` array.
3. An item is removed from the `todos` array.
4. An item is replaced in the `todos` array.
5. The `isDone` property of any of the objects in the `todos` array changes.

### Multiple Dependent Keys

It's important to note that the `@each` key can be dependent on more than one key.
For example, if you are using `Ember.computed` to sort an array by multiple keys,
you would declare the dependency with braces: `todos.@each.{priority,title}`

### When to use `[]` and `@each`

Both `[]` and `@each` will update bindings when the array is replaced and when the members of the
array are changed.  If you're using `@each` on a particular property, you don't also need to use `[]`:

```javascript
  //specifying both '[]' and '@each' is redundant here
  incomplete: computed('todos.[]', 'todos.@each.isDone', function() {
  ...
  })
```

Using `@each` is more expensive than `[]`, so default to `[]` if you don't actually have to observe property
changes on individual members of the array.

### Computed Property Macros

Ember also provides a computed property macro
[`computed.filterBy`](https://www.emberjs.com/api/ember/release/classes/@ember%2Fobject%2Fcomputed/methods/alias?anchor=filterBy),
which is a shorter way of expressing the above computed property:

```app/components/todo-list.js
import EmberObject, { computed } from '@ember/object';
import { filterBy } from '@ember/object/computed';
import Component from '@ember/component';

export default Component.extend({
  todos: null,

  init() {
    this.set('todos', [
      EmberObject.create({ isDone: true }),
      EmberObject.create({ isDone: false }),
      EmberObject.create({ isDone: true }),
    ]);
  },

  incomplete: filterBy('todos', 'isDone', false)
});
```

In both of the examples above, `incomplete` is an array containing the single incomplete todo:

```javascript
import TodoListComponent from 'app/components/todo-list';

let todoListComponent = TodoListComponent.create();
todoListComponent.get('incomplete.length');
// 1
```

If we change the todo's `isDone` property, the `incomplete` property is updated
automatically:

```javascript
import EmberObject from '@ember/object';

let todos = todoListComponent.get('todos');
let todo = todos.objectAt(1);
todo.set('isDone', true);

todoListComponent.get('incomplete.length');
// 0

todo = EmberObject.create({ isDone: false });
todos.pushObject(todo);

todoListComponent.get('incomplete.length');
// 1
```

Note that `@each` only works one level deep. You cannot use nested forms like
`todos.@each.owner.name` or `todos.@each.owner.@each.name`.

## `[]` vs `@each`

Sometimes you don't care if properties of individual array items change. In this
case use the `[]` key instead of `@each`. Computed properties dependent on an array
using the `[]` key will only update if items are added to or removed from the array,
or if the array property is set to a different array. For example:

```app/components/todo-list.js
import EmberObject, { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  todos: null,

  init() {
    this.set('todos', [
      EmberObject.create({ isDone: true }),
      EmberObject.create({ isDone: false }),
      EmberObject.create({ isDone: true }),
    ]);
  },

  selectedTodo: null,
  indexOfSelectedTodo: computed('selectedTodo', 'todos.[]', function() {
    return this.get('todos').indexOf(this.get('selectedTodo'));
  })
});
```

Here, `indexOfSelectedTodo` depends on `todos.[]`, so it will update if we add an item
to `todos`, but won't update if the value of `isDone` on a `todo` changes.

Several of the [Ember.computed](https://www.emberjs.com/api/ember/release/classes/@ember%2Fobject%2Fcomputed) macros
utilize the `[]` key to implement common use-cases. For instance, to
create a computed property that mapped properties from an array, you could use
[Ember.computed.map](https://www.emberjs.com/api/ember/release/classes/@ember%2Fobject%2Fcomputed/methods/map?anchor=map)
or build the computed property yourself:

```javascript
import EmberObject, { computed } from '@ember/object';

const Hamster = EmberObject.extend({
  excitingChores: computed('chores.[]', function() {
    return this.get('chores').map(function(chore, index) {
      return `CHORE ${index}: ${chore.toUpperCase()}!`;
    });
  })
});

const hamster = Hamster.create({
  chores: ['clean', 'write more unit tests']
});

hamster.get('excitingChores'); // ['CHORE 1: CLEAN!', 'CHORE 2: WRITE MORE UNIT TESTS!']
hamster.get('chores').pushObject('review code');
hamster.get('excitingChores'); // ['CHORE 1: CLEAN!', 'CHORE 2: WRITE MORE UNIT TESTS!', 'CHORE 3: REVIEW CODE!']
```

By comparison, using the computed macro abstracts some of this away:

```javascript
import EmberObject from '@ember/object';
import { map } from '@ember/object/computed';

const Hamster = EmberObject.extend({
  excitingChores: map('chores', function(chore, index) {
    return `CHORE ${index}: ${chore.toUpperCase()}!`;
  })
});
```

The computed macros expect you to use an array, so there is no need to use the
`[]` key in these cases. However, building your own custom computed property
requires you to tell Ember.js that it is watching for array changes, which is
where the `[]` key comes in handy.
