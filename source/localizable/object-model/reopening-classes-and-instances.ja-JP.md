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

`reopen()`は、クラスのすべてのインスタンス間で共有される、インスタンスメソッドやプロパティを追加するために使われます。 普通のJavaScript (プロトタイプを使わない場合) のように、特定のクラスのインスタンスにメソッドやプロパティを追加するものではありません。

静的なメソッドやプロパティをクラス自身に追加する必要がある場合には、[`reopenClass()`](http://emberjs.com/api/classes/Ember.Object.html#method_reopenClass)を使います。.

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