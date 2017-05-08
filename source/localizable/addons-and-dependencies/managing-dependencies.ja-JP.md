Emberアプリを開発しているときには、Ember自体が扱っていない一般的なシナリオを実行する可能性があります。それはたとえば、認証だったりスタイルシート用にSASSを使用することだったりといったことです。 Ember CLIは、これらの問題を解決するための再利用可能なライブラリを配布する一般的なフォーマットを提供します。このフォーマットは、[Emberアドオン](#toc_addons)と呼ばれます。 さらに、Emberアプリ特有のものではない、CSSフレームワークやJavaScriptのdatepickeなどといったフロントエンドの依存関係を利用することもできます。 Ember CLI は標準の[Bowerパッケージマネージャー](#toc_bower)を介してこれらのパッケージをインストールすることをサポートしています。.

## アドオン

Emberアドオンは[Ember CLI](http://ember-cli.com/extending/#developing-addons-and-blueprints)を使ってインストールできます (例: `ember install ember-cli-sass`)。 アドオンは、それ以外の依存性をプロジェクトの`bower.json`ファイルを自動的に変更することによって、他の依存関係をもたらす可能性があります。

[Ember Observer](http://emberobserver.com)に行けば、アドオンのリストを見ることができます。.

## Bower

Ember CLIは、フロントエンドの依存関係を最新に保ちやすくするために、[Bower](http://bower.io)パッケージマネージャーを使用します。 Bowerの構成ファイルである`bower.json`は、Ember CLIプロジェクトのルートにあり、プロジェクトの依存関係のリストを記載します。 `bower install`を実行すると、`bower.json`にリストされている全ての依存関係が一度にインストールされます。

Ember CLIは`bower.json`の変更を監視します。したがって、`bower install <dependencies> --save`によって新しい依存関係をインストールすると、Ember CLIはアプリケーションをリロードします。.

## その他のアセット

アドオンやBowerパッケージとして利用できないサードパーティのJavaScriptは、プロジェクトの`vendor/`フォルダーに配置する必要があります。

あなた自身のアセット (`robots.txt`や`favicon`、カスタムフォントなど)はプロジェクト内の`public/`フォルダーに配置する必要があります。

## アセットのコンパイル

アドオンに含まれていない依存関係を使用している場合は、アセットをビルドにアセットを含めるようEmber CLIに指示する必要があります。 これを行うには、アセットのマニフェストファイルである`ember-cli-build.js`を使用します。 その場合は、`bower_components`フォルダー及び`vendor`フォルダーにあるアセットをインポートするようにしてください。

### JavaScriptアセットによって提供されるグローバル変数

いくつかのアセット (以下の例における`moment`など) によって提供されるグローバル変数は、`インポート`する必要なしに、アプリケーションから使用できます。 アセットパスを最初にして唯一の引数として指定してください。

```ember-cli-build.js app.import('bower_components/moment/moment.js');

    <br />`.jshintrc`の`predef`セクションに`"moment"`を追加して、未定義変数の使用に関するJSHintエラーを防ぐ必要があります。
    
    ### AMD JavaScript モジュール
    
    ```ember-cli-build.js
    app.import('bower_components/ic-ajax/dist/named-amd/main.js', {
      exports: {
        'ic-ajax': [
          'default',
          'defineFixture',
          'lookupFixture',
          'raw',
          'request'
        ]
      }
    });
    

こうすることで、必要なモジュールを非同期でアプリケーションに`インポート`できます (例えば`import { raw as icAjaxRaw } from 'ic-ajax';`のようにします) 。)

### 環境固有のアセット

環境ごとに異なるアセットを使用する必要がある場合は、最初のパラメーターとしてオブジェクトを指定します。 その際、オブジェクトのキーは環境名に、あたいは環境で使用するアセットにする必要があります。

```ember-cli-build.js app.import({ development: 'bower_components/ember/ember.js', production: 'bower_components/ember/ember.prod.js' });

    <br />ある環境だけにアセットをインポートしたい場合は、`app.import`を`if`文で括ります。
    テスト中に必要なアセットの場合には、テストモードで利用できるかを指示するために`{type: 'test'}`も使用する必要があります。
    
    ```ember-cli-build.js
    if (app.env === 'development') {
      // Only import when in development mode
      app.import('vendor/ember-renderspeed/ember-renderspeed.js');
    }
    if (app.env === 'test') {
      // Only import in test mode and place in test-support.js
      app.import(app.bowerDirectory + '/sinonjs/sinon.js', { type: 'test' });
      app.import(app.bowerDirectory + '/sinon-qunit/lib/sinon-qunit.js', { type: 'test' });
    }
    

### CSS

第一引数にアセットのパスを指定します。

```ember-cli-build.js app.import('bower_components/foundation/css/foundation.css');

    <br />この方法で追加された全てのスタイル用アセットは、1つに結合されて`/assets/vendor.css`として出力されます。
    
    ### その他のアセット
    
    `public/`フォルダー内の全てのアセットは、最終的な出力ディレクトリである`dist/`にそのままコピーされます。
    
    
    例えば、`public/images/favicon.ico`にある`favicon`は、`dist/images/favicon.ico`にコピーされます。
    
    `vendor/`に手動で入れられたか、あるいはBowerのようなパッケージマネージャーを介して入れられた全てのサードパーティのアセットは、`import()`によって追加しなければなりません。
    
    `import()`によって追加されていないサードパーティのアセットは、最終ビルドには含まれません。
    
    デフォルトでは、`import`されたアセットは、既存のディレクトリ構造を維持したまま`dist/`にコピーされます。
    
    ```ember-cli-build.js
    app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf');
    

この例では、`dist/font-awesome/fonts/fontawesome-webfont.ttf`にフォントファイルを作成しています.

オプションで、`import()`に対してファイルを別のパスに置くよう指示することもできます。 次の例では、ファイルを`dist/assets/fontawesome-webfont.ttf`にコピーします。.

```ember-cli-build.js app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf', { destDir: 'assets' });

    <br />特定の依存関係を他の依存関係よりも前にロードする必要がある場合は、`import()`の2番目の引数`prepend`プロパティを`true`に設定します。
    これによって、既定の動作の代わりに、vendorファイルの先頭に依存関係が追加されます (既定の動作ではvendorファイルの最後に依存関係が追加されます) 。
    
    ```ember-cli-build.js
    app.import('bower_components/es5-shim/es5-shim.js', {
      type: 'vendor',
      prepend: true
    });