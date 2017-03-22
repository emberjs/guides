何らかのバインディング実装を含んでいる大体のフレームワークとは異なり、Ember.jsのバインディングはどのオブジェクトでも使用できます。 つまり、バインディングはEmberフレームワークで最もよく使われているものであり、Emberアプリケーション開発者が直面するほとんどの問題には、計算型プロパティが適切な解決方法だということです。

双方向バインディングを作成する最も簡単な方法は、別のオブジェクトへのパスを指定する[`computed.alias()`](http://emberjs.com/api/classes/Ember.computed.html#method_alias)を使用することです。

```javascript
husband = Ember.Object.create({
  pets: 0
});

Wife = Ember.Object.extend({
  pets: Ember.computed.alias('husband.pets')
});

wife = Wife.create({
  husband: husband
});

wife.get('pets'); // 0

// Someone gets a pet.
husband.set('pets', 1);
wife.get('pets'); // 1
```

バインディングはすぐには更新されないことに注意してください。 Emberは、変更を同期する前に、アプリケーションコードすべての実行が終了するのを待ちます。そのため、あなたは変更が一時的な際でもバインディングのオーバーヘッドを気にすることなく、何回でも変更できます。

## 片方向バインディング

A one-way binding only propagates changes in one direction, using [`computed.oneWay()`](http://emberjs.com/api/classes/Ember.computed.html#method_oneWay). Often, one-way bindings are a performance optimization and you can safely use a two-way binding (which are de facto one-way bindings if you only ever change one side). Sometimes one-way bindings are useful to achieve specific behaviour such as a default that is the same as another property but can be overridden (e.g. a shipping address that starts the same as a billing address but can later be changed)

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