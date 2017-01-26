欢迎来到 Ember.js 指南！这份文档将会带领你从新手一直成长到 Ember 专家。

## 指南结构

在指南中每个页面的左侧是目录，按照章节组织并在展开后可以看到涵盖的所有主题。 章节及所属的主题由浅入深顺序排列。

这份指南主要是针对构建 Ember 应用程序的实践指导，重点放在 Ember.js 中大多数广泛使用的特性。 如果你想要查阅完整的文档，包括 Ember 所有的特性和 API，请查阅 [Ember.js API 文档](http://emberjs.com/api/)。.

The Guides begin with an explanation of how to get started with Ember, followed by a tutorial on how to build your first Ember app. If you're brand new to Ember, we recommend you start off by following along with these first two sections of the Guides.

## 前提条件

While we try to make the Guides as beginner-friendly as we can, we must establish a baseline so that the guides can keep focused on Ember.js functionality. We will try to link to appropriate documentation whenever a concept is introduced.

为了更容易理解这份指南，你需要有以下的知识基础：

* **HTML，CSS，JavaScript**——创建 web 页面的基石。 你可以在 [Mozilla 开发者网络（Mozilla Developer Network）](https://developer.mozilla.org/en-US/docs/Web)找到这些技术的相关文档。.
* **Promises**——用于在 JavaScript 代码中处理异步编程的原生机制。 参阅 [Mozilla 开发者网络（Mozilla Developer Network）](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)的相关部分。
* **ES2015 modules** - you will better understand [Ember CLI's](https://ember-cli.com/) project structure and import paths if you are comfortable with [JavaScript Modules](http://jsmodules.io/).
* **ES2015 语法**—— Ember CLI 默认配备了 Babel.js，于是你可以直接享用诸如箭头函数，模版字符串，解构等最新的语言特性。 这部分的内容你可以查看 [Babel.js 文档](https://babeljs.io/docs/learn-es2015/) 或阅读在线书籍[理解 ECMAScript 6](https://leanpub.com/understandinges6/read)。

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
* 在 [the GitHub repository](https://github.com/emberjs/guides/) 提交 issue 或者 pull request。

Clicking the pencil icon will bring you to GitHub's editor for that guide so you can edit right away, using the Markdown markup language. This is the fastest way to correct a typo, a missing word, or an error in a code sample.

If you wish to make a more significant contribution be sure to check our [issue tracker](https://github.com/emberjs/guides/issues) to see if your issue is already being addressed. If you don't find an active issue, open a new one.

If you have any questions about styling or the contributing process, you can check out our [contributing guide](https://github.com/emberjs/guides/blob/master/CONTRIBUTING.md). If your question persists, reach us at `#-team-learning` on the [Slack group](https://ember-community-slackin.herokuapp.com/).

Good luck!