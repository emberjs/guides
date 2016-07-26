Ember CLIはEmberのコマンドラインインターフェイスです。標準的なプロジェクトの構造、一連の開発ツール、それにアドオンのシステムを提供しています。 これにより、Ember 開発者はアプリケーションを実行するための構造を開発するのではなく、アプリケーションそのものの開発に焦点を絞ることができます。 コマンドラインで、 `ember --help`を実行するとEmber CLI が提供しているコマンドが表示されます。 さらに、特定のコマンドについて情報確認したい場合は、`ember help <command-name>`と実行してください。.

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
testem.js
```

Ember CLI が作成した、ファイルとディレクトリを確認してみましょう。

**app**: この配下にモジュール、コンポーネント、ルート、テンプレートそしてスタイルシートが含まれています。Emberプロジェクトでのコーディングはこの中で行われます。

**bower_components / bower.json**: Bower は依存関係を管理するツールです。 Ember CLI ではフロントエンドのプラグインとコンポーネント(HTML、 CSS、 JavaScript、 など) を管理するために利用しています。 すべてのBowerコンポーネントは`bower_components` ディレクトリにインストールされます。 `bower.json`を開くと、Ember、Ember CLI Shims、Ember CLI Test Loader、そしてテストのための QUnit らの自動的にインストールされる、依存関係を確認できます。 Bootstrapなどのフロントエンドの依存関係を追加すれば、それらもリストアップされ`bower_components`ディレクトリに追加されます。

**config**: アプリケーションの設定を行う`environment.js` が含まれています。

**dist**: デプロイメント用のアプリケーションをビルドすると、この配下に出力されます。

**node_modules / package.json**: このディレクトリとファイルはnpmに関連しています。 npmはNode.jsのパッケージマネジャーです。 Ember は Node で書かれていて、様々なNode.js モジュールを利用しています。 `Package.json` ファイルは、アプリケーションが利用している、 npm の依存関係を管理しています。追加でインストールしたEmber CLI add-ons があれば、それもこのリストで管理されます。 `package.json`に乗っているパッケージは、node_modules ディレクトリにインストールされます。

**public**: このディレクトリには、画像ファイルやフォントなどの資産が含まれています。

**vendor**: このディレクトリはBower によって管理されていないフロント エンド (JavaScript、CSS など) の依存関係が行きます。

**tests / testem.js**: アプリケーションの自動テストファイルは`tests` フォルダに、 そしてEmber CLIのテストランナー**testem** は`testem.js`に設定されます。.

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
    './config/environment';` は、 `config` という変数でアプリケーションの環境設定を利用できるようにします。 `const`は読み込み専用の変数を宣言するためのもので、こう宣言することで、他のコードによって書き換えられることが起きないことを担保します。 ファイルの終わりの `export default Router;
    ` はこのファイルで記述したコードが、変数 `Router` としてアプリケーションの、他のパーツでも利用できるようにしています。
    
    ## Emberのアップグレード
    
    チュートリアルの先に進む前に、インストールされた、Ember とEmber Dataが最新のバージョンであることを確認してください。 もし 、`bower.json`ファイルに記載のある、`ember` や`ember-data`ガイドの左上にあるバージョン番号よりも低い場合は、`bower.json` のバージョン番号を、編集してから `bower install`コマンドを実行して、バージョンを更新してください。
    同様に、もし`package.json`内の`ember-data`のバージョンが低い場合は、バージョン番号を更新ご`npm install`コマンドを実行してください。
    
    ## 開発サーバー
    
    新規のプロジェクトが作成てきたことを確認するために、開発用サーバーを起動しましょう。
    
    ```shell
    ember server
    

または、省略された

```shell
ember s
```

ブラウザで [`http://localhost:4200`](http://localhost:4200)を開くと、デフォルトのwelcomeスクリーンが表示されているはずです。 `app/templates/application.hbs`ファイルを追加すると、welcomeスクリーンは独自のコンテンツに置き換えられます。

![default welcome screen](../../images/ember-cli/default-welcome-page.png)