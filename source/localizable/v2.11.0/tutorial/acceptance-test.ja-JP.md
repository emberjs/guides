Emberアプリケーションの基本的な設定や処理を説明するために、このセクションではSuper Rentalsという不動産賃貸向けEmberアプリケーションを順を追って構築していきます。 homeページ、aboutページ、contact ページから始めます。

アプリケーションの構築に取り掛かる前に、目的のアプリケーションの外観を以下に示します。

![super rentals homepage screenshot](../../images/service/style-super-rentals-maps.png)

それでは、Super Rentalsアプリケーションのhomeページで何をしたいかを考えてみましょう。

私たちはアプリケーションに次のことを求めます。

* 利用可能な賃貸物件の一覧表示
* 会社情報へのリンク
* 連絡先情報へのリンク
* 賃貸物件一覧の都市ごとの絞り込み

これらのゴールは、[EmberのAcceptance tests (受け入れテスト)](../../testing/acceptance/)として表現できます。 Acceptance tests (受け入れテスト)は、実際に人が行うように相互作用するだけでなく、それを自動で行えます。そうすることで、アプリケーションが将来にわたって壊れないことを担保できます。

それでは、Ember CLIを使って、Acceptance tests (受入テスト)を作成していきましょう。

```shell
ember g acceptance-test list-rentals
```

コマンドを実行すると、次のメッセージが表示されます。そして、`list-rentals-test`というファイルが一つ作成されます。.

```shell
installing acceptance-test
  create tests/acceptance/list-rentals-test.js
```

新しいテストファイルを開くと、`list-rentals` route (ルート)に移動して、route (ルート)が読み読まれることを確認する定型コードが現れます。 このボイラープレートコードは、初めての動作するacceptance test (受入テスト)へとあなたを導いてくれます。 ここではindex route (ルート)、つまり`/`をテストしているので、まず`/list-rentals`を編集して`/`とします。

<pre><code class="/tests/acceptance/list-rentals-test.js{-6,+7,-8,+9,-12,+13}">import { test } from 'qunit';
import moduleForAcceptance from 'super-rentals/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | list-rentals');

test('visiting /list-rentals', function(assert) {
test('visiting /', function(assert) {
  visit('/list-rentals');
  visit('/');

  andThen(function() {
    assert.equal(currentURL(), '/list-rentals');
    assert.equal(currentURL(), '/');
  });
});
</code></pre>

では、新しいコマンドラインウィンドウを立ち上げ、そこで`ember test --server`と打ってテストスイートを実行してください。JSHintの束と共に、acceptance test (受入テスト)が成功することを確認できるはずです。

先に述べたように、この定型のテストコードは環境をチェックするだけのためのものです。それでは、私たちのゴールに合わせて、このテストを置き換えていきましょう。

<pre><code class="/tests/acceptance/list-rentals-test.js">import { test } from 'qunit';
import moduleForAcceptance from 'super-rentals/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | list-rentals');

test('should redirect to rentals route', function (assert) {
});

test('should list available rentals.', function (assert) {
});

test('should link to information about the company.', function (assert) {
});

test('should link to contact information.', function (assert) {
});

test('should filter the list of rentals by city.', function (assert) {
});

test('should show details for a specific rental', function (assert) {
});
</code></pre>

`ember test --server`を実行すると、計6個のテストに失敗するでしょう。 各テストはなんのテストもしていないために失敗しています(何かをテストすることは`assertion`とも呼ばれます)。 私たちにはアプリケーションがどのようなものかわかっているので、テストに詳細を追加していけます。

Emberは、acceptance test (受入テスト)でよく目にする仕事を行うテストヘルパーを提供します。例えば、route (ルート)へのアクセス、フィールドへの入力、要素のクリック、ベージの描画を待つ、といったテストヘルパーがあります。

賃貸物件を選択することをサイトの中心にしたいので、ルートURL (`/`)へのトラフィックを、`rentals` route (ルート)にリダイレクトするようにします。 テストヘルパーを使うと、これを確認する簡単なテストを作成できます。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should redirect to rentals route', function (assert) {
  visit('/');
  andThen(function() {
    assert.equal(currentURL(), '/rentals', 'should redirect automatically');
  });
});
</code></pre>

このテストではいくつかのヘルパーが作用しています。

