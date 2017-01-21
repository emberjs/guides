欢迎来到 Ember.js 指南！这份文档将会带领你从新手一直成长到 Ember 专家。

## 指南结构

在指南中每个页面的左侧是目录，按照章节组织并在展开后可以看到涵盖的所有主题。 章节及所属的主题由浅入深顺序排列。

这份指南主要是针对构建 Ember 应用程序的实践指导，重点放在 Ember.js 中大多数广泛使用的特性。 如果你想要查阅完整的文档，包括 Ember 所有的特性和 API，请查阅 [Ember.js API 文档](http://emberjs.com/api/)。.

指南开始解释了如何尽快上手 Ember，紧接着是一份教你构建第一个 Ember 应用程序的教程。如果你是第一次接触 Ember 的话，我们推荐你先从上述两个章节开始。

## 前提条件

尽管我们努力让这份指南可以对初学者足够友好，但也必须设定一个技术基准以便我们可以把指南的主要内容集中在 Ember.js 自身的特性上。 我们会在新的概念出现之时提供相关文档的链接。

为了更容易理解这份指南，你需要有以下的知识基础：

* **HTML，CSS，JavaScript**——创建 web 页面的基石。 你可以在 [Mozilla 开发者网络（Mozilla Developer Network）](https://developer.mozilla.org/en-US/docs/Web)找到这些技术的相关文档。.
* **Promises**——用于在 JavaScript 代码中处理异步编程的原生机制。 参阅 [Mozilla 开发者网络（Mozilla Developer Network）](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)的相关部分。
* **ES2015 modules**——如果你熟悉 [ES6 JavaScript Modules](https://ember-cli.com/) 的话就更容易理解 [Ember CLI's](http://jsmodules.io/)的项目结构及模块导入路径..
* **ES2015 语法**—— Ember CLI 默认配备了 Babel.js，于是你可以直接享用诸如箭头函数，模版字符串，解构等最新的语言特性。 这部分的内容你可以查看 [Babel.js 文档](https://babeljs.io/docs/learn-es2015/)或阅读在线书籍[理解 ECMAScript 6](https://leanpub.com/understandinges6/read)。

## A Note on Mobile Performance

Ember will do a lot to help you write fast apps, but it can't prevent you from writing a slow one. This is especially true on mobile devices. To deliver a great experience, it's important to measure performance early and often, and with a diverse set of devices.

Make sure you are testing performance on real devices. Simulated mobile environments on a desktop computer give an optimistic-at-best representation of what your real world performance will be like. The more operating systems and hardware configurations you test, the more confident you can be.

Due to their limited network connectivity and CPU power, great performance on mobile devices rarely comes for free. You should integrate performance testing into your development workflow from the beginning. This will help you avoid making costly architectural mistakes that are much harder to fix if you only notice them once your app is nearly complete.

In short:

  1. Always test on real, representative mobile devices.
  2. Measure performance from the beginning, and keep testing as your app develops.

These tips will help you identify problems early so they can be addressed systematically, rather than in a last-minute scramble.

## Reporting a problem

Typos, missing words, and code samples with errors are all considered documentation bugs. If you spot one of them, or want to otherwise improve the existing guides, we are happy to help you help us!

Some of the more common ways to report a problem with the guides are:

* 点击每页右上角的铅笔图标
* 在 [the GitHub repository](https://github.com/emberjs/guides/)提交issue 或者pull request。

Clicking the pencil icon will bring you to GitHub's editor for that guide so you can edit right away, using the Markdown markup language. This is the fastest way to correct a typo, a missing word, or an error in a code sample.

If you wish to make a more significant contribution be sure to check our [issue tracker](https://github.com/emberjs/guides/issues) to see if your issue is already being addressed. If you don't find an active issue, open a new one.

If you have any questions about styling or the contributing process, you can check out our [contributing guide](https://github.com/emberjs/guides/blob/master/CONTRIBUTING.md). If your question persists, reach us at `#-team-learning` on the [Slack group](https://ember-community-slackin.herokuapp.com/).

Good luck!