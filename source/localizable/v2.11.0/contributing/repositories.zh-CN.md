Ember 是由几个软件包组合而成的。 如果你有意添加一个特性或修复一个 bug 请在对应的代码仓库内发出 pull request 请求。 请确保在针对 Ember 代码仓库作出改变之前检查了下面列出的软件包。

# 主要代码仓库

**Ember.js** - Ember 的主体代码仓库。

* <https://github.com/emberjs/ember.js>

**Ember Data** - Ember 的数据持久化层软件包。

* <https://github.com/emberjs/data>

**Ember 网站** - <http://emberjs.com> 的源代码。

* <https://github.com/emberjs/website>

**Ember 指南** - 你正在阅读的 <http://guides.emberjs.com> 的源代码。

* <https://github.com/emberjs/guides>

# Ember 所用到的软件包

下列软件包是 Ember 资源产出的一部分，但是它们的开发工作发生在独立的软件仓库里。

## `Backburner`

* **backburner.js** - Ember 运行时循环的实现。
* <https://github.com/ebryn/backburner.js>

## `DAG Map`

* **dag-map** - 用于 JavaScript 的有向无环图数据结构实现。
* <https://github.com/krisselden/dag-map>

## `Glimmer 2`

* **glimmer** - 现已包含在 Ember 中的一个非常快速的渲染引擎实现。
* <https://github.com/tildeio/glimmer>

## `HTMLBars`

* **htmlbars** - Ember 中主要是用的模版语法。
* <https://github.com/tildeio/htmlbars>

## `morph-range`

* **morph-range** - Ember 用来操作文本节点（也称 morphs）的库，是为 HTMLBars 创建的用于追踪可变化的文本。
* <https://github.com/krisselden/morph-range>

## `Route Recognizer`

* **route-recognizer** - 轻量级的针对注册路由来匹配路径的 JavaScript 软件包。
* <https://github.com/tildeio/route-recognizer>

## `router.js`

* **router.js** - 轻量级的构建于 route-recognizer 和 rsvp 之上的 JavaScript 软件包，提供了处理路由的 API。
* <https://github.com/tildeio/router.js>

## `RSVP`

* **rsvp.js** - Ember 所使用的 Promises/A+ 规范的实现。
* <https://github.com/tildeio/rsvp.js>