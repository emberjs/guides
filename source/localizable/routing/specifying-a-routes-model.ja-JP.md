モデルからのデータをテンプレートに表示させたいことが多々あります。ルートの機能の一つは適切なモデルを読み込むことです。

たとえば、次のこのルーターをご覧ください。

```app/router.js Router.map(function() { this.route('favorite-posts'); });

    <br />`favoritePosts`ルートのモデルを読み込むには、`favoritePosts` ルートハンドラーで [`model()`][1] フックを設定します:
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#method_model
    
    ```app/routes/favorite-posts.js
    export default Ember.Route.extend({
      model() {
        return this.store.query('post', { favorite: true });
      }
    });
    

通常`model`フックは[Ember Data](../../models/)のレコードを返しますが、[プロミス](https://www.promisejs.org/)オブジェクト(Ember Dataオブジェクトまたはプロミス)を返すことも、純粋なJavaScriptのオブジェクトや配列を返すこともできます。 Ember はテンプレートを描画する前に、データが読み込まれる (プロミスが解決される) まで待機します。

そしてルートは`モデル`フックの戻り値をコントローラの`モデル`プロパティとします。 そうすることで、テンプレートの`model`プロパティとしてアクセス可能にまります。

```app/templates/favorite-posts.hbs 

# Favorite Posts {{#each model as |post|}} 

{{post.body}} {{/each}}

    <br />## ダイナミックモデル
    
    ルートの中には常に同じモデルを表示するものがあります。 例えば、`/photos`ルートは常に、アプリケーションでアクセス可能な写真の一覧を表示します。 もしユーザーが現在のルートから一旦離れて、その後戻ってきたら、モデルは変更されません。
    
    ただし、そのルートのモデルがユーザーの操作に応じて変更されることはあるでしょう。 例えば、フォトビューアーアプリケーションがあったとします。`/photos` ルートが、変更されることのない写真のリストをモデルとして、`/photos` テンプレートを描画します。 しかし、ユーザーが特定の写真をクリックすると、選択されたモデルで`photo`テンプレートを表示させたいと思います。 もしユーザーが、一旦戻り、別の写真をクリックした場合は、今度は違うモデルで `photo` テンプレートを描画させます。
    
    このような事例の場合、URL にテンプレートの情報だけではなく、どのモデルなのかという情報も含めるのが重要です。
    
    Ember はこれを [ダイナミック セグメント](../defining-your-routes/#toc_dynamic-segments)がルートを定義する達成しています。
    
    一度ダイナミックセグメントでルートを定義したら、Ember は　ダイナミックな部分をURL から摘出して、モデルフックにハッシュとして引き渡します:
    
    ```app/router.js
    Router.map(function() {
      this.route('photo', { path: '/photos/:photo_id' });
    });
    

```app/routes/photo.js export default Ember.Route.extend({ model(params) { return this.store.findRecord('photo', params.photo_id); } });

    <br />ダイナミックセグメントがあるルートの`model` フックを、ID(例えば、`47` とか `post-slug`など)をモデルに変更して、ルートのテンプレートとして描画できるようにする必要があります。 上記の例の場合は、写真のID(`params.photo_id`) を Ember Data'sの`findRecord`
    メソッドの引数としています。
    
    注意: ダイナミックセグメントがあるルートは、URLの入力があったときだけ呼び出された場合のみ、`model`フックを呼び出します。 遷移によりルートの入力があった場合は(例 [link-to](../../templates/links)Handlebarsヘルパーを利用しているときなど ) モデルのコンテキストはすでに与えられているため、フックは実行されません。 ダイナミック セグメントのないルートは常にモデル フックを実行します。
    
    ## 複数モデル
    
    複数モデルは、[Ember.RSVP.hash](http://emberjs.com/api/classes/RSVP.html#method_hash) を通じて返すことが可能です。
    `Ember.RSVP.hash` はプロミスを返す、パラメータを受け取り、すべてのプロミスが解決されたとき `Ember.RSVP.hash` 自体のプロミスが解決されます。 例えば
    
    ```app/routes/songs.js
    export default Ember.Route.extend({
      model() {
        return Ember.RSVP.hash({
          songs: this.store.findAll('song'),
          albums: this.store.findAll('album')
        });
      }
    });
    

この`songs` テンプレートでは、`{{#each}}`で利用する、曲モデルと、アルバムモデルの両方を指定して、利用することができます。

```app/templates/songs.hbs 

# Playlist

{{#each model.songs as |song|}} 

- {{song.name}} by {{song.artist}} {{/each}} 

# Albums

{{#each model.albums as |album|}} 

- {{album.title}} by {{album.artist}} {{/each}}  ```