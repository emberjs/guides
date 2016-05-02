Ember 的起步是很容易的。Ember 使用命令行构建工具 Ember CLI 来创建和管理项目。

* 现代化的应用程序静态资源管理（包括文件合并、压缩，以及版本控制）。
* 帮助创建组件、路由及更多的生成器。
* 常规的项目结构使得既有的 Ember 应用程序也很容易套用。
* 通过 [Babel](http://babeljs.io/docs/learn-es2015/) 项目支持 ES2015／ES6 JavaScript。 这也包含了对于 [Javascript 模块](http://exploringjs.com/es6/ch_modules.html)的支持，本指南将通篇使用这一特性。
* 完整的 [QUnit](https://qunitjs.com/) 测试集成。
* 通过不断增长的 Ember Addons 插件生态系统持续受益。

## 依赖

### Node.js 和 npm

Ember CLI 使用 JavaScript 创建，并且需要 [Node.js](https://nodejs.org/) 运行环境的支持。 它还需要通过 [npm](https://www.npmjs.com/) 来获取依赖的模块和软件包。 npm 与 Node.js 是打包在一起的，所以如果你的计算机已经安装了 Node.js 那就一切就绪了。

Ember 需要 Node.js 0.12 或是更高版本以及 npm 2.7 及以上。若你无法确定你是否安装了 Node.js 以及版本号是否合乎要求，那就在命令行运行以下命令：

```bash
node --version
npm --version
```

如果看到 *"command not found"* 错误或是过期版本的 Node：

* Windows or Mac users can download and run [this Node.js installer](http://nodejs.org/download/).
* Mac users often prefer to install Node using [Homebrew](http://brew.sh/). After installing Homebrew, run `brew install node` to install Node.js.
* Linux users can use [this guide for Node.js installation on Linux](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

If you get an outdated version of npm, run `npm install -g npm`.

### Git

Ember requires Git to manage many of its dependencies. Git comes with Mac OS X and most Linux distributions. Windows users can download and run [this Git installer](http://git-scm.com/download/win).

### Watchman (optional)

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (optional)

You can run your tests from the command line with PhantomJS, without the need for a browser to be open. Consult the [PhantomJS download instructions](http://phantomjs.org/download.html).

## Installation

Install Ember using npm:

```bash
npm install -g ember-cli
```

To verify that your installation was successful, run:

```bash
ember -v
```

If a version number is shown, you're ready to go.