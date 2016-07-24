クエリーパラメーター とはURLの`?`の右側に表示さえる、付属的なキー・バリューペアーです。 例えば、次のURLは二つのクエリーパラメーター、`sort` と`page`は、それぞれ`ASC` と `2`の値を持つ:

```text
http://example.com/articles?sort=ASC&page=2
```

クエリーパラメーターは、追加的なURLの*パス* としてアプリケーションの状態をURLに追加することができます(例えば、`?`の左側全て)。 クエリーパラメーターの一般的な利用方法としては、ページコレクションの中で、フィルターの基準や、並びの条件を表す、現在のページ番号を表示するといったものがります。

### クエリ パラメーターの設定

クエリ パラメーターは、ルートドリプンコント ローラーで宣言されます。 例えば、`articles` ルートでアクティブなクエリーパラメーターの設定は、`controller:articles`で宣言されるべきです。.

まだ、「人気のある」という`'category'`に未だに分類されていない、ポストを指定するためにの`controller:article`の`queryParams`パラメータとして`'category'`を指定します。

```app/controllers/articles.js export default Ember.Controller.extend({ queryParams: ['category'], category: null });

    <br />これは、URLの`category`クエリーパラメーターと`controller:articles`の`category`プロパティの間をバインドします。 言い換えると、一度`articles`ルートが入力されると、URLのあらゆる`category`クエーリーパラメーターは`controller:articles`の`category`を更新します、逆も同様です。
    
    次は`articles` テンプレートが描画するためのカタログフィルタ配列のコンピュートプロパティを定義する必要があります:
    
    ```app/controllers/articles.js
    export default Ember.Controller.extend({
      queryParams: ['category'],
      category: null,
    
      filteredArticles: Ember.computed('category', 'model', function() {
        var category = this.get('category');
        var articles = this.get('model');
    
        if (category) {
          return articles.filterBy('category', category);
        } else {
          return articles;
        }
      })
    });
    

このコードで、次の動作を確立しています。

  1. もし、ユーザーが`/articles`に遷移すると、`category` は `null`となり記事はフィルタされません。
  2. ユーザーが`/articles?category=recent`へと遷移すると、`category`が`"recent"`に設定され、記事がフィルタされます。
  3. `articles` route (ルート)内では、どのような`controller:articles`の`category`property (プロパティ) への変更も、URL の クエリ パラメーターを更新します。 デフォルトでは、クエリー パラメーターのプロパティーの変更はrouter (ルーター)のtransition (遷移)は行なわずURLのみ更新されます。 (例　`model` hooks や `setupController` などは呼び出されません);

### link-to Helper (ヘルパー)

link-to Helper (ヘルパー)は、パラメーターの指定に`query-params` subexpression helper (ヘルパー)を利用しています。

```handlebars
// ターゲットパラメータの明示的な設定
{{#link-to "posts" (query-params direction="asc")}}Sort{{/link-to}}

// バインドもサポートされています
{{#link-to "posts" (query-params direction=otherDirection)}}Sort{{/link-to}}
```

上記の例では、`direction` は `posts` controller (コントローラー)のクエーリー　パラメーターだと推定されますが、しかし与えられた名前と先端のcontrollers (コントローラー)と関連付けられる、`posts` route (ルート) hierarchy (階層)のいずれかの`direction` property (プロパティー)にいかもしれません。

The `link-to` helper takes into account query parameters when determining its "active" state, and will set the class appropriately. The active state is determined by calculating whether the query params end up the same after clicking a link. You don't have to supply all of the current, active query params for this to be true.

### transitionTo

`Route#transitionTo` and `Controller#transitionToRoute` accept a final argument, which is an object with the key `queryParams`.

```app/routes/some-route.js this.transitionTo('post', object, { queryParams: { showDetails: true }}); this.transitionTo('posts', { queryParams: { sort: 'title' }});

// もしルートを変更せずにクエーリパラメーターを遷移したい場合は this.transitionTo({ queryParams: { direction: 'asc' }});

    <br />URL の遷移に関しても、クエーリパラメーターを追加することができます:
    
    ```app/routes/some-route.js
    this.transitionTo('/posts/1?sort=date&showDetails=true');
    

### Opting into a full transition

Arguments provided to `transitionTo` or `link-to` only correspond to a change in query param values, and not a change in the route hierarchy, it is not considered a full transition, which means that hooks like `model` and `setupController` won't fire by default, but rather only controller properties will be updated with new query param values, as will the URL.

But some query param changes necessitate loading data from the server, in which case it is desirable to opt into a full-on transition. To opt into a full transition when a controller query param property changes, you can use the optional `queryParams` configuration hash on the `Route` associated with that controller, and set that query param's `refreshModel` config property to `true`:

