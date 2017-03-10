## 計算型プロパティ（Computed Properties）とは何か？

計算型プロパティとは、簡単に言うとプロパティとして宣言できる関数です。 計算型プロパティは関数として定義することで作成でき、Emberはそのプロパティが参照された際に自動でその関数を呼び出します。 そして、ユーザーは通常の静的なプロパティと同様にそのプロパティを扱うことができます。

1つ以上の通常のプロパティを使い、それらを計算したり変換することで新しい計算型プロパティの値を作成すると、大変便利です。

### 計算型プロパティを使う

単純な例から始めることにしましょう。

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

ここでは、`firstName`と`lastName`を依存プロパティとして持つ計算型プロパティ、`fullName`を宣言しています。 `fullName`プロパティに初めてアクセスすると、計算型プロパティの背後にある関数 (すなわち宣言時の引数の最後) が実行され、結果がキャッシュされます。 以降の`fullName`へのアクセスは関数呼び出し無しにキャッシュから読み込まれます。 依存するプロパティのいずれかが変更されると、キャッシュが無効になって、次のアクセス時に再び関数が実行されます。

オブジェクトに属するプロパティに依存させたいときは、ブレース展開を使用して、複数の依存キーを設定できます。

```javascript
let obj = Ember.Object.extend({
  baz: {foo: 'BLAMMO', bar: 'BLAZORZ'},

  something: Ember.computed('baz.{foo,bar}', function() {
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  })
});
```

こうすることで、依存するキーがほとんど同じ場合に、記述の重複や冗長さを抑えて、`baz`の先の`foo`と`bar`も監視できます。

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


let captainAmerica = Person.create();
captainAmerica.set('fullName', 'William Burnside');
captainAmerica.get('firstName'); // William
captainAmerica.get('lastName'); // Burnside
```

### 計算型プロパティマクロ

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

計算型プロパティマクロの完全な一覧を確認するには、[APIドキュメント](http://emberjs.com/api/classes/Ember.computed.html)を参照してください。