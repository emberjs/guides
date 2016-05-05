ユーザーが賃貸物件を検索するとき、検索対象を特定の都市に限定に限定することもあるでしょう。 特定の都市で検索したり、入力中に検索候補を出すコンポーネントを作成しましょう。

`filter-listing`という名称の新しいコンポーネントを作成しまう。.

```shell
ember g component filter-listing
```

以前と同じように、このコマンドはHandlebars template (`app/templates/components/filter-listing.hbs`) と JavaScript ファイル (`app/components/filter-listing.js`を作成します。).

Handlebars template はこのようになります。

```app/templates/components/filter-listing.hbs City: {{input value=filter key-up=(action autoComplete filter)}}

<button {{action search filter}}>Search</button>

{{#each filteredList as |item|}} <li {{action 'choose' item.city}}>{{item.city}}</li> {{/each}} 

    <br />template (テンプレート)はtext フィールドを描画する[`{{input}}`](../../templates/input-helpers) helper (ヘルパー)を含んでいます、そこにユーザーが都市名を入力すると、都市名がフィリタされます。 `input`の入力値`value`は`filter` のプロパティと関連付けされます。
    `key-up`プロパティは`autoComplete` action (アクション)と関連付けら、`index` controller (コントローラー)のコンポーネントを渡します。 `autoComplete` action (アクション)は起動時に引数として、`filter` property (プロパティ)を受け取ります。
    
    テンプレートは`search` action (アクション)にバインドされたボタンも含まれています。
    `autoComplete` action (アクション)と同様に、`search` action (アクション)も起動時に`index` controller (コントローラー)から渡され、`filter` property (プロパティ)を受け取ります。
    
    最後に、`filter-listing.hbs` template (テンプレート)は `city` property (プロパティ)の各項目を表示する、component (コンポーネント) に`filteredList` property (プロパティ)の順不同のリストを含んでいます。 リスト アイテムをクリックすると、その都市の名前アイテムをパラメーターとして 'input' のフィールドに入力する、 `city`プロパティの`choose`アクションが発生します。
    
    component (コンポーネント)の JavaScriptは次のようになっています :
    
    ```app/components/filter-listing.js
    export default Ember.Component.extend({
      filter: null,
    
      actions: {
        choose(city) {
          this.set('filter', city);
        }
      }
    });
    

There's a property for each of the `filter` and `filteredList`, and the `choose` action as described above.

Only the `choose` action is defined by the `filter-listing.js` component. Both the `autoComplete` and `search` actions are \[passed\] (../../components/triggering-changes-with-actions/#toc_passing-the-action-to-the-component) in by the calling object. This is a pattern known as *closure actions*.

To see how this works, change your `index.hbs` template to look like this:

```app/templates/index.hbs 

# Welcome to Super Rentals 

We hope you find exactly what you're looking for in a place to stay.   
  


{{filter-listing filteredList=filteredList autoComplete=(action 'autoComplete') search=(action 'search')}}

{{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} {{/each}}

{{#link-to 'about'}}About{{/link-to}} {{#link-to 'contact'}}Click here to contact us.{{/link-to}}

    <br />We've added the `filter-listing.js` component to our `index.hbs` template.
    We then pass in the functions and properties that we want the `filter-listing`
    component to use. The `index` page defines some of the logic for
    how the component should behave, and the component uses those specific
    functions and properties.
    
    For this to work, we need to introduce a `controller` into our app.
    Generate a controller for the `index` page by running the following:
    
    ```shell
    ember g controller index
    

Now, define your new controller like so:

```app/controllers/index.js import Ember from 'ember';

export default Ember.Controller.extend({ filteredList: null, actions: { autoComplete(param) { if (param !== '') { this.get('store').query('rental', { city: param }).then((result) => this.set('filteredList', result)); } else { this.set('filteredList', null); } }, search(param) { if (param !== '') { this.get('store').query('rental', { city: param }).then((result) => this.set('model', result)); } else { this.get('store').findAll('rental').then((result) => this.set('model', result)); } } } });

    <br />As you can see, we define a property in the controller called `filteredList`,
    that is referenced from within the `filter-listing.hbs` template.
    
    When the user types in the text field in our component, the `autoComplete`
    action in the controller is called. This action takes in the `filter`
    property, and filters the `rental` data for records in data store that match
    what the user has typed thus far. The result of the query is set as the
    `filteredList` property, which is used to populate the autocomplete list
    in the component.
    
    We also define a `search` action here that is passed in to the component,
    and called when the search button is clicked. This is slightly different
    in that the result of the query is actually used to update the `model`
    of the `index` route, and that changes the full rental listing on the
    page.
    
    For these actions to work, we need to modify the Mirage `config.js` file
    to look like this, so that it can respond to our queries.
    
    ```mirage/config.js
    export default function() {
      this.get('/rentals', function(db, request) {
        let rentals = [{
            type: 'rentals',
            id: 1,
            attributes: {
              title: 'Grand Old Mansion',
              owner: 'Veruca Salt',
              city: 'San Francisco',
              type: 'Estate',
              bedrooms: 15,
              image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg'
            }
          }, {
            type: 'rentals',
            id: 2,
            attributes: {
              title: 'Urban Living',
              owner: 'Mike Teavee',
              city: 'Seattle',
              type: 'Condo',
              bedrooms: 1,
              image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg'
            }
          }, {
            type: 'rentals',
            id: 3,
            attributes: {
              title: 'Downtown Charm',
              owner: 'Violet Beauregarde',
              city: 'Portland',
              type: 'Apartment',
              bedrooms: 3,
              image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg'
            }
          }];
    
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
    

With these changes, users can search for properties in a given city, with a search field that provides suggestions as they type.