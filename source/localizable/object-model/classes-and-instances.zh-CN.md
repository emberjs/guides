当你学了Ember之后，您会看到类似 `Ember.Component.extend()`和 `DS。Model.extend()` 的代码。 在这里，您将了解方法 `extend()` ，以及其他主要Ember对象模型特性。

### 定义类

在*Ember.Object*上调用[`extend()`](http://emberjs.com/api/classes/Ember.Object.html#method_extend)方法即可定义一个Ember类。比如下面的代码：

```javascript
const Person = Ember.Object.extend({
  say(thing) {
    alert(thing);
  }
});
```

定义了一个`Person`类，这个类有一个`say()`方法。

此外可以通过调用 *extend()* 方法，从任何现有的类中创建一个 `subclass`。 例如，您可能想要创建一个Ember内置 [`Ember.Component`](http://emberjs.com/api/classes/Ember.Component.html) 类的子类︰

```app/components/todo-item.js export default Ember.Component.extend({ classNameBindings: ['isUrgent'], isUrgent: true });

    <br />### 重写父类的方法
    
    在子类重写父类的方法，并在方法里调用_super()方法来调用父类中对应的方法触发父类方法的行为。
    
    ```javascript
    const Person = Ember.Object.extend({
      say(thing) {
        alert(`${this.get('name')} says: ${thing}`);
      }
    });
    
    const Soldier = Person.extend({
      say(thing) {
        // this will call the method in the parent class (Person#say), appending
        // the string ', sir!' to the variable `thing` passed in
        this._super(`${thing}, sir!`);
      }
    });
    
    let yehuda = Soldier.create({
      name: 'Yehuda Katz'
    });
    
    yehuda.say('Yes'); // alerts "Yehuda Katz says: Yes, sir!"
    

在某些情况下，在重写父类方法前后可以通过调用`_super()`方法传递参数到父类。

这样做的好处是可以保持父类方法原始的行为不被改变。

一个常见的例子是重写Ember Data序列化方法[`normalizeResponse()`](http://emberjs.com/api/data/classes/DS.JSONAPISerializer.html#method_normalizeResponse) 。

一种传递操作的快捷使用方式，如`...arguments`。

```javascript
normalizeResponse(store, primaryModelClass, payload, id, requestType)  {
  // Customize my JSON payload for Ember-Data
  return this._super(...arguments);
}
```

上面的示例中将原始参数 (在你的自定义代码前返回) 返回给父类，使得父类的其他行为得以正常执行。

### 创建类实例

类定义之后，你可以通过调用*create()*方法创建一个[`类实例`](http://emberjs.com/api/classes/Ember.Object.html#method_create)。 任何方法、 属性和计算属性都可以在类内部定义︰

```javascript
const Person = Ember.Object.extend({
  say(thing) {
    alert(`${this.get('name')} says: ${thing}`);
  }
});

let person = Person.create();

person.say('Hello'); // alerts " says: Hello"
```

当创建实例时，可以通过向 `create()` 方法传递一个可选的哈希来初始化其属性的值︰

```javascript
const Person = Ember.Object.extend({
  helloWorld() {
    alert(`Hi, my name is ${this.get('name')}`);
  }
});

let tom = Person.create({
  name: 'Tom Dale'
});

tom.helloWorld(); // alerts "Hi, my name is Tom Dale"
```

请注意，出于性能方面的考虑，同时调用 `create()` 你不能重新定义实例的计算属性和不应该重新定义现有或定义新的方法。 在调用 `create()`方法 时，您应该只设置简单属性。 如果您需要定义或重新定义方法或计算属性，你应该创建一个新的子类并实例化它。

按照惯例，属性或变量应该使用驼峰式命名，而不是实例。 所以，变量`Person`应该指的是一个类，而`person`应该指的是一个类的实例(通常类`Person`的实例)。 你应该在Ember的应用程序中坚守这些命名约定。

### 初始化实例

当一个新的实例被创建时，会自动调用[`init()`](http://emberjs.com/api/classes/Ember.Object.html#method_init)方法。 当你想在类实例化时候执行某些逻辑在init方法里处理是非常好的方法。

```js
const Person = Ember.Object.extend({
  init() {
    alert(`${this.get('name')}, reporting for duty!`);
  }
});

Person.create({
  name: 'Stefan Penner'
});

// alerts "Stefan Penner, reporting for duty!"
```

如果一个类是Ember框架的子类，比如`Ember.Component`的子类，并且在子类中重写了`init()`方法，此时请务必确保调用了`this._super(...arguments)`方法。 如果你不这样做，父类不能完成重要的初始化工作，在您的应用程序中，你会出现一些不可预知的行为。

对象的所有实例可以共享定义在`Ember.Object`上的任何数组和对象。

```js
const Person = Ember.Object.extend({
  shoppingList: ['eggs', 'cheese']
});

Person.create({
  name: 'Stefan Penner',
  addItem() {
    this.get('shoppingList').pushObject('bacon');
  }
});

Person.create({
  name: 'Robert Jackson',
  addItem() {
    this.get('shoppingList').pushObject('sausage');
  }
});
// They both end up with: ['eggs', 'cheese', 'bacon', 'sausage']
```

为了避免这种行为，Ember鼓励在 `init()`中初始化这些数组和对象属性。这样做可以确保每个实例是唯一。

```js
const Person = Ember.Object.extend({
  init() {
    this.set('shoppingList', ['eggs', 'cheese']);
  }
});

Person.create({
  name: 'Stefan Penner',
  addItem() {
    this.get('shoppingList').pushObject('bacon');
  }
});

Person.create({
  name: 'Robert Jackson',
  addItem() {
    this.get('shoppingList').pushObject('sausage');
  }
});
```

### 访问对象属性

访问对象的属性时，可以使用 [`get ()`](http://emberjs.com/api/classes/Ember.Object.html#method_get) 和 [`set()`](http://emberjs.com/api/classes/Ember.Object.html#method_set) 的访问器方法︰

```js
const Person = Ember.Object.extend({
  name: 'Robert Jackson'
});

let person = Person.create();

person.get('name'); // 'Robert Jackson'
person.set('name', 'Tobias Fünke');
person.get('name'); // 'Tobias Fünke'
```

访问对象属性时请使用这2个访问器方法；否则，属性不会重新计算、 观察器不会被触发，模板不会更新。