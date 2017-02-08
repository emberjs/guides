In Super Rentals we want to arrive at a home page which shows a list of rentals. From there, we should be able to navigate to an about page and a contact page.

Ember provides a [robust routing mechanism](../../routing/) to define logical, addressable pages within our application.

## ルートに関して

Let's start by building our "about" page. To create a new, URL addressable page in the application, we need to generate a route using Ember CLI.

`ember help generate`を実行すると、Emberに付属する、さまざまなリソースを自動生成するツール群を確認できます。 では、route generator ( ルートジェネレータ)を使って、`about` route (ルート)を作成していきましょう。

```shell
ember generate route about
```

コマンドは次のように省略することもできます。

```shell
ember g route about
```

The output of the command displays what actions were taken by the generator:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

A route is composed of the following parts:

  1. An entry in `/app/router.js`, mapping the route name to a specific URI. *`(app/router.js)`*
  2. A route handler JavaScript file, instructing what behavior should be executed when the route is loaded. *`(app/routes/about.js)`*
  3. A route template, describing the page represented by the route. *`(app/templates/about.hbs)`*

Opening `/app/router.js` shows that there is a new line of code for the *about* route, calling `this.route('about')` in the `map` function. Calling the function `this.route(routeName)`, tells the Ember router to load the specified route handler when the user navigates to the URI with the same name. In this case when the user navigates to `/about`, the route handler represented by `/app/routes/about.js` will be used. See the guide for [defining routes](../../routing/defining-your-routes/) for more details.

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType, rootURL: config.rootURL });

Router.map(function() { this.route('about'); });

export default Router;

    <br />デフォルトで、`about` route handler (ルートハンドラー)は`about.hbs` template (テンプレート)を読み込みます。
    これは、わざわざ`app/routes/about.js`を書き換えなくても、`about.hbs`が表示されることを意味しています。
    
    generator (ジェネレータ)によって必要なルーティングが完了しているので、すぐに template (テンプレート)の編集が行えます。
    `about`ページ用に、サイトについてのちょっとした情報を示すHTMLを追加しましょう。
    
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
    

Run `ember server` (or `ember serve` or even `ember s` for short) from the shell to start the Ember development server, and then go to [`http://localhost:4200/about`](http://localhost:4200/about) to see our new app in action!

## Contact ルート

次に、会社のコンタクト情報を記載する route (ルート)を作成します。もう一度、route (ルート)、route handler (ルートハンドラー)、template (テンプレート)を自動生成することから始めます。

```shell
ember g route contact
```

The output from this command shows a new `contact` route in `app/router.js`, and a corresponding route handler in `app/routes/contact.js`.

In the route template `/app/templates/contact.hbs`, we can add the details for contacting our Super Rentals HQ:

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

    <br />これで、２番目のroute (ルート)が完成しました。
    URL[`http://localhost:4200/contact`](http://localhost:4200/contact)にアクセスすると、コンタクトページにアクセスできます。
    
    ## Navigating with Links and the {{link-to}} Helper
    
    We'd like to avoid our users having knowledge of our URLs in order to move around our site,
    so let's add some navigational links at the bottom of each page.
    aboutページにcontactページへのリンク、contactページにはaboutページへのリンクを作ります。
    
    Ember has built-in template **helpers** that provide functionality for interacting with the framework.
    The [`{{link-to}}`](../../templates/links/) helper provides special ease of use features in linking to Ember routes.
    Here we will use the `{{link-to}}` helper in our code to perform a basic link between routes:
    
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
    

`{{link-to}}` helper (ヘルパー)は、リンク先となるroute (ルート)名を引数として受け取ります。この場合は、`contact` がそれに当たります。 [`http://localhost:4200/about`](http://localhost:4200/about)を開くと、contactページへのリンクが機能していることがわかります。

![super rentals about page screenshot](../../images/routes-and-templates/ember-super-rentals-about.png)

`about`と`contact`を行ったり来たりできるように、次はcontactページにリンクを追加します。.

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

    <br />## 賃貸物件のroute (ルート)
    
    ユーザーが閲覧できる賃貸物件の一覧を表示するアプリケーションが欲しいです。
    これを実現するために、第3のroute (ルート)を追加します。名前は`rentals`としましょう。
    

Let's update the newly generated `app/templates/rentals.hbs` with some basic markup to add some initial content our rentals list page. We'll come back to this page later to add in the actual rental properties.

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

    <br />## インデックス route (ルート)
    
    静的なページも2つ完成しましたし、サイトを訪れたユーザーを迎えるhome ページを追加するにはいい頃合いでしょう。
    この時点でアプリケーションのメインページになるのは、すでにroute (ルート)を作成済みの賃貸物件一覧ページです。
    つまりここでは、インデックスroute (ルート)をすでに作成済みの`rentals` route (ルート)に単に転送したいものとします。
    
    aboutページとcontactページでやったのと同じように、まずは`index`という名前の新しいroute (ルート) を作成します。
    
    ```shell
    ember g route index
    

コマンドを実行すると、見慣れたroute (ルート) ジェネレータの結果を確認できます。

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

これまで作成してきたroute (ルート)ハンドラーと異なり、`index<0> route (ルート)は特別です。router (ルーター)での対応付けは必要ありません。
どうして対応付けが必要ないかは、Emberで<a href="../subroutes">入れ子になったroute (ルート)</a>を扱う際に詳しく説明します。</p>

<p>index用のユニットテストを実装するところから始めましょう。
やりたいことは<code>rentals`に遷移することなので、ユニットテストではroute (ルート)の[`replaceWith`](http://emberjs.com/api/classes/Ember.Route.html#method_replaceWith)メソッドが期待するroute (ルート)を呼び出すことを確認します。 `replaceWith`はroute (ルート)の`transitionTo`関数と似たようなものです。`transitionTo`がブラウザーのヒストリーに現在のURLを追加するのに対し、`replaceWith`は現在のURLを置き換えるという違いがあります。 `rentals` route (ルート)をhomeページとして使いたいので、ここでは`replaceWith`関数を使用します。 route (ルート) 用の`replaceWith`メソッドをスタブし、呼び出された際に`rentals` route (ルート)が渡されるかを検証することで、これを確認します。

```tests/unit/routes/index-test.js import { moduleFor, test } from 'ember-qunit';

moduleFor('route:index', 'Unit | Route | index');

test('should transition to rentals route', function(assert) { let route = this.subject({ replaceWith(routeName) { assert.equal(routeName, 'rentals', 'replace with route name rentals'); } }); route.beforeModel(); });

    <br />index route (ルート)に`replaceWith`呼び出しを単に追加します。
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      beforeModel() {
        this.replaceWith('rentals');
      }
    });
    

これでroot route (ルート)`/<code>は<0>/rentals`というURL を読み込むようになりました。

## ナビゲーション付きのバナーを追加する

アプリケーションの各route (ルート)に置いたボタンスタイルのリンクに追加して、共通のバナーを用意したいと思います。バナーにはアプリケーションのタイトルとメインページへのナビゲーションを表示します。

まず、 `ember g template application`と入力し、アプリケーション用のtemplate (テンプレート)を作成します。.

```shell
installing template
  create app/templates/application.hbs
```

`application.hbs`が存在すると、そこに記述したものはアプリケーションのすべてのページで表示されます。ここでは、以下のようにナビゲーション・バナーのマークアップを追加します。

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

`div` 要素の中に`{{outlet}}`が含まれていることに注目してください。 The [`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet) in this case is a placeholder for the content rendered by the current route, such as *about*, or *contact*.

Now that we've added routes and linkages between them, the three acceptance tests we created for navigating to our routes should now pass.

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)