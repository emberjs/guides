应用程序启动时，路由器通过当前 URL匹配定义好的 *路由*。 接着路由负责显示模板、 加载数据，或者设置应用程序状态。

## 基本路由

Ember应用程序路由器中的 [`map()`](http://emberjs.com/api/classes/Ember.Router.html#method_map) 方法可以用来定义 URL 映射。 当调用 `map()`方法时，你应该传递一个将值 `此` 设置为对象，您可以使用创建路线与调用的函数。

```app/router.js Router.map(function() { this.route('about', { path: '/about' }); this.route('favorites', { path: '/favs' }); });

    <br />现在，当用户访问`/about`时，Ember会渲染`about`模板。 访问`/favs`会渲染`favorites`模板
    
    如果路径地址和路由名字相同，你可以省略路径。 这种情况下, 下面的写法和上面的例子一个效果:
    
    ```app/router.js
    Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
    });
    

在模板里面，可以使用[`{{link-to}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_link-to)在不同的路由间跳转，使用传给`route`方法的参数作为名字

```handlebars
{{#link-to "index"}}<img class="logo">{{/link-to}}

<nav>
  {{#link-to "about"}}About{{/link-to}}
  {{#link-to "favorites"}}Favorites{{/link-to}}
</nav>
```

`{{link-to}}` 还会给指向当前激活路由的链接加一个 `active` class

## 嵌套路由

通常你会希望在一个模板里面显示另一个模板。 例如，在一个博客应用程序中，你可能希望在文章列表页面包含一个创建新文章的页面，而不是从文章列表页面跳转到创建新文章页面。

在这些情况下，你可以使用嵌套路由在一个模板里面显示另一个模板。

您可以通过将传递一个函数给 `this.route` 来定义嵌套路由:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />然后在你想显示嵌套模板的位置加一个`{{outlet}}`:
    
    ```templates/posts.hbs
    <h1>Posts</h1>
    <!-- Display posts and other content -->
    {{outlet}}
    

这个路由器创建一个`/posts`路由和一个 `/posts/new`路由。 当用户访问 `/posts` 时，他们只会看到 `posts.hbs` 模板。 (下面的 [index routes](#toc_index-routes) 一节有一个重要的补充)。当用户访问 `posts/new` 时，他们会看到 `posts/new.hbs` 模板渲染在`posts` 模板的`{{outlet}}`位置。

嵌套路由的名字包括其父路由的名字。 如果你想跳转到一个路径 (无论是通过 `transitionTo` 或 `{{#link-to}}`)，请确保使用完整的路由名称 (`posts.new`，而不是`new`.).

## 应用程序路由

应用程序首次启动时会进入`application` 路由. 和其他路由一样，默认会加载具有相同名称 (在这种情况下的 `application`) 的模板。 你应该把你的页眉、 页脚和任何其他装饰的内容放在这里。 所有其它路由会把其模板渲染到 `application.hbs` 模板的 `{{outlet}}`位置.

所以的Ember应用都有这条路由，所以你不用在 `app/router.js`中指定.

## Index路由

在每个嵌套的 (包括最顶级) 的路由中，Ember都会自动提供一条 `/`path named`index`路由.

例如，如果您编写一个简单的路由器，像这样︰

```app/router.js Router.map(function(){ this.route('favorites'); });

    <br />它等效于:
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('favorites');
    });
    

`index` 模板将会渲染到 `application` 模板的 `{{outlet}}` 位置。 如果在用户跳转到 `/favorites`，Ember会将 `index` 模板替换成 `favorites` 模板。

像这样的嵌套路由 ︰

```app/router.js Router.map(function() { this.route('posts', function() { this.route('favorites'); }); });

    <br />等效于：
    
    ```app/router.js
    Router.map(function(){
      this.route('index', { path: '/' });
      this.route('posts', function() {
        this.route('index', { path: '/' });
        this.route('favorites');
      });
    });
    

如果在用户跳转到 `/posts`，当前路由将会是 `posts.index`，并且 `posts/index` 模板将会渲染到`posts` 模板的 `{{outlet}}` 位置。

如果接着用户跳转到 `/favorites`，Ember会将 `posts` 模板中的 `{{outlet}}` 替换成 `favorites` 模板。

## 动态地址片段

路由的职责之一是加载模型。

例如，如果有一条 `this.route('posts');` 路由，它可能会加载所有发布的博客文章。

因为 `/posts` 表示固定的模型，我们不需要任何额外的信息就能知道要加载什么数据。 然而，如果我们想要一条路由表示一个单一的博客文章，我们不想把每一个可能的文章地址硬编码到路由器中。

进入*动态地址片段*.

一个动态地址片段是 URL 中以 `:` 开头，后面跟着标识符的部分。

```app/router.js Router.map(function() { this.route('posts'); this.route('post', { path: '/post/:post_id' }); });

    <br />如果用户导航到 `/posts/5 `，路由将使用值为`5` 的 `post_id` 来加载正确的帖子。 在下一节，[指定路由模型](../specifying-a-routes-model)，您将学习更多关于如何加载模型的知识。
    
    ## 通配符 / 全局路由
    
    又可以定义匹配多个URL片段的通配符路由。 这可以很有用，例如，如果你想有一个匹配所有路径的路由，这在当用户输入你的应用没有处理的不正确的 URL 时会非常有用。
    
    ```app/router.js
    Router.map(function() {
      this.route('page-not-found', { path: '/*wildcard' });
    });
    

## 路由处理程序

要让路由做一下渲染具有相同名称的模板之外的事情，你需要创建路由处理程序。 以下指南将探讨路由处理程序的不同特性。 更多关于路由的信息，请参阅 API 文档为 [路由器](http://emberjs.com/api/classes/Ember.Router.html) 和 [路由处理程序](http://emberjs.com/api/classes/Ember.Route.html).