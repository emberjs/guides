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

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />ハードコードされた、JavaScriptオブジェクトの配列にレンタル品の要素を追加しましょう。
    _title_, _owner_, _city_, _type_, _image_, and _bedrooms_:
    
    ```app/models/rental.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      title: DS.attr(),
      owner: DS.attr(),
      city: DS.attr(),
      type: DS.attr(),
      image: DS.attr(),
      bedrooms: DS.attr()
    });
    

これで、モデルを Ember Data のストア内に保存しています。

## Mirage を Ember Dataから利用

Ember Data はいくつかの方法でデータを保存するように設定できます、しかし多くの場合それらはバックエンドのAPIサーバです。 このチュートリアルでは[Mirage](http://www.ember-cli-mirage.com)を利用します。 これにより、開発の段階では、バックエンドサーバーを模倣して、フェイクなデータを利用できるようになります。

では、Mirageのインストールから始めましょう。

```shell
ember install ember-cli-mirage
```

もし、別のシェルで`ember serve` を実行していた場合は、ビルドにMirageを含めるために、サーバーを再起動します。

では Mirage を上記で定義したレンタル品を返すように `app/mirage/config.js`を更新しましょう。

```app/mirage/config.js export default function() { this.get('/rentals', function() { return { data: [{ type: 'rentals', id: 1, attributes: { title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' } }, { type: 'rentals', id: 2, attributes: { title: 'Urban Living', owner: 'Mike Teavee', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' } }, { type: 'rentals', id: 3, attributes: { title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' } }] }; }); }

    <br />この設定で Mirage は Ember Data が`/rentals`にGET リクエストを出すたびに、JSONでJavaScriptオブジェクトを返します。
    
    ### モデルフックの更新
    
    この新しいデータストアを利用するために、ルートハンドラの`model` フックを更新しなければいけません。
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.store.findAll('rental');
      }
    });
    

`this.store.findAll('rental')`を呼び出すと、 Ember Data は `/rentals`にGET リクエスを送ります。 Ember Data の詳細については[モデルセクション](../../models/)を確認してください。.

開発環境では Mirage を利用しているので、Mirageは事前にMirageに提供したデータを返します。 プロダクションにアプリケーションをデプロイする際には、実際にEmber Data がやりとりをするバックエンドを構築する必要があります。