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

Don't have npm? [Learn how to install Node.js and npm here](https://docs.npmjs.com/getting-started/installing-node). For a full list of dependencies necessary for an Ember CLI project, consult our [Installing Ember](../../getting-started/) guide.

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

Open [`http://localhost:4200`](http://localhost:4200) in your browser of choice. You should see an Ember welcome page and not much else. 恭喜！ You just created and booted your first Ember app.

Let's create a new template using the `ember generate` command.

```sh
ember generate template application
```

The `application` template is always on screen while the user has your application loaded. In your editor, open `app/templates/application.hbs` and add the following:

```app/templates/application.hbs 

# PeopleTracker

{{outlet}}

    <br />Notice that Ember detects the new file and automatically reloads the
    page for you in the background. You should see that the welcome page
    has been replaced by "PeopleTracker".
    
    ## Define a Route
    
    Let's build an application that shows a list of scientists. To do that,
    the first step is to create a route. For now, you can think of routes as
    being the different pages that make up your application.
    
    Ember comes with _generators_ that automate the boilerplate code for
    common tasks. To generate a route, type this in your terminal:
    
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

    <br />In your browser, open
    [`http://localhost:4200/scientists`](http://localhost:4200/scientists). You should
    see the `<h2>` you put in the `scientists.hbs` template, right below the
    `<h1>` from our `application.hbs` template.
    
    Now that we've got the `scientists` template rendering, let's give it some
    data to render. We do that by specifying a _model_ for that route, and
    we can specify a model by editing `app/routes/scientists.js`.
    
    We'll take the code created for us by the generator and add a `model()`
    method to the `Route`:
    
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

    <br />Here, we use the `each` helper to loop over each item in the array we
    provided from the `model()` hook and print it inside an `<li>` element.
    
    ## Create a UI Component
    
    As your application grows and you notice you are sharing UI elements
    between multiple pages (or using them multiple times on the same page),
    Ember makes it easy to refactor your templates into reusable components.
    
    Let's create a `people-list` component that we can use
    in multiple places to show a list of people.
    
    As usual, there's a generator that makes this easy for us. Make a new
    component by typing:
    
    ```sh
    ember generate component people-list
    

把 `scientists` 模板的内容复制粘贴到 `people-list` 组件的模板里面，然后把它编辑成如下这个样子：

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />Note that we've changed the title from a hard-coded string ("List of
    Scientists") to a dynamic property (`{{title}}`). We've also renamed
    `scientist` to the more-generic `person`, decreasing the coupling of our
    component to where it's used.
    
    Save this template and switch back to the `scientists` template. Replace all
    our old code with our new componentized version. Components look like
    HTML tags but instead of using angle brackets (`<tag>`) they use double
    curly braces (`{{component}}`). We're going to tell our component:
    
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