```app/routes/articles.js export default Ember.Route.extend({ queryParams: { category: { refreshModel: true } }, model(params) { // 上記の`refreshModel:true` のクエーリパラメーターを設定することで、初めて'articles' ルートが呼び出されます。

    // params has format of { category: "someValueOrJustNull" },
    // which we can forward to the server.
    return this.get('store').query('article', params);
    

} });

    <br />```app/controllers/articles.js
    export default Ember.Controller.extend({
      queryParams: ['category'],
      category: null
    });
    

### Update URL with `replaceState` instead

By default, Ember will use `pushState` to update the URL in the address bar in response to a controller query param property change, but if you would like to use `replaceState` instead (which prevents an additional item from being added to your browser's history), you can specify this on the `Route`'s `queryParams` config hash, e.g. (continued from the example above):

```app/routes/articles.js export default Ember.Route.extend({ queryParams: { category: { replace: true } } });

    <br />Note that the name of this config property and its default value of
    `false` is similar to the `link-to` helper's, which also lets
    you opt into a `replaceState` transition via `replace=true`.
    
    ### Map a controller's property to a different query param key
    
    By default, specifying `foo` as a controller query param property will
    bind to a query param whose key is `foo`, e.g. `?foo=123`. 次の設定シンタックスで、コントローラプロパティを他のクエーリパラメーターキー にマップすることも可能です:
    
    ```app/controllers/articles.js
    export default Ember.Controller.extend({
      queryParams: {
        category: 'articles_category'
      },
      category: null
    });
    

This will cause changes to the `controller:articles`'s `category` property to update the `articles_category` query param, and vice versa.

Note that query params that require additional customization can be provided along with strings in the `queryParams` array.

```app/controllers/articles.js export default Ember.Controller.extend({ queryParams: ['page', 'filter', { category: 'articles_category' }], category: null, page: 1, filter: 'recent' });

    <br />### Default values and deserialization
    
    In the following example, the controller query param property `page` is
    considered to have a default value of `1`.
    
    ```app/controllers/articles.js
    export default Ember.Controller.extend({
      queryParams: 'page',
      page: 1
    });
    

This affects query param behavior in two ways:

  1. Query param values are cast to the same datatype as the default value, e.g. a URL change from `/?page=3` to `/?page=2` will set `controller:articles`'s `page` property to the number `2`, rather than the string `"2"`. The same also applies to boolean default values.
  2. When a controller's query param property is currently set to its default value, this value won't be serialized into the URL. So in the above example, if `page` is `1`, the URL might look like `/articles`, but once someone sets the controller's `page` value to `2`, the URL will become `/articles?page=2`.

### Sticky Query Param Values

By default, query param values in Ember are "sticky", in that if you make changes to a query param and then leave and re-enter the route, the new value of that query param will be preserved (rather than reset to its default). This is a particularly handy default for preserving sort/filter parameters as you navigate back and forth between routes.

Furthermore, these sticky query param values are remembered/restored according to the model loaded into the route. So, given a `team` route with dynamic segment `/:team_name` and controller query param "filter", if you navigate to `/badgers` and filter by `"rookies"`, then navigate to `/bears` and filter by `"best"`, and then navigate to `/potatoes` and filter by `"lamest"`, then given the following nav bar links,

```handlebars
{{#link-to "team" "badgers"}}Badgers{{/link-to}}
{{#link-to "team" "bears"}}Bears{{/link-to}}
{{#link-to "team" "potatoes"}}Potatoes{{/link-to}}
```

the generated links would be

```html
<a href="/badgers?filter=rookies">Badgers</a>
<a href="/bears?filter=best">Bears</a>
<a href="/potatoes?filter=lamest">Potatoes</a>
```

This illustrates that once you change a query param, it is stored and tied to the model loaded into the route.

If you wish to reset a query param, you have two options:

  1. explicitly pass in the default value for that query param into `link-to` or `transitionTo`.
  2. use the `Route.resetController` hook to set query param values back to their defaults before exiting the route or changing the route's model.

In the following example, the controller's `page` query param is reset to 1, *while still scoped to the pre-transition `ArticlesRoute` model*. The result of this is that all links pointing back into the exited route will use the newly reset value `1` as the value for the `page` query param.

```app/routes/articles.js export default Ember.Route.extend({ resetController(controller, isExiting, transition) { if (isExiting) { // isExiting would be false if only the route's model was changing controller.set('page', 1); } } });

    <br />In some cases, you might not want the sticky query param value to be
    scoped to the route's model but would rather reuse a query param's value
    even as a route's model changes. `"controller"`に`scope` オプションと`queryParams`
    コンフィグレーションハッシュを設定することで達成することができます:
    
    ```app/controllers/articles.js
    export default Ember.Controller.extend({
      queryParams: [{
        showMagnifyingGlass: {
          scope: 'controller'
        }
      }]
    });
    

次の例は、スコープとURLのクエリーパラメーターキーをシングルるコントローラークエーリパラメータで上書きできることを示しています。

    app/controllers/articles.js
    export default Ember.Controller.extend({
      queryParams: ['page', 'filter',
        {
          showMagnifyingGlass: {
            scope: 'controller',
            as: 'glass'
          }
        }
      ]
    });