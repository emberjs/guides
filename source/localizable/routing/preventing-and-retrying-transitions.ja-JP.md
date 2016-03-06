ルートの遷移の間に、Emberルータは遷移オブジェクトを関連する遷移に関係するるとにルートフックに引き渡します。 この遷移オブジェクトへのアクセスがあるすべてのフックには`transition.abort()`を呼ぶことで、遷移を中断する機能があります、そして遷移オブジェクトがストアされた場合は `transition.retry()`を呼び出すことで、再実行することができます。.

### `willTransition`を介して遷移を防止

`{{link-to}}`、 `transitionTo`または、URLの変更で遷移を行うとき、 カレントのアクティブルートで`willTransition` アクションが発生します。 これが、アクティブな各リーフルートルートが遷移を発生させるかどうかの決断を行うことを可能にします。

Imagine your app is in a route that's displaying a complex form for the user to fill out and the user accidentally navigates backwards. Unless the transition is prevented, the user might lose all of the progress they made on the form, which can make for a pretty frustrating user experience.

次の例がこの状況を処理する一つの方法です。

```app/routes/form.js export default Ember.Route.extend({ actions: { willTransition(transition) { if (this.controller.get('userHasEnteredData') && !confirm('Are you sure you want to abandon progress?')) { transition.abort(); } else { // Bubble the `willTransition` action so that // parent routes can decide whether or not to abort. return true; } } } });

    <br />When the user clicks on a `{{link-to}}` helper, or when the app initiates a
    transition by using `transitionTo`, the transition will be aborted and the URL
    will remain unchanged. However, if the browser back button is used to
    navigate away from `route:form`, or if the user manually changes the URL, the
    new URL will be navigated to before the `willTransition` action is
    called. This will result in the browser displaying the new URL, even if
    `willTransition` calls `transition.abort()`.
    
    ### Aborting Transitions Within `model`, `beforeModel`, `afterModel`
    
    The `model`, `beforeModel`, and `afterModel` hooks described in
    [Asynchronous Routing](../asynchronous-routing)
    each get called with a transition object. This makes it possible for
    destination routes to abort attempted transitions.
    
    ```app/routes/disco.js
    export default Ember.Route.extend({
      beforeModel(transition) {
        if (new Date() > new Date('January 1, 1980')) {
          alert('Sorry, you need a time machine to enter this route.');
          transition.abort();
        }
      }
    });
    

### Storing and Retrying a Transition

Aborted transitions can be retried at a later time. A common use case for this is having an authenticated route redirect the user to a login page, and then redirecting them back to the authenticated route once they've logged in.

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