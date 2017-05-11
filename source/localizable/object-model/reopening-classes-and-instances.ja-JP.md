クラスを一度にすべて定義する必要はありません。 You can reopen a class and define new properties using the [`reopen()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopen) method.

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

`reopen()`は、クラスのすべてのインスタンス間で共有される、インスタンスメソッドやプロパティを追加するために使われます。 普通のJavaScript (プロトタイプを使わない場合) のように、特定のクラスのインスタンスにメソッドやプロパティを追加するものではありません。

静的なメソッドやプロパティをクラス自身に追加する必要がある場合には、[`reopenClass()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopenClass)を使います。.

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