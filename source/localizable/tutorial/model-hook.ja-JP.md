index テンプレートに利用可能なレンタル品のリストを追加してみましょう。 ユーザーがレンタル品の追加、更新、削除などを行うので、レンタルが静的なものではないことは、すでに分かっています。 そのためにレンタル品の情報を保存する*rentals*モデルが必要です。 最初はシンプルに、JavaScript オブジェクトの配列をハードコードします。 のちにアプリケーションのデーターを管理する、Ember Dataを利用して置き換えいきます。

次に示すのが、ホームページが完成した時の姿です。

![スーパー レンタルのレンタル リストとホームページ](../../images/models/super-rentals-index-with-list.png)

In Ember, route handlers are responsible for loading model data. Let's open `app/routes/rentals.js` and add our hard-coded data as the return value of the `model` hook:

```app/routes/rentals.js import Ember from 'ember';

let rentals = [{ id: 'grand-old-mansion', title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' }, { id: 'urban-living', title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' }, { id: 'downtown-charm', title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' }];

export default Ember.Route.extend({ model() { return rentals; } });

    <br />ここでは、`model: function()`と同意義のES6メソッド 簡略構文の `model()`で書いています。
    
    The `model` function acts as a **hook**, meaning that Ember will call it for us during different times in our app.
    The model hook we've added to our `rentals` route handler will be called when a user enters the `rentals` route.
    
    The `model` hook returns our _rentals_ array and passes it to our `rentals` template as the `model` property.
    
    では、テンプレートを見てみましょう。　　
    モデルデータをリストの表示のために利用できます。
    ここでは、別のよく使われる、`{{each}}`と呼ばれる、Handlebarsヘルパーを利用します。
    This helper will let us loop through each of the objects in our model:
    
    ```app/templates/rentals.hbs{+13,+14,+15,+16,+17,+18,+19,+20,+21,+22,+23,+24,+25,+26,+27,+28,+29}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>Welcome!</h2>
      <p>
        We hope you find exactly what you're looking for in a place to stay.
        <br>Browse our listings, or use the search box below to narrow your search.
      </p>
      {{#link-to 'about' class="button"}}
        About Us
      {{/link-to}}
    </div>
    
    {{#each model as |rental|}}
      <article class="listing">
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
    {{/each}}
    

このテンプレートでは、それぞれのモデルオブジェクトを*rental*と呼びます。各レンタル品のプロパティについての情報を一覧として作成します。

これにより、物件を表示できるようになりました、受入テストが通るようになっているはずです。

![list rentals test passing](../../images/model-hook/passing-list-rentals-tests.png)