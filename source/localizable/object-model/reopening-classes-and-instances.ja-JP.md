クラスを一度にすべて定義する必要はありません。 [`reopen()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopenClass)メソッドを使うことで、クラスをリオープンして新しいプロパティを定義できます。

```javascript
Person.reopen({
  isPerson: true
});

Person.create().get('isPerson'); // true
```

`reopen()`を使うとき、既存のメソッドをオーバーライドして、その中で`this._super`を呼び出すこともできます。.

```javascript
Person.reopen({
  // `say`をオーバーライドして最後に!をつける
  say(thing) {
    this._super(thing + '!');
  }
});
```

`reopen()`は、クラスのすべてのインスタンス間で共有される、インスタンスメソッドやプロパティを追加するために使われます。 It does not add methods and properties to a particular instance of a class as in vanilla JavaScript (without using prototype).

But when you need to add static methods or static properties to the class itself you can use [`reopenClass()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopenClass).

```javascript
// クラスに静的なプロパティを追加
Person.reopenClass({
  isPerson: false
});
// Personインスタンスのプロパティをオーバーライド
Person.reopen({
  isPerson: true
});

Person.isPerson; // false - これは`reopenClass`によって作成された静的なプロパティなので
Person.create().get('isPerson'); // true
```