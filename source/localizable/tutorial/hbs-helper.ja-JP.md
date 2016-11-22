これまでのところ、このアプリケーションはEmber Dataのモデルから、データを直接ユーザーに表示していました。 アプリケーションが成長するにつれ、データをそのまま表示するだけではなく、加工してユーザーに表示したいと思うでしょう。 そのために、EmberにはHandlebarsテンプレートヘルパーがあります。ヘルパーをつかうことで、テンプレート内のデータを装飾（decorate）できます。 それでは、Handlebarsヘルパーを使って、ユーザーが賃貸物件を"standalone" (一戸建て)なのか"Community"(集合住宅)の一部なのかを簡単に確認できるようにしましょう。

まずは、`rental-property-type`ヘルパーを生成します。

```shell
ember g helper rental-property-type
```

このコマンドは二つのファイルを生成します。作られるファイルは、ヘルパーと、それに対応するテストです。

```shell
installing helper
  create app/helpers/rental-property-type.js
installing helper-test
  create tests/unit/helpers/rental-property-type-test.js
```

この新しいヘルパーは、ジェネレーターが自動生成したコードから始まります。

```app/helpers/rental-property-type.js import Ember from 'ember';

export function rentalPropertyType(params/*, hash*/) { return params; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />`rental.type`を渡すように新しい helper (ヘルパー)を使うように`rental-listing` component templateを更新します:
    
    ```app/templates/components/rental-listing.hbs{-11,+12}
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
        <span>Type:</span> {{rental-property-type rental.type}} - {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

理想としては、最初の、賃貸物件として"Type: Standalone - Estate"が表示されます。 実際には、デフォルトのテンプレートヘルパーは`rental.type` の値を返しています。 これを更新して、ヘルパーが配列`communityPropertyTypes`を探してもしプロパティが存在したら `'Community'` または `'Standalone'`を返してようにしましょう。

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]/*, hash*/) { if (communityPropertyTypes.includes(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Handlebars はヘルパーにテンプレートから配列を引数として渡します。 ES2015 のDestructuring assignmentを使って、配列の最初の項目を取り出して、`type`という名称にしています。 これによって、配列`communityPropertyTypes`に`type`が存在するか確認ができるようになります。

ブラウザで確認をすると、最初のレンタル品は"Standalone"として他の2つの項目が"Community"として表示されてるはずです。