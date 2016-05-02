每一个 Ember 应用程序都是扩展（继承）自 [`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html) 的类（class）。 这个类用于声明及配置构建应用程序所需的多个对象。（可视作一个高级的应用程序层级的命名空间）

随着应用程序的启动，它会创建一个 [`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html) 用于管理它具有状态化的一面。 这个实例是其它为你的应用程序所创建的实例对象的“所有者”。

本质上，`Application` *定义你的应用程序*而 `ApplicationInstance` *管理应用程序的状态*。.

这种在关注点上的分离不仅仅是为了明晰应用程序的架构，同时也能提到其效率。 特别是当应用程序需要在测试和／或服务端渲染（例如，通过 [FastBoot](https://github.com/tildeio/ember-cli-fastboot)）时频繁启动的时候，这一点尤其显著。 单个 `Application` 的配置可以只做一次然后在多个状态化的 `ApplicationInstance` 实例之间共享。 一旦不再需要这些实例就可以丢弃它们（例如当测试运行结束或是 FaseBoot 请求完毕时）。