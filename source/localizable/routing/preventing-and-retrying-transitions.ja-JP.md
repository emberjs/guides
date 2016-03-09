ルートの遷移の間に、Emberルータは遷移オブジェクトを関連する遷移に関係するるとにルートフックに引き渡します。 この遷移オブジェクトへのアクセスがあるすべてのフックには`transition.abort()`を呼ぶことで、遷移を中断する機能があります、そして遷移オブジェクトがストアされた場合は `transition.retry()`を呼び出すことで、再実行することができます。.

### `willTransition`を介して遷移を防止

`{{link-to}}`、 `transitionTo`または、URLの変更で遷移を行うとき、 カレントのアクティブルートで`willTransition` アクションが発生します。 これが、アクティブな各リーフルートルートが遷移を発生させるかどうかの決断を行うことを可能にします。

アプリケーションの状態が、ユーザーが入力する複雑なフォームを表示しているルートだとします、ユーザーが誤って戻るボタンを押してしまったとします。 遷移を中断しない限り、ユーザーはすでに入力した情報を失うかもしれません、そのような状態はユーザーにとって良いユーザー体験とは言えません。

次の例がこの状況を処理する一つの方法です。

```app/routes/form.js export default Ember.Route.extend({ actions: { willTransition(transition) { if (this.controller.get('userHasEnteredData') && !confirm('Are you sure you want to abandon progress?')) { transition.abort(); } else { // Bubble the `willTransition` action so that // parent routes can decide whether or not to abort. return true; } } } });

    <br />ユーザーが`{{link-to}}` ヘルパーをクリッスしたとき、または、アプリケーションが`transitionTo`を使って遷移を行っているとき、遷移は中断され URL は変化されずそのまま残ります。 一方で、ブラウザの戻るボタンを使って、`route:form`から離れる操作を行った、もしくはユーザーが手動でURLを書き換え、`willTransition` アクションが呼ばれる前に新しいURLに移動したとき。 この結果、`willTransition`が`transition.abort()`を呼び出しても、ブラウザは新しいURLを表示します。
    
    ### `model`、`beforeModel`、`afterModel`での遷移の中断
    
    [Asynchronous Routing](../asynchronous-routing)で説明のある、`model`、`beforeModel`、`afterModel`フックはそれぞれ遷移オブジェクトから呼び出されます。 これにより遷移先のルートが遷移を中断することが可能になります。
    
    ```app/routes/disco.js
    export default Ember.Route.extend({
      beforeModel(transition) {
        if (new Date() > new Date('January 1, 1980')) {
          alert('Sorry, you need a time machine to enter this route.');
          transition.abort();
        }
      }
    });
    

### 遷移の保存と再挑戦

中断された遷移はその後、再挑戦することが可能です。 この一般的な使用例としては、認証済ルートがユーザーをログインページにリダイレクトし、その後ユーザーが再度、ログイン後認証済ルートのもどってくるといったケースです。

```app/routes/some-authenticated.js export default Ember.Route.extend({ beforeModel(transition) { if (!this.controllerFor('auth').get('userIsLoggedIn')) { var loginController = this.controllerFor('login'); loginController.set('previousTransition', transition); this.transitionTo('login'); } } });

    <br />```app/controllers/login.js
    export default Ember.Controller.extend({
      actions: {
        login() {
          // Log the user in, then reattempt previous transition if it exists.
          var previousTransition = this.get('previousTransition');
          if (previousTransition) {
            this.set('previousTransition', null);
            previousTransition.retry();
          } else {
            // Default back to homepage
            this.transitionToRoute('index');
          }
        }
      }
    });