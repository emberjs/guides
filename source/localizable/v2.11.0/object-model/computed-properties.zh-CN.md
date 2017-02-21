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

上述代码声明了计算属性`fullName`，并且这个计算属性依赖于普通属性 `firstName` 和 `lastName` The first time you access the `fullName` property, the function backing the computed property (i.e. the last argument) will be run and the results will be cached. `FullName` 的后续访问将从缓存中读取，而无需调用该函数。 更改依赖项属性的任何导致缓存失效，因此计算属性函数在下次访问时再次运行以获取最新的值。

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

可以用计算属性的值来创建新的计算属性。 前面的示例中添加一个计算属性`description`，使用现有 `fullName` 属性以及添加一些其他属性︰

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

### 动态更新

默认情况下，计算的属性观察他们所依赖的所有属性（包括计算属性），当所依赖的属性发生变化之后会自动触发计算属性的更新，比如下面的代码：

```javascript
captainAmerica.set('firstName', 'William');

captainAmerica.get('description'); // "William Rogers; Age: 80; Country: USA"
```

所以，当属性`firstName`发生改变被计算属性`fullName`观察到使得计算属性值自动更新，由于计算属性`fullName`发生改变又被<0>description</0>观察到，同样的会使得这个计算属性值也自动更新。

设置任意依赖的属性导致的改变，将按照创建的计算属性链，一路向下传播，到所有依赖他们的计算属性。

### 设置计算属性

你还以自定义计算属性的`set`方法，在方法内增加自己的处理逻辑。 如果尝试设置一个计算属性，需要在调用的时候传入键值(属性名)，以及将被设置的值。 你必须从 setter 函数返回新的计算属性预定值。

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
```

### 计算属性宏

某些类型的计算属性是很常见的。Ember提供大量的计算属性宏(通用方法)，用这些宏处理计算属性非常的简便。

在此示例中，提供两种方式判断计算属性值是否于某个值相等︰

```javascript
Person = Ember.Object.extend({
  fullName: 'Tony Stark',

  isIronManLongWay: Ember.computed('fullName', function() {
    return this.get('fullName') === 'Tony Stark';
  }),

  isIronManShortWay: Ember.computed.equal('fullName', 'Tony Stark')
});
```

若要了解更多计算属性宏，请看 [API 文档](http://emberjs.com/api/classes/Ember.computed.html)详细的介绍。