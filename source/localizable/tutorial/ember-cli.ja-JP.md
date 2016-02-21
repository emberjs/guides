Ember CLIはEmberのコマンドラインインターフェイスです、標準的なプロジェクトの構造、一連の開発ツール、それにアドオンのシステムを提供しています。 これにより、Ember 開発者はアプリケーションを実行するための構造を開発するのではなく、アプリケーションそのものの開発に焦点を絞ることができます。 コマンドラインで、 `ember --help`を実行するとEmber CLI が提供しているコマンドが表示されます。 さらに、特定のコマンドについて情報確認したい場合は、`ember help <command-name>`と実行してください。.

## 新規アプリケーションの作成

Ember CLI を使って新規のプロジェクトを作るには、`new`コマンドを使います。チュートリアルの次のセクションので利用するために、`super-rentals`を作ります。.

```shell
ember new super-rentals
```

## ディレクトリ構造

`new` コマンドは次のファイルとディレクトリ構造を含んだ、プロジェクトを作成します。

```text
|--app
|--bower_components
|--config
|--dist
|--node_modules
|--public
|--tests
|--tmp
|--vendor

bower.json
ember-cli-build.js
package.json
README.md
testem.json
```

Ember CLI が作成した、ファイルとディレクトリを確認してみましょう。

**app**: この配下にモジュール、コンポーネント、ルート、テンプレートそしてスタイルシートが含まれています。Emberプロジェクトでのコーディングはこの中で行われます。

**bower_components / bower.json**: Bower は依存関係を管理するツールです。 Ember CLI ではフロントエンドのプラグインとコンポーネント(HTML、 CSS、 JavaScript、 など) を管理するために利用しています。 すべてのBowerコンポーネントは`bower_components` ディレクトリにインストールされます。 `bower.json`を開くと自動的にインストールされる、Ember、jQuery、Ember Data と QUnit (テストで利用される)が一連の依存関係を確認できます。 もし、追加のフロントエンドに関する依存関係を(例えばBootstrapなど) を追加すれば`bower_components` にリストアップされるのを確認できます。

**config**: アプリケーションの設定を行う`environment.js` が含まれています。

**dist**: デプロイメント用のアプリケーションをビルドすると、この配下に出力されます。

**node_modules / package.json**: このディレクトリとファイルはnpmに関連しています。 npmはNode.jsのパッケージマネジャーです。 Ember は Node で書かれていて、様々なNode.js モジュールを利用しています。 `Package.json` ファイルは、アプリケーションが利用している、 npm の依存関係を管理しています。追加でインストールしたEmber-CLI add-ons があれば、それもこのリストで管理されます。 `package.json`に乗っているパッケージは、node_modules ディレクトリにインストールされます。

**public**: このディレクトリには、画像ファイルやフォントなどの資産が含まれています。

**vendor**: このディレクトリはBower によって管理されていないフロント エンド (JavaScript、CSS など) の依存関係が行きます。

**tests / testem.json**: アプリケーションの自動テストファイルは、`tests` フォルダーに、`testem.json` にはEmber CLI のテスト ランナー **testem** の設定ファイルがあります。.

**tmp**: Ember CLI の一時ファイルはここにあります。

**ember-cli-build.js**: このファイルには、Ember CLIがどのようにアプリケーションをビルドすべきかが記載されています。

## ES6 モジュール

`app/router.js`を見るとすぐに、あまり馴染みのないコードに気がつくかもしれません。

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType });

Router.map(function() { });

export default Router;

    <br />Ember CLI は ECMAScript 2015 (省略してES2015、または、ES6とも呼ばれる。) モジュールを、コードの整理のために利用しています。
    例えば、`import Ember from 'ember';` という行は、Ember.js ライブラリーを `Ember`という変数で利用できるようにします。 また`import config from
    './config/environment';` は、 `config` という変数でアプリケーションの環境設定を利用できるようにします。 `const` is a way to declare a read-only variable, 
    as to make sure it is not accidentally reassigned elsewhere. At the end of the file,
    `export default Router;` makes the `Router` variable defined in this file available 
    to other parts of the app.
    
    ## Upgrading Ember
    
    Before continuing to the tutorial, make sure that you have the most recent
    version of Ember installed. If the versions of `ember` and `ember-data` in
    `bower.json` are lower than the version number in the upper-left corner of these
    Guides, update the version numbers in `bower.json` and then run `bower install`.
    
    ## The Development Server
    
    Once we have a new project in place, we can confirm everything is working by
    starting the Ember development server:
    
    ```shell
    ember server
    

または、省略された

```shell
ember s
```

ブラウザで `localhost:4200`を開くと、真新しいアプリケーションが、 "Welcome to Ember"　と表示されているが確認できるはずです。