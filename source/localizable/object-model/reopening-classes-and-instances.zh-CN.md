一个类只需要定义一次即可。 You can reopen a class and define new properties using the [`reopen()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopen) method.

```javascript
Person.reopen({
  isPerson: true
});

Person.create().get('isPerson'); // true
```

在使用 `reopen()` 时，你也可以重写现有方法并调用 `this._super`.

```javascript
Person.reopen({
  // override `say` to add an ! at the end
  say(thing) {
    this._super(thing + '!');
  }
});
```

`reopen()` 用于添加所有实例之间共享的实例方法和类属性。 `reopen`方法不能往一个类的实例新增属性或方法(不使用原型)。

但当您需要将静态方法或静态属性添加到类本身时你可以使用 [`reopenClass()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopenClass).

```javascript
// add static property to class
Person.reopenClass({
  isPerson: false
});
// override property of existing and future Person instances
Person.reopen({
  isPerson: true
});

Person.isPerson; // false - because it is static property created by `reopenClass`
Person.create().get('isPerson'); // true
```