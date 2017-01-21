Super Rentalsでは、各賃貸物件の場所を示す地図を表示できるようにしたいと考えています。 この機能を実装するために、いくつかのEmberの概念を利用します。

  1. それぞれの賃貸物件の地図を表示するcomponent (コンポーネント)
  2. 描画された地図のキャッシュをアプリケーションのさまざまな場所で使用するための service (サービス)
  3. Google Maps APIから地図を作成するためのユーティリティ関数

地図を表示するところから始め、Google Map APIを使用して仕事を締めくくることにしましょう。

### Component (コンポーネント) に地図を表示する

地図上に賃貸物件の都市を示すコンポーネントを追加することから始めます。

<pre><code class="app/templates/components/rental-listing.hbs{+19}">&lt;article class="listing"&gt;
  &lt;a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}"&gt;
    &lt;img src="{{rental.image}}" alt=""&gt;
    &lt;small&gt;View Larger&lt;/small&gt;
  &lt;/a&gt;
  &lt;h3&gt;{{rental.title}}&lt;/h3&gt;
  &lt;div class="detail owner"&gt;
    &lt;span&gt;Owner:&lt;/span&gt; {{rental.owner}}
  &lt;/div&gt;
  &lt;div class="detail type"&gt;
    &lt;span&gt;Type:&lt;/span&gt; {{rental-property-type rental.type}} - {{rental.type}}
  &lt;/div&gt;
  &lt;div class="detail location"&gt;
    &lt;span&gt;Location:&lt;/span&gt; {{rental.city}}
  &lt;/div&gt;
  &lt;div class="detail bedrooms"&gt;
    &lt;span&gt;Number of bedrooms:&lt;/span&gt; {{rental.bedrooms}}
  &lt;/div&gt;
  {{location-map location=rental.city}}
&lt;/article&gt;
</code></pre>

次に、Ember CLIを使って地図 component (コンポーネント)を生成します。

```shell
ember g component location-map
```

このコマンドを実行すると、component (コンポーネント)のJavaScriptファイル、テンプレート、テストファイルの3つのファイルが生成されます。 component (コンポーネント)で実現したいことを考えてみるために、まずテストを実装します。

この場合、Google Maps service (サービス)の地図表示の処理を考えます。 私たちのcomponent (コンポーネント)の仕事は、地図サービス（マップ要素）の結果をコンポーネントテンプレートの要素に追加することです。

この動作を検証することにテストを制限するため、登録APIを利用して地図サービスのスタブを提供します。 アプリケーションの実際のオブジェクトの代わりにスタブをたて、その動作をシミュレートします。 スタブサービスでは、`getMapElement`が呼び出された場所に基づいた地図をフェッチするメソッドを定義します。.

<pre><code class="tests/integration/components/location-map-test.js">import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

let StubMapsService = Ember.Service.extend({
  getMapElement(location) {
    this.set('calledWithLocation', location);
    // We create a div here to simulate our maps service,
    // which will create and then cache the map element
    return document.createElement('div');
  }
});

moduleForComponent('location-map', 'Integration | Component | location map', {
  integration: true,
  beforeEach() {
    this.register('service:maps', StubMapsService);
    this.inject.service('maps', { as: 'mapsService' });
  }
});

test('should append map element to container element', function(assert) {
  this.set('myLocation', 'New York');
  this.render(hbs`{{location-map location=myLocation}}`);
  assert.equal(this.$('.map-container').children().length, 1, 'the map element should be put onscreen');
  assert.equal(this.get('mapsService.calledWithLocation'), 'New York', 'a map of New York should be requested');
});
</code></pre>

各テストの前に実行される`beforeEach`関数では、暗黙的な関数`this.register`を使用して、地図サービスの代わりにスタブサービスを登録します。 サービスを登録すると、テンプレートからcomponent (コンポーネント)をロードしたり、今回のようにサービスを注入したりするために、Emberアプリケーションでオブジェクトを使用できるようになります。

`this.inject.service`関数を呼び出すと、たったいま登録したサービスがテストのコンテキストに挿入されます。そのため、それぞれのテストは`this.get('mapsService')`を介してサービスにアクセスが可能です。 この例では、スタブ内の`calledWithLocation`がコンポーネントに渡された位置に設定されていることを検証しています。

テストを通すには、コンテナ要素をcomponent (コンポーネント)のテンプレートに追加します。

<pre><code class="app/templates/components/location-map.hbs">&lt;div class="map-container"&gt;&lt;/div&gt;
</code></pre>

次に、コンポーネントを更新して、地図の出力を内部のコンテナ要素に追加します。 地図サービスのインジェクションを追加し、提供されたlocationを使って`getMapElement`関数を呼び出します。

