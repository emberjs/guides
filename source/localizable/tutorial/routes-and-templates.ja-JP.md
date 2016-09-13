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

    <br />## A Rentals Route
    We want our application to show a list of rentals that users can browse.
    To make this happen we'll add a third route and call it `rentals`.
    
    ```shell
    ember g route rentals
    

Let's update the newly generated `rentals.hbs` with some basic markup to seed our rentals list page. We'll come back to this page later to add in the actual rental properties.

```app/templates/rentals.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Welcome!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

    <br />## An Index Route
    
    With our two static pages in place, we are ready to add our home page which welcomes users to the site.
    At this point our main page in our application is our rentals page, for which we've already created a route.
    So we want our index route to simply forward to the `rentals` route we've already created.
    
    Using the same process we did for our about and contact pages, we will first generate a new route called `index`.
    
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

Unlike the other route handlers we've made so far, the `index` route is special: it does NOT require an entry in the router's mapping. We'll learn more about why the entry isn't required when we look at [nested routes](../subroutes) in Ember.

We can start by implementing the unit test for index. Since all we want to do is transition to `rentals`, our unit test will make sure that the route's [`replaceWith`](http://emberjs.com/api/classes/Ember.Route.html#method_replaceWith) method is called with the desired route. `replaceWith` is similar to the route's `transitionTo` function, the difference being that `replaceWith` will replace the current URL in the browser's history, while `transitionTo` will add to the history. Since we want our `rentals` route to serve as our home page, we will use the `replaceWith` function. We'll verify that by stubbing the `replaceWith` method for the route and asserting that the `rentals` route is passed when called.

```tests/unit/routes/index-test.js import { moduleFor, test } from 'ember-qunit';

moduleFor('route:index', 'Unit | Route | index');

test('should transition to rentals route', function(assert) { let route = this.subject({ replaceWith(routeName) { assert.equal(routeName, 'rentals', 'replace with route name rentals'); } }); route.beforeModel(); });

    <br />In our index route, we simply add the `replaceWith` invocation.
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      beforeModel() {
        this._super(...arguments);
        this.replaceWith('rentals');
      }
    });
    

Now visiting the root route `/` will result in the `/rentals` URL loading.

## Adding a Banner with Navigation

In addition to providing button-style links in each route of our application, we would like to provide a common banner to display both the title of our application, as well as its main pages.

First, create the application template by typing `ember g template application`.

```shell
installing template
  create app/templates/application.hbs
```

When `application.hbs` exists, anything you put in it is shown for every page in the application. Now add the following banner navigation markup:

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

Notice the inclusion of an `{{outlet}}` within the body `div` element. The [`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet) defers to the router, which will render in its place the markup for the current route, meaning the different routes we develop for our application will get rendered there.

Now that we've added routes and linkages between them, the three acceptance tests we created for navigating to our routes will now pass.

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)