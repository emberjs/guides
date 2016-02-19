index テンプレートに利用可能なレンタル品のリストを追加してみましょう。 ユーザーがレンタル品の追加、更新、削除などを行うので、レンタルが静的なものではないことは、すでに分かっています。 そのためにレンタル品の情報を保存する*rentals*モデルが必要です。 最初はシンプルに、JavaScript オブジェクトの配列をハードコードします。 のちにアプリケーションのデーターを管理する、Ember Dataを利用して置き換えいきます。

次に示すのが、ホームページが完成した時の姿です。

![スーパー レンタルのレンタル リストとホームページ](../../images/models/super-rentals-index-with-list.png)

Emberではルートハンドラが、モデルデータの読み込みを担っています。`app/routes/index.js` を開けて、`model` フックとしてハードコードデータを追加します。

```app/routes/index.js import Ember from 'ember';

var rentals = [{ id: 1, title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' }, { id: 2, title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' }, { id: 3, title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' }];

export default Ember.Route.extend({ model() { return rentals; } });

    <br />ここでは、`model: function()`と同意義のES6メソッド 簡略構文の `model()`で書いています。
    
    `model`ファンクションは**hook**として機能します、つまりアプリケーションの様々なときに、 Ember が呼び出しをすることを意味しています。`index` ルートに追加されたモデルフックは、ユーザーが`index` ルートを入力するたびに呼び出されます。
    
    `model` フックは　配列 our _rentals_ array を`model` プロパティとして`index` テンプレートに渡します。
    
    では、テンプレートを見てみましょう。　　
    モデルデータをリストの表示のために利用できます。
    ここでは、別のよく使われる、`{{each}}`と呼ばれる、Handlebarsヘルパーを利用します。
    このヘルパーはモデルの中のそれぞれのオブジェクトをループで回します。
    
    ```app/templates/index.hbs
    <h1>Welcome to Super Rentals</h1>
    
    <p>We hope you find exactly what you're looking for in a place to stay.</p>
    
    {{#each model as |rental|}}
      <h2>{{rental.title}}</h2>
      <p>Owner: {{rental.owner}}</p>
      <p>Type: {{rental.type}}</p>
      <p>Location: {{rental.city}}</p>
      <p>Number of bedrooms: {{rental.bedrooms}}</p>
    {{/each}}
    
    {{#link-to "about"}}About{{/link-to}}
    {{#link-to "contact"}}Click here to contact us.{{/link-to}}
    

このテンプレートでは、それぞれのモデルオブジェクトを*rental*と呼びます。各レンタル品のプロパティについての情報を一覧として作成します。