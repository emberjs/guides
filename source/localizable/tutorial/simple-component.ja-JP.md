レンタル品をユーザーが閲覧している時に、ユーザーが決断できるように後押しする、いくつかのインタラクティブな選択肢があるのを望んでいるかもしれません。 各レンタル品の画像を表示したり、消したりする機能を追加してみましょう。 これを実現するために、コンポーネントを利用します。

各レンタル品の、動作を管理する`rental-listing` コンポーネントを自動生成しましょう。 dash (-記号)は各コンポーネントと各HTMLとの重複を避けるために必須です、`rental-listing`は許容されますが、`rental`は許容されません。

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

イメージをタグルする動作を作成するには、まず失敗するテストを実装します。

受入テストには、賃貸物件のモデルが持っている全ての情報を持つ物件のスタブを作成します。 当初は、component (コンポーネント)が`wide` classなしで描画されるようにアサートします。 画像をクリックすると、そのエレメントに`wide` クラスが追加され、もう一度クリックすると、`wide`クラスが取り除かれます。 画像のエレメントをCSSセレクタ `.image` で見つけていることに注意してください。.

```tests/integration/components/rental-listing-test.js import { moduleForComponent, test } from 'ember-qunit'; import hbs from 'htmlbars-inline-precompile'; import Ember from 'ember';

moduleForComponent('rental-listing', 'Integration | Component | rental listing', { integration: true });

test('should toggle wide class on click', function(assert) { assert.expect(3); let stubRental = Ember.Object.create({ image: 'fake.png', title: 'test-title', owner: 'test-owner', type: 'test-type', city: 'test-city', bedrooms: 3 }); this.set('rentalObj', stubRental); this.render(hbs`{{rental-listing rental=rentalObj}}`); assert.equal(this.$('.image.wide').length, 0, 'initially rendered small'); this.$('.image').click(); assert.equal(this.$('.image.wide').length, 1, 'rendered wide after click'); this.$('.image').click(); assert.equal(this.$('.image.wide').length, 0, 'rendered small after second click'); });

    <br />コンポーネントは、外見を定義するつの部分で構成されています:
    
    * 外見を定義する template (テンプレート)(`app/templates/components/rental-listing.hbs`)
    * 動作を定義するJavaScriptのソースファイル(`app/components/rental-listing.js`)
    
    新規で作成した`rental-listing` component (コンポーネント)はユーザーがレンタル品とどうインタラクションを行うかを管理します。
    まず、index.hbs` template (テンプレート)から各賃貸物件の詳細を表示する情報を`rental-listing.hbs` に移動してイメージフィールドを追加します:
    
    ```app/templates/components/rental-listing.hbs{+2}
    <article class="listing">
      <img src="{{rental.image}}" class="image" alt="">
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Type:</span> {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

`index.hbs` template (テンプレート)でそれまでのHTMLマークアップを`rental-listing` component (コンポーネント)　の`{{#each}}` ループを置き換えます。

```app/templates/index.hbs{+13,+14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30} 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Welcome!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay. <br />Browse our listings, or use the search box above to narrow your search.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

{{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} {{#each model as |rental|}} <article class="listing"> 

### {{rental.title}}

<div class="detail owner">
  <span>Owner:</span> {{rental.owner}}
</div>

<div class="detail type">
  <span>Type:</span> {{rental.type}}
</div>

<div class="detail location">
  <span>Location:</span> {{rental.city}}
</div>

<div class="detail bedrooms">
  <span>Number of bedrooms:</span> {{rental.bedrooms}}
</div></article> {{/each}}

    ここでは`rental-listing` component (コンポーネント)をその名称で呼び出しています、そして各`rentalUnit`をcomponent (コンポーネント)の`rental`属性として割り当てています。
    
    ## 画像の表示と非表示
    
    これで、ユーザーの要求でレンタル品の画像を表示する機能を追加できるようになりました。
    
    Let's use the `{{#if}}` helper to show our current rental image larger only when `isWide` is set to true, by setting the element class name to `wide`. We'll also add some text to indicate that the image can be clicked on, and wrap both with an anchor element, giving it the `image` class name so that our test can find it.
    
    ```app/templates/components/rental-listing.hbs{+2,+4,+5}
    <article class="listing">
      <a class="image {{if isWide "wide"}}">
        <img src="{{rental.image}}" alt="">
        <small>View Larger</small>
      </a>
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Type:</span> {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

The value of `isWide` comes from our component's JavaScript file, in this case `rental-listing.js`. Since we want the image to be smaller at first, we will set the property to start as `false`:

```app/components/rental-listing.js import Ember from 'ember';

export default Ember.Component.extend({ isWide: false });

    <br />To allow the user to widen the image, we will need to add an action that toggles the value of `isWide`.
    `toggleImageSize` action (アクション)を呼び出しましょう
    
    ```app/templates/components/rental-listing.hbs{+2}
    <article class="listing">
      <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
        <img src="{{rental.image}}" alt="">
        <small>View Larger</small>
      </a>
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Type:</span> {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

Clicking the anchor element will send the action to the component. Ember will then go into the `actions` hash and call the `toggleImageSize` function. Let's create the `toggleImageSize` function and toggle the `isWide` property on our component:

```app/components/rental-listing.js{+5,+6,+7,+8,+9} import Ember from 'ember';

export default Ember.Component.extend({ isWide: false, actions: { toggleImageSize() { this.toggleProperty('isWide'); } } }); ```

Now when we click the image or the `View Larger` link in our browser, we see our image show larger. When we click the enlarged image we again see it smaller.

![rental listing with expand](../../images/simple-component/styled-rental-listings.png)