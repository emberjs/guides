現在、アプリケーションは、`rentals`ルートハンドラの*rentals* を扱うモデルを設定するため、ハードコードされた、データを使用しています。 アプリケーションが大きくなるにつれ、新たなレンタル品を扱ったり、更新をしたり、削除をして、それらの変更をバックエンドのサーバーに保存したいとするでしょう。 この問題を解決するために、Ember は Ember Data という、データの管理を行うライブラリと統合されています。

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

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />Let's add the same attributes for our rental that we used in our hard-coded array of JavaScript objects -
    _title_, _owner_, _city_, _type_, _image_, _bedrooms_ and _description_:
    
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
    

これで、モデルを Ember Data のストア内に保存しています。

### Model Hook (モデルフック)の更新

新しいデータストアを利用するには、route handler (ルートハンドラ)の `model` hook (モデルフック)を更新する必要があります。

```app/routes/rentals.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('rental'); } }); ```

`this.get('store').findAll('rental')`を呼び出すとき、は`/rentals`にGETリクエストを送ります。 Ember Data の詳細については[モデルセクション](../../models/)を確認してください。.

開発環境では Mirage を利用しているので、Mirageは事前にMirageに提供したデータを返します。 プロダクションにアプリケーションをデプロイする際には、実際にEmber Data がやりとりをするバックエンドを構築する必要があります。