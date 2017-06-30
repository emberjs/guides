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

サービスにアクセスするには、`Ember.inject.service`を使って、そのサービスをDIコンテナ (コンポーネントや別のサービスなど) に注入します。 この機能を使用するには2つの方法があります。 引数なしで呼び出すことも、サービスの登録名を渡すことも可能です。 引数が渡されなかった場合は、サービスは変数キーの名前に基づいて読み込まれます。 ショッピングカートサービスを引数なしで読み込むには以下のようにします。

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js shoppingCart: Ember.inject.service() });

    <br />引数としてサービス名を与えることで、サービスを注入する方法もあります。
    
    ```app/components/cart-contents.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      //will load the service in file /app/services/shopping-cart.js
      cart: Ember.inject.service('shopping-cart')
    });
    

この方法では、ショッピングカートサービスをコンポーネントに注入して、`cart`プロパティとして利用可能にしています。

時にはサービスが存在するかしないかが定まらないこともあります。イニシャライザが条件付きでサービスを登録するような場合です。 通常は存在しないサービスを注入しようとするとエラーが投げられるので、Emberの[`getOwner`](https://emberjs.com/api/classes/Ember.html#method_getOwner)を使ってサービスを検索する必要があります。

```app/components/cart-contents.js import Ember from 'ember';

export default Ember.Component.extend({ //will load the service in file /app/services/shopping-cart.js cart: Ember.computed(function() { return Ember.getOwner(this).lookup('service:shopping-cart'); }) });

    <br />注入されたプロパティは遅延読み込みされます。つまり、プロパティが明示的に呼び出されるまで、サービスはインスタンス化されません。
    したがって、コンポーネント内で`get`を使いサービスにアクセスする必要があります。そうでない場合は、サービスが定義されていない可能性があります。
    
    一旦読み込まれると、サービスはアプリケーションが終了するまで存続します。
    
    以下では、`cart-contents`コンポーネントにremoveアクションを追加します。
    `this.get`を使って`cart`サービスにアクセスしていることに注目してください。
    
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
    

コンポーネントにサービスを注入すると、それはテンプレート内でも使用できます。 カートからデータを取得するために`cart`が使われていることに注目してください。

    app/templates/components/cart-contents.hbs
    <ul>
      {{#each cart.items as |item|}}
        <li>
          {{item.name}}
          <button {{action "remove" item}}>Remove</button>
        </li>
      {{/each}}
    </ul>