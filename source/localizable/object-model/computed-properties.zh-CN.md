## 计算属性是什么？

简而言之，计算属性让你声明的函数作为属性。 你可以创建一个函数作为计算属性，当你获取计算属性值的时候此函数会自动被Ember调用。 你可以像普通的静态属性那样使用计算属性。

计算属性用于获取一个或多个普通属性值以及用于改变或操作他们的数据来创建新值都是非常方便的。

### 在`action`中计算的属性

我们将从一个简单的例子开始︰

```javascript
Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  })
});

let ironMan = Person.create({
  firstName: 'Tony',
  lastName:  'Stark'
});

ironMan.get('fullName'); // "Tony Stark"
```

上述代码声明了计算属性`fullName`，并且这个计算属性依赖于普通属性 `firstName` 和 `lastName` 第一次你访问 计算属性`fullName` ，计算的属性上的函数将被执行(最后一个参数，也是一个函数)并把函数的结果返回，同时这个结果还会被缓存起来。 `FullName` 的后续访问将从缓存中读取，而无需调用该函数。 更改依赖项属性的任何导致缓存失效，因此计算属性函数在下次访问时再次运行以获取最新的值。

当你想要依赖于属于一个对象的属性时，您可以通过使用大括号扩展设置多个相关的参数︰

```javascript
let obj = Ember.Object.extend({
  baz: {foo: 'BLAMMO', bar: 'BLAZORZ'},

  something: Ember.computed('baz.{foo,bar}', function() {
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  })
});
```

请看上述代码，计算属性还允许你监测一个对象 `baz`的多个属性`foo` 和`bar`，当计算属性依赖对象的多个属性时这种方式非常实用。

### 计算属性链

可以用计算属性的值来创建新的计算属性。 Let's add a `description` computed property to the previous example, and use the existing `fullName` property and add in some other properties:

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

let captainAmerica = Person.create({
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

You can also define what Ember should do when setting a computed property. If you try to set a computed property, it will be invoked with the key (property name), and the value you want to set it to. You must return the new intended value of the computed property from the setter function.

```javascript
Person = Ember.Object.extend({
  firstName: null,
  lastName: null,

  fullName: Ember.computed('firstName', 'lastName', {
    get(key) {
      return `${this.get('firstName')} ${this.get('lastName')}`;
    },
    set(key, value) {
      let [firstName, lastName] = value.split(/\s+/);
      this.set('firstName', firstName);
      this.set('lastName',  lastName);
      return value;
    }
  })
});


let captainAmerica = Person.create();
captainAmerica.set('fullName', 'William Burnside');
captainAmerica.get('firstName'); // William
captainAmerica.get('lastName'); // Burnside
```

### Computed property macros

Some types of computed properties are very common. Ember provides a number of computed property macros, which are shorter ways of expressing certain types of computed property.

In this example, the two computed properties are equivalent:

```javascript
Person = Ember.Object.extend({
  fullName: 'Tony Stark',

  isIronManLongWay: Ember.computed('fullName', function() {
    return this.get('fullName') === 'Tony Stark';
  }),

  isIronManShortWay: Ember.computed.equal('fullName', 'Tony Stark')
});
```

To see the full list of computed property macros, have a look at [the API documentation](http://emberjs.com/api/classes/Ember.computed.html)