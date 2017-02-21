这份指南将会指导你如何从零开始构建一个简单的 Ember 应用程序。

我们将介绍以下步骤：

  1. 安装 Ember。
  2. 创建一个新的应用程序。
  3. 定义一个路由（Route）。
  4. 编写一个 UI 组件（Component）。
  5. 将你的应用程序构建成适合部署到生产环境的产品。

## 安装 Ember

使用 Node.js 的包管理器 npm 只需要一条命令即可安装 Ember。在终端输入：

```sh
npm install -g ember-cli
```

没有安装npm? [学习如何安装Node.js和npm](https://docs.npmjs.com/getting-started/installing-node) 获取所有Ember CLI项目依赖，参考 [Ember安装手册](../../getting-started/)

## 创建一个新的应用程序

当你通过 npm 安装好 Ember 之后，就可以在终端中使用一个新的命令 `ember` 了。你可以用 `ember new` 命令来创建一个新的应用程序。

```sh
ember new ember-quickstart
```

这一命令将会创建一个新的目录叫做 `ember-quickstart`，同时在其中设置好一个全新的 Ember 应用程序。无需额外动作，你的应用程序就已包括：

* 一个用于开发的服务器软件。
* 模板编译系统。
* JavaScript 和 CSS 压缩系统。
* 通过 Babel 来实现的 ES2015 特性。

通过集成软件包为你提供创建可直接就绪生产环境的 web 应用所需的一切基础，Ember 让开始一个新项目变得无比轻松自如。

我们来确认一下是否一切都运转正常。`cd` 到应用程序目录 `ember-quickstart` 下，并通过以下命令来启动开发服务器：

```sh
cd ember-quickstart
ember server
```

几秒钟后，你会看到如下的输出：

```text
Livereload server on http://localhost:49152
Serving on http://localhost:4200/
```

（在终端中键入 Ctrl-C 可以随时终止服务器。）

浏览器中打开[`http://localhost:4200`](http://localhost:4200) 你可以看到Ember的欢迎页面。 恭喜！ 你成功的创建和运行了你的第一个Ember程序。

接下来我们使用 `ember generate`来创建新模板。

```sh
ember generate template application
```

用户加载完应用后， `application` 模板始终存在与用户界面，打开`app/templates/application.hbs` 添加如下内容：

```app/templates/application.hbs 

# PeopleTracker

{{outlet}}

    <br />注意，Ember会检测新增文件并在后台自动更新页面。 因此我们可以看到欢迎页面变成 “PeopleTracker”。 You also added an `{{outlet}}` to this page, which means that any nested route will be rendered in that place.
    
    ## 定义route（路由）
    
    让我们构建一个显示科学家列表的应用程序。 要做到这一点，
    第一步就是创建一个路由。 现在，你可以先认为路由就是组成你应用程序的不同页面。
    
    Ember 自带的 _generators_ 可以为一些常规任务自动创建代码模板。 通过在控制台输入如下命令来创建一个名为scientists的路由：
    
    ```sh
    ember generate route scientists
    

你会看到像这样的输出：

```text
installing route
  create app/routes/scientists.js
  create app/templates/scientists.hbs
updating router
  add route scientists
installing route-test
  create tests/unit/routes/scientists-test.js
```

这就是在告诉你 Ember 已经创建了：

  1. 一个在当用户访问 `/scientists` 时用于显示的模板.
  2. 一个 `Route` 对象，该对象负责获取数据模型（model）并在模板中使用。
  3. 一个应用程序路由器里的入口（代码位于 `app/router.js`）).
  4. 一个针对该路由的单元测试。

打开新创建的 `app/templates/scientists.hbs` 模板文件并添加下列 HTML 代码：

```app/templates/scientists.hbs 

## List of Scientists

    <br />浏览器中打开
    [`http://localhost:4200/scientists`](http://localhost:4200/scientists). 你可以看到你放在 `scientists.hbs` 的 `<h2>` 位于 `application.hbs` `<h1>` 的下方。
    
    现在我们渲染了`scientists`模板, 下面我们为它渲染一些数据。 通过指定路由的 _model_ 来实现, 我们来编辑一下`app/routes/scientists.js`.
    
    我们来改一下有生成器生成的模版，在`Route`中使用`model()`
    
    ```app/routes/scientists.js{+4,+5,+6}
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return ['Marie Curie', 'Mae Jemison', 'Albert Hofmann'];
      }
    });
    

（这段代码用到了一些最新的 JavaScript 特性，有一些你可能并不熟悉。 可以通过这篇 [JavaScript 最新特性概述](https://ponyfoo.com/articles/es6) 来深入了解一下。）.)

在一个路由的 `model()` 方法中，你只需返回你想提供给模板使用的任意数据。 如果需要异步获取数据，`model()` 方法也支持任何使用 [JavaScript Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) 的库。.

现在我们来告诉 Ember 如何把上面这一组字符串转化成 HTML。打开 `scientists` 模板，添加一些 Handlebar 代码来遍历数组，然后输出︰

```app/templates/scientists.hbs{+3,+4,+5,+6,+7} 

## List of Scientists

{{#each model as |scientist|}} 

* {{scientist}} {{/each}} 

    <br />我们使用`each`去遍历数据，数据则是通过`model()`设置，最终将数据渲染到`<li>`元素。
    
    ## 创建UI组件
    
    随着应用程序的增长，我们需要共享一些UI元素给不同的页面(或者一个页面内的多次调用) Ember的可重用组件很方便的解决这个问题。
    
    我们来创建一个 `people-list` 组件，这个组件可以在多个不同的地方显示一个人员列表。
    
    跟往常一样，有一个生成器可以帮我们轻松地完成这个任务。 输入以下命令来生成一个新组件：
    
    ```sh
    ember generate component people-list
    

把 `scientists` 模板的内容复制粘贴到 `people-list` 组件的模板里面，然后把它编辑成如下这个样子：

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />注意，我们把标题从一个固定的字符串（“List of Scientists”）变成了一个动态属性（`{{title}}`）。 我们还把 `scientist` 改成了更有通用性的 `person`，这样一来，我们的组件跟其使用环境之间的耦合度就降低了。
    
    保存一下这个模板，然后切换回 `scientists` 模板。 把原有的代码都删除，替换成新的组件化的版本。 组件调用的语法看起来很像 HTML 标签，但是使用双花括号（`{{component}}`）括起来，而不是尖括号（`<tag>`）。 We're going to tell our component:
    
    1. What title to use, via the `title` attribute.
    2. What array of people to use, via the `people` attribute. We'll
       provide this route's `model` as the list of people.
    
    ```app/templates/scientists.hbs{-1,-2,-3,-4,-5,-6,-7,+8}
    <h2>List of Scientists</h2>
    
    <ul>
      {{#each model as |scientist|}}
        <li>{{scientist}}</li>
      {{/each}}
    </ul>
    {{people-list title="List of Scientists" people=model}}
    

回到你的浏览器，应该看到 UI 跟原来一模一样。唯一的区别是，现在我们已经把我们的列表组件化成了一个更容易复用和维护的版本。

如果你创建一个新的路由来显示另一个人员列表，你就能看到这个组件化的效果了。 留给读者作为练习，你可以尝试创建一个 `programmers` 路由来显示一些著名程序员的列表。 通过复用 `people-list` 组件，你几乎不用写任何代码就能实现这个功能。

## Building For Production

现在我们的程序已经写好并在开发环境中验证完毕，到了部署给用户的时候了。运行以下命令即可：

```sh
ember build --env production
```

这个 `build` 命令会把你程序中所包含的所有的资源打包起来。这些资源包括 JavaScript、模板、CSS、web 字体、图片，等等。

这里我们通过 `--env` 参数来告知 Ember，让它为生产环境来构建。 这样会创建一个优化过的包，可以直接上传到你的 web 主机。 构建完成后，你可以在 `dist/` 目录下找到所有拼接和压缩好的资源。

Ember 社群重视协作，重视打造每个人都可以依赖的常用工具。 如果你对将你的应用快速稳定地部署到生产环境中有兴趣，可以查阅[Ember CLI Deploy](http://ember-cli-deploy.com/)这个插件

如果你是要把应用程序部署到一个 Apache web 服务器上面，那么首先为其创建一个新的虚拟主机（virtual host）。 To make sure all routes are handled by index.html, add the following directive to the application's virtual host configuration

    FallbackResource index.html