物件を検索するとき、ユーザーは特定の都市に絞って検索することもできます。 物件を都市別にフィルタするコンポーネントを作成していきましょう。

まず新しい component (コンポーネント)を作成しましょう。 このcomponent (コンポーネント)に求めるのは、入力によって物件のリストをフィルタすることです。したがって、このcomponent (コンポーネント)の名前は`list-filter`と呼ぶことにします。

```shell
ember g component list-filter
```

前と同じように、このコマンドはHandlebarsテンプレート(`app/templates/components/list-filter.hbs`)とJavaScriptファイル(`app/components/list-filter.js`)、インテグレーションテストファイル(`tests/integration/components/list-filter-test.js`)を生成する。).

それでは、テストを書くことで、何をするのかを考えていきましょう。 フィルタ component (コンポーネント)は、フィルタされたアイテムのリストを、inner template block (内部テンプレートブロック) と呼ばれる、内側で描画されたものに渡す必要があります。 component (コンポーネント) は次の2つのアクションを呼び出すようにします。一つは、フィルタが提供されていないときに、すべてのリストを提供するアクション。もう一つは、都市別にリストを検索するアクションです。

最初のテストでは、準備したすべての都市が表示され、一覧されるオブジェクトがテンプレートからアクセス可能であることを確認します。

