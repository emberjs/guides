これまでのところ、このアプリケーションはユーザーに直接Ember Data モデルから データを表示していました。 アプリケーションが成長するにつれ、データをそのまま表示するだけではなく、データを加工してからユーザーに表示したいと思います。 そのために、Ember には Handlebars テンプレートにヘルパーがあり、テンプレーのデータを装飾（decorate）することができます。 handlebars ヘルパーを使って、ユーザーが資産(レンタル品) が "standalone"なのか"Community"の一部なのか簡単に確認できるようにします。

そのために、`rental-property-type`ヘルパーを作っていきましょう。

```shell
ember g helper rental-property-type
```

このコマンドは、ヘルパーと、それに該当するテストの二つのファイルを生成します

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

    <br />`rental-listing`コンポーネントテンプレートを更新して、`rental.type`をヘルパーが引き渡すようにしましょう。
    
    ```app/templates/components/rental-listing.hbs
    <h2>{{rental.title}}</h2>
    <p>Owner: {{rental.owner}}</p>
    <p>Type: {{rental-property-type rental.type}} - {{rental.type}}</p>
    <p>Location: {{rental.city}}</p>
    <p>Number of bedrooms: {{rental.bedrooms}}</p>
    {{#if isImageShowing }}
      <p><img src={{rental.image}} alt={{rental.type}} width="500px"></p>
      <button {{action "imageHide"}}>Hide image</button>
    {{else}}
      <button {{action "imageShow"}}>Show image</button>
    {{/if}}
    

理想としては、最初の、レンタル品のとして"Type: Standalone - Estate"が表示されます。 実際には、デフォルトのテンプレートヘルパーは`rental.type` の値を返しています。 これを更新して、ヘルパーが配列`communityPropertyTypes`を探してもしプロパティが存在したら `'Community'` または `'Standalone'`を返してようにしましょう。

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]/*, hash*/) { if (communityPropertyTypes.contains(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Handlebars はヘルパーにテンプレートから配列を引数として渡します。 ES2015 のDestructuring assignmentを使って、配列の最初の項目を取り出して、`type`という名称にしています。 これによって、配列`communityPropertyTypes`に`type`が存在するか確認ができるようになります。

ブラウザで確認をすると、最初のレンタル品は"Standalone"として他の2つの項目が"Community"として表示されてるはずです。