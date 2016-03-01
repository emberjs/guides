アプリケーションが起動すると、ルーターが現在のURLに設定された *ルート*と一致させます。 ルートが順番に、テンプレートを表示、データを読み込み、またはアプリケーションの状態を設定する責を担っています。

## 基本的なルート

Emberアプリケーションのルーターの[`map()`](http://emberjs.com/api/classes/Ember.Router.html#method_map) メソッドの呼び出しは、URL マッピングの定義として呼び出すことができます。 `Map()` を呼び出すとき、ルートの作成のために、`this` の値を持った関数を渡す必要があります。

```app/router.js Router.map(function() { this.route('about', { path: '/about' }); this.route('favorites', { path: '/favs' }); });

    <br />ユーザーが`/about`にアクセスするとき、 Ember は`about`テンプレーを描画します。 `/favs` にアクセスすると、 `favorites` テンプレートを描画します。
    
    もしルートの名前と、パスが同じ場合は、省略することができます。 この場合、次のコードが上記と同等の例になります。
    
    ```app/router.js
    Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
    });
    

テンプレート内で[`{{link-to}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_link-to) を `ルート` メソッド名で利用することで、 ルート間を移動することができます。

```handlebars
{{#link-to "index"}}<img class="logo">{{/link-to}}

<nav>
  {{#link-to "about"}}About{{/link-to}}
  {{#link-to "favorites"}}Favorites{{/link-to}}
</nav>
```

`{{link-to}}` ヘルパーは、現在アクディブになっているルートに`active` クラスを、追加することもできます。

## ネスト(入れ子)されたルート

テンプレート内で、他のテンプレートを描画したいということは、よくあることです。 例えば、ブログアプリケーションでブログポストのリストから新規ポストを作成するのではなく、リストの隣に、ポスト作成を表示させたいかもしれません。

この場合、ネストされたルートを利用することで、テンプレート内で他のテンプレーを表示することができます。

`this.route`にコールバックを渡すことで、ネストされたルートを定義することができます。

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />そしてその後ネストされたテンプレーを表示させたい箇所に `{{outlet}}` ヘルパーをテンプレートに追加します。
    
    ```templates/posts.hbs
    <h1>Posts</h1>
    <!-- Display posts and other content -->
    {{outlet}}
    

このルーターは`/posts` と`/posts/new`からルートを作成します。 ユーザーが`/posts`にアクセスするとき、単に`posts.hbs`テンプレートが表示されます。 ([index routes](#toc_index-routes)直下にこの事柄につての重要な追加説明があります。) ユーザーが `posts/new`にアクセスすると、ユーザーは`posts` テンプレートの`{{outlet}}` に描画された`posts/new.hbs`テンプレートを見ることができます。

ネストされたルートの名称には、その元の名前が含まれています。 もし、ルートに(`transitionTo` もしくは`{{#link-to}}`を経由して)推移したいとき、完全なルート名を使うのを忘れないでください。( `new`でhなく`posts.new`).

## アプリケーション ルート

アプリケーションが起動すると、まず`application` が呼び出されます。 デフォルトで他のルートのように、同じ名前を持つ、テンプレートを呼び出します。 (この場合`application`) ヘッダー、フッターなどのデコラティブなコンテンツはここに置く必要があります。 他のすべてのルートは`application.hbs` テンプレートの `{{outlet}}`にそろぞれのテンプレートを描画します。.

このルートは、すべてのアプリケーションの一部なので、`app/router.js`のしては不要です。.

## インデックス ルート

入れ子のあらゆる場面で、 (一番上の階層も含めて)、 Ember 自動的に `index`という名称の`/` ルートを提供します。.

たとえば、このような単純なルーターを記述した場合。

```app/router.js Router.map(function(){ this.route('favorites'); });

    <br />次のコードと同じです。
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('favorites');
    });
    

`application`テンプレート内の`{{outlet}}`に`index`テンプレートが描画されます。 ユーザーが`/favorites`に移動したら、Ember は `index` テンプレートを `favorites` テンプレートと置き換えます。

次のように、入れ子になったルーター:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('favorites'); }); });

    <br />次のコードと同じです。
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('posts', function() {
        this.route('index', { path: '/' });
        this.route('favorites');
      });
    });
    

ユーザーが `/posts`にナビゲートしてきたら、そのときのカレントルートは`posts.index`になり`posts/index`テンプレートが`posts`テンプレートの`{{outlet}}` 内に描画されます。

ユーザーが `/posts/favorites`にナビゲートしてきたら、Emberは`{{outlet}}`を`posts` テンプレートから`posts/favorites`テンプレートに置き換えます。

## ダイナミックなセグメント

ルートの機能の 1 つは、モデルを読み込むことです。

たとえば、 `this.route('posts');`,というルートがあるとします、ルートはアプリケーションのすべてのブログポストを読み込むかもしれません。

なぜなら`/posts` が静的なモデルのため、データを再取得するのに必要な追加的な情報が必要ないからです。 一方、ルートにポストを一つだけ表示させたい場合、ルーターに各ポストを表示させるためにハードコードはしたくないものです。

*動的セグメント*の入力。.

動的セグメントとは、`:` から始まり、識別子が続くURLの一部です。

```app/router.js Router.map(function() { this.route('posts'); this.route('post', { path: '/post/:post_id' }); });

    <br />ユーザーが`/post/5`にナビゲーションした場合、ルートが`post_id` を`5` として、該当するポストを読み込みます。 次のセクション[Specifying a Route's
    Model](../specifying-a-routes-model) では、さらに「どのようにモデルを読み込むか」について学習します。
    
    ## ワイルドカード / グロビングルート
    
    複数のURL セグメントと一致するワイルドカードルートを定義することが可能です。 例えばユーザーが、アプリケーションでは管理をしていないような不正なURL を入力した場合などのための、キャッチオールルータとして利用できます。
    
    ```app/router.js
    Router.map(function() {
      this.route('page-not-found', { path: '/*wildcard' });
    });
    

## ルート ハンドラー

ルートにテンプレートの描画以上のことをさせたいとき、ルートハンドが必要になります。 次のガイドでは、ルート ハンドラーのさまざまな機能について学習します。 さらにルートの詳細を確認したい場合は、API ドキュメントの [the router](http://emberjs.com/api/classes/Ember.Router.html) と [route handlers](http://emberjs.com/api/classes/Ember.Route.html)を参照してください。.