Ember アプリケーションの基本的な準備と、順序を示すために、この項目では、Super Rentalsという資産レンタルのEmber アプリケーションの構築を順を追って示していきます。 homeページ、aboutページと、contact ページから始めましょう。 その前に、ユーザーの目線でアプリケーションを見てみましょう。

![super rentals homepage screenshot](../../images/service/style-super-rentals-maps.png)

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
    

`ember serve`(省略形だと`ember s`)を実行して、シェルからEmberの開発サーバーを起動しましょう、その後ブラウザで`localhost:4200/about`を開くとアプリケーションが確認できます。

## Contact ルート

続いて、会社のコンタクト情報を記載するルートを作成しましょう。もう一度、ルート、ルートハンドラー、テンプレートを自動生成することから始めます。

```shell
ember g route contact
```

ジェネレータコマンドを実行され、`app/router.js`ないに`contact` ルートが作成され、`app/routes/contact.js`には該当するルートが作成されます。 `contact`テンプレートを利用していくので、`contact`ルートには編集をする必要がありません。

`contact.hbs`テンプレートには Super Rentals HQのコンタクト情報を追記します:

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
    該当のURL `localhost:4200/contact` にアクセスすると、contactページが表示されます。
    
    ## リンクによるナビゲーションと {{link-to}} ヘルバー
    
    アプリケーション内を遷移するのに、ユーザーがURLを知る必要があるようなこと望んでません、そこで各ページの下部にナビゲーション用のリンクを追加しましょう。
    それではaboutページにcontactページへのリンク、aboutページにはcontactへのリンクを作ります。
    
    Ember には他のルートへのリンクなどの機能を提供する**ヘルパー** が組み込まれています。
    Here we will use the `{{link-to}}` helper in our code to link between routes:
    
    ```app/templates/about.hbs{+9,+10,+11}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      </p>
      {{#link-to 'index' class="button"}}
        Get Started!
      {{/link-to}}
    </div>
    

The `{{link-to}}` helper takes an argument with the name of the route to link to, in this case: `contact`. When we look at our about page, we now have a working link to our contact page.

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

Now, we'll add a link to our contact page so we can navigate from back and forth between `about` and `contact`.

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

    <br />## Index ルート
    
    静的パージが二つ完成したので、ユーザーを迎える home を追加する準備ができました。
    about ページと contact ページのプロセスと同様に、`index`という名前のルートを生成することから始めます。
    
    ```shell
    ember g route index
    

We can see the now familiar output for the route generator:

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

Unlike the other route handlers we've made so far, the `index` route is special: it does NOT require an entry in the router's mapping. We'll learn more about why the entry isn't required when we look at nested routes in Ember.

Let's update our `index.hbs` with some HTML for our home page and our links to the other routes in our application:

    app/templates/index.hbs
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>Welcome!</h2>
      <p>
        We hope you find exactly what you're looking for in a place to stay.
        <br>Browse our listings, or use the search box above to narrow your search.
      </p>
      {{#link-to 'about' class="button"}}
        About Us
      {{/link-to}}
    </div>