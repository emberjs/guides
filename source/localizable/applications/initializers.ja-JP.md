イニシャライザはアプリケーション起動時にアプリケーションを設定する機会を提供します。

イニシャライザには、アプリケーションイニシャライザとアプリケーションインスタンスイニシャライザの２種類があります。

アプリケーションイニシャライザはアプリケーション起動時に実行され、アプリケーションで[依存性の注入](../dependency-injection)を行うための主要な手段を提供します。

アプリケーションインスタンスイニシャライザは、アプリケーションインスタンスの読み込み時に実行されます。 アプリケーションの状態を初期化する手段を提供し、アプリケーションインスタンス固有の依存性注入を行う手段も提供します (A/Bテスト構成など)。

イニシャライザ内で行う処理は、アプリケーションの読み込み遅延を可能な限り抑えるために、極力軽くすべきです。 アプリケーションイニシャライザ (`deferReadiness`や`advanceReadiness`) で非同期処理を可能にする高度なテクニックも存在しますが、そうしたテクニックは一般には避けるべきです。 ほとんどの場合、非同期の読み込み条件 (ユーザー認証など) は、条件の解決を待つ間にDOMのやり取りが可能であるアプリケーションルートのフックで処理される方がよいです。

## アプリケーションイニシャライザ

アプリケーションイニシャライザはEmber CLIの`イニシャライザ`ジェネレータで作成できます。

```bash
ember generate initializer shopping-cart
```

それでは、`shopping-cart`のイニシャライザをカスタマイズし、アプリケーションの全てのルートに`cart`プロパティを注入しましょう。

```app/initializers/shopping-cart.js export function initialize(application) { application.inject('route', 'cart', 'service:shopping-cart'); };

export default { name: 'shopping-cart', initialize: initialize };

    <br />## アプリケーションインスタンスイニシャライザ
    
    アプリケーションインスタンスイニシャライザは、Ember CLIの`instance-initializer`ジェネレータを使用して、次のように作成できます。
    
    ```bash
    ember generate instance-initializer logger
    

次に、インスタンスが起動していることを示すいくつかの単純なログを追加してみましょう。

```app/instance-initializers/logger.js export function initialize(applicationInstance) { let logger = applicationInstance.lookup('logger:main'); logger.log('Hello from the instance initializer!'); }

export default { name: 'logger', initialize: initialize };

    <br />## イニシャライザの順序を指定する
    
    もしイニシャライザの実行順を制御したければ、`before`と (もしくは) `after`オプションを使用します。
    
    ```app/initializers/config-reader.js
    export function initialize(application) {
      // ... your code ...
    };
    
    export default {
      name: 'config-reader',
      before: 'websocket-init',
      initialize: initialize
    };
    

```app/initializers/websocket-init.js export function initialize(application) { // ... your code ... };

export default { name: 'websocket-init', after: 'config-reader', initialize: initialize };

    <br />```app/initializers/asset-init.js
    export function initialize(application) {
      // ... your code ...
    };
    
    export default {
      name: 'asset-init',
      after: ['config-reader', 'websocket-init'],
      initialize: initialize
    };
    

順序付けは、同じタイプのイニシャライザにのみ適用されます(アプリケーションorアプリケーションインスタンス) 。 アプリケーションイニシャライザは、常にアプリケーションインスタンスイニシャライザより前に実行されます。