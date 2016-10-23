Ember はプロジェクトに簡単に追加することのできる、addons (アドオン)の豊かなエコシステムを持っています。Addons (アドオン)は多くの場合、時間を節約し、あなたがあなた自身のプロジェクトに集中することのできる、幅広い機能をプロジェクトに追加します。

addons (アドオン)をブラウズするには、[Ember Observer](https://emberobserver.com/) のサイトをご覧ください。 NPMに公開されている、ember addons (アドオン)をいくつかの基準で点数付けをして、分類し一覧にしています。

Super Rentals には、[ember-cli-tutorial-style](https://github.com/toddjordan/ember-cli-tutorial-style)と[ember-cli-mirage](http://www.ember-cli-mirage.com/)の二つのaddons (アドオン)を活用しています。.

### ember-cli-tutorial-style

Super Rentalsをスタイリングするためにコピーペーストをする代わりに、チュートリアルにCSSを追加する[ember-cli-tutorial-style](https://github.com/ember-learn/ember-cli-tutorial-style)というアドオン作成しました。 addon (アドオン)は`ember-tutorial.css`というファイルを作成して、super-rentalsの`vendor`ディレクトリに置きます。 As Ember CLI runs, it takes the `ember-tutorial` CSS file and puts it in `vendor.css` (which is referenced in `app/index.html`). We can make additional style tweaks to `vendor/ember-tutorial.css`, and the changes will take effect whenever we restart the app.

addon (アドオン)をインストールするために、次のコマンドを実行します。

```shell
ember install ember-cli-tutorial-style
```

Ember addonsは npm パッケージなので `ember install`コマンドで`node_modules` ディレクトリにaddonをインストールし、`package.json` にエントリーを追加します。 必ず、アドオンが正常にインストールした後、サーバーを再起動してください。 サーバーを再起動すると、新しいCSSが組み込まれ、ブラウザウィンドを更新すると、次の事が表示されます:

![super rentals styled homepage](../../images/installing-addons/styled-super-rentals-basic.png)

### ember-cli-mirage

[Mirage](http://www.ember-cli-mirage.com/)はよく利用される、Emberに受入テストを提供する、クライアントHTTPスタビングライブラリーです。 このチュートリアルにおいては、mirage をデータのソースとして使用します。 Mirageにより、開発の段階では、バックエンドサーバーを模倣して、フェイクなデータを利用できるようになります。

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