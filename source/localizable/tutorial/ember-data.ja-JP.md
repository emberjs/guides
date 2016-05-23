現在、アプリケーションは、`index`ルートハンドラの*rentals* を扱うモデルを設定するため、ハードコードされた、データを使用しています。 アプリケーションが大きくなるにつれ、新たなレンタル品を扱ったり、更新をしたり、削除をして、それらの変更をバックエンドのサーバーに保存したいとするでしょう。 この問題を解決するために、Ember は Ember Data という、データの管理を行うライブラリと統合されています。

では、最初のEmber Data モデル`rental`を作成していきましょう。

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

モデルファイルの中身は

```app/models/rental.js import Model from 'ember-data/model';

export default Model.extend({

});

    <br />賃貸アプリに使う、ハードコードされた配列JavaScript オブジェクトに要素を幾つか追加しましょう。 -
    _title_, _owner_, _city_, _type_, _image_, and _bedrooms_:
    
    ```app/models/rental.js
    import Model from 'ember-data/model';
    import attr from 'ember-data/attr';
    
    export default Model.extend({
      title: attr(),
      owner: attr(),
      city: attr(),
      type: attr(),
      image: attr(),
      bedrooms: attr()
    });
    

これで、モデルを Ember Data のストア内に保存しています。

### Updating the Model Hook

To use our new data store, we need to update the `model` hook in our route handler.

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.store.findAll('rental'); } }); ```

When we call `this.store.findAll('rental')`, Ember Data will make a GET request to `/rentals`. You can read more about Ember Data in the [Models section](../../models/).

Since we're using Mirage in our development environment, Mirage will return the data we've provided. When we deploy our app to a production server, we will need to provide a backend for Ember Data to communicate with.