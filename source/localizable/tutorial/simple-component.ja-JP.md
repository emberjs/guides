レンタル品をユーザーが閲覧している時に、ユーザーが決断できるように後押しする、いくつかのインタラクティブな選択肢があるのを望んでいるかもしれません。 各レンタル品の画像を表示したり、消したりする機能を追加してみましょう。 これを実現するために、コンポーネントを利用します。

各レンタル品の、動作を管理する`rental-listing` コンポーネントを自動生成しましょう。 すべてのコンポーネント名ダッシュをつけるのは他の HTML 要素との競合の可能性を避けるために必要です。 `rental-listing`は許されていますが、`rental`ではダメです。

```shell
ember g component rental-listing
```

Ember CLI はコンポーネントのための、いくつかのファイルを自動生成します。

```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

コンポーネントは、外見を定義するHandlebarsテンプレート(`app/templates/components/rental-listing.hbs`)と動作を定義するJavaScriptのソースファイル(`app/components/rental-listing.js`) の2つの部分で構成されています。

新規で作成した`rental-listing`コンポーネントはユーザーがレンタル品とどうインタラクションを行うかを管理します。 まず、単一のレンタル品の詳細表示を`index.hbs` テンプレートから`rental-listing.hbs`に移動しましょう。

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}}

    <br />`index.hbs` テンプレートにある古いHTMLを、新たな `rental-listing`コンポーネントの`{{#each}}` ループと置き換えましょう。
    
    ```app/templates/index.hbs
    <h1> Welcome to Super Rentals </h1>
    
    We hope you find exactly what you're looking for in a place to stay.
    
    {{#each model as |rentalUnit|}}
      {{rental-listing rental=rentalUnit}}
    {{/each}}
    

ここでは`rental-listing` コンポーネントをその名称で呼び出しています、そして各`rentalUnit`をコンポーネントの`rental` 属性として割り当てています。

## イメージの表示/非表示

ここで、ユーザーの要求でレンタル品の画像を表示する機能を追加できるようになりっました。

`{{#if}}` ヘルパーを使って、`isImageShowing` がtrueの時のみ表示ようにします。それ以外の時はイメージの表示を切り替えることのできるボタンを表示します。

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}} {{#if isImageShowing}} 

<img src={{rental.image}} alt={{rental.type}} width="500"> {{else}} 

<button>Show image</button> {{/if}}

    <br />`isImageShowing`の値は、コンポーネントのJavaScriptファイル、この場合は`rental-listing.js`から与えられます。
    はじめは画像を非常時にしたいので、プロパティを`false`にして開始します。
    
    ```app/components/rental-listing.js
    export default Ember.Component.extend({
      isImageShowing: false
    });
    

ユーザーがボタンをクリックした時に画像を表示するために、`isImageShowing` の値を`true`に変更するアクションを追加する必要があります。 これを、`imageShow`と呼ぶことにします。

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}} {{#if isImageShowing}} 

<img src={{rental.image}} alt={{rental.type}} width="500"> {{else}} <button {{action "imageshow"}}>Show image</button> {{/if}}

    <br />このボタンをクリックすると、コンポーネントにこのアクションが送られます。
    そうするとEmber は`actions`ハッシュに推移し、`imageShow` ファンクションを呼び出します。
    コンポーネントの`imageShow` ファンクションを作って `isImageShowing` を `true` にしましょう。
    
    ```app/components/rental-listing.js
    export default Ember.Component.extend({
      isImageShowing: false,
      actions: {
        imageShow() {
          this.set('isImageShowing', true);
        }
      }
    });
    

ここで、ブラウザでボタンをクリックすると、画像を確認することができます。

ユーザーが画像を非表示にすることができるように、テンプレート内に`imageHide`アクションのボタンを追加します。

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}} {{#if isImageShowing}} 

<img src={{rental.image}} alt={{rental.type}} width="500"><button {{action "imagehide"}}>Hide image</button> {{else}} <button {{action "imageshow"}}>Show image</button> {{/if}}

    <br />`imageHide`アクションハンドラの `isImageShowing` を `false`に設定します。
    
    ```app/components/rental-listing.js
    export default Ember.Component.extend({
      isImageShowing: false,
      actions: {
        imageShow() {
          this.set('isImageShowing', true);
        },
        imageHide() {
          this.set('isImageShowing', false);
        }
      }
    });
    

ユーザーは"Show image" と "Hide image" ボタンをクリックすることで、イメージの表示/非表示を切り替えることが可能となります。