都市によるフィルタリング呼び出しは非同期で行われるので、テストではこれを考慮する必要があります。 ここでは、スタブされたアクションからPromiseを戻すことによって[actions](../../components/triggering-changes-with-actions/#toc_handling-action-completion)を活かし、`filterByCity`呼び出しから非同期アクションの完了を処理します。

結果を検証するには、テスト終了時に`wait`呼び出しを追加する必要もあります。 Emberの[wait</code>ヘルパー](../../testing/testing-components/#toc_waiting-on-asynchronous-behavior)は、指定された関数コールバックを実行してテストが終了する前に、すべてのPromiseが解決するのを待ちます。

```tests/integration/components/list-filter-test.js import { moduleForComponent, test } from 'ember-qunit'; import hbs from 'htmlbars-inline-precompile'; import wait from 'ember-test-helpers/wait'; import RSVP from 'rsvp';

moduleForComponent('list-filter', 'Integration | Component | filter listing', { integration: true });

const ITEMS = [{city: 'San Francisco'}, {city: 'Portland'}, {city: 'Seattle'}]; const FILTERED_ITEMS = [{city: 'San Francisco'}];

test('should initially load all listings', function (assert) { // we want our actions to return promises, since they are potentially fetching data asynchronously this.on('filterByCity', (val) => { if (val === '') { return RSVP.resolve(ITEMS); } else { return RSVP.resolve(FILTERED_ITEMS); } });

// with an integration test, you can set up and use your component in the same way your application // will use it. this.render(hbs`{{#list-filter filter=(action 'filterByCity') as |results|}}
      <ul>
      {{#each results as |item|}}
        <li class="city">
          {{item.city}}
        </li>
      {{/each}}
      </ul>
    {{/list-filter}}`);

// the wait function will return a promise that will wait for all promises // and xhr requests to resolve before running the contents of the then block. return wait().then(() => { assert.equal(this.$('.city').length, 3); assert.equal(this.$('.city').first().text().trim(), 'San Francisco'); }); });

    2つ目のテストでは、フィルタの入力テキストがフィルタアクションを実際に適切に呼び出し、表示されたリストを更新することを確認します。
    
    入力フィールドへの`keyUp`イベントを生成してアクションを強制し、1つのアイテムだけが表示されることを検証します。
    
    ```tests/integration/components/list-filter-test.js
    test('should update with matching listings', function (assert) {
      this.on('filterByCity', (val) => {
        if (val === '') {
          return RSVP.resolve(ITEMS);
        } else {
          return RSVP.resolve(FILTERED_ITEMS);
        }
      });
    
      this.render(hbs`
        {{#list-filter filter=(action 'filterByCity') as |results|}}
          <ul>
          {{#each results as |item|}}
            <li class="city">
              {{item.city}}
            </li>
          {{/each}}
          </ul>
        {{/list-filter}}
      `);
    
      // The keyup event here should invoke an action that will cause the list to be filtered
      this.$('.list-filter input').val('San').keyup();
    
      return wait().then(() => {
        assert.equal(this.$('.city').length, 1);
        assert.equal(this.$('.city').text().trim(), 'San Francisco');
      });
    });
    
    

次に、`app/templates/rentals.hbs`ファイルにて、テストに書いたのと同様に、新しく`list-filter`コンポーネントを追加します。 ただ都市を表示するだけでなく、`rental-listing`コンポーネントを使用して、賃貸物件の詳細も表示します。

```app/templates/rentals.hbs 

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

{{#list-filter filter=(action 'filterByCity') as |rentals|}} 

<ul class="results">
  {{#each rentals as |rentalUnit|}} 
  
  <li>
    {{rental-listing rental=rentalUnit}}
  </li> {{/each}}
</ul> {{/list-filter}}

    <br />これで、テストに失敗するようになりました。コンポーネント要素が欲しい気持ちになったので、コンポーネントを実装しましょう。
    単に入力フィールドとブロックへ結果リストを出力する領域を提供するコンポーネントが欲しいので、テンプレートは単純になります。
    
    ```app/templates/components/list-filter.hbs
    {{input value=value key-up=(action 'handleFilterEntry') class="light" placeholder="Filter By City"}}
    {{yield results}}
    

このテンプレートには、テキストフィールドとして表示される[`{{input}}`](../../templates/input-helpers) ヘルパーが含まれています。このテキストフィールドには、検索に使う都市のリストをフィルタするためのパターンを入力できます。 `input`の`value`プロパティは、コンポーネントの`value`プロパティにバインドされます。 `key-up`プロパティは`handleFilterEntry`アクションにバインドされます。

コンポーネントのJavaScriptコードは次のようになります。

```app/components/list-filter.js import Ember from 'ember';

export default Ember.Component.extend({ classNames: ['list-filter'], value: '',

init() { this._super(...arguments); this.get('filter')('').then((results) => this.set('results', results)); },

actions: { handleFilterEntry() { let filterInputValue = this.get('value'); let filterAction = this.get('filter'); filterAction(filterInputValue).then((filterResults) => this.set('results', filterResults)); } }

});

    <br />`init`フックを使って初期リストの値を設定するために、空の値で`filter`アクションを呼び出します。
    `handleFilterEntry`アクションは、入力ヘルパーによって設定された``value`属性に基づいてフィルタアクションを呼び出します。
    
    `filter`アクションは、呼び出し元オブジェクトによって [コンポーネントに渡されます](../../ components/triggering-changes-with-actions/#toc_passing-the-component) 。 これは _クロージャアクション_ として知られているパターンです。
    
    これらのアクションを実装するために、`rentals`コントローラーを作成しましょう。
    コントローラーには、対応するルートのテンプレートに使用可能なアクションとプロパティを含めることができます。
    
    `rentals` route (ルート)用のコントローラを生成するには、次のコマンドを実行します。
    
    ```shell
    ember g controller rentals
    

それでは、新しいコントローラを以下のように定義してください。

```app/controllers/rentals.js import Ember from 'ember';

export default Ember.Controller.extend({ actions: { filterByCity(param) { if (param !== '') { return this.get('store').query('rental', { city: param }); } else { return this.get('store').findAll('rental'); } } } });

    <br />ユーザーがcomponent (コンポーネント)のテキストフィールドに入力すると、コントローラの`filterByCity`アクションが呼び出されます。
    このアクションは`value`プロパティを取り込み、これまでに入力したものと一致するデータストア内の`rental`データにあるレコードをフィルターします。
    クエリの結果は、呼び出し元に返されます。
    
    このアクションを動かすには、Mirageの`config.js`ファイルを次のように置き換えて、クエリに応答できるようにする必要があります。
    
    ```mirage/config.js
    export default function() {
      this.namespace = '/api';
    
      let rentals = [{
          type: 'rentals',
          id: 'grand-old-mansion',
          attributes: {
            title: 'Grand Old Mansion',
            owner: 'Veruca Salt',
            city: 'San Francisco',
            type: 'Estate',
            bedrooms: 15,
            image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg',
            description: "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests."
          } This rental is within walking distance of 2 bus stops and the Metro."
          }
        }, {
          type: 'rentals',
          id: 'downtown-charm',
          attributes: {
            title: 'Downtown Charm',
            owner: 'Violet Beauregarde',
            city: 'Portland',
            type: 'Apartment',
            bedrooms: 3,
            image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg',
            description: "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet."
          }
        }];
    
      this.get('/rentals', function(db, request) {
        if(request.queryParams.city !== undefined) {
          let filteredRentals = rentals.filter(function(i) {
            return i.attributes.city.toLowerCase().indexOf(request.queryParams.city.toLowerCase()) !== -1;
          });
          return { data: filteredRentals };
        } else {
          return { data: rentals };
        }
      });
    }
    

Mirageの設定を更新すると、テストに通るようになるだけでなく、入力すると物件一覧を更新する簡単なフィルタがホーム画面に表示されるようになるはずです。

![home screen with filter component](../../images/autocomplete-component/styled-super-rentals-filter.png)

![passing acceptance tests](../../images/autocomplete-component/passing-acceptance-tests.png)