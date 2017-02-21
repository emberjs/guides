Ember アプリケーションをデプロイするには、単に出力された`ember build` をweb サーバーに転送します。 転送は標準的なUnixのファイル転送ツール、`rsync` や `scp`などで行うことが可能です。 また、他にもデプロイを簡略化してくれる、サービスも存在します。

## Scpコマンドでのデプロイ

出力された`ember build` をwebサーバーにコピーすることで、あらゆるサーバーに対してアプリケーションをデプロイすることが可能です:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Surge.sh へのデプロイ

[ Surge.sh](http://surge.sh/) はフリーで任意のフォルダを、webに公開することができます。Emberアプリケーションは単に`ember build`によって生成されたフォルダーををデプロイすることができます。.

surge cliツールのインストールが事前に完了している必要があります:

```shell
npm install -g surge
```

インストール後、`surge`コマンドでアプリケーションのデプロイが実行可能になります。 surgeがEmberのクライアントサイドでのルーティングをサポートするには、 index.html のコピーを 200.html という名称で提供する必要があることに注意してください。

```shell
ember build --environment=development
cd dist
cp index.html 200.html
surge
```

デプロイの初回時にはデフォルトを承認するために、return キーを押します。`funny-name.surge.sh`等でURLが提供され、そのURLに対して、デプロイを行っていくことができます。

アプリケーションに変更を行い同一のURLにデプロイするには、同一のて実行します、今回はアプリケーションのURLをコマンドのオプションにします。

```shell
rm -rf dist
ember build --environment=development
cd dist
cp index.html 200.html
surge funny-name.surge.sh
```

ここでは`--enviroment=development`を設定して、Mirageが引き続きmock ファイクデータを利用できるようにします。 しかし、一般的には`ember build --environment=production`を利用して、プロダクションで利用できるようコードを生成します。

## サーバー

### Apache

Apacheサーバーでは、Emberのルーティングが正しく動作するためにrewriteエンジン (mod-rewrite) を有効にする必要があります。 もしメインのURLとして動かすつもりでdistフォルダーをアップロードしたけれども、'{main URL}/example'などのルートに行くと404が返ってくるようなら、サーバーは「フレンドリー」URLが設定されていません。 Webサイトのルートフォルダー「.htaccess」(ピリオドから始まり、その前には何も付きません)という名前のファイルが存在していないのなら、この問題を解決するために、それを追加してください。 ファイルには以下の行を追加します。

```text
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) index.html [L]
</IfModule>
```

サーバーの構成が異なる場合には、さまざまなオプションが必要になるかもしれません。があります。詳細については http://httpd.apache.org/docs/2.0/misc/rewriteguide.html を参照してください。