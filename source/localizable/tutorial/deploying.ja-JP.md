Ember アプリケーションをデプロイするには、単に出力された`ember build` をweb サーバーに転送します。 転送は標準的なUnixのファイル転送ツール、`rsync` や `scp`などで行うことが可能です。 また、他にもデプロイを簡略化してくれる、サービスも存在します。

## Scpコマンドでのデプロイ

出力された`ember build` をwebサーバーにコピーすることで、あらゆるサーバーに対してアプリケーションをデプロイすることが可能です:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Surge.sh へのデプロイ

Surge.sh はフリーで任意のフォルダを、webに公開することができます。Emberアプリケーションは単に`ember build`によって生成されたフォルダーををデプロイすることができます。.

surge cliツールのインストールが事前に完了している必要があります:

```shell
npm install -g surge
```

Then you can use the `surge` command to deploy your application. Note you will also need to provide a copy of index.html with the filename 200.html so that surge can support Ember's client-side routing.

```shell
ember build --environment=production
cd dist
cp index.html 200.html
surge
```

Press return to accept the defaults when deploying the first time. You will be provided with a URL in the form `funny-name.surge.sh` that you can use for repeated deployments.

So to deploy to the same URL after making changes, perform the same steps, this time providing the URL for your site:

```shell
rm -rf dist
ember build --environment=production
cd dist
cp index.html 200.html
surge funny-name.surge.sh
```