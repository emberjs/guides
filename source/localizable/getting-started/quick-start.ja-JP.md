このガイドでは、Emberを使ったシンプルなアプリケーションを0から構築する方法を紹介します。

次の手順を説明していきます。

  1. Emberのインストール。
  2. 新しいアプリケーションの作成。
  3. ルートの定義。
  4. UI コンポーネントの記述。
  5. プロダクション・デプロイ用のビルドの実施。

## Emberのインストール

Emberは Node.jsのパッケージマネージャー npmを使えば、コマンドを一つ実行するだけでのインストールすることができます。次のコマンドをターミナルで実行してください。

```sh
npm install -g ember-cli
```

npm がありませんか? [Node.jsとnpmはこのリンク先からのインストールできます](https://docs.npmjs.com/getting-started/installing-node)。 Ember CLIプロジェクト用の依存関係の完全なリストは、ガイドの[Emberをインストールする](../../getting-started/)を参照してください。

## 新しいアプリケーションの作成

npmを通してEmberをインストールしたら、ターミナルで新しい`ember`コマンドが利用できるようになります。新しいEmberアプリケーションが作成するには`ember new`コマンドを実行します。

```sh
ember new ember-quickstart
```

このコマンドで、新しい`ember-quickstart`というディレクトリが作成され、その内部に新しいEmberアプリケーションがセットアップされます。そのままの状態で、あなたのアプリケーションには次のものが含まれます。

* 開発用サーバー。
* テンプレートのコンパイル。
* JavaScriptとCSSの圧縮。
* BabelによるES2015の機能。

Emberは、Webアプリケーションをプロダクションに配置するために必要なすべてを、統合された1つのパッケージとして提供します。それによって、私たちは新しいプロジェクトを簡単に始めることができます。

すべてが正常に動作することを確認しましょう。ターミナルで`cd`を実行し、アプリケーションのディレクトリである`ember-quickstart`に移動します。そして、開発用サーバーを起動するために以下を入力します。

```sh
cd ember-quickstart
ember server
```

しばらく待つと、次のような出力が表示されます。

```text
Livereload server on http://localhost:49152
Serving on http://localhost:4200/
```

(サーバーを停止する際はいつでも、ターミナルにCtrl-Cと入力してください)。

お好みのブラウザで[`http://localhost:4200`](http://localhost:4200)を開いてください。 Emberのウェルカムページが見えるはずです。 おめでとうございます ！ あなたは初めてのEmberアプリを作成して起動しました。

`ember generate`コマンドを利用して、新しいテンプレートを1つ作成してみましょう。

```sh
ember generate template application
```

アプリケーションが読み込まれた際にはいつも、`application`テンプレートが画面上にあります。エディターで`app/templates/application.hbs` を開いて、次のコードを追加してください。

```app/templates/application.hbs 

# PeopleTracker

{{outlet}}

    <br />Emberは新しいファイルを検知し、バックグラウンドでページを自動的にリロードしたはずです。 ウェルカムページが"PeopleTracker"に置き換わったのが確認できるはずです。
    
    ## route（ルート）の定義
    
    では、科学者のリストを表示するアプリケーションを作っていきましょう。 そのためには、まずroute（ルート）を作成する必要があります。 当面は、ルートはアプリケーションを構成する別のページと考えるといいでしょう。
    
    Emberには定型コードを自動生成する、_generators_（ジェネレータ）があります。 ルートを生成するには、ターミナルで次のように入力します。
    
    ```sh
    ember generate route scientists
    

すると、次のような出力が表示されるはずです。

```text
installing route
  create app/routes/scientists.js
  create app/templates/scientists.hbs
updating router
  add route scientists
installing route-test
  create tests/unit/routes/scientists-test.js
```

これは、Emberが以下を作成したことを意味しています。

  1. ユーザーが`/scientists`を訪れた時に表示されるテンプレート。.
  2. テンプレートがモデルを取得する際に利用する`ルート`。
  3. アプリケーション・ルーター内のエントリ (アプリケーション・ルーターは`app/router.js`に存在しています).
  4. このルート用のユニットテスト。

`app/templates/scientists.hbs`を開いて、以下のHTMLを追加してください。

```app/templates/scientists.hbs 

## List of Scientists

    <br />ブラウザで[`http://localhost:4200/scientists`](http://localhost:4200/scientists)を開いてください。 You should
    see the `<h2>` you put in the `scientists.hbs` template, right below the
    `<h1>` from our `application.hbs` template.
    
    これで`scientists`テンプテートが出来ました。それでは、描画用のデータを与えていきましょう。 そのために、ルートのための_モデル_を指定します。モデルを指定するには`app/routes/scientists.js`を編集します。
    
    ジェネレータによって生成されたコードのうち、`Route`に`model()`メドッドを追加します。
    
    ```app/routes/scientists.js{+4,+5,+6}
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return ['Marie Curie', 'Mae Jemison', 'Albert Hofmann'];
      }
    });
    

(このサンプルはJavaScriptの最新機能を使っているため、そのうちのいくつかはもしかすると馴染みがないかもしれません。 詳細は[JavaScript最新機能の概要](https://ponyfoo.com/articles/es6)から学べます。.)

ルートの`model()`メソッドでは、テンプレートで利用する あらゆるデータを返します。 非同期でデータを取得する必要がある場合でも、`model()`メソッドは[JavaScript Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)をサポートするいずれのライブラリもサポートしています。.

それでは、文字列の配列をHTMLに変換する方法をEmberに伝えてみましょう。`scientists`テンプレートを開いてHandlebarsコードを追加し、ループしながら配列の中身を出力させます。

```app/templates/scientists.hbs{+3,+4,+5,+6,+7} 

## List of Scientists

{{#each model as |scientist|}} 

* {{scientist}} {{/each}} 

    <br />`each`ヘルバーを使って、`model()`フックから取り出した配列の各要素を`<li>`要素内に出力しています。
    
    ## UIコンポーネントの作成
    
    アプリケーションが大きくなるにつれ、複数のページで同じUI要素を使用していたり、同一ページ内でUI要素を重複して使用していることが、目につくようになります。Emberでは、テンプレートを再利用可能なコンポーネントへと簡単にリファクタリングできます。
    
    それでは、`people-list`コンポーネントを作成し、人のリスト表示を複数の場所で利用できるようにしてみましょう。
    
    例によって、この作業を簡単にしてくれるジェネレーターがあります。 新しいコンポーネントを作成するには、次のように入力します。
    
    ```sh 
    ember generate component people-list
    

`scientists`テンプレートをコピーして、`people-list`コンポーネントのテンプレートににペーストし、次のように編集します。

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />タイトルをハードコーディングされた文字列 ("List of Scientists") から動的プロパティ (`{{title}}`) に変更していることに注目してください。 また、コンポーネントを汎用的に利用できるように、`scientist`をより一般化して`person`という名称に変更しました。
    
    このテンプレートを保存したら、`scientists`テンプレートに戻ります。 以前のコードを、新しくコンポーネント化したコードにすべて置き換えます。 一見HTMLタグのようにも見えますが、コンポーネントは角かっこ(`<tag>`) の代わりに2重波かっこ(`{{component}}`) を利用します。 コンポーネントに次の内容を与えましょう。
    
    1. titleには'title' 属性の値を使う。
    2. 人の配列には`people`属性の値を使う。 このルートの`model`には人のリストを設定することにします。
    
    ```app/templates/scientists.hbs{-1,-2,-3,-4,-5,-6,-7,+8} 
    <h2>List of Scientists</h2> 
    
    <ul>
       {{#each model as |scientist|}}
         <li>{{scientist}}</li>
       {{/each}} 
    </ul> 
    {{people-list title="List of Scientists" people=model}}
    

ブラウザでページをリロードしても、UIの見た目はが変わっていないはずです。唯一の違いは、リスト表示をコンポーネント化したことで、より再利用性と保守性の高いバージョンを利用していることです。

この効果は、異なる人のリストを利用するルートを作成する際に確認できます。 例題として、著名なプログラマを表示する`programmers`ルートを作成してみてはどうでしょう。 `people-list`コンポーネントを利用することで、ほぼコードを書かずに例題を解くことができるはずです。

## プロダクション用のビルド

ここまでで、アプリケーションを作成し、開発環境では機能することが確認できました。いよいよ、ユーザーにデプロイする準備が整いました。そのためには、次のコマンドを実行してください。

```sh
ember build --env production
```

`build`コマンドは、アプリケーションを構成するすべてのアセット (JavaScript、テンプレート、 CSS、 Webフォント、画像など) を一つにまとめます。

今回は、`--env`フラグを通して、プロダクション環境にビルドするようEmberに指示しました。 こうすることで、Webホストへのアップロードに最適化されたバンドルが作成されます。 ビルドが完了すると、`dist/`ディレクトリ配下にすべてが連結・ミニファイドされたアセットが確認できるでしょう。

Emberコミュニティは協調、そして誰もが当てにする一般的なツールを構築することに価値を置きます。 もし、高速で信頼性の高い方法でアプリケーションをプロダクションに配置することに興味があるのなら、[Ember CLI Deploy](http://ember-cli-deploy.com/) addon (アドオン) を確認するといいでしょう。

Apache Webサーバにデプロイする場合は、まずアプリケーション用の新しいバーチャルホストを作成します。 すべてのroutes (ルート)がindex.htmlによって処理されることを確認するには、アプリケーションのバーチャルホスト設定に次のディレクティブを追加してください。

    FallbackResource index.html