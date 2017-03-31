今のところ、アプリケーションは、賃貸物件のリストとして`rentals` route (ルート) ハンドラに定義したとハードコードデータを使います。 アプリケーションが育つと、私たちはサーバに賃貸物件のデータを永続化したくなります。そして、クエリーするなどの高度なデータ操作を容易に行えるようにします。

Emberには、[Ember Data](https://github.com/emberjs/data)というデータ管理ライブラリが付属し、永続的なアプリケーションデータを処理します。

Ember Dataでは、[`DS.Model`](http://emberjs.com/api/data/classes/DS.Model.html)を拡張することによって、アプリケーションに提供したいデータの構造を定義する必要があります。.

Ember CLI を使ってEmber Dataモデルを生成できます。 これから作るモデルを`rental`と呼ぶことにしましょう。これを生成するには、次のようにします。

```shell
ember g model rental
```

コマンドを実行すると、モデルファイルとテストファイルを作成します。

```shell
installing model
  create app/models/rental.js
installing model-test
  create tests/unit/models/rental-test.js
```

When we open the model file, we can see a blank class extending [`DS.Model`](http://emberjs.com/api/data/classes/DS.Model.html):

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />では、rentalオブジェクトの構造を定義しましょう。JavaScriptオブジェクトの配列にハードコードして[ここまで使ってきた](../model-hook/) 賃貸物件の属性を使います。定義する属性は _title_、 _owner_、 _city_、 _type_、 _image_、 _bedrooms_ 、 _description_になります。
    関数 [`DS.attr()`](http://emberjs.com/api/data/classes/DS.html#method_attr) の結果を与えることによって、属性を定義します。
    Ember Dataの属性についての詳細は、ガイドの[属性を定義する](../../models/defining-models/#toc_defining-attributes) セクションを参照してください。
    
    ```app/models/rental.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      title: DS.attr(),
      owner: DS.attr(),
      city: DS.attr(),
      type: DS.attr(),
      image: DS.attr(),
      bedrooms: DS.attr(),
      description: DS.attr()
    });
    

We now have a model object that we can use for our Ember Data implementation.

### Model Hook (モデルフック)の更新

新しいEmber Dataモデルオブジェクトを使用するには、ルートハンドラで[以前に定義した](../model-hook/) `model`関数を更新する必要があります。 ハードコードされたJavaScript配列を削除して、[Ember Data storeサービス](../../models/#toc_the-store-and-a-single-source-of-truth)への次の呼び出しに置き換えてください。 [storeサービス](http://emberjs.com/api/data/classes/DS.Store.html)はEmberのすべてのルートとコンポーネントにインジェクトされています。 storeはEmber Dataとやりとりするために使用する主要なインターフェイスです。 今回は、storeの[`findAll`](http://emberjs.com/api/data/classes/DS.Store.html#method_findAll)関数を呼び出して、新しく作成されたrentalモデルクラスの名前を設定します。

```app/routes/rentals.js{+5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30,-31,-32,-33} import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('rental'); return [{ id: 'grand-old-mansion', title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg', description: "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests." }, { id: 'urban-living', title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg', description: "A commuters dream. This rental is within walking distance of 2 bus stops and the Metro." }, { id: 'downtown-charm', title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg', description: "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet." }]; } }); ```

When we call `findAll`, Ember Data will attempt to fetch rentals from `/api/rentals`. If you recall, in the section titled [Installing Addons](../installing-addons/) we set up an adapter to route data requests through `/api`.

Ember Dataの詳細については[モデルセクション](../../models/)を確認してください。.

Since we have already set up Ember Mirage in our development environment, Mirage will return the data we requested without actually making a network request.

When we deploy our app to a production server, we will likely want to replace Mirage with a remote server for Ember Data to communicate with for storing and retrieving persisted data. A remote server will allow for data to be shared and updated across users.