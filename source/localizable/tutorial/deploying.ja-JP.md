Ember アプリケーションをデプロイするには、単に出力された`ember build` をweb サーバーに転送します。 転送は標準的なUnixのファイル転送ツール、`rsync` や `scp`などで行うことが可能です。 また、他にもデプロイを簡略化してくれる、サービスも存在します。

## Scpコマンドでのデプロイ

出力された`ember build` をwebサーバーにコピーすることで、あらゆるサーバーに対してアプリケーションをデプロイすることが可能です:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Surge.sh へのデプロイ

[ Surge.sh](http://surge.sh/)はフリーで任意のフォルダを、webに公開できます。Emberアプリケーションをデプロイするには、単に`ember build`によって生成されたフォルダーをデプロイするだけです。.

Surge.shにデプロイするには、以下のようにsurge cliツールをインストールしておく必要があります。

```shell
npm install -g surge
```

そうすれば、アプリケーションをデプロイするための`surge`コマンドが使用できます。その際、Emberのクライアントサイドのルーティングを可能にするために、index.htmlを200.htmlというファイル名に変更しなくてはならないことに注意してください。

```shell
ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

上記ではfunny-name.surge.shを選択しましたが、まだ使用されていない任意のサブドメインを使うことができます。あるいは、DNSをsurgeのあるサーバーに向けることで、あなたが所有するカスタムドメインを使うこともできます。 第2引数が省略された場合には、Surgeは適当なサブドメインを提示します。

変更した後に同じURLにデプロイするには、同じ手順に従って、ドメインを再利用します。

```shell
rm -rf dist
ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

ここでは`--environment=development`を設定して、Mirageが引き続きmock ファイクデータを利用できるようにします。 しかし、一般的には`ember build --environment=production`を利用して、プロダクションで利用できるようコードを生成します。

## サーバー

### Apache

Apacheサーバーでは、Emberのルーティングが正しく動作するためにrewriteエンジン (mod-rewrite) を有効にする必要があります。 もしメインのURLとして動かすつもりでdistフォルダーをアップロードしたけれども、'{main URL}/example'などのルートに行くと404が返ってくるようなら、サーバーには「フレンドリー」URLが設定されていません。

これを修正するには、ウェブサイトのrootディレクトリに「.htaccess」というファイルを追加し、以下の内容を記述してください。

```text
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) index.html [L]
</IfModule>
```

サーバーの構成は異なる可能性があるので、異なるオプションが必要となるかもしれません。 詳細については [Apache の URL 書き換えガイド](http://httpd.apache.org/docs/2.0/misc/rewriteguide.html) を参照してください。