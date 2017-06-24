[`Ember.Service`](http://emberjs.com/api/classes/Ember.Service.html)はアプリケーションが存続している間に生きているEmberオブジェクトで、アプリケーションの様々な部分から利用することができます。

サービスは、状態の共有や永続的な接続が必要な機能に役立ちます。サービスの使用例には、以下のようなものがあります。

* ユーザーやセッションの認証
* 位置情報
* WebSocket
* Server Sent Events や通知
* Ember Dataに適合しないサーバーAPIの呼び出し
* サードパーティ製API
* ログの記録

### サービスを定義する

サービスはEmber CLIの`service`ジェネレータを使って作成できます。例えば、次のコマンドは`ShoppingCart`サービスを作成します。

```bash
ember generate service shopping-cart
```

サービスは必ず[`Ember.Service`](http://emberjs.com/api/classes/Ember.Service.html)基底クラスを継承しなければなりません。

```app/services/shopping-cart.js import Ember from 'ember';

export default Ember.Service.extend({ });

    <br />他のEmberオブジェクトと同様に、サービスは初期化され、独自のプロパティとメソッドを持つことが可能です。
    以下に示すショッピングカートサービスでは、現在ショッピングカートに入っているアイテムを表すアイテムの配列を管理します。
    
    ```app/services/shopping-cart.js
    import Ember from 'ember';
    
    export default Ember.Service.extend({
      items: null,
    
      init() {
        this._super(...arguments);
        this.set('items', []);
      },
    
      add(item) {
        this.get('items').pushObject(item);
      },
    
      remove(item) {
        this.get('items').removeObject(item);
      },
    
      empty() {
        this.get('items').clear();
      }
    });
    

### サービスにアクセスする

サービスにアクセスするには、`Ember.inject.service`を使って、そのサービスをDIコンテナ (コンポーネントや別のサービスなど) に注入します。 There are 2 ways to use this function. You can either invoke it with no arguments, or you can pass it the registered name of the service. When no arguments are passed, the service is loaded based on the name of the variable key. You can load the shopping cart service with no arguments like below.

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js shoppingCart: Ember.inject.service() });

    <br />Another way to inject a service is to provide the name of the service as the argument.
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      //will load the service in file /app/services/shopping-cart.js
      cart: Ember.inject.service('shopping-cart')
    });
    

This injects the shopping cart service into the component and makes it available as the `cart` property.

Sometimes a service may or may not exist, like when an initializer conditionally registers a service. Since normal injection will throw an error if the service doesn't exist, you must look up the service using Ember's [`getOwner`](https://emberjs.com/api/classes/Ember.html#method_getOwner) instead.

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js cart: Ember.computed(function() { return Ember.getOwner(this).lookup('service:shopping-cart'); }) });

    <br />Injected properties are lazy loaded; meaning the service will not be instantiated until the property is explicitly called.
    Therefore you need to access services in your component using the `get` function otherwise you might get an undefined.
    
    Once loaded, a service will persist until the application exits.
    
    Below we add a remove action to the `cart-contents` component.
    Notice that below we access the `cart` service with a call to`this.get`.
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      cart: Ember.inject.service('shopping-cart'),
    
      actions: {
        remove(item) {
          this.get('cart').remove(item);
        }
      }
    });
    

Once injected into a component, a service can also be used in the template. Note `cart` being used below to get data from the cart.

    app/templates/components/cart-contents.hbs
    <ul>
      {{#each cart.items as |item|}}
        <li>
          {{item.name}}
          <button {{action "remove" item}}>Remove</button>
        </li>
      {{/each}}
    </ul>