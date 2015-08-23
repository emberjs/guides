Often, you may have a computed property that relies on all of the items in an
array to determine its value. For example, you may want to count all of the
todo items in a controller to determine how many of them are completed.

Here's what that computed property might look like:

```app/controllers/todos.js
export default Ember.Controller.extend({
  todos: [
    Ember.Object.create({ isDone: true }),
    Ember.Object.create({ isDone: false }),
    Ember.Object.create({ isDone: true })
  ],

  remaining: Ember.computed('todos.@each.isDone', function() {
    var todos = this.get('todos');
    return todos.filterBy('isDone', false).get('length');
  })
});
```

Note here that the dependent key (`todos.@each.isDone`) contains the special
key `@each`. This instructs Ember.js to update bindings and fire observers for
this computed property when one of the following four events occurs:

1. The `isDone` property of any of the objects in the `todos` array changes.
2. An item is added to the `todos` array.
3. An item is removed from the `todos` array.
4. The `todos` property of the controller is changed to a different array.

In the example above, the `remaining` count is `1`:

```javascript
import TodosController from 'app/controllers/todos';
todosController = TodosController.create();
todosController.get('remaining');
// 1
```

If we change the todo's `isDone` property, the `remaining` property is updated
automatically:

```javascript
var todos = todosController.get('todos');
var todo = todos.objectAt(1);
todo.set('isDone', true);

todosController.get('remaining');
// 0

todo = Ember.Object.create({ isDone: false });
todos.pushObject(todo);

todosController.get('remaining');
// 1
```

Note that `@each` only works one level deep. You cannot use nested forms like
`todos.@each.owner.name` or `todos.@each.owner.@each.name`.

Sometimes you don't care if properties of individual array items change. In this
case use the `[]` key instead of `@each`. Computed properties dependent on an array
using the `[] key will only update if items are added to or removed from the array,
or if the array property is set to a different array. For example:

```app/controllers/todos.js
export default Ember.Controller.extend({
  todos: [
    Ember.Object.create({ isDone: true }),
    Ember.Object.create({ isDone: false }),
    Ember.Object.create({ isDone: true })
  ],

  selectedTodo: null,
  indexOfSelectedTodo: Ember.computed('selectedTodo', 'todos.[]', function() {
    return this.get('todos').indexOf(this.get('selectedTodo'));
  })
});
```

Here, `indexOfSelectedTodo` depends on `todos.[]`, so it will update if we add an item
to `todos`, but won't update if the value of `isDone` on a `todo` changes.

Several of the [Ember.computed](http://emberjs.com/api/classes/Ember.computed.html) macros 
utilize the `[]` key to implement common use-cases. For instance, to
create a computed property that mapped properties from an array, you could use 
[Ember.computed.map](http://emberjs.com/api/classes/Ember.computed.html#method_map)
or build the computed yourself:

```javascript
const Hamster = Ember.Object.extend({
  excitingChores: Ember.computed('chores.[]', function() {
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
const Hamster = Ember.Object.extend({
  excitingChores: Ember.computed.map('chores', function(chore, index) {
    return `CHORE ${index}: ${chore.toUpperCase()}!`;
  })
});
```

The computed macros expect you to use an array, so there is no need to use the
`[]` key in these cases. However, building your own custom computed property
requires you to tell Ember.js that it is watching for array changes, which is
where the `[]` key comes in handy.