* [`visit`](http://emberjs.com/api/classes/Ember.Test.html#method_visit)ヘルパーは与えられたURLに沿ったroute (ルート)を読み込みます。
* [`andThen`](../../testing/acceptance/#toc_wait-helpers)ヘルパーは、それ以前に呼び出されたテストヘルパーすべての完了を待って、渡した関数を実行します。 この場合は、`visit`の後にページがロードされるのを待つ必要があります。そうすることで、賃貸物件が表示されているかを検証できます。
* [`currentURL`](http://emberjs.com/api/classes/Ember.Test.html#method_currentURL)はテストアプリケーションが現在訪れているURLを返します。

物件が一覧されていることを確認するには、まず index route (ルート)にアクセスします。そして、3つの物件が表示されることを確認します。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should list available rentals.', function (assert) {
  visit('/');
  andThen(function() {
    assert.equal(find('.listing').length, 3, 'should see 3 listings');
  });
});
</code></pre>

テストは、各物件の要素に`listing`というCSSクラスがあることを前提としています。.

次の2つのテストでは、aboutページとcontactページのリンクをクリックしたときに適切なURLが読み込まれることを確認しています。 ユーザーがリンクをクリックする操作をシュミレートするために、[`click`](http://emberjs.com/api/classes/Ember.Test.html#method_click) helper (ヘルパー)を使用しています。 そして、新しい画面が読み込まれた後、新しいURLが期待しているURLと一致していることを、[`currentURL`](http://emberjs.com/api/classes/Ember.Test.html#method_currentURL) helper (ヘルパー)を使って確認しています。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should link to information about the company.', function (assert) {
  visit('/');
  click('a:contains("About")');
  andThen(function() {
    assert.equal(currentURL(), '/about', 'should navigate to about');
  });
});

test('should link to contact information', function (assert) {
  visit('/');
  click('a:contains("Contact")');
  andThen(function() {
    assert.equal(currentURL(), '/contact', 'should navigate to contact');
  });
});
</code></pre>

ふたつの[非同期テストヘルパー](../../testing/acceptance/#toc_asynchronous-helpers)を、`andThen`あるいはPromiseを使う必要なく、連続して呼び出せることに注目してください。 これが可能なのは、非同期テストヘルパーは他のテストヘルパーが完了するまで待機するように作られているためです。

URLをテストした後は、都市の検索条件に応じて一覧を絞り込めるテストをするために、メインの賃貸ページを掘り下げます。 `list-filter`というクラスを持つコンテナーに入力フィールドがあることを見込みます。 その入力フィールドの検索条件に「Seattle」と入力し、フィルター操作のトリガーとなるキーアップイベントを送ります。 私たちはデータを制御しており、「Seattle」の物件が1つしかないことを知っています。なので、リスト内の物件の数が1つであることと、その物件の場所が「Seattle」であることを検証します。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should filter the list of rentals by city.', function (assert) {
  visit('/');
  fillIn('.list-filter input', 'seattle');
  keyEvent('.list-filter input', 'keyup', 69);
  andThen(function() {
    assert.equal(find('.listing').length, 1, 'should show 1 listing');
    assert.equal(find('.listing .location:contains("Seattle")').length, 1, 'should contain 1 listing with location Seattle');
  });
});
</code></pre>

最後に、特定の賃貸物件をクリックし、詳細ページを読み込むことを検証しましょう。 タイトルをクリックし、拡大した賃貸物件の説明が表示されることを確認します。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should show details for a specific rental', function (assert) {
  visit('/rentals');
  click('a:contains("Grand Old Mansion")');
  andThen(function() {
    assert.equal(currentURL(), '/rentals/grand-old-mansion', 'should navigate to show route');
    assert.equal(find('.show-listing h2').text(), "Grand Old Mansion", 'should list rental title');
    assert.equal(find('.description').length, 1, 'should list a description of the property');
  });
});
</code></pre>

もちろんこの機能はまだ実装していないので、テストは失敗します。 なので、`ember test --server`を実行すると、テストの出力は今のところすべて失敗します。そして、これはチュートリアルの残りのTODOリストになります。

![failing tests](../../images/acceptance-test/failed-acceptance-tests.png)

チュートリアルを通して、 acceptance test (受入テスト)を機能を満たしているかの確認に使っていきます。全てを緑色にできれば、最終的な目的の達成です!