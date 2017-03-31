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

私たちの新しいヘルパーは、ジェネレータが生成した定型コードから始まります。

```app/helpers/rental-property-type.js import Ember from 'ember';

export function rentalPropertyType(params/*, hash*/) { return params; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />`rental-listing` component (コンポーネント) のテンプレートを更新して、新しいhelper (ヘルパー)を使うようにし、`rental.type`を渡しましょう。
    
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
    

理想としては、最初の賃貸物件に"Type: Standalone - Estate"と表示されます。 ですが実際には、デフォルトのテンプレートヘルパーは`rental.type`の値を返しています。 ヘルパーを更新して、プロパティが配列`communityPropertyTypes`の中に存在するか調べ、もし存在したら`'Community'`または`'Standalone'`を返すようにしましょう。

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]) { if (communityPropertyTypes.includes(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Each [argument](https://guides.emberjs.com/v2.12.0/templates/writing-helpers/#toc_helper-arguments) in the helper will be added to an array and passed to our helper. For example, `{{my-helper "foo" "bar"}}` would result in `myHelper(["foo", "bar"])`. Using array [ES2015 destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) assignment, we can name expected parameters within the array. In the example above, the first argument in the template will be assigned to `type`. This provides a flexible, expressive interface for your helpers, including optional arguments and default values.

ブラウザで確認すると、最初の賃貸物件は"Standalone"、他の2つの物件が"Community"と表示されているはずです。