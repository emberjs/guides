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

<pre><code class="javascript{-6,+7,-8,+9,-12,+13}">import { test } from 'qunit';
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

moduleForAcceptance('Acceptance | homepage');

test('should list available rentals.', function (assert) {
});

test('should link to information about the company.', function (assert) {
});

test('should link to contact information.', function (assert) {
});

test('should filter the list of rentals by city.', function (assert) {
});
</code></pre>

これらのテストは、失敗します、なぜなら、Ember tests (Ember テスト)は何もテストしない場合(`assertion`として知られる)、テストは失敗で終わるからです。 すでに、アプリケーションがどのようになるのか、アイデアがあるので、それらをもとにして詳細をテストに追加することができます。

Ember は route (ルート)へのアクセス、フィールドへの入力、要素をクリックする、ベージの描画を待つ、といったacceptance tests (受入テスト)での一般的なタスクをテストヘルパーとして提供しています。

物件が表示されているのを確認するためには、まず index route (index ルート)にアクセスして、3つの物件が表示されることを確認します。

<pre><code class="/tests/acceptance/list-rentals-test.js">test('should list available rentals.', function (assert) {
  visit('/');
  andThen(function () {
    assert.equal(find('.listing').length, 3, 'should see 3 listings');
  });
});
</code></pre>

テストは各物件に`listing`クラスがあることを、前提としています。.

[`visit`](http://emberjs.com/api/classes/Ember.Test.html#method_visit) helper (ヘルパー)は、指定されたURLの route (ルート)を読み込みます。

[`andThen`](../../testing/acceptance/#toc_wait-helpers) helper (ヘルパー)はテストしている function (関数)が実行される、以前の呼び出された、テスト helper (ヘルパー)が完了するまで待機します。 この場合、`visit`で呼び出した、ページが読み込まれるまで待ちます、そうすることで、listings が表示されているか、assert (アサート)することができます。

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

最終的に、リストを、都市の検索条件で絞り込むことができることをテストします。 コンテナーが`list-filter`クラスのついた、入力フィールドがあるとしています。 その入力フィールドの検索条件には「 "Seattle" 」を入力して、フィルターアクションのトリガーとなる、キーアップイベントを送ります。 データーをコントロールしているので、都市が "Seattle" の物件が一つしかないことを知っているので、リスト内の物件の数は一つになっていて、場所は "Seattle" であるとアサートしています。

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

当然、まだのこ機能を実装していないので、テストは失敗します。テストの出力は全て、失敗したテストになっているはずです、これでチュートリアルの残りの部分を作るためのtodoリストができました。

![failing tests](../../images/acceptance-test/failed-acceptance-tests.png)

チュートリアルを通して、 acceptance tests (受入テスト)を昨日の確認のために利用します。全てが緑色にすることができれば、最終的な目的の達成です!