Ember アプリケーションの基本的な準備と、順序を示すために、この項目では、Super Rentalsという資産レンタルのEmber アプリケーションの構築を順を追って示していきます。 homeページ、aboutページと、contact ページから始めましょう。 その前に、ユーザーの目線でアプリケーションを見てみましょう。

![super rentals homepage screenshot](../../images/service/style-super-rentals-maps.png)

ホームページはレンタルのリストを表示しています。ここから、about ページと contact ページに遷移することができます。

では、まず　"about" ページを作成するところから始めます。 URL `/about`が読み込まれると、router (ルーター)がURLと同じ名前の*about.js*という route handler (ルート ハンドラー ) をマップしているということを、覚えておいてください。 その後、route handler (ルートハンドラ)が template (テンプレート)を読み込みます。

## ルートに関して

`ember help generate`を実行すると、Ember とともにインストールされ、様々なEmber リソースのファイルを自動生成できるツールについて、確認ができます。 まずは、route generator ( ルートジェネレータ)を使って、`about` route (ルート)を作成していきます。

```shell
ember generate route about
```

次の省略形でも、結果は同じです。

```shell
ember g route about
```

generator (ジェネレータ)が行っていることを、確認することができます:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

３つの新しいファイルが生成されます: 一つは route handler (ルートハンドラー)、一つはroute handler (ルートハンドラー)が描画するtemplate (テンプレート)、最後の一つはテストファイル。四つ目のファイル、router (ルーター)には編集が加えられています。

router (ルーター)ファイルを開くと、generator (ジェネレータ)が自動的に*about*ルートをマップしてることが確認できます。この route (ルート)が`about`の route handler (ルートハンドラー)を読み込みます。

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType, rootURL: config.rootURL });

Router.map(function() { this.route('about'); });

export default Router;

    <br />デフォルトで、`about` route handler (ルートハンドラー)は`about.hbs`  template (テンプレート)を読み込みます。
    これは`app/routes/about.js` を書き換えなくても、 `about.hbs` が表示されることを意味しています。
    
    generator (ジェネレータ)によって必要なルーティングが完了しているので、すぐに template (テンプレート)の編集が行えます。
    For our `about` page, we'll add some HTML that has a bit of information about the site:
    
    ```app/templates/about.hbs
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      </p>
    </div>
    

コマンド `ember serve`(省略形だと`ember s`)を実行して、シェルからEmberの開発サーバーを起動します、その後ブラウザで[`http://localhost:4200/about`](http://localhost:4200/about) を開くとアプリケーションが確認できます。

## Contact ルート

会社のコンタクト情報を記載する route (ルート)を作成しましょう。もう一度、route (ルート)、route handler (ルートハンドラー)、template (テンプレート)を自動生成することから始めます。

```shell
ember g route contact
```

generator (ジェネレータ)が実行され、`app/router.js`内に`contact` ルートが作成され、`app/routes/contact.js`には該当するルートが作成されます。 `contact`テンプレートを利用していくので、`contact` route (ルート)は追加で編集をする必要はありません。

`contact.hbs`には Super Rentals HQのコンタクト情報を追記します:

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Contact Us
  </h2>
  
  <p>
    Super Rentals Representatives would love to help you<br />choose a destination or answer any questions you may have.
  </p>
  
  <p>
    Super Rentals HQ 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p>
</div>

    <br />これで、２番目のルートが完成しました。
    URL[`http://localhost:4200/contact`](http://localhost:4200/contact)にアクセスすると、contact pageにアクセスできます。
    
    ## リンクによるナビゲーションと {{link-to}} Helper (ヘルバー)
    
    アプリケーション内を遷移するのに、ユーザーがURLを知る必要があるようなことは、望んでません、そこで各ページの下部にナビゲーション用のリンクを追加しましょう。
    それではaboutページにcontactページへのリンク、aboutページにはcontactへのリンクを作ります。
    
    Ember には他のルートへのリンクなどの機能を提供する**helpers (ヘルパー)** が組み込まれています。
    ここでは routes (ルート)間のリンクを表示するために `{{link-to}}` helper (ヘルパー)を利用します:
    
    ```app/templates/about.hbs{+9,+10,+11}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      </p>
      {{#link-to 'contact' class="button"}}
        Get Started!
      {{/link-to}}
    </div>
    

`{{link-to}}` helper (ヘルパー)はリンク先にとなる route (ルーター)名を引数として受け取ります、この場合は`contact` がそれに当たります。 [`http://localhost:4200/about`](http://localhost:4200/about),を開くと、コンタクトページへのリンクが機能しているのがわかります。

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

次は`contact`ページと`about` の間で移動ができるように、contact ページにリンクを追加します。.

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Contact Us
  </h2>
  
  <p>
    Super Rentals Representatives would love to help you<br />choose a destination or answer any questions you may have.
  </p>
  
  <p>
    Super Rentals HQ 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p> {{#link-to 'about' class="button"}} About {{/link-to}}
</div>

    <br />## Index Route(ルート)
    
    静的なページがが二つ完成したので、サイトに来たユーザーを迎える home を追加する準備ができました。
    about ページと contact ページの手順と同様に、`index`という名前の route (ルート)を生成することから始めます。
    
    ```shell
    ember g route index
    

見慣れた、route (ルート)ジェネレーターの結果が出力されます。

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

作成してきた他のルートハンドラーとは違い、`index` route (ルート)は特別で、ルートマッピングにエントリーを必要としていません。 どうしてエントリーの必要がないのかは、ネストされたEmberの routes (ルート)を扱う際に詳細を説明します。

`index.hbs`にhome ページ用のHTMLとアプリケーション内の他の routes (ルート)へのリンクを追加します。

```app/templates/index.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Welcome!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay. <br />Browse our listings, or use the search box above to narrow your search.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

    <br />## ナビゲーションの有るバナーを追加
    
    アプリケーションの各 route (ルート)の、ボタンスタイルのリンクに追加して、共通のアプリケーションのタイトルと、そのメインページを表示したいと思います。
    
    まず、`ember g template application`と入力して、アプリケーション template (テンプレート)を作成します。
    
    ```shell
    installing template
      create app/templates/application.hbs
    

`application.hbs`が存在する場合、そこに追加したものは、アプリケーションの全てのページで表示されます。次のナビゲーション用のバナーマークアップを追加します:

    app/templates/application.hbs
    <div class="container">
      <div class="menu">
        {{#link-to 'index'}}
          <h1 class="left">
            <em>SuperRentals</em>
          </h1>
        {{/link-to}}
        <div class="left links">
          {{#link-to 'about'}}
            About
          {{/link-to}}
          {{#link-to 'contact'}}
            Contact
          {{/link-to}}
        </div>
      </div>
      <div class="body">
        {{outlet}}
      </div>
    </div>

`div` 要素の中に`{{outlet}}`が含まれていることに注目してください。 [`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet) は、ルーターに従い、その時のルートによって描画されます、つまり私たちが開発するアプリケーションのそれぞれのルートは、そこに生成されます。

routes (ルート)とそれらを繋ぐリンクを追加しました。、aboutとcontactとのナビゲーションのために作成した二つの受入テストは、この段階で通っているはずです。

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)