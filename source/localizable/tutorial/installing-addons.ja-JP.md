Emberは、プロジェクトに簡単に追加できる、豊富なaddons (アドオン)のエコシステムを持っています。addons (アドオン)は幅広い機能をプロジェクトに追加することで、多くの場合、時間を節約し、あなたをあなた自身のプロジェクトに集中できるようにしてくれます。

addon (アドオン)のリストを閲覧するには、[Ember Observer](https://emberobserver.com/) のWebサイトへ行ってください。 サイトへ行くと、NPMに公開されている ember addon (アドオン)が分類されて閲覧できるようになっています。addon (アドオン)は、いくつかの基準で点数付けがされています。

Super Rentals では、[ember-cli-tutorial-style](https://github.com/toddjordan/ember-cli-tutorial-style)と[ember-cli-mirage](http://www.ember-cli-mirage.com/)という、二つのaddon (アドオン)を活用します。.

### ember-cli-tutorial-style

Super RentalsにスタイルをあてるためにCSSをコピーペーストをする代わりに、私たちは[ember-cli-tutorial-style](https://github.com/ember-learn/ember-cli-tutorial-style)という addon (アドオン) を作成し、チュートリアルにすぐにCSSを追加できるようにしました。 addon (アドオン)は、`ember-tutorial.css`というファイルを作成し、super-rentalsの`vendor`ディレクトリの下にそのファイルを置きます。 Ember CLI は実行されると、`ember-tutorial` CSS ファイルを(`/app/index.html`が参照している)`vendor.css`に差し込みます。 追加のスタイルを微調整するには、`vendor/ember-tutorial.css`を変更します。変更はアプリケーションを再起動することで有効になります。

addon (アドオン)をインストールするために、次のコマンドを実行します。

```shell
ember install ember-cli-tutorial-style
```

Ember addon (アドオン) は npm パッケージです。なので、`ember install`コマンドをすると、`node_modules` ディレクトリにインストールされ、`package.json` にエントリーが追加されます。 addon (アドオン)のインストールに成功したら、必ずサーバーを再起動してください。 サーバーを再起動すると、新しいCSSが組み込まれます。ブラウザのウィンドウを更新すると、次のような表示になるはずです。

![super rentals styled homepage](../../images/installing-addons/styled-super-rentals-basic.png)

### ember-cli-mirage

[Mirage](http://www.ember-cli-mirage.com/)は、クライアントHTTPスタブライブラリーで、Emberの受入テストでよく利用されます。 このチュートリアルでは、データソースとして Mirage を使用します。 Mirageを使い、開発中のアプリケーション用に偽のデータを生成し、バックエンドサーバーを模倣します。

Mirage addon (アドオン)を次の手順でインストールしてください:

```shell
ember install ember-cli-mirage
```

もし、別のシェルで`ember serve` を実行していた場合は、ビルドにMirageを含めるために、サーバーを再起動します。

Let's now configure Mirage to send back our rentals that we had defined above by updating `mirage/config.js`:

```mirage/config.js
export default function() {
  this.namespace = '/api';

  this.get('/rentals', function() {
    return {
      data: [{
        type: 'rentals',
        id: 'grand-old-mansion',
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
        id: 'urban-living',
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
        id: 'downtown-charm',
        attributes: {
          title: 'Downtown Charm',
          owner: 'Violet Beauregarde',
          city: 'Portland',
          type: 'Apartment',
          bedrooms: 3,
          image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg'
        }
      }]
    };
  });
}
```

この設定により Mirage は Ember Data が`/api/rentals`にGET リクエストを出すたびに、JSONでJavaScriptオブジェクトを返しますようになります。 In order for this to work, we need our application to default to making requests to the namespace of `/api`. Without this change, navigation to `/rentals` in our application would conflict with Mirage.

To do this, we want to generate an application adapter.

```shell
ember generate adapter application
```

このアダプターは、Ember Data から [`JSONAPIAdapter`](http://emberjs.com/api/data/classes/DS.JSONAPIAdapter.html) 基本クラスを拡張します。

```app/adapters/application.js
import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  namespace: 'api'
});

```