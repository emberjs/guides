Ember 的起步是很容易的。Ember 使用命令行构建工具 Ember CLI 来创建和管理项目。

* Modern application asset management (including concatenation, minification, and versioning).
* 帮助创建组件、路由及更多的生成器。
* 常规的项目结构使得既有的 Ember 应用程序也很容易套用。
* 通过 [Babel](http://babeljs.io/docs/learn-es2015/) 项目支持 ES2015／ES6 JavaScript。 这也包含了对于 [Javascript 模块](http://exploringjs.com/es6/ch_modules.html)的支持，本指南将通篇使用这一特性。
* 完整的 [QUnit](https://qunitjs.com/) 测试集成。
* The ability to consume a growing ecosystem of [Ember Addons](https://emberobserver.com/).

## 依赖

### Node.js 和 npm

Ember CLI 使用 JavaScript 创建，并且需要 [Node.js](https://nodejs.org/) 运行环境的支持。 它还需要通过 [npm](https://www.npmjs.com/) 来获取依赖的模块和软件包。 npm 与 Node.js 是打包在一起的，所以如果你的计算机已经安装了 Node.js 那就一切就绪了。

Ember 需要 Node.js 0.12 或是更高版本以及 npm 2.7 及以上。若你无法确定你是否安装了 Node.js 以及版本号是否合乎要求，那就在命令行运行以下命令：

```bash
node --version
npm --version
```

如果看到 *"command not found"* 错误或是过期版本的 Node：

* Windows 或者 Mac 的用户可以下载并运行 [此 Node.js 安装程序](http://nodejs.org/download/).
* Mac 用户通常喜欢使用 [Homebrew](http://brew.sh/) 安装 Node。安装好 Homebrew 后，运行 `brew install node` 来安装 Node.js。
* Linux 用户可以使用 [这份在 Linux 上安装 Node.js 的指南](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

如果你看到 npm 的版本过期，运行 `npm install -g npm`.

### Git

Ember 需要 Git 来管理许多它依赖的东西。 Mac OS X 和大多数 Linux 发行版都带有 Git. Windows 用户可以下载并运行 [此 Git 安装程序](http://git-scm.com/download/win)。.

### Watchman（可选）

在 Mac 和 Linux 上，你可以通过安装 [Watchman](https://facebook.github.io/watchman/docs/install.html) 来提高文件变化监测的性能。.

### PhantomJS（可选）

PhantomJS 可以帮助你在命令行运行测试而不需要打开浏览器。请咨询 [PhantomJS 下载指南](http://phantomjs.org/download.html)。.

## 安装

使用 npm 安装 Ember：

```bash
npm install -g ember-cli
```

若要验证您的安装成功，请运行：

```bash
ember -v
```

如果显示出了版本号，你就准备好了。