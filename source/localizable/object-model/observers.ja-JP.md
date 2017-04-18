***Note:** Observers are often over-used by new Ember developers. Observers are used heavily within the Ember framework itself, but for most problems Ember app developers face, computed properties are the appropriate solution.*

Ember supports observing any property, including computed properties.

Observers should contain behavior that reacts to changes in another property. Observers are especially useful when you need to perform some behavior after a binding has finished synchronizing.

`Ember.observer`を使うことで、次のようにオブジェクトにオブザーバーを設定できます。

```javascript
Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  }),

  fullNameChanged: Ember.observer('fullName', function() {
    // deal with the change
    console.log(`fullName changed to: ${this.get('fullName')}`);
  })
});

let person = Person.create({
  firstName: 'Yehuda',
  lastName: 'Katz'
});

// observer won't fire until `fullName` is consumed first
person.get('fullName'); // "Yehuda Katz"
person.set('firstName', 'Brohuda'); // fullName changed to: Brohuda Katz
```

計算型プロパティの`fullName`は`firstName`に依存しているので、`firstName`を更新すると`fullName`のオブザーバーが同様に起動します。

### オブザーバーと非同期性

Emberのオブザーバーは現状は非同期です。 これは、監視しているプロパティの一つが変更するとすぐにオブザーバーが起動することを意味しています。 これによって、まだ同期されていないプロパティとの間にバグが混入しやすくなります。

```javascript
Person.reopen({
  lastNameChanged: Ember.observer('lastName', function() {
    // The observer depends on lastName and so does fullName. Because observers
    // are synchronous, when this function is called the value of fullName is
    // not updated yet so this will log the old value of fullName
    console.log(this.get('fullName'));
  })
});
```

この同期動作は、複数のプロパティを監視している際にオブザーバーが複数回起動される状況にもつながります。

```javascript
Person.reopen({
  partOfNameChanged: Ember.observer('firstName', 'lastName', function() {
    // Because both firstName and lastName were set, this observer will fire twice.
  })
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

これらの問題を回避するには、[`Ember.run.once()`](http://emberjs.com/api/classes/Ember.run.html#method_once)を使用する必要があります。 これを使うことで、行わなければならない任意の処理が一度だけ起き、次の実行時には全てのバインディングが同期されることが保証されます。

```javascript
Person.reopen({
  partOfNameChanged: Ember.observer('firstName', 'lastName', function() {
    Ember.run.once(this, 'processFullName');
  }),

  processFullName() {
    // This will only fire once if you set two properties at the same time, and
    // will also happen in the next run loop once all properties are synchronized
    console.log(this.get('fullName'));
  }
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

### オブザーバーとオブジェクトの初期化

オブザーバーはオブジェクトの初期化が完全に終了するまでは起動しません。

もし初期化プロセスの一部としてオブザーバーを起動する必要がある場合は、`set`の副作用に依存はできません。 代わりに、次のように[`Ember.on()`](http://emberjs.com/api/classes/Ember.html#method_on)を使うことで`init`の後にオブザーバーを合わせて実行するように指示します。

```javascript
Person = Ember.Object.extend({
  init() {
    this.set('salutation', 'Mr/Ms');
  },

  salutationDidChange: Ember.on('init', Ember.observer('salutation', function() {
    // some side effect of salutation changing
  }))
});
```

### 使われていない計算型プロパティはオブザーバーを作動させない

計算型プロパティが決して`get()`されないなら、たとえ依存するキーが変更されたとしてもオブザーバーは起動しません。未知の値から別の値に変更する値について考慮できます。

計算型プロパティはほとんどの場合、常に監視されると同時にフェッチされているため、このことは通常アプリケーションに影響しません。 たとえば、計算型プロパティの値を取得し、DOMに置き (あるいはD3などで描画し) 、そのプロパティを監視することで、プロパティが変更されるとDOMが更新されるようにします。

計算型プロパティを監視する必要があるものの現在取得されていない場合には、`init()`メソッドにおいて取得します。

### クラス定義の外側

[`addObserver()`](http://emberjs.com/api/classes/Ember.Object.html#method_addObserver)を使うことで、クラス定義の外側のオブジェクトにオブザーバーをも追加できます。

```javascript
person.addObserver('fullName', function() {
  // deal with the change
});
```