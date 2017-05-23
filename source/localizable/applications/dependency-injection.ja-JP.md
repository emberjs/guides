Emberアプリケーションは、クラスやクラス間の依存関係を宣言・インスタンス化するために、デザインパターンの1つ[依存性の注入](https://en.wikipedia.org/wiki/Dependency_injection) (DI, Dependency Injection) を利用します。 アプリケーションとアプリケーションのインスタンスはそれぞれ、EmberのDI実装の役割を果たします。

[`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html)は依存関係を宣言するための「レジストリ」として機能します。 ファクトリ (クラス) は、アプリケーションに登録されるのはもちろん、オブジェクトのインスタンス化時に適用される依存性の「注入」に関するルールにも登録されます。

[`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html)は登録されたファクトリからインスタンス化されたオブジェクトの「オーナー」として機能します。 アプリケーションインスタンスは、オブジェクトを「探す」(インスタンス化および/あるいは検索する)手段を提供します。

> *注意事項: `Application`はアプリケーション用のプライマリのレジストリとして機能しますが、各`ApplicationInstance`もまたレジストリとして機能することが可能です。 インスタンスレベルで登録を行えることは、機能のA/Bテストのような、インスタンスレベルのカスタマイズを提供するのに便利です。*

## ファクトリによる登録

ファクトリは、*route*や*template*、カスタムクラスなどのようなアプリケーションの任意の部分を表現できます。 全てのファクトリは特定のキーにより登録されます。 例えば、indexテンプレートは`template:index`をキーにして登録されます。そして、アプリケーションルートは`route:application`をキーにして登録されます.

登録に使われるキーはコロン (`:`) によって分割された2つの部分を持ちます。 1つ目の部分はフレームワークにおけるファクトリのタイプ、2つ目の部分は特定のファクトリ名を表します。 したがって、`index`テンプレートは`template:index`というキーを持つことになります。 Emberは組み込みのファクトリタイプをいくつか持っています。例えば、`service`、`route`、`template`、`component`などです.

新しいタイプのファクトリを登録さえすれば、独自のファクトリタイプを作成できます。 例えば、`user`タイプを作成するには、単に`application.register('user:user-to-register')`としてファクトリを登録するだけです。.

ファクトリの登録は、アプリケーションかアプリケーションインスタンスのイニシャライザのいずれかで行う必要があります (前者で行うのが最も一般的です)。

例えば、アプリケーションのイニシャライザで`logger:main`というキーで`Logger`ファクトリを登録する場合は以下のようにします。

```app/initializers/logger.js import Ember from 'ember';

export function initialize(application) { let Logger = Ember.Object.extend({ log(m) { console.log(m); } });

application.register('logger:main', Logger); }

export default { name: 'logger', initialize: initialize };

    <br />### すでにインスタンス化されたオブジェクトを登録する
    
    デフォルトでは、登録されたファクトリが検索されたときにEmberはそのファクトリをインスタンス化しようとします。
    既にインスタンス化されたオブジェクトをクラスの代わりに登録するときは、
    `instantiate: false`オプションを使用して、検索時に再インスタンス化を行わないようにします。
    
    以下の例では、`logger`は検索された場合は「そのまま」返す必要があるプレーンなJavaScriptオブジェクトです。
    
    ```app/initializers/logger.js
    export function initialize(application) {
      let logger = {
        log(m) {
          console.log(m);
        }
      };
    
      application.register('logger:main', logger, { instantiate: false });
    }
    
    export default {
      name: 'logger',
      initialize: initialize
    };
    

### シングルトンを登録するか、それとも非シングルトンを登録するか

デフォルトでは、登録は「シングルトン」として扱われます。 これは、最初に検索された際に作成されたインスタンスがキャッシュされ、以降の検索ではそれが返されるということを、単に意味しています。

検索される度に新鮮なオブジェクトを作成したい場合には、`singleton: false`オプションを使って、非シングルトンとしてファクトリを登録してください。

以下の例では、`Message`クラスを日シングルトンとして登録しています。

```app/initializers/notification.js import Ember from 'ember';

export function initialize(application) { let Message = Ember.Object.extend({ text: '' });

application.register('notification:message', Message, { singleton: false }); }

export default { name: 'notification', initialize: initialize };

    <br />## ファクトリの注入
    
    一旦ファクトリを登録すると、必要に応じてそれを「注入」することが可能になります。
    
    ファクトリは、*注入するタイプ*によってファクトリの「タイプ」全体に注入することが可能です。 例えば以下のようになります。
    
    ```app/initializers/logger.js
    import Ember from 'ember';
    
    export function initialize(application) {
      let Logger = Ember.Object.extend({
        log(m) {
          console.log(m);
        }
      });
    
      application.register('logger:main', Logger);
      application.inject('route', 'logger', 'logger:main');
    }
    
    export default {
      name: 'logger',
      initialize: initialize
    };
    

このタイプの注入の結果として、 `route`タイプの全てのファクトリが注入された`logger`プロパティと共にインスタンス化されます。 `logger`の値は`logger:main`と名付けられたファクトリから取得されます。.

上記を行なったアプリケーションのルートでは、注入されたloggerに以下のようにアクセスできます。

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ activate() { // The logger property is injected into all routes this.get('logger').log('Entered the index route!'); } });

    <br />以下のように完全なキーを使うことで、特定のファクトリにのみに注入を行うことも可能です。
    
    ```js
    application.inject('route:index', 'logger', 'logger:main');
    

このケースでは、loggerはindexルートだけに注入されます。

注入は、インスタンス化が必要な任意のクラスに行うことができます。これにはコンポーネント、ヘルパー、ルート、ルータなど、Emberの主要なフレームワーククラス全てが含まれます。

### アドホックな注入

`Ember.inject`を使うことで、直接Emberのクラスに依存性の注入を行うことも可能です。 現在`Ember.inject`は、コントローラー (`Ember.inject.controller`を介して) やサービス (`Ember.inject.service`を介して)の注入をサポートしています。).

以下のコードは、`cart-contents`コンポーネントに`shopping-cart`サービスを`cart`プロパティとして注入しています。

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ cart: Ember.inject.service('shopping-cart') });

    <br />プロパティと同じ名前のサービスを注入する場合は、単にサービス名を指定しないようにします (ケバブケース化された名前が使われます) 。
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      shoppingCart: Ember.inject.service()
    });
    

## ファクトリによるインスタンス検索

実行中のアプリケーションでファクトリのインスタンスをフェッチするには、アプリケーションインスタンスの[`lookup`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html#method_lookup)メソッドを呼び出します。 このメソッドはファクトリを識別する文字列の引数を一つ取り、適切なオブジェクトを返します。

```javascript
applicationInstance.lookup('factory-type:factory-name');
```

アプリケーションインスタンスは、Emberのインスタンスイニシャライザのフックに渡され、アプリケーションインスタンスによってインスタンス化された各オブジェクトの「所有者」として追加されます。

### インスタンスイニシャライザ内でのアプリケーションインスタンスの使用

インスタンスイニシャライザは引数としてアプリケーションインスタンスを受け取ります。これによって、インスタンスイニシャライザ内で登録されているファクトリのインスタンスを検索することが可能となります。

```app/instance-initializers/logger.js export function initialize(applicationInstance) { let logger = applicationInstance.lookup('logger:main');

logger.log('Hello from the instance initializer!'); }

export default { name: 'logger', initialize: initialize };

    <br />### ファクトリインスタンスからアプリケーションインスタンスを取得する
    
    [`Ember.getOwner`][4]を使うことで、オブジェクトを「所有する」アプリケーションインスタンスを取得できます。 つまり、コンポーネントやヘルパー、ルートなどのようなフレームワークオブジェクトは、実行時にアプリケーションインスタンスを使って検索を行うために、[`Ember.getOwner`][4]を使うことができるということです。
    
    例えば、このコンポーネントは歌の`audioType`に基づく異なるオーティオサービスを使って曲を演奏します。
    
    ```app/components/play-audio.js
    import Ember from 'ember';
    const {
      Component,
      computed,
      getOwner
    } = Ember;
    
    // Usage:
    //
    //   {{play-audio song=song}}
    //
    export default Component.extend({
      audioService: computed('song.audioType', function() {
        let applicationInstance = getOwner(this);
        let audioType = this.get('song.audioType');
        return applicationInstance.lookup(`service:audio-${audioType}`);
      }),
    
      click() {
        let player = this.get('audioService');
        player.play(this.get('song.file'));
      }
    });