次に、[コンポーネントのライフサイクルフック](../../components/the-component-lifecycle/#toc_integrating-with-third-party-libraries-with-code-didinsertelement-code)である`didInsertElement`を実装して、サービスから取得したmap要素を追加します。 この関数は、コンポーネントのマークアップがDOMに挿入された後、描画時に実行されます。

<pre><code class="app/components/location-map.js">import Ember from 'ember';

export default Ember.Component.extend({
  maps: Ember.inject.service(),

  didInsertElement() {
    this._super(...arguments);
    let location = this.get('location');
    let mapElement = this.get('maps').getMapElement(location);
    this.$('.map-container').append(mapElement);
  }
});
</code></pre>

### サービスで地図を取得する

この時点でコンポーネントのインテグレーションテストは通るはずです。ただし、Webページで開いたときには何の地図も表示されません。実際に地図を作成するために、mapsサービスを実装していきます。

[サービス](../../applications/services)を使用して地図APIにアクセスすると、いくつかのメリットが得られます。

* サービスは[service locator](https://en.wikipedia.org/wiki/Service_locator_pattern)を使って注入されます。そして、地図APIをコードから抽象化することで、リファクタリングとメンテナンスを容易にします。
* サービスは遅延ロードされているため、最初に呼び出されるまで初期化されません。 場合によっては、これによってアプリのプロセッサ負荷とメモリ消費量を減少できる可能性があります。
* サービスはSingleton (シングルトン)であり、地図データをキャッシュ可能にします。
* サービスはライフサイクルに従います。つまり、サービスが停止したときにクリーンアップコードを実行してメモリリークや不要な処理などを防ぐフックを持ちます。

Ember CLIを使用してサービスを作成してみましょう。Ember CLIを使用すると、サービスファイルとサービスファイルの単体テストが作成されます。

```shell
ember g service maps
```

このサービスは、位置に基づいて地図要素のキャッシュを保持します。 地図要素がキャッシュに存在する場合、サービスはそれを返します。そうでなければ、新しい要素を作成してキャッシュに追加します。

このサービスをテストするために、新しい位置情報がユーティリティを使って作成された際に、以前にロードされた位置情報がキャッシュからフェッチされることを検証したいと思うでしょう。

<pre><code class="tests/unit/services/maps-test.js">import { moduleFor, test } from 'ember-qunit';
import Ember from 'ember';

const DUMMY_ELEMENT = {};

let MapUtilStub = Ember.Object.extend({
  createMap(element, location) {
    this.assert.ok(element, 'createMap called with element');
    this.assert.ok(location, 'createMap called with location');
    return DUMMY_ELEMENT;
  }
});

moduleFor('service:maps', 'Unit | Service | maps', {
  needs: ['util:google-maps']
});

test('should create a new map if one isnt cached for location', function (assert) {
  assert.expect(4);
  let stubMapUtil = MapUtilStub.create({ assert });
  let mapService = this.subject({ mapUtil: stubMapUtil });
  let element = mapService.getMapElement('San Francisco');
  assert.ok(element, 'element exists');
  assert.equal(element.className, 'map', 'element has class name of map');
});

test('should use existing map if one is cached for location', function (assert) {
  assert.expect(1);
  let stubCachedMaps = Ember.Object.create({
    sanFrancisco: DUMMY_ELEMENT
  });
  let mapService = this.subject({ cachedMaps: stubCachedMaps });
  let element = mapService.getMapElement('San Francisco');
  assert.equal(element, DUMMY_ELEMENT, 'element fetched from cache');
});
</code></pre>

テストでダミーオブジェクトを地図要素として返して使用していることに注目してください。 地図要素はキャッシュがアクセスされたことを検証するためだけに使われるので、任意のオブジェクトにすることができます。 また、キーとして使用するために、キャッシュオブジェクトの中で場所が`キャメルケース化`されていることに注目してください。

サービスを以下に示すように実装します。 指定された場所の地図が既に存在するかどうかを確認し、あればその地図を使用します。そうでなければ、Google Mapsユーティリティを呼び出して地図を作成します。 Emberユーティリティの背後にあるmaps APIとのやりとりを抽象化し、Googleへネットワークリクエストを発行しなくてもサービスをテストできるようにします。

```app/services/maps.js
import Ember from 'ember';
import MapUtil from '../utils/google-maps';

export default Ember.Service.extend({

  init() {
    if (!this.get('cachedMaps')) {
      this.set('cachedMaps', Ember.Object.create());
    }
    if (!this.get('mapUtil')) {
      this.set('mapUtil', MapUtil.create());
    }
  },

  getMapElement(location) {
    let camelizedLocation = location.camelize();
    let element = this.get(`cachedMaps.${camelizedLocation}`);
    if (!element) {
      element = this.createMapElement();
      this.get('mapUtil').createMap(element, location);
      this.set(`cachedMaps.${camelizedLocation}`, element);
    }
    return element;
  },

  createMapElement() {
    let element = document.createElement('div');
    element.className = 'map';
    return element;
  }

});
```

### Googleマップを利用できるようにする

地図ユーティリティを実装する前に、EmberアプリケーションでサードパーティマップAPIを利用できるようにする必要があります。 Emberにサードパーティライブラリを含めるにはいくつかの方法があります。 サードパーティライブラリを追加する方法は、[依存関係を管理する](../../addons-and-dependencies/managing-dependencies/)のガイドを参照してください。

GoogleはマップAPIをリモートスクリプトとして提供しています。curlを使用してプロジェクトのvendorディレクトリにダウンロードしましょう。

プロジェクトのルートディレクトリから次のコマンドを実行して、Google Mapのスクリプトを`gmaps.js`という名前でプロジェクトのvenderフォルダの下に置きます。 `Curl`はUNIXコマンドです。もしWindowsを使っている場合は[Windows bash サポート](https://msdn.microsoft.com/en-us/commandline/wsl/about)を活用するか、別の方法を使って、スクリプトをvenderディレクトリの下にダウンロードする必要があります。

```shell
curl -o vendor/gmaps.js https://maps.googleapis.com/maps/api/js?v=3.22
```

vendorディレクトリに入れることで、スクリプトをアプリに組み込むことができます。 あとは、ビルドファイルを使って、Ember CLIにインポートするよう指示するだけです。

<pre><code class="ember-cli-build.js{+22}">/*jshint node:true*/
/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    // Add options here
  });

  //  `app.import`を使って出力ファイルにライブラリーを追加します。 to add additional 
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  app.import('vendor/gmaps.js');

  return app.toTree();
};
</code></pre>

