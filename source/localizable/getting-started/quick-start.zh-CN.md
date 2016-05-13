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

还没有 npm 吗？[这里教你如何安装 Node.js 和 npm](https://docs.npmjs.com/getting-started/installing-node)。.

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

在浏览器中打开 <http://localhost:4200>。 你将看到一个干净的只写有 "Welcome to Ember" 的页面。 恭喜！ 你刚刚创建并运行了你的第一个 Ember 应用程序。

切换到你的编辑器并打开 `app/templates/application.hbs` 文件。这就是 `application` 模板了，当用户打开你的应用程序时该模板会始终显示在屏幕上。

在你的编辑器中，将 `<h1>` 标签里的 `Welcome to Ember` 改成 `PeopleTracker` 然后保存文件。 注意 Ember 会检测到你刚才所做的改变并在后台为你自动刷新页面。 你应该能看到 "Welcome to Ember" 已经变成了 "PeopleTracker"。

## 定义路由

来让我们创建一个能显示科学家列表的应用程序吧。 要做到这一点，第一步是创建一个路由。 现在，你可以把路由看作是组成你的应用程序的不同的页面。

Ember 带有一个*生成器*可以为常见的任务自动创建样板代码。要生成一个路由，可以在终端中输入：

```sh
ember generate route scientists
```

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

    <br />在你的浏览器中打开 [http://localhost:4200/scientists](http://localhost:4200/scientists)。 你应该能看到你放在 `scientists.hbs` 模板中的那个 `<h2>`，它就紧挨在 `application.hbs` 模板里那个 `<h2>` 的后面。
    
    现在我们既然已经渲染出 `scientists` 模板了，那不妨再给它一些数据让它渲染。 实现的方法是，给这条路由指定一个数据模型（_model）。我们可以通过编辑 `app/routes/scientists.js` 来指定数据模型。
    
    生成器已经替我们产生好了一些代码，我们只要在 `Route` 中添加一个 `model()`方法即可：
    
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

    <br />我们在这里使用了 `each` 辅助函数来遍历数组中的每一个元素（这个数组是我们从 `model()` 钩子函数中传递出来的），然后把每个元素输出到一个 `<li>` 标签内。
    
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
    

Copy and paste the `scientists` template into the `people-list` component's template and edit it to look as follows:

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
    

Go back to your browser and you should see that the UI looks identical. The only difference is that now we've componentized our list into a version that's more reusable and more maintainable.

You can see this in action if you create a new route that shows a different list of people. As an exercise for the reader, you may try to create a `programmers` route that shows a list of famous programmers. By re-using the `people-list` component, you can do it in almost no code at all.

## Building For Production

Now that we've written our application and verified that it works in development, it's time to get it ready to deploy to our users. To do so, run the following command:

```sh
ember build --env production
```

The `build` command packages up all of the assets that make up your application&mdash;JavaScript, templates, CSS, web fonts, images, and more.

In this case, we told Ember to build for the production environment via the `--env` flag. This creates an optimized bundle that's ready to upload to your web host. Once the build finishes, you'll find all of the concatenated and minified assets in your application's `dist/` directory.

The Ember community values collaboration and building common tools that everyone relies on. If you're interested in deploying your app to production in a fast and reliable way, check out the [Ember CLI Deploy](http://ember-cli-deploy.github.io/ember-cli-deploy/) addon.

If you deploy your application to an Apache web server, first create a new virtual host for the application. To make sure all routes are handled by index.html, add the following directive to the application's virtual host configuration

    FallbackResource index.html