正如其他的框架一样，Ember也有它特有的数据绑定方式，并且可以在任何一个对象上使用绑定。 而然，数据绑定大多数情况都是使用在Ember框架本身，对于开发者最好还是使用计算属性更为简单方便。

创建一个双向绑定的最简单方法是使用 [`computed.alias()`](http://emberjs.com/api/classes/Ember.computed.html#method_alias)，指定路径到另一个对象。

```javascript
wife = Ember.Object.create({
  householdIncome: 80000
});

Husband = Ember.Object.extend({
  householdIncome: Ember.computed.alias('wife.householdIncome')
});

husband = Husband.create({
  wife: wife
});

husband.get('householdIncome'); // 80000

// Someone gets raise.
wife.set('householdIncome', 90000);
husband.get('householdIncome'); // 90000
```

请注意，绑定不会立即更新。 Ember会等待直到程序代码完成运行完成并且是在同步改变之前，所以你可以多次改变计算属性的值。由于绑定是很短暂的所以也不需要担心开销问题。

## 单向绑定

单向绑定只会在一个方向上传播变化，使用 [`computed.oneWay()`](http://emberjs.com/api/classes/Ember.computed.html#method_oneWay)方法实现单向绑定。 通常，单向绑定是一种性能优化，您可以安全地使用一个双向绑定 (这是事实上的单向绑定，如果你只改变一侧)。 有时候单向绑定用于实现特定行为的时候是非常有用的，比如一个可修改的属性与默认属性相同的时候(比如，一个可更改的送货地址生成账单的时候可以与账单地址相同)。

```javascript
user = Ember.Object.create({
  fullName: 'Kara Gates'
});

UserComponent = Ember.Component.extend({
  userName: Ember.computed.oneWay('user.fullName')
});

userComponent = UserComponent.create({
  user: user
});

// Changing the name of the user object changes
// the value on the view.
user.set('fullName', 'Krang Gates');
// userComponent.userName will become "Krang Gates"

// ...but changes to the view don't make it back to
// the object.
userComponent.set('userName', 'Truckasaurus Gates');
user.get('fullName'); // "Krang Gates"
```