### Google Maps APIにアクセスする

アプリケーションでマップAPIを使用できるようになったので、マップユーティリティを作成できます。 ユーティリティファイルは、Ember CLIを使用して生成することができます。

```shell
ember g util google-maps
```

CLIの`generate util`コマンドは、ユーティリティファイルとユニットテストを作成します。 Googleコードのテストはしたくないので、ユニットテストは削除しましょう。 このアプリケーションには`createMap`という関数が必要です。この関数では、` google.maps.Map`を使用して地図要素を作成し、`google.maps.Geocoder`を使って場所の座標を検索し、`google.maps.Marker`を使って解決された位置情報に基づいて地図上にピンを立てます。

<pre><code class="app/utils/google-maps.js">import Ember from 'ember';

const google = window.google;

export default Ember.Object.extend({

  init() {
    this.set('geocoder', new google.maps.Geocoder());
  },

  createMap(element, location) {
    let map = new google.maps.Map(element, { scrollwheel: false, zoom: 10 });
    this.pinLocation(location, map);
    return map;
  },

  pinLocation(location, map) {
    this.get('geocoder').geocode({address: location}, (result, status) =&gt; {
      if (status === google.maps.GeocoderStatus.OK) {
        let geometry = result[0].geometry.location;
        let position = { lat: geometry.lat(), lng: geometry.lng() };
        map.setCenter(position);
        new google.maps.Marker({ position, map, title: location });
      }
    });
  }

});
</code></pre>

サーバーを再起動すると、地図機能がフロントページ上に表示されるはずです!

![super rentals homepage with maps](../../images/service/style-super-rentals-maps.png)

### acceptance test (受入テスト) におけるスタブサービス

最後に、新しいサービスを考慮して受け入れテストを更新したいと思います。 地図が表示されていることを確認することは良いことですが、受け入れテストを実行するたびにGoogle Maps APIを叩きたくはありません。 このチュートリアルでは、コンポーネントのインテグレーションテストを使用して、マップDOMが画面にアタッチされていることを確認します。 APIリクエストの制限を超えないように、受入テストでは地図サービスをスタブします。

サービスはしばしば、自動化テストに含めることが望ましくないサードパーティのAPIに接続することがあります。 これらのサービスをスタブするには、テストスイートに問題のある依存関係は持ち込まず、同じAPIを実装するスタブサービスを登録するだけで済みます。

acceptance test (受入テスト) の後に、次のコードを追加してください。

<pre><code class="/tests/acceptance/list-rentals-test.js{+3,+5,+6,+7,+8,+9,+10,-11,+12,+13,+14,+15,+16,+17}">import { test } from 'qunit';
import moduleForAcceptance from 'super-rentals/tests/helpers/module-for-acceptance';
import Ember from 'ember';

let StubMapsService = Ember.Service.extend({
  getMapElement() {
    return document.createElement('div');
  }
});

moduleForAcceptance('Acceptance | list-rentals');
moduleForAcceptance('Acceptance | list rentals', {
  beforeEach() {
    this.application.register('service:stubMaps', StubMapsService);
    this.application.inject('component:location-map', 'maps', 'service:stubMaps');
  }
});
</code></pre>

ここでは、空のdivを作成する独自のスタブ地図サービスを追加しています。 次にEmberの[registry](../../applications/dependency-injection#toc_factory-registrations)に配置し、サービスを使用する`location-map `コンポーネントに挿入します。 コンポーネントが作られるたびに、スタブ地図サービスがGoogleマップサービスに注入されます。 acceptance test (受入テスト)を実行すると、テストが実行されるときに地図が描画されないことを確認できます。

![acceptance tests without maps](../../images/service/acceptance-without-maps.png)