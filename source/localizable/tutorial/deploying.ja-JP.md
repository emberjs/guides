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

Then you can use the `surge` command to deploy your application. Note you will also need to rename index.html to 200.html to enable Ember's client-side routing.

```shell
ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

We chose funny-name.surge.sh but you may use any unclaimed subdomain you like or use a custom domain that you own and have pointed the DNS to one of surges servers. If the second argument is left blank surge will prompt you with a suggested subdomain.

To deploy to the same URL after making changes, perform the same steps, reusing the same domain as before.

```shell
rm -rf dist
ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

ここでは`--enviroment=development`を設定して、Mirageが引き続きmock ファイクデータを利用できるようにします。 However, normally we would use `ember build --environment=production` which optimizes your application for production.

## サーバー

### Apache

Apacheサーバーでは、Emberのルーティングが正しく動作するためにrewriteエンジン (mod-rewrite) を有効にする必要があります。 If you upload your dist folder, going to your main URL works, but when you try to go to a route such as '{main URL}/example' and it returns 404, your server has not been configured for "friendly" URLs.

To fix this add a file called '.htaccess' to the root folder of your website. Add these lines:

```text
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) index.html [L]
</IfModule>
```

Your server's configuration may be different so you may need different options. Please see http://httpd.apache.org/docs/2.0/misc/rewriteguide.html for more information.