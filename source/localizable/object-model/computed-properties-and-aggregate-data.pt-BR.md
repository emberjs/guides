Sometimes you have a computed property whose value depends on the properties of items in an array. For example, you may have an array of todo items, and want to calculate the incomplete todo's based on their `isDone` property.

To facilitate this, Ember provides the `@each` key illustrated below:

```app/components/todo-list.js export default Ember.Component.extend({ todos: null,

init() { this.set('todos', [ Ember.Object.create({ isDone: true }), Ember.Object.create({ isDone: false }), Ember.Object.create({ isDone: true }), ]); },

incomplete: Ember.computed('todos.@each.isDone', function() { var todos = this.get('todos'); return todos.filterBy('isDone', false); }) });

    <br />Here, the dependent key `todos.@each.isDone` instructs Ember.js to update bindings
    and fire observers when any of the following events occurs:
    
    1. The `isDone` property of any of the objects in the `todos` array changes.
    2. An item is added to the `todos` array.
    3. An item is removed from the `todos` array.
    4. The `todos` property of the component is changed to a different array.
    
    Ember also provides a computed property macro
    [`computed.filterBy`](http://emberjs.com/api/classes/Ember.computed.html#method_filterBy),
    which is a shorter way of expressing the above computed property:
    
    ```app/components/todo-list.js
    export default Ember.Component.extend({
      todos: null,
    
      init() {
        this.set('todos', [
          Ember.Object.create({ isDone: true }),
          Ember.Object.create({ isDone: false }),
          Ember.Object.create({ isDone: true }),
        ]);
      },
    
      incomplete: Ember.computed.filterBy('todos', 'isDone', false)
    });
    

In both of the examples above, `incomplete` is an array containing the single incomplete todo:

```javascript
import TodoListComponent from 'app/components/todo-list';

let todoListComponent = TodoListComponent.create();
todoListComponent.get('incomplete.length');
// 1
```

If we change the todo's `isDone` property, the `incomplete` property is updated automatically:

```javascript
let todos = todoListComponent.get('todos');
let todo = todos.objectAt(1);
todo.set('isDone', true);

todoListComponent.get('incomplete.length');
// 0

todo = Ember.Object.create({ isDone: false });
todos.pushObject(todo);

todoListComponent.get('incomplete.length');
// 1
```

Note that `@each` only works one level deep. You cannot use nested forms like `todos.@each.owner.name` or `todos.@each.owner.@each.name`.

Sometimes you don't care if properties of individual array items change. In this case use the `[]` key instead of `@each`. Computed properties dependent on an array using the `[]` key will only update if items are added to or removed from the array, or if the array property is set to a different array. For example:

```app/components/todo-list.js export default Ember.Component.extend({ todos: null,

init() { this.set('todos', [ Ember.Object.create({ isDone: true }), Ember.Object.create({ isDone: false }), Ember.Object.create({ isDone: true }), ]); },

selectedTodo: null, indexOfSelectedTodo: Ember.computed('selectedTodo', 'todos.[]', function() { return this.get('todos').indexOf(this.get('selectedTodo')); }) });

    <br />Here, `indexOfSelectedTodo` depends on `todos.[]`, so it will update if we add an item
    to `todos`, but won't update if the value of `isDone` on a `todo` changes.
    
    Several of the [Ember.computed](http://emberjs.com/api/classes/Ember.computed.html) macros
    utilize the `[]` key to implement common use-cases. For instance, to
    create a computed property that mapped properties from an array, you could use
    [Ember.computed.map](http://emberjs.com/api/classes/Ember.computed.html#method_map)
    or build the computed property yourself:
    
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
    

By comparison, using the computed macro abstracts some of this away:

```javascript
const Hamster = Ember.Object.extend({
  excitingChores: Ember.computed.map('chores', function(chore, index) {
    return `CHORE ${index}: ${chore.toUpperCase()}!`;
  })
});
```

The computed macros expect you to use an array, so there is no need to use the `[]` key in these cases. However, building your own custom computed property requires you to tell Ember.js that it is watching for array changes, which is where the `[]` key comes in handy.