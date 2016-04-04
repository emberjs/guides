Ember アプリケーションの基本的な準備と、順序を示すために、この項目では、Super Rentalsという資産レンタルのEmber アプリケーションの構築を順を追って示していきます。 homeページ、aboutページと、contact ページから始めましょう。 その前に、ユーザーの目線でアプリケーションを見てみましょう。

![super rentals homepage screenshot](../../images/routes-and-templates/ember-super-rentals-index.png)

ホームページはレンタルのリストを表示しています。ここから、about ページと contact ページに遷移することができます。

まっさらの`super-rentals`というEmber CLI アプリケーションが起動していることを、確認してください。

```shell
ember new super-rentals
```

アプリケーションの３つのページを構築する前に、 `app/templates/application.hbs` ファイルの内容を`{{outlet}}` 意外、消去します。 `application.hbs` ファイルのルールについては、アプケーションにツートをいくつか作った後で説明します。

では、まず　"about" ページを作成してみましょう。 URL `/about`が読み込まれると、URLと同じ名前のルーターハンドラー *about.js*をマップしているということを、念頭においてください。 その後、ルートハンドラがテンプレートを読み込みます。

## ルートに関して

`ember help generate`を実行すると、Ember とともにインストールされる、様々なEmber リソースのファイルを自動生成できるツールについて、確認ができます。 ルートジェネレータを使って、`about`ルートの作成を、初めて行きましょう。

```shell
ember generate route about
```

次の省略形でも、同じ結果が実行でします。

```shell
ember g route about
```

実行後、ジェネレータ実行することを確認することができます。

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

３つの新しいファイルが生成されます: 一つはルートハンドラー、一つはルートハンドラーが描画するテンプレート、最後の一つはテストファイル。四つ目のファイル、ルーターには編集が加えられています。

ルーターファイルを開くと、ジェネレータが自動的に*about*ルートをマップしてることが、確認できます。このルートが`about`のルートハンドラーを読み込みます。

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType });

Router.map(function() { this.route('about'); });

export default Router;

    <br />デフォルトで、`about`ルートハンドラーは`about.hbs` テンプレートを読み込みます。
    これは`app/routes/about.js` に変更しなくても、 `about.hbs` が表示されることを意味しています。
    
    ジェネレータによって必要なルーティングが完了しているので、すぐにテンプレートのコーディングが行えます。
    `about`ページ:　このサイトに関する情報のHTMLを追加しましょう。
    
    ```app/templates/about.hbs
    <h2>About Super Rentals</h2>
    
    <p>The Super Rentals website is a delightful project created to explore Ember.
    By building a property rental site, we can simultaneously imagine traveling
    AND building Ember applications.</p>
    

`ember serve`(省略形だと`ember s`)を実行して、シェルからEmberの開発サーバーを起動しましょう、その後ブラウザで`localhost:4200/about`を開くとアプリケーションが確認できます。

## Contact ルート

続いて、会社のコンタクト情報を記載するルートを作成しましょう。もう一度、ルート、ルートハンドラー、テンプレートを自動生成することから始めます。

```shell
ember g route contact
```

ジェネレータコマンドを実行され、`app/router.js`ないに`contact` ルートが作成され、`app/routes/contact.js`には該当するルートが作成されます。 `contact`テンプレートを利用していくので、`contact`ルートには編集をする必要がありません。

`contact.hbs`テンプレートには Super Rentals HQのコンタクト情報を追記します:

```app/templates/contact.hbs 

Super Rentals Representatives would love to help you choose a destination or answer any questions you may have.

Contact us today:

Super Rentals HQ 

<address>
  1212 Test Address Avenue<br /> Testington, OR 97233
</address>

[(503)555-1212](tel:503.555.1212)

<superrentalsrep@superrentals.com>

    <br />これで、２番目のルートが完成しました。
    該当のURL `localhost:4200/contact` にアクセスすると、contactページが表示されます。
    
    ## リンクによるナビゲーションと {{link-to}} ヘルバー
    
    アプリケーション内を遷移するのに、ユーザーがURLを知る必要があるようなこと望んでません、そこで各ページの下部にナビゲーション用のリンクを追加しましょう。
    それではaboutページにcontactページへのリンク、aboutページにはcontactへのリンクを作ります。
    
    Ember には他のルートへのリンクなどの機能を提供する**ヘルパー** が組み込まれています。
    ここではルーター間のリンクするために、 `{{link-to}}` ヘルパーを利用します:
    
    ```app/templates/about.hbs
    <h2>About Super Rentals</h2>
    
    <p>The Super Rentals website is a delightful project created to explore Ember.<br>
      By building a property rental site, we can simultaneously imagine traveling<br>
      AND building Ember applications.</p>
    
    {{#link-to "contact"}}Click here to contact us.{{/link-to}}
    

`{{link-to}}` ヘルパーは、リンクする先のルーター名を引数として一つとります。この場合は`contact`がそれにあたります。 about ページを確認するとcontact ページへのリンクが機能していることが確認できます。

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

`contact`ページと`about` の間で移動ができるように、次は contact ページにリンクを追加します。.

```app/templates/contact.hbs 

Super Rentals Representatives would love to help you choose a destination or answer any questions you may have.

Contact us today:

Super Rentals HQ 

<address>
  1212 Test Address Avenue<br /> Testington, OR 97233
</address>

[(503)555-1212](tel:503.555.1212)

<superrentalsrep@superrentals.com>

{{#link-to "about"}}About{{/link-to}}

    <br />## Index ルート
    
    静的パージが二つ完成したので、ユーザーを迎える home を追加する準備ができました。
    about ページと contact ページのプロセスと同様に、`index`という名前のルートを生成することから始めます。
    
    ```shell
    ember g route index
    

ルートジェネレータの出力はすでに馴染みななっているものです。

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

作成してきた他のルートハンドラーとは違い、`index`ルートは特別で、ルートマッピングにエントリーは必要ありません。 どうしてエントリーの必要がないのか、に関してはネストされたEmberのルートを扱う際に詳細を説明します。

`index.hbs`にhome ページ用のHTMLとアプリケーション内の他のルートへのリンクを追加します。

```app/templates/index.hbs 

# Welcome to Super Rentals

We hope you find exactly what you're looking for in a place to stay.

{{#link-to "about"}}About{{/link-to}} {{#link-to "contact"}}Click here to contact us.{{/link-to}} ```