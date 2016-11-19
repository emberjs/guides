賃貸物件のリストを閲覧している際、ユーザーはインタラクティブな選択肢を使って、意思決定に役立てたいと思うかもしれません。 各賃貸物件の画像のサイズを切り替える機能を追加することにしましょう。 これを実現するために、コンポーネントを利用します。

それでは、各賃貸物件の動作を管理する、`rental-listing`コンポーネントを生成していきましょう。 コンポーネント名のdash (-記号)は、HTML要素名との重複を避けるために必須のものです。そのため、`rental-listing`は許容されますが、`rental`は許容されません。

```shell
ember g component rental-listing
```

コマンドを実行すると、Ember CLI はコンポーネント用のファイルをほんのわずか生成します。

```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

画像サイズの切り替えに失敗するテストを実装するところから、始めることにしましょう。

受入テスト用に、賃貸物件のモデルが持っている全ての属性を持つ物件のスタブを作成します。 コンポーネントが最初は`wide`クラス属性なしで描画されることを、アサートするようにします。 そして、画像をクリックすると、その要素に`wide` クラスが追加され、もう一度クリックすると、`wide`クラスが取り除かれるようにします。 画像をCSSセレクタ `.image` で見つけていることに注目してください。.

```tests/integration/components/rental-listing-test.js import { moduleForComponent, test } from 'ember-qunit'; import hbs from 'htmlbars-inline-precompile'; import Ember from 'ember';

moduleForComponent('rental-listing', 'Integration | Component | rental listing', { integration: true });

test('should toggle wide class on click', function(assert) { assert.expect(3); let stubRental = Ember.Object.create({ image: 'fake.png', title: 'test-title', owner: 'test-owner', type: 'test-type', city: 'test-city', bedrooms: 3 }); this.set('rentalObj', stubRental); this.render(hbs`{{rental-listing rental=rentalObj}}`); assert.equal(this.$('.image.wide').length, 0, 'initially rendered small'); this.$('.image').click(); assert.equal(this.$('.image.wide').length, 1, 'rendered wide after click'); this.$('.image').click(); assert.equal(this.$('.image.wide').length, 0, 'rendered small after second click'); });

    <br />コンポーネントは、次の二つの部分で構成されています。
    
    * 見た目を定義する template (テンプレート)(`app/templates/components/rental-listing.hbs`)
    * 振る舞いを定義するJavaScriptのソースファイル(`app/components/rental-listing.js`)
    
    作成した`rental-listing` component (コンポーネント)は、ユーザーが賃貸物件をどのように見て、どう相互作用するかを管理します。
    最初に、それぞれの賃貸物件の物件詳細を`rentals.hbs` テンプレートから `rental-listing.hbs`に移動しましょう。そして、画像のフィールドを追加しましょう。
    
    ```app/templates/components/rental-listing.hbs{+2}
    <article class="listing">
      <img src="{{rental.image}}" alt="">
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
    

それでは、`rentals.hbs` template (テンプレート)にこれまであったHTMLマークアップを、`rental-listing` component (コンポーネント)の`{{#each}}` ループに置き換えます。

```app/templates/rentals.hbs{+12,+13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29} 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Welcome!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay.
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

    ここでは、`rental-listing` component (コンポーネント)を名前で呼び出しています。そして、各`rentalUnit`をcomponent (コンポーネント)の`rental`属性として割り当てています。
    
    ## 画像の表示と非表示
    
    これで、ユーザーからの要求によって賃貸物件画像を表示する機能を追加できるようになりました。
    
    `{{#if}}` helper (ヘルパー)を使って、`isWide`がtrueのときだけ`wide`クラスを設定することで、現在の賃貸物件画像を大きく表示するようにしてみましょう。 イメージがクリック可能だと示すテキストも追加します。そして、それらをアンカー要素でまとめ`image`クラスを与えることで、テストがそれを見つけられるようにします。
    
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
    

`isWide`の値は、component (コンポーネント)のJavaScriptファイルから与えられます。この場合は、`rental-listing.js`から与えられることになります。 最初は画像は小さい状態にしたいので、属性は`false`に設定します。

```app/components/rental-listing.js{+4} import Ember from 'ember';

export default Ember.Component.extend({ isWide: false });

    <br />ユーザーが画像を拡大できるようにするには、`isWide`を付加するアクションを追加する必要があります。
    `toggleImageSize` アクションを呼び出しましょう。
    
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
    

このアンカー要素をクリックすると、コンポーネントにこのアクションが送られます。 Emberは、`actions`ハッシュに移動し、`toggleImageSize`関数を呼び出します。 `toggleImageSize`関数を作成して、component (コンポーネント)の`isWide` プロパティーを切り替えられるようにしましょう:

```app/components/rental-listing.js{+5,+6,+7,+8,+9} import Ember from 'ember';

export default Ember.Component.extend({ isWide: false, actions: { toggleImageSize() { this.toggleProperty('isWide'); } } }); ```

これで、ブラウザーのリンク`View Larger`をクリックすると、画像が拡大されます、拡大された画像をクリックすると、画像が小さくなります。

![rental listing with expand](../../images/simple-component/styled-rental-listings.png)