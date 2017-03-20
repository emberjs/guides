## 計算型プロパティ（Computed Properties）とは何か？

計算型プロパティとは、簡単に言うとプロパティとして宣言できる関数です。 計算型プロパティは関数として定義することで作成でき、Emberはそのプロパティが参照された際に自動でその関数を呼び出します。 そして、ユーザーは通常の静的なプロパティと同様にそのプロパティを扱うことができます。

1つ以上の通常のプロパティを使い、それらを計算したり変換することで新しい計算型プロパティの値を作成すると、大変便利です。

### 計算型プロパティを使う

単純な例から始めることにしましょう。 `firstName`と`lastName`というプロパティを持つ `Person` オブジェクトに、それらのいずれかが変更された時に2つの名前を結合する`fullName`プロパティが欲しいときには、次のようにします。

```javascript
Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: Ember.computed('firstName', 'lastName', function() {
    let firstName = this.get('firstName');
    let lastName = this.get('lastName');

    return `${firstName} ${lastName}`;
  })
});

let ironMan = Person.create({
  firstName: 'Tony',
  lastName:  'Stark'
});
```

ここでは、`firstName`と`lastName`を依存プロパティとして持つ計算型プロパティ、`fullName`を宣言しています。 `fullName`プロパティに初めてアクセスした際に、上記の関数が呼び出されて結果がキャッシュされます。 以降の`fullName`へのアクセスは、関数の呼び出し無しにキャッシュから読み込まれます。 依存するプロパティのいずれかが変更されると、キャッシュが無効になって、次のアクセス時に再び関数が実行されます。

### 同一のオブジェクトへの複数の依存

先ほどの例で、計算型プロパティ`fullName`は2つの異なるプロパティに依存していました。

```javascript
…
  fullName: Ember.computed('firstName', 'lastName', function() {
    let firstName = this.get('firstName');
    let lastName = this.get('lastName');

    return `${firstName} ${lastName}`;
  })
…
```

*ブレース展開*という省略構文を使うことでも依存関係を宣言できます。 依存するプロパティを中かっこ(`{}`) で囲み、カンマで区切ります。

```javascript
…
  fullName: Ember.computed('{firstName,lastName}', function() {
    let firstName = this.get('firstName');
    let lastName = this.get('lastName');

    return `${firstName} ${lastName}`;
  })
…
```

この構文は1つのオブジェクトに複数のプロパティを依存させる場合に特に便利です。たとえば、以下のコードを

```javascript
let obj = Ember.Object.extend({
  baz: {foo: 'BLAMMO', bar: 'BLAZORZ'},

  something: Ember.computed('baz.foo', 'baz.bar', function() {
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  })
});
```

次のように置き換えれます。

```javascript
let obj = Ember.Object.extend({
  baz: {foo: 'BLAMMO', bar: 'BLAZORZ'},

  something: Ember.computed('baz.{foo,bar}', function() {
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  })
});
```

### 計算型プロパティの連鎖

計算型プロパティは新しい計算型プロパティを作成するための値としても使えます。 それでは、前のコード例に`description`という計算型プロパティを追加しましょう。既存の`fullName`プロパティを使い、その他のいくつかのプロパティも追加しましょう。

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

### 動的な更新

計算型プロパティは、標準的に、依存するプロパティに加えられたいかなる変更を監視し、呼び出された際に値を動的に更新します。それでは、計算型プロパティを動的に更新してみましょう。

```javascript
captainAmerica.set('firstName', 'William');

captainAmerica.get('description'); // "William Rogers; Age: 80; Country: USA"
```

ここで、`firstName`への変更は、`description`プロパティによって監視されている、`fullName`計算型プロパティによって監視されていました。

依存しているプロパティが設定されると、変更はそれらに依存している計算型プロパティへと伝播し、依存している計算型プロパティの連鎖の最後まで伝わります。

### 計算型プロパティの設定

計算型プロパティを設定したときにEmberがすべきことを定義することもできます。 計算型プロパティを設定しようとすると、キー (プロパティ名) と設定しようとしている値とともにsetter関数が起動されます。 その際には、戻り値にで計算型プロパティの新しい値を返す必要があります。

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

### 計算型プロパティマクロ

計算型プロパティのいくつかのタイプはとても一般的です。Emberは、ある種類の計算型プロパティをより短く表現する、計算型プロパティのマクロを提供しています。

以下の例で、2つの計算型プロパティは等価です。

```javascript
Person = Ember.Object.extend({
  fullName: 'Tony Stark',

  isIronManLongWay: Ember.computed('fullName', function() {
    return this.get('fullName') === 'Tony Stark';
  }),

  isIronManShortWay: Ember.computed.equal('fullName', 'Tony Stark')
});
```

計算型プロパティマクロの完全な一覧を確認するには、[APIドキュメント](http://emberjs.com/api/classes/Ember.computed.html)を参照してください。