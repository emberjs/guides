Super Rentals アプリケーションのホームページについて何をしたいか、考えてみましょう。

アプリケーションには次のことが考えられます:

* 利用可能な賃貸物件の表示
* 会社情報へのリンク
* 連絡先情報へのリンク
* 賃貸物件リストの都市での絞り込み表示

これらのゴールは、[Ember acceptance tests](../../testing/acceptance/)として表示することができます。 Acceptance tests (受入テスト)は実際の人がアプリケーションとインタラクトするように振る舞います、さらに自動で行うことができます、こうすることえ、アプリケーションが先にわたって壊れないことを、担保することができます。

まず、Ember CLI を使って、Acceptance tests (受入テスト)を作成します。

```shell
ember g acceptance-test list-rentals
```

コマンドを実行すると、次のメッセージが表示され、`list-rentals-test`というファイルが一つ作成されます。.

```shell
installing acceptance-test
  create tests/acceptance/list-rentals-test.js
```

新しいテストファイルを開けると、`list-rentals` route (ルート)に移動して、route (ルート)が読み読まれることを確認するための、ボイラープレートコードがあります。 このボイラープレートコードは、初めての、実効的なacceptance test (受入テスト)へを導いてくれます。 ここでは index route (index ルート)つまり、`/`をテストしているので、まず`/list-rentals` を編集して `/`とします:

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

では、新規のウィンドウのコマンドラインで`ember test --server`を実効して、テストスイートが(JSHintと共に) acceptance test (受入テスト)が一つ成功していることが、確認できるはずです。

先に述べたように、このテスト ボイラープレートは環境をチェックするだけのためのものです、そこで、それらを、ゴールに合わせて、置き換えていきましょう。

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

これらのテストは、失敗します、なぜなら、Ember tests (Ember テスト)は何もテストしない場合(`assertion`として知られる)、テストは失敗で終わるからです。 すでに、アプリケーションがどのようになるのか、アイデアがあるので、それらをもとにして詳細をテストに追加することができます。

Ember は route (ルート)へのアクセス、フィールドへの入力、要素をクリックする、ベージの描画を待つ、といったacceptance tests (受入テスト)での一般的なタスクをテストヘルパーとして提供しています。

We want the main focus of our site to be selecting rentals, so we plan to redirect traffic going to the root URL `/`, to our `rentals` route. We can create a simple test using our test helpers to verify this:

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should redirect to rentals route', function (assert) {
  visit('/');
  andThen(function() {
    assert.equal(currentURL(), '/rentals', 'should redirect automatically');
  });
});
</code></pre>

A few helpers are in play in this test:

* The [`visit`](http://emberjs.com/api/classes/Ember.Test.html#method_visit) helper loads the route specified for the given URL.
* The [`andThen`](../../testing/acceptance/#toc_wait-helpers) helper waits for all previously called test helpers to complete before executing the function you provide it. In this case, we need to wait for the page to load after `visit`, so that we can assert that the listings are displayed.
* [`currentURL`](http://emberjs.com/api/classes/Ember.Test.html#method_currentURL) returns the URL that test application is currently visiting.

To check that rentals are listed, we'll first visit the index route and check that the results show 3 listings:

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should list available rentals.', function (assert) {
  visit('/');
  andThen(function () {
    assert.equal(find('.listing').length, 3, 'should see 3 listings');
  });
});
</code></pre>

The test assumes that each rental element will have a CSS class called `listing`.

次のテストでは、about と contact のページへのリンクをクリックすると、適切なURLが読み込まれることを確認します。 [`click`](http://emberjs.com/api/classes/Ember.Test.html#method_click) helper (ヘルパー)を使って、ユーザーのクリックをシュミレートします。 新規の画面が読み込まれると、[`currentURL`](http://emberjs.com/api/classes/Ember.Test.html#method_currentURL) helper (ヘルパー)を使って、新規のURLが一致していることを、確認できます。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should link to information about the company.', function (assert) {
  visit('/');
  click('a:contains("About")');
  andThen(function () {
    assert.equal(currentURL(), '/about', 'should navigate to about');
  });
});

test('should link to contact information', function (assert) {
  visit('/');
  click('a:contains("Contact")');
  andThen(function () {
    assert.equal(currentURL(), '/contact', 'should navigate to contact');
  });
});
</code></pre>

`andThen`は使わずに、[asynchronous test helpers](../../testing/acceptance/#toc_asynchronous-helpers)を続けて呼び出すことが可能なことに注意してください。 各 asynchronous test helper (ヘルパー)は他のテストhelper (ヘルパー)が完了するまで待機するようにできているからです。

After testing URLs, we'll drill down on our main rental page to test that we can filter the list down according to a city search criteria. コンテナーが`list-filter`クラスのついた、入力フィールドがあるとしています。 その入力フィールドの検索条件には「 "Seattle" 」を入力して、フィルターアクションのトリガーとなる、キーアップイベントを送ります。 データーをコントロールしているので、都市が "Seattle" の物件が一つしかないことを知っているので、リスト内の物件の数は一つになっていて、場所は "Seattle" であるとアサートしています。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should filter the list of rentals by city.', function (assert) {
  visit('/');
  fillIn('.list-filter input', 'seattle');
  keyEvent('.list-filter input', 'keyup', 69);
  andThen(function () {
    assert.equal(find('.listing').length, 1, 'should show 1 listing');
    assert.equal(find('.listing .location:contains("Seattle")').length, 1, 'should contain 1 listing with location Seattle');
  });
});
</code></pre>

Finally, we want to verify that we can click on a specific rental and load a detailed view to the page. We'll click on the title and validate that an expanded description of the rental is shown.

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should show details for a specific rental', function (assert) {
  visit('/rentals');
  click('a:contains("Grand Old Mansion")');
  andThen(function() {
    assert.equal(currentURL(), '/rentals/grand-old-mansion', "should navigate to show route");
    assert.equal(find('.show-listing h2').text(), "Grand Old Mansion", 'should list rental title');
    assert.equal(find('.description').length, 1, 'should list a description of the property');
  });
});
</code></pre>

Of course because we have not implemented this functionality yet, our tests will all fail. Your test output should now show all failed tests, which gives us a todo list for the rest of the tutorial.

![failing tests](../../images/acceptance-test/failed-acceptance-tests.png)

As we walk through the tutorial, we'll use our acceptance tests as a checklist of functionality. When all are green, we've accomplished our high level goals!