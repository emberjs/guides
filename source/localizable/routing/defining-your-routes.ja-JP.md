アプリケーションが起動すると、ルーターが現在のURLに設定された *ルート*と一致させます。 ルートが順番に、テンプレートを表示、データを読み込み、またはアプリケーションの状態を設定する責を担っています。

## 基本的なルート

Emberアプリケーションのルーターの[`map()`](http://emberjs.com/api/classes/Ember.Router.html#method_map) メソッドの呼び出しは、URL マッピングの定義として呼び出すことができます。 `Map()` を呼び出すとき、ルートの作成のために、`this` の値を持った関数を渡す必要があります。

```app/router.js Router.map(function() { this.route('about', { path: '/about' }); this.route('favorites', { path: '/favs' }); });

    <br />ユーザーが`/about`にアクセスするとき、 Ember は`about`テンプレーを描画します。
    template. `/favs` にアクセスすると、 `favorites` テンプレートを描画します。
    
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

## The application route

The `application` route is entered when your app first boots up. Like other routes, it will load a template with the same name (`application` in this case) by default. You should put your header, footer, and any other decorative content here. All other routes will render their templates into the `application.hbs` template's `{{outlet}}`.

This route is part of every application, so you don't need to specify it in your `app/router.js`.

## Index Routes

At every level of nesting (including the top level), Ember.js automatically provides a route for the `/` path named `index`.

For example, if you write a simple router like this:

```app/router.js Router.map(function(){ this.route('favorites'); });

    <br />次のコードと同じです。
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('favorites');
    });
    

The `index` template will be rendered into the `{{outlet}}` in the `application` template. If the user navigates to `/favorites`, Ember.js will replace the `index` template with the `favorites` template.

A nested router like this:

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
    

If the user navigates to `/posts`, the current route will be `posts.index`, and the `posts/index` template will be rendered into the `{{outlet}}` in the `posts` template.

If the user then navigates to `/posts/favorites`, Ember.js will replace the `{{outlet}}` in the `posts` template with the `posts/favorites` template.

## ダイナミックなセグメント

One of the responsibilities of a route is to load a model.

For example, if we have the route `this.route('posts');`, our route might load all of the blog posts for the app.

Because `/posts` represents a fixed model, we don't need any additional information to know what to retrieve. However, if we want a route to represent a single post, we would not want to have to hardcode every possible post into the router.

Enter *dynamic segments*.

A dynamic segment is a portion of a URL that starts with a `:` and is followed by an identifier.

```app/router.js Router.map(function() { this.route('posts'); this.route('post', { path: '/post/:post_id' }); });

    <br />If the user navigates to `/post/5`, the route will then have the `post_id` of
    `5` to use to load the correct post. In the next section, [Specifying a Route's
    Model](../specifying-a-routes-model), you will learn more about how to load a model.
    
    ## Wildcard / globbing routes
    
    You can define wildcard routes that will match multiple URL segments. This could be used, for example,
    if you'd like a catch-all route which is useful when the user enters an incorrect URL not managed
    by your app.
    
    ```app/router.js
    Router.map(function() {
      this.route('page-not-found', { path: '/*wildcard' });
    });
    

## ルート ハンドラー

To have your route do something beyond render a template with the same name, you'll need to create a route handler. The following guides will explore the different features of route handlers. For more information on routes, see the API documentation for [the router](http://emberjs.com/api/classes/Ember.Router.html) and for [route handlers](http://emberjs.com/api/classes/Ember.Route.html).