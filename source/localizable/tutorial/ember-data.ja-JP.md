今のところ、アプリケーションは、`rentals` route(ルート) ハンドラで*rentals* を扱うため、ハードコードされたデータを使ってモデルを設定しています。 アプリケーションが大きくなるに、新たな賃貸物件を作成・更新・削除をして、それらの変更をバックエンドのサーバーに保存したくなるでしょう。 Emberは、この問題を解決するために、Ember Dataというデータの管理を行うライブラリを統合しています。

それでは、最初のEmber Data モデルとして、`rental`というモデルを作成していきましょう。

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

モデルファイルの中身は次のようになっています。

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />では、JavaScriptオブジェクトの配列としてハードコードしていた際に使っていた、賃貸物件用の属性を追加しましょう。_title_、_owner_、_city_、_type_、_image_、_bedrooms_ 、_description_を追加します。
    
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
    

ここまでで、Ember Data のストア内にモデルが用意されました。

### Model Hook (モデルフック)の更新

新しいデータストアを利用するには、route handler (ルートハンドラ)の `model` hook (モデルフック)を更新する必要があります。

```app/routes/rentals.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('rental'); } }); ```

`this.get('store').findAll('rental')`を呼び出すとき、は`/rentals`にGETリクエストを送ります。 Ember Data の詳細については[モデルセクション](../../models/)を確認してください。.

開発環境では Mirage を利用しているので、事前にMirageに提供したデータが返されます。 プロダクションにアプリケーションをデプロイする際には、実際にEmber Data がやりとりをするバックエンドを構築する必要があります。