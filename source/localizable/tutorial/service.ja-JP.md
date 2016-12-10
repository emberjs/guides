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

We then append the map element we get back from the service by implementing `didInsertElement`, which is a [component lifecycle hook](../../components/the-component-lifecycle/#toc_integrating-with-third-party-libraries-with-code-didinsertelement-code). This function gets executed at render time after the component's markup gets inserted into the DOM.

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

### Fetching Maps With a Service

At this point we should have a passing component integration test, but our acceptance test should now fail, unable to find our maps service. In addition to our acceptance test failing, no maps show up when we view our web page. To actually generate the maps, we'll implement the maps service.

Accessing our maps API through a [service](../../applications/services) will give us several benefits

* It is injected with a [service locator](https://en.wikipedia.org/wiki/Service_locator_pattern), meaning it will abstract the maps API from the code that uses it, allowing for easier refactoring and maintenance.
* It is lazy-loaded, meaning it won't be initialized until it is called the first time. In some cases this can reduce your app's processor load and memory consumption.
* It is a singleton, which will allow us cache map data.
* It follows a lifecycle, meaning we have hooks to execute cleanup code when the service stops, preventing things like memory leaks and unnecessary processing.

Let's get started creating our service by generating it through Ember CLI, which will create the service file, as well as a unit test for it.

```shell
ember g service maps
```

The service will keep a cache of map elements based on location. If the map element exists in the cache, the service will return it, otherwise it will create a new one and add it to the cache.

To test our service, we'll want to assert that locations that have been previously loaded are fetched from cache, while new locations are created using the utility.

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

Note that the test uses a dummy object as the returned map element. This can be any object because it is only used to assert that the cache has been accessed. Also note that the location has been `camelized` in the cache object, so that it may be used as a key.

Now implement the service as follows. Note that we check if a map already exists for the given location and use that one, otherwise we call a Google Maps utility to create one. We abstract our interaction with the maps API behind an Ember utility so that we can test our service without making network requests to Google.

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

### Making Google Maps Available

Before implementing the map utility, we need to make the 3rd party map API available to our Ember app. There are several ways to include 3rd party libraries in Ember. See the guides section on [managing dependencies](../../addons-and-dependencies/managing-dependencies/) as a starting point when you need to add one.

Since Google provides its map API as a remote script, we'll use curl to download it into our project's vendor directory.

From your project's root directory, run the following command to put the Google maps script in your projects vendor folder as `gmaps.js`.  
`Curl` is a UNIX command, so if you are on windows you should take advantage of [Windows bash support](https://msdn.microsoft.com/en-us/commandline/wsl/about), or use an alternate method to download the script into the vendor directory.

```shell
curl -o vendor/gmaps.js https://maps.googleapis.com/maps/api/js?v=3.22
```

Once in the vendor directory, the script can be built into the app. We just need to tell Ember CLI to import it using our build file:

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

### Accessing the Google Maps API

Now that we have the maps API available to the application, we can create our map utility. Utility files can be generated using Ember CLI.

```shell
ember g util google-maps
```

The CLI `generate util` command will create a utility file and a unit test. We'll delete the unit test since we don't want to test Google code. Our app needs a single function, `createMap`, which makes use of `google.maps.Map` to create our map element, `google.maps.Geocoder` to lookup the coordinates of our location, and `google.maps.Marker` to pin our map based on the resolved location.

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

After we restart the server we should now see some end to end maps functionality show up on our front page!

![super rentals homepage with maps](../../images/service/style-super-rentals-maps.png)

### Stubbing Services in Acceptance Tests

Finally, we want to update our acceptance tests to account for our new service. While it would be great to verify that a map is displaying, we don't want to hammer the Google Maps API every time we run our acceptance test. For this tutorial we'll rely on our component integration tests to ensure that the map DOM is being attached to our screen. To avoid hitting our Maps request limit, we'll stub out our Maps service in our acceptance tests.

Often, services connect to third party APIs that are not desirable to include in automated tests. To stub these services we simply have to register a stub service that implements the same API, but does not have the dependencies that are problematic for the test suite.

Add the following code after the imports to our acceptance test:

<pre><code class="/tests/acceptance/list-rentals-test.js">import Ember from 'ember';

let StubMapsService = Ember.Service.extend({
  getMapElement() {
    return document.createElement('div');
  }
});

moduleForAcceptance('Acceptance | list rentals', {
  beforeEach() {
    this.application.register('service:stubMaps', StubMapsService);
    this.application.inject('component:location-map', 'maps', 'service:stubMaps');
  }
});
</code></pre>

What's happening here is we are adding our own stub maps service that simply creates an empty div. Then we are putting it in Ember's [registry](../../applications/dependency-injection#toc_factory-registrations), and injecting it into the `location-map` component that uses it. That way every time that component is created, our stub map service gets injected over the Google maps service. Now when we run our acceptance tests, you'll notice that maps do not get rendered as the test runs.

![acceptance tests without maps](../../images/service/acceptance-without-maps.png)