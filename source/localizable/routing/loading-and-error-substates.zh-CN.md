Ember路由控制器允许提供一个可以用来表示路由读取或路由读取错误的反馈状态。

## “加载”子状态

在beforeModel、model、afterModel钩子中，数据可能需要一些时间来加载。 从技术角度来说，路由控制器会暂停跳转，直至所有钩子方法的Promise全部完全填充（fullfill）

先看如下代码：

```app/router.js Router.map(function() { this.route('slow-model'); });

    <br />```app/routes/slow-model.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.get('store').findAll('slow-model');
      }
    });
    

如果你跳转到slow-model，在model钩子方法中，查询可能需要很长的时间才能完成。 在这段时间里，用户界面并不能体现出现在正在发生的任何事情。 如果你在刷新后进入此路由，您的页面将会是一片空白，因为你并没有完全实际进入任何路由，没有任何模版会被渲染。 如果你从另一个路由跳转到slow-model，在模型完全加载之前，你仍然会看到前一个路由的模版，然后，boom，slow-model的模版会突然完全显示出来。

这种行为大多数情况下是无法接受的 ，所以，我们如何在这种类似的过渡期间去提供一个可供用户感知的视觉反馈呢？

只需要定义一个名为loading的模版（和相应的路由） The intermediate transition into the loading substate happens immediately (synchronously), the URL won't be updated, and, unlike other transitions, the currently active transition won't be aborted.

Once the main transition into `slow-model` completes, the `loading` route will be exited and the transition to `slow-model` will continue.

For nested routes, like:

```app/router.js Router.map(function() { this.route('foo', function() { this.route('bar', function() { this.route('slow-model'); }); }); });

    <br />When accessing `foo.bar.slow-model` route then Ember will alternate trying to
    find a `routeName-loading` or `loading` template in the hierarchy starting with
    `foo.bar.slow-model-loading`:
    
    1. `foo.bar.slow-model-loading`
    2. `foo.bar.loading` or `foo.bar-loading`
    3. `foo.loading` or `foo-loading`
    4. `loading` or `application-loading`
    
    It's important to note that for `slow-model` itself, Ember will not try to
    find a `slow-model.loading` template but for the rest of the hierarchy either
    syntax is acceptable. This can be useful for creating a custom loading screen
    for a leaf route like `slow-model`.
    
    When accessing `foo.bar` route then Ember will search for:
    
    1. `foo.bar-loading`
    2. `foo.loading` or `foo-loading`
    3. `loading` or `application-loading`
    
    It's important to note that `foo.bar.loading` is not considered now.
    
    ### The `loading` event
    
    If the various `beforeModel`/`model`/`afterModel` hooks
    don't immediately resolve, a [`loading`][1] event will be fired on that route.
    
    [1]: http://emberjs.com/api/classes/Ember.Route.html#event_loading
    
    ```app/routes/foo-slow-model.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.get('store').findAll('slow-model');
      },
      actions: {
        loading(transition, originRoute) {
          let controller = this.controllerFor('foo');
          controller.set('currentlyLoading', true);
          return true; // allows the loading template to be shown
        }
      }
    });
    

If the `loading` handler is not defined at the specific route, the event will continue to bubble above a transition's parent route, providing the `application` route the opportunity to manage it.

When using the `loading` handler, we can make use of the transition promise to know when the loading event is over:

```app/routes/foo-slow-model.js import Ember from 'ember';

export default Ember.Route.extend({ ... actions: { loading(transition, originRoute) { let controller = this.controllerFor('foo'); controller.set('currentlyLoading', true); transition.promise.finally(function() { controller.set('currentlyLoading', false); }); } } });

    <br />## `error` substates
    
    Ember provides an analogous approach to `loading` substates in
    the case of errors encountered during a transition.
    
    Similar to how the default `loading` event handlers are implemented,
    the default `error` handlers will look for an appropriate error substate to
    enter, if one can be found.
    
    ```app/router.js
    Router.map(function() {
      this.route('articles', function() {
        this.route('overview');
      });
    });
    

As with the `loading` substate, on a thrown error or rejected promise returned from the `articles.overview` route's `model` hook (or `beforeModel` or `afterModel`) Ember will look for an error template or route in the following order:

  1. `articles.overview-error`
  2. `articles.error` or `articles-error`
  3. `error` or `application-error`

If one of the above is found, the router will immediately transition into that substate (without updating the URL). The "reason" for the error (i.e. the exception thrown or the promise reject value) will be passed to that error state as its `model`.

The model hooks (`beforeModel`, `model`, and `afterModel`) of an error substate are not called. Only the `setupController` method of the error substate is called with the `error` as the model. See example below:

```js
setupController: function(controller, error) {
  Ember.Logger.debug(error.message);
  this._super(...arguments);
}
```

If no viable error substates can be found, an error message will be logged.

### The `error` event

If the `articles.overview` route's `model` hook returns a promise that rejects (for instance the server returned an error, the user isn't logged in, etc.), an [`error`](http://emberjs.com/api/classes/Ember.Route.html#event_error) event will fire from that route and bubble upward. This `error` event can be handled and used to display an error message, redirect to a login page, etc.

```app/routes/articles-overview.js import Ember from 'ember';

export default Ember.Route.extend({ model(params) { return this.get('store').findAll('privileged-model'); }, actions: { error(error, transition) { if (error.status === '403') { this.replaceWith('login'); } else { // Let the route above this handle the error. return true; } } } }); ```

Analogous to the `loading` event, you could manage the `error` event at the application level to avoid writing the same code for multiple routes.