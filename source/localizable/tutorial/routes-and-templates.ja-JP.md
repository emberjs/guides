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
    

コマンド `ember server`(省略形だと`ember serve`あるいは`ember s`)を実行して、シェルからEmberの開発サーバーを起動してください。そして、ブラウザで[`http://localhost:4200/about`](http://localhost:4200/about)を開いて、新しいアプリケーションの動きを確認しましょう。

## Contact ルート

次に、会社のコンタクト情報を記載する route (ルート)を作成します。もう一度、route (ルート)、route handler (ルートハンドラー)、template (テンプレート)を自動生成することから始めます。

```shell
ember g route contact
```

このコマンドの出力は、`app/router.js`内に新しい`contact` route (ルート)が作成されたこと、そして`app/routes/contact.js`に該当するルートハンドラーが作成されたことを示します。.

ルートテンプレート`/app/templates/contact.hbs`にSuper Rentals HQのコンタクト情報を追記しましょう。

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
    
    ## リンクと {{link-to}} ヘルパーによるナビゲーション
    
    ユーザーがサイトを移動するためにURLを知ってなくてはならないというのは避けたいので、各ページの下部にいくつかのナビゲーションリンクを追加しましょう。
    aboutページにcontactページへのリンク、contactページにはaboutページへのリンクを作ります。
    
    Emberはフレームワークとやりとりする機能を持つ組み込みのテンプレート **ヘルパー** を持っています。
    [`{{link-to}}`](../../templates/links/) ヘルパーは、特別使いやすいEmberのルートへのリンク機能を提供します。
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
    

新しく生成した`app/templates/rentals.hbs`をいくつかの基本的なマークアップと共に更新して、賃貸物件の一覧ページ用のいくつかの初期コンテンツを追加しましょう。 実際の賃貸物件情報を追加するために、後でまたこのページには戻ってくる予定です。

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

    <br />## index ルート
    
    3つのルートを用意して、サイトのルートURI (`/`) へのリクエストを処理する index ルートを追加する準備が整いました。
    rentalsページをアプリケーションのメインページにしたいと考えており、既にルートを作成しています。
    したがって、indexルートをすでに作成済みの`rentals`ルートに単に転送したいということです。
    
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

<p>新しいindexルートのユニットテストを実装するところから始めましょう。</p>

<p>やりたいことは<code>/`を訪れたユーザーを`/rentals`に遷移させることなので、ユニットテストでは期待するルートで[`replaceWith`](http://emberjs.com/api/classes/Ember.Route.html#method_replaceWith)メソッドが呼び出されることを確認します。 `replaceWith`はルートの[`transitionTo`](../../routing/redirection/#toc_transitioning-before-the-model-is-known)関数と似たようなものです。<1>transitionTo</1>がブラウザーのヒストリーに現在のURLを追加するのに対し、`replaceWith`は現在のURLを置き換えるという違いがあります。 `rentals` ルートをhomeページとして使いたいので、ここでは`replaceWith`関数を使用します。 

テストでは、`replaceWith`メソッドをスタブし、呼び出された際に`rentals`ルートが渡されたかどうかを検証することで、ルートがリダイレクトされるかを確認します。

`stub`は、テストしているオブジェクトに渡してすでに存在するものを置き換える、単なる偽関数です。 この場合は、期待する呼び出し方がされているかを検証するために`replaceWith`関数をスタブしています。

```tests/unit/routes/index-test.js import { moduleFor, test } from 'ember-qunit';

moduleFor('route:index', 'Unit | Route | index');

test('should transition to rentals route', function(assert) { let route = this.subject({ replaceWith(routeName) { assert.equal(routeName, 'rentals', 'replace with route name rentals'); } }); route.beforeModel(); });

    <br />index ルートに実際の`replaceWith`呼び出しを単に追加します。
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      beforeModel() {
        this.replaceWith('rentals');
      }
    });
    

これでroot ルート`/`は`/rentals`というURL を読み込むようになりました。

## ナビゲーション付きのバナーを追加する

アプリケーションの各route (ルート)に置いたボタンスタイルのリンクに追加して、共通のバナーを用意したいと思います。バナーにはアプリケーションのタイトルとメインページへのナビゲーションを表示します。

アプリケーションのすべてのページで何かしらを表示するには、アプリケーション テンプレートを使用します。 アプリケーション テンプレートは、新しいプロジェクトを作成するときに生成されます。 アプリケーションテンプレート `/app/templates/application.hbs` を開き、次のバナーナビゲーションのマークアップを追加しましょう。

    app/templates/application.hbs
    <div class="container">
      <div class="menu">
        {{#link-to 'index'}}
          <h1>
            <em>SuperRentals</em>
          </h1>
        {{/link-to}}
        <div class="links">
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