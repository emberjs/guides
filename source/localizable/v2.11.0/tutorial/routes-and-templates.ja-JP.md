Super Rentalsでは、homeページを開くと賃貸物件の一覧を閲覧でき、そこからaboutページやcontactページへと遷移するようにします。

Emberは、アプリケーション内の論理的でアドレスを指定できるページを定義するために、[堅牢なルーティング機構](../../routing/)を提供します。

## ルートに関して

では「about」ページを構築することから始めましょう。 新しい、URL指定が可能なページをアプリケーションに作成するには、Ember CLIを使ってroute (ルート) を生成する必要があります。

`ember help generate`を実行すると、Emberに付属する、さまざまなリソースを自動生成するツール群を確認できます。 では、route generator ( ルートジェネレータ)を使って、`about` route (ルート)を作成していきましょう。

```shell
ember generate route about
```

コマンドは次のように省略することもできます。

```shell
ember g route about
```

コマンドの出力には、ジェネレータによって実行されたアクションの内容が表示されます。

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

route (ルート) は次の部品で構成されます。

  1. ルート名を特定の URI にマッピングする`/app/router.js`内のエントリ。*`(app/router.js)`*
  2. ルートが読み込まれたときにどのような動作を実行する必要があるかを指示するルートハンドラのJavaScriptファイル。*`(app/routes/about.js)`*
  3. ルートによって表現されるページを記述するルートテンプレート。*`(app/templates/about.hbs)`*

`/app/router.js`を開くと、*about*ルート用の新しい行があることがわかります。それは`map`関数内で`this.route('about')`を呼び出している箇所です。 `this.route(routeName)`関数の呼び出しは、Emberのrouter (ルーター) に、ユーザーが同名のURIを訪れた際に特定のルートハンドラーを読み込む様に指示します。 この場合は、ユーザーが`/about`に移動した際に、`/app/routes/about.js`で表現されたルートハンドラーが使われることになります。 詳細は[ルートを定義する](../../routing/defining-your-routes/)ためのガイドを参照してください。

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
    ここでは、コード内の `{{link-to}}` ヘルパーを使用して、ルート間の基本的なリンクを表します。
    
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
        Contact Us
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

    <br />## An Index Route
    
    With our three routes in place, we are ready to add an index route, which will handle requests to the root URI (`/`) of our site.
    We'd like to make the rentals page the main page of our application, and we've already created a route.
    Therefore, we want our index route to simply forward to the `rentals` route we've already created.
    
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

<p>Let's start by implementing the unit test for our new index route.</p>

<p>Since all we want to do is transition people who visit <code>/` to `/rentals`, our unit test will make sure that the route's [`replaceWith`](http://emberjs.com/api/classes/Ember.Route.html#method_replaceWith) method is called with the desired route. `replaceWith` is similar to the route's [`transitionTo`](../../routing/redirection/#toc_transitioning-before-the-model-is-known) function; the difference being that `replaceWith` will replace the current URL in the browser's history, while `transitionTo` will add to the history. Since we want our `rentals` route to serve as our home page, we will use the `replaceWith` function.

In our test, we'll make sure that our index route is redirecting by stubbing the `replaceWith` method for the route and asserting that the `rentals` route is passed when called.

A `stub` is simply a fake function that we provide to an object we are testing, that takes the place of one that is already there. In this case we are stubbing the `replaceWith` function to assert that it is called with what we expect.

```tests/unit/routes/index-test.js import { moduleFor, test } from 'ember-qunit';

moduleFor('route:index', 'Unit | Route | index');

test('should transition to rentals route', function(assert) { let route = this.subject({ replaceWith(routeName) { assert.equal(routeName, 'rentals', 'replace with route name rentals'); } }); route.beforeModel(); });

    <br />In our index route, we simply add the actual `replaceWith` invocation.
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      beforeModel() {
        this.replaceWith('rentals');
      }
    });
    

Now visiting the root route `/` will result in the `/rentals` URL loading.

## ナビゲーション付きのバナーを追加する

In addition to providing button-style links in each route of our application, we would like to provide a common banner to display both the title of our application, as well as its main pages.

To show something in every page of your application, you can use the application template. The application template is generated when you create a new project. Let's open the application template at `/app/templates/application.hbs`, and add the following banner navigation markup:

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

`div` 要素の中に`{{outlet}}`が含まれていることに注目してください。 この場合の[`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet)は、*about*や*contact*などのような、現在のroute (ルート)によって描画されるコンテンツ用のプレースホルダーになります。.

ここまでで、route (ルート)とそれらを繋ぐリンクを追加しました。route (ルート)へのナビゲーション用に作成した三つの受入テストは、この段階で通っているでしょう。

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)