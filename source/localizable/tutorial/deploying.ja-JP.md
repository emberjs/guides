To deploy an Ember application simply transfer the output from `ember build` to a web server. 転送は標準的なUnixのファイル転送ツール、`rsync` や `scp`などで行うことが可能です。 また、他にもデプロイを簡略化してくれる、サービスも存在します。

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

We use `--enviroment=development` here so that Mirage will continue to mock fake data. However, normally we would use `ember build --environment=production` which does more to make your code ready for production.