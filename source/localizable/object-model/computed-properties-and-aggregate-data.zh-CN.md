有时候，一个计算属性的值依赖数组元素的属性。 比如，你有一个包含todo的数组，你想根据数组元素的`isDone`属性计算todo是否完成。

为了完成这个需求，Ember提供了`@each`，如下代码段：

```app/components/todo-list.js export default Ember.Component.extend({ todos: [ Ember.Object.create({ isDone: true }), Ember.Object.create({ isDone: false }), Ember.Object.create({ isDone: true }) ],

incomplete: Ember.computed('todos.@each.isDone', function() { var todos = this.get('todos'); return todos.filterBy('isDone', false); }) });

    <br />对于键`todos.@each.isDone`只要出发下列的任何一个事件都会自动更新计算属性值以及触发观察者。
    
    
    1. 在todos数组中任意一个对象的isDone属性值发生变化的时候；
    2. 往todos数组新增元素的时候；
    3. 往todos数组新增元素的时候；
    4. 在组件中todos数组被改变为其他的数组的时候；
    
    Ember提供了计算属性宏[`computed.filterBy`](http://emberjs.com/api/classes/Ember.computed.html#method_filterBy)，这是Ember封装好的用于处理计算属性的方法，此方法可以简单的处理上述4点的变化。
    
    ```app/components/todo-list.js
    export default Ember.Component.extend({
      todos: [
        Ember.Object.create({ isDone: true }),
        Ember.Object.create({ isDone: false }),
        Ember.Object.create({ isDone: true })
      ],
    
      incomplete: Ember.computed.filterBy('todos', 'isDone', false)
    });
    

在上述的例子中，`incomplete`是一个包含了一个未完成todo项（`isDone`为`false`）的数组。

```javascript
import TodoListComponent from 'app/components/todo-list';

let todoListComponent = TodoListComponent.create();
todoListComponent.get('incomplete.length');
// 结果为 1
```

如果我们改变 todo的 `isDone` 属性，计算属性`incomplete`会自动更新 ︰

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

请注意，`@each` 仅适用单层属性。比如如 `todos.@each.owner.name` 或 `todos.@each.owner.@each.name`这些用法都是不允许的。.

有时如果你不在乎的各个数组项的属性更改。 在这种情况下使用 `[]` 键而不是 `@each`。 如果计算属性依赖于数组元素个数，可以使用键 `[]`， 只有往数组中添加新元素或从数组中删除元素或数组属性设置为另一个数组时才会出发计算属性变化。 例如：

```app/components/todo-list.js export default Ember.Component.extend({ todos: [ Ember.Object.create({ isDone: true }), Ember.Object.create({ isDone: false }), Ember.Object.create({ isDone: true }) ],

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
    

相比之下，使用计算的宏还有其他方式︰

```javascript
const Hamster = Ember.Object.extend({
  excitingChores: Ember.computed.map('chores', function(chore, index) {
    return `CHORE ${index}: ${chore.toUpperCase()}!`;
  })
});
```

计算的宏希望你能在数组中是用，所以没有必要在这些情况下使用 `[]` 键。 然而，如果是创建自定义计算属性则需要告诉 Ember.js，让Ember监测数组的变化，此时 `[]` 键就派上用场了。