有时候，一个计算属性的值依赖数组元素的属性。 比如，你有一个包含todo的数组，你想根据数组元素的`isDone`属性计算todo是否完成。

为了完成这个需求，Ember提供了`@each`，如下代码段：

```app/components/todo-list.js export default Ember.Component.extend({ todos: null,

init() { this.set('todos', [ Ember.Object.create({ isDone: true }), Ember.Object.create({ isDone: false }), Ember.Object.create({ isDone: true }), ]); },

incomplete: Ember.computed('todos.@each.isDone', function() { var todos = this.get('todos'); return todos.filterBy('isDone', false); }) });

    <br />对于键`todos.@each.isDone`只要出发下列的任何一个事件都会自动更新计算属性值以及触发观察者。
    
    
    1. 在todos数组中任意一个对象的isDone属性值发生变化的时候；
    2. 往todos数组新增元素的时候；
    3. 往todos数组新增元素的时候；
    4. 在组件中todos数组被改变为其他的数组的时候；
    
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
// 结果为 1
```

If we change the todo's `isDone` property, the `incomplete` property is updated automatically:

```javascript
let todos = todoListComponent.get('todos');
let todo = todos.objectAt(1);
todo.set('isDone', true);

todoListComponent.get('incomplete.length');
// 结果为0

todo = Ember.Object.create({ isDone: false });
todos.pushObject(todo);

todoListComponent.get('incomplete.length');
// 结果为1
```

Note that `@each` only works one level deep. You cannot use nested forms like `todos.@each.owner.name` or `todos.@each.owner.@each.name`.

Sometimes you don't care if properties of individual array items change. In this case use the `[]` key instead of `@each`. Computed properties dependent on an array using the `[]` key will only update if items are added to or removed from the array, or if the array property is set to a different array. For example:

```app/components/todo-list.js export default Ember.Component.extend({ todos: null,

init() { this.set('todos', [ Ember.Object.create({ isDone: true }), Ember.Object.create({ isDone: false }), Ember.Object.create({ isDone: true }), ]); },

selectedTodo: null, indexOfSelectedTodo: Ember.computed('selectedTodo', 'todos.[]', function() { return this.get('todos').indexOf(this.get('selectedTodo')); }) });

    <br />上述代码中`indexOfSelectedTodo`依赖于`todos.[]`，所以当你往数组`todos`新增元素的时候回使得计算属性`indexOfSelectedTodo`自动更新，但是当你修饰数组元素的`isDone`属性时并不会使得计算属性`indexOfSelectedTodo`自动更新。
    
    几个 [Ember.computed] (http://emberjs.com/api/classes/Ember.computed.html) 宏利用 '[]' 键来执行常见的用例。 例如，要创建映射从数组的属性计算的属性，您可以使用[Ember.computed.map] (http://emberjs.com/api/classes/Ember.computed.html#method_map) 或自己设计计算的属性:
    
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