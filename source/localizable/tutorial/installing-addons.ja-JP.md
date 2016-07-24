Ember はプロジェクトに簡単に追加することのできる、addons (アドオン)の豊かなエコシステムを持っています。Addons (アドオン)は多くの場合、時間を節約し、あなたがあなた自身のプロジェクトに集中することのできる、幅広い機能をプロジェクトに追加します。

addons (アドオン)をブラウズするには、[Ember Observer](https://emberobserver.com/) のサイトをご覧ください。 NPMに公開されている、ember addons (アドオン)をいくつかの基準で点数付けをして、分類し一覧にしています。

Super Rentals には、[ember-cli-tutorial-style](https://github.com/toddjordan/ember-cli-tutorial-style)と[ember-cli-mirage](http://www.ember-cli-mirage.com/)の二つのaddons (アドオン)を活用しています。.

### ember-cli-tutorial-style

Super Rentalsをスタイリングするためにコピーペーストをする代わりに、チュートリアルにCSSを追加する[ember-cli-tutorial-style](https://github.com/ember-learn/ember-cli-tutorial-style)というアドオン作成しました。 addon (アドオン)は`ember-tutorial.css`というファイルを作成して、super-rentalsの`vendor`ディレクトリに置きます。 Ember CLI を実行されると、`ember-tutorial`の CSS ファイルは `vendor.css` (`/app/index.html`が参照している)に置かれます。 スタイリングを変更するために`/vendor/ember-tutorial.css`を変更することができます、アプリケーションを再起動するたびに、変更は有効になります。

addon (アドオン)をインストールするために、次のコマンドを実行します。

```shell
ember install ember-cli-tutorial-style
```

Since Ember addons are npm packages, `ember install` installs them in the `node_modules` directory, and makes an entry in `package.json`. Be sure to restart your server after the addon has installed successfully. Restarting the server will incorporate the new CSS and refreshing the browser window will give you this:

![super rentals styled homepage](../../images/installing-addons/styled-super-rentals-basic.png)

### ember-cli-mirage

[Mirage](http://www.ember-cli-mirage.com/)はよく利用される、Emberに受入テストを提供する、クライアントHTTPスタビングライブラリーです。 このチュートリアルにおいては、mirage をデータのソースとして使用します。 Mirageにより、開発の段階では、バックエンドサーバーを模倣して、フェイクなデータを利用できるようになります。

Mirage addon (アドオン)を次の手順でインストールしてください:

```shell
ember install ember-cli-mirage
```

もし、別のシェルで`ember serve` を実行していた場合は、ビルドにMirageを含めるために、サーバーを再起動します。

では Mirage を上記で定義した物件情報を返すように、`/mirage/config.js`を更新しましょう。

```mirage/config.js
export default function() {
  this.get('/rentals', function() {
    return {
      data: [{
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
      }]
    };
  });
}
```

この設定により Mirage は Ember Data が`/rentals`にGET リクエストを出すたびに、JSONでJavaScriptオブジェクトを返しますようになります。