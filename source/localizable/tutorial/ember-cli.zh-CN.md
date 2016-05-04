Ember的CLI（命令行界面），包含一系列的开发工具，可以为你生成一个标准的项目骨架。 这让你能更专注于应用本身，避免为一些边角的构建问题分神。 你可以通过`ember --help`命令查看帮助。 想了解特定命令的信息，可以使用`ember help <command-name>`。.

## 创建一个新应用

Ember CLI的`new`命令可以帮你创建一个新项目。为下一章做准备，我们来创建一个叫 `super-rentals`的应用。.

```shell
ember new super-rentals
```

## 目录结构

`new`命令生成了如下的目录结构：

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

仔细看看生成的内容：

**app**：这是存储models，components，routes，templates以及styles的文件夹，你的代码大部分都将在这个文件夹里。

**bower_components / bower.json**：Bower是一个依赖管理工具。 它用于管理前端的组件依赖（HTML，CSS，Javascript等等）。 所有Bower组件都会被安装到`bower_components`文件夹。 打开`bower.json`，可以看到自动安装的组件（Ember，JQuery，Ember Data以及用于测试的QUnit），以及他们的依赖列表。 如果你添加一个新的组件例如Bootstrap，也会发现它被安装到`bower_components`目录，并在<0>bower.json</0>罗列出来。

**config**：config目录包含项目的配置文件，你可以在`environment.js`设置他们。

**dist**：用于存放构建完成的应用，可被用于部署。

**node_modules / package.json**：这是npm所需的目录， npm是Node.js的包管理器。 Ember本身便是用Node构建的，而且也用到了大量的Node.js模块。 `package.json`文件存储当前应用的npm包依赖，你安装过的Ember-CLI插件同样会出现在这里。 依据`package.json`，用到的包被安装到 node_modules 目录中。

**public**：存储图片，字体等（静态）资源。

**vendor**：包含不被Bower管理的Javascript，CSS资源。

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