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

**bower_components / bower.json**：Bower 是一个依赖管理工具。 在 Ember CLI 中，它用于管理前端插件和组件依赖（如 HTML、CSS、Javascript 等）。 所有 Bower 组件都安装在 `bower_components` 目录下。 If we open `bower.json`, we see the list of dependencies that are installed automatically including Ember, Ember CLI Shims, Ember CLI Test Loader, and QUnit (for testing). If we add additional front-end dependencies, such as Bootstrap, we will see them listed here, and added to the `bower_components` directory.

**config**：config 目录包含 `environment.js` 文件，你可以在这里配置你的应用程序。

**dist**：当我们构建好用于部署的应用程序时，所有的输出文件都被创建到这里。

**node_modules / package.json**：这两个目录和文件来自 npm。 npm 是 Node.js 的包管理器。 Ember 本身便是用 Node 构建的，而且它的操作也用到了大量的 Node.js 模块。 `package.json` 文件维护应用程序当前的所有 npm 包依赖列表。任何你安装的 Ember-CLI 插件同样会出现在这里。 所有列在 `package.json` 中的包都会被安装到 node_modules 目录中。

**public**：这个目录下包含图片、字体等静态资源。

**vendor**：这个目录包含所有不被 Bower 管理的前端依赖，诸如 Javascript 或 CSS。

**tests / testem.js**：自动化测试都在 `tests` 文件夹中。Ember CLI 的测试运行器 **testem** 则在 `testem.js` 文件中进行配置。.

**tmp**：存放 Ember CLI 的临时文件。

**ember-cli-build.js**：这个文件描述 Ember CLI 应该如何构建我们的应用程序。

## ES6 模块

如果你观察一下 `app/router.js` 文件就会发现，有些语法可能对你来说不太熟悉。

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType });

Router.map(function() { });

export default Router;

    <br />Ember CLI 使用 ECMAScript 2015（简称 ES2015，以前也叫 ES6）模块来组织应用程序代码。
    比如说 `import Ember from 'ember';` 这一行，让我们可以通过 `Ember` 变量来访问实际的 Ember.js 库。 而 `import config from './config/environment';` 这一行则让我们可以通过 `config` 变量来访问程序的配置数据。 `const` 是一种声明只读变量的方法，以确保该变量的值不会在其它地方被误更改。 在文件的末尾，`export default Router;` 使得此文件中定义的 `Router` 变量可以从应用程序的其它地方来调用。
    
    ## Upgrading Ember
    
    Before continuing to the tutorial, make sure that you have the most recent
    versions of Ember and Ember Data installed. If the version of `ember` in
    `bower.json` is lower than the version number in the upper-left corner of these
    Guides, update the version number in `bower.json` and then run `bower install`.
    Similarly, if the version of `ember-data` in `package.json` is lower, update the
    version number and then run `npm install`.
    
    ## The Development Server
    
    Once we have a new project in place, we can confirm everything is working by
    starting the Ember development server:
    
    ```shell
    ember server
    

也可以缩写如下：

```shell
ember s
```

用浏览器打开 `localhost:4200`，就可以看到我们崭新的应用程序正在显示一行文本：“Welcome to Ember”。