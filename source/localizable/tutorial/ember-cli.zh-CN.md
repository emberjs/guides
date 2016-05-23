Ember CLI 是 Ember 的命令行界面。它提供了一个标准的项目结构、一套开发工具、以及一个插件系统。 它能让 Ember 开发者更专注于构建应用程序本身，而不是花时间去构建那些为了让程序运行起来所必须的支持性结构。 在命令行环境下，你可以很简单地通过 `ember --help` 来显示 Ember CLI 所提供的所有命令。 要了解某个特定命令的详细信息，输入 `ember help <command-name>` 即可。.

## 创建一个新应用程序

要用 Ember CLI 创建一个新项目，可以使用 `new` 命令。为了给本教程的下一节做准备，你可以创建一个应用程序叫做 `super-rentals`。.

```shell
ember new super-rentals
```

## 目录结构

`new` 命令生成由以下这些文件和目录构成的项目结构：

```text
|--app
|--bower_components
|--config
|--dist
|--node_modules
|--public
|--tests
|--tmp
|--vendor

bower.json
ember-cli-build.js
package.json
README.md
testem.js
```

我们来看一下 Ember CLI 生成的这些文件夹和文件。

**app**：这里储存所有关于数据模型、组件、路由、模板和样式表的文件夹和文件。一个 Ember 项目的大部分编码都会在这个文件夹中进行。

**bower_components / bower.json**：Bower 是一个依赖管理工具。 在 Ember CLI 中，它用于管理前端插件和组件依赖（如 HTML、CSS、Javascript 等）。 所有 Bower 组件都安装在 `bower_components` 目录下。 打开 `bower.json` 即可一些已经被自动安装好的依赖，包括 Ember、JQuery、Ember Data 和用于测试的 QUnit 。 如果我们添加一个新的前端依赖，例如 Bootstrap，我们也会发现它会列在这个文件中，并且被添加到 `bower_components` 目录。

**config**：config 目录包含 `environment.js` 文件，你可以在这里配置你的应用程序。

**dist**：当我们构建好用于部署的应用程序时，所有的输出文件都被创建到这里。

**node_modules / package.json**：这两个目录和文件来自 npm。 npm 是 Node.js 的包管理器。 Ember 本身便是用 Node 构建的，而且它的操作也用到了大量的 Node.js 模块。 `package.json` 文件维护应用程序当前的所有 npm 包依赖列表。任何你安装的 Ember-CLI 插件同样会出现在这里。 所有列在 `package.json` 中的包都会被安装到 node_modules 目录中。

**public**：这个目录下包含图片、字体等静态资源。

**vendor**：这个目录包含所有不被 Bower 管理的前端依赖，诸如 Javascript 或 CSS。

**tests / testem.js**：存放自动化测试文件，另外你可以在`testem.js`配置**testem**，Ember的自动化测试工具。.

**tmp**：存放Ember CLI用到的临时文件。

**ember-cli-build.js**: This file describes how Ember CLI should build our app.

## ES6模块

If you take a look at `app/router.js`, you'll notice some syntax that may be unfamiliar to you.

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType });

Router.map(function() { });

export default Router;

    <br />Ember CLI uses ECMAScript 2015 (ES2015 for short or previously known as ES6) modules to organize application
    code.
    For example, the line `import Ember from 'ember';` gives us access to the actual
    Ember.js library as the variable `Ember`. And the `import config from
    './config/environment';` line gives us access to our app's configuration data
    as the variable `config`. `const` is a way to declare a read-only variable, 
    as to make sure it is not accidentally reassigned elsewhere. At the end of the file,
    `export default Router;` makes the `Router` variable defined in this file available 
    to other parts of the app.
    
    ## Upgrading Ember
    
    Before continuing to the tutorial, make sure that you have the most recent
    version of Ember installed. If the versions of `ember` and `ember-data` in
    `bower.json` are lower than the version number in the upper-left corner of these
    Guides, update the version numbers in `bower.json` and then run `bower install`.
    
    ## The Development Server
    
    Once we have a new project in place, we can confirm everything is working by
    starting the Ember development server:
    
    ```shell
    ember server
    

or, for short:

```shell
ember s
```

If we navigate to `localhost:4200`, we'll see our brand new app displaying the text "Welcome to Ember".