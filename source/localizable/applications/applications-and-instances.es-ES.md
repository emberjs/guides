Cada aplicación de Ember se representa con una clase que extiende de [`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html). Esta clase se utiliza para declarar y configurar los múltiples objetos que forman parte de tu aplicación.

As your application boots, it creates an [`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html) that is used to manage its stateful aspects. This instance acts as the "owner" of objects instantiated for your app.

Essentially, the `Application` *defines your application* while the `ApplicationInstance` *manages its state*.

This separation of concerns not only clarifies the architecture of your app, it can also improve its efficiency. This is particularly true when your app needs to be booted repeatedly during testing and / or server-rendering (e.g. via [FastBoot](https://github.com/tildeio/ember-cli-fastboot)). The configuration of a single `Application` can be done once and shared among multiple stateful `ApplicationInstance` instances. These instances can be discarded once they're no longer needed (e.g. when a test has run or FastBoot request has finished).