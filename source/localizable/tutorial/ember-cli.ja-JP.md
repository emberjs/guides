Emberチュートリアルへようこそ！ このチュートリアルでは、基本的なEmberの概念を紹介するために、本格的な見た目のアプリケーションを作成していきます。 万が一チュートリアル中に立ち往生する部分があれば、<https://github.com/ember-learn/super-rentals>を参照して完成版アプリの動作例を参照してください。

Ember CLIは、Emberのコマンドライン・インターフェイスです。標準的なプロジェクト構造、一連の開発ツール、そしてアドオンのシステムを提供しています。 おかげで、Ember開発者はアプリケーションそのものの開発に集中することができます。アプリケーションを実行するサポート環境の構築に手間をかける必要はありません。 コマンドラインで `ember --help` と実行すると、Ember CLIが提供しているコマンド一覧が表示されます。 コマンド毎にさらに詳しい情報を確認したければ、`ember help <command-name>` と実行してください。.

## 新規アプリケーションの作成

Ember CLIを使って新規にプロジェクトを作成するには、`new`コマンドを使います。次のセクションで行うチュートリアルの準備として、`super-rentals`という名前のアプリケーションを作成しておきましょう。.

```shell
ember new super-rentals
```

## ディレクトリ構造

`new`コマンドは、次に示すファイルやディレクトリから構成される、プロジェクトを作成します。

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

Ember CLIが作成したファイルやディレクトリを見てみましょう。

**app**: この配下に、モジュールやコンポーネント、ルート、テンプレート、スタイルシート用のディレクトリやファイルが含まれています。Emberプロジェクトにおけるコーディングの大半は、この中で行われます。

**bower_components / bower.json**: Bowerは依存関係を管理するツールです。 Ember CLIでは、フロントエンドのプラグインやコンポーネントの依存性(HTML、 CSS、 JavaScript など) を管理するために利用しています。 すべてのBowerコンポーネントは`bower_components`ディレクトリにインストールされます。 `bower.json`を開くと、EmberやEmber CLI Shims、(テストで利用される)QUnitなどを含む、自動的にインストールされる依存関係のリストを確認できます。 Bootstrapなど、フロントエンドの依存関係を新たに追加した場合、それらはここにリストされます。そして、それらは`bower_components`ディレクトリに追加されます。

**config**: 設定ファイル用のディレクトリです。ここには、アプリケーションの設定を行う`environment.js` が含まれています。

**dist**: デプロイ用にアプリケーションをビルドすると、出力ファイルはこの配下に作成されます。

**node_modules / package.json**: このディレクトリとファイルはnpmに関連しています。 npmはNode.jsのパッケージマネージャーです。 EmberはNodeで構築されていて、動作に様々なNode.jsモジュールを利用しています。 `package.json`ファイルは、アプリケーションのnpmの依存関係のリストを管理しています。追加でインストールしたEmber CLIアドオンがあれば、それもこのリストで管理されます。 `package.json`内にリストされているパッケージは、node_modulesディレクトリにインストールされます。

**public**: このディレクトリには、画像ファイルやフォントなどのアセットが含まれています。

**vendor**: このディレクトリには、Bowerによって管理されないフロントエンドの依存関係 (JavaScript、CSS など) を配置します。

**tests / testem.js**: アプリケーションの自動テストは`tests`ディレクトリ配下に配置します。Ember CLIのテストランナー**testem**は、`testem.js`によって設定されます。.

**tmp**: Ember CLIの一時ファイルがここに置かれます。

**ember-cli-build.js**: このファイルには、Ember CLIがアプリケーションをどのようにビルドすべきかを記載します。

## ES6 モジュール

`app/router.js`に目を通すと、見慣れない構文が使われてることに気がつくはずです。

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType, rootURL: config.rootURL });

Router.map(function() { });

export default Router;

    <br />Ember CLIは、ECMAScript 2015 (省略してES2015、またはES6とも呼ばれます) モジュールを使って、アプリケーションコードを構造化します。
    例えば、`import Ember from 'ember';` という行は、Ember.jsライブラリを`Ember`という変数で利用できるようにしています。 また、`import config from
    './config/environment';`という行は、アプリケーションの設定データを`config`という変数で利用できるようにしています。 `const`は読み込み専用の変数を宣言するためのものです。`const`を使って変数を宣言することで、他のコードで書き換えられないことが担保されます。 ファイルの終わりには`export default Router;
    `という行があります。この行は、このファイル内で定義された変数`Router`を、アプリケーションの他の部分でも利用できるようにしています。
    
    ## Emberのアップグレード
    
    チュートリアルを先に進める前に、インストール済みのEmberとEmber Dataが最新のバージョンであることを確認してください。 もし、`bower.json`にある`ember`のバージョンがこのガイドの左上にあるバージョン番号よりも古い場合には、`bower.json`内のバージョン番号を更新し、`bower install`を実行してください。
    同様に、もし`package.json`内の`ember-data`のバージョンが古かった場合は、`package.json`内のバージョン番号を更新し、`npm install`コマンドを実行してください。
    
    ## 開発サーバー
    
    新規のプロジェクトを作成したら、うまく動いていることを確認するために、以下のようにEmberの開発サーバーを起動します。
    
    ```shell
    ember server
    

コマンドは次のように省略することもできます。

```shell
ember s
```

ブラウザで[`http://localhost:4200`](http://localhost:4200)を開くと、デフォルトのウェルカムページが表示されているはずです。 いったん`app/templates/application.hbs`ファイルを追加すると、ウェルカムページは独自のコンテンツに置き換えられます。

![default welcome screen](../../images/ember-cli/default-welcome-page.png)