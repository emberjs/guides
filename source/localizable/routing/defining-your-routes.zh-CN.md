当应用程序启动时，路由控制器通过匹配当前 URL的对应路由，依次进行如下操作： 设置程序状态、载入数据、渲染模版。

若要定义一个路由，请运行

```shell
ember generate route route-name
```

此命令会创建一个路由文件app/routes/route-name.js，一个对应的模版文件app/templates/route-name.hbs以及一个单元测试文件tests/unit/routes/route-name-test.js。 并将该路由添加至路由控制器router.js中。

## 路由基础

Ember路由控制器中的map() 方法可以用来定义URL映射。 当调用map() 方法时，应传递一个方法，包含可以创建路由的this对象。

```app/router.js Router.map(function() { this.route('about', { path: '/about' }); this.route('favorites', { path: '/favs' }); });```

    <br />现在，当用户访问/about 时，Ember会自动渲染about 模版； 访问 /favs时，会渲染favorites 模版。
    
    当路由路径和名称相同时，可以省略路由路径定义。 在本节示例中，下方代码和之前的代码可以实现相同的功能。
    ```app/router.js
    Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
    });
    ```
    

在模版文件中，你可以在{{link-to}} 标签内使用路由名称在各个路由间跳转。

```handlebars
{{#link-to "index"}}<img class="logo">{{/link-to}}

<nav>
  {{#link-to "about"}}About{{/link-to}}
  {{#link-to "favorites"}}Favorites{{/link-to}}
</nav>
```

{{link-to}} 同样会向当前激活路由的链接中添加一个active类。

如果路由名称由多个单词组成，按照惯例单词间应由短横分割，例如：

```app/router.js Router.map(function() { this.route('blog-post', { path: '/blog-post' }); });

    <br />定义好的路由默认使用blog-post.js路由处理程序，blog-post.hbs模版文件，以及在{{link-to}}中使用blog-post跳转到此路由。
    
    如果使用下划线分割路由名称，例如：
    ```app/router.js
    Router.map(function() {
      this.route('blog_post', { path: '/blog-post' });
    });
    

仍然会默认使用blog-post.js路由处理程序和blog-post.hbs模版文件，但是在{{link-to}}中需要使用blog_post来跳转。

## 嵌套路由

你可能经常需要在一个模版中包含另一个模版。 例如，在一个博客应用程序中，你可能希望在文章列表页面包含一个创建新文章的页面，而不是从文章列表页面跳转到创建新文章页面。

在这些情况下，你可以使用嵌套路由在一个模板里面显示另一个模板。

您可以通过将传递一个回调函数给 `this.route` 来定义嵌套路由:

```app/router.js Router.map(function() { this.route('posts', function() { this.route('new'); }); });

    <br />假设你已经生成了posts路由，那么可以使用ember generate route posts/new命令来生成嵌套路由。
    

然后在模版文件中你想嵌套显示到地方加入{{outlet}} 标签：

```templates/posts.hbs 

# Posts

<!-- Display posts and other content --> {{outlet}}

    <br />这个路由控制器已经创建了/posts和posts/new两个路由。 当用户访问/posts路由时，只会看到独立的posts.hbs模版。 （下文的index routes部分有一个重要的补充）当用户访问posts/new时，posts/new.hbs模版会被渲染至posts.hbs中的{{outlet}}处。
    
    嵌套路由的名字包括其父路由的名字。
    如果你想跳转到一个路径（无论是通过{{link-to}}跳转，还是通过transitionTo跳转），需要提供全部到路由名称（例如posts.new，而不是new）
    
    ## 应用程序路由（初始路由）
    
    初始路由是app第一次启动时进入的路由。 和其他路由一样，初始路由同样默认会调用同名的模版文件（在这里是application模版）
    你应该把网页的页眉页脚和其他装饰性的内容放在这里。 所有其他的路由会将其模版渲染至application.hbs模版中的{{outlet}}中。
    
    所有的Ember应用都有此条路由，所以你不必在app/router.js中定义此条路由。
    
    ## 首页路由
    在每层嵌套路由（包含最高层）中，Ember会自动提供一个名为index的路由，路径为'/'。
    要看到嵌套路由的层级定义，检查路由控制器，当你每看到一个function，这就是一个新的层级。
    
    举个例子，假设你定义了如下的路由控制器：
    ```app/router.js
    Router.map(function() {
      this.route('favorites');
    });
    

它等同于：

```app/router.js Router.map(function() { this.route('index', { path: '/' }); this.route('favorites'); });

    <br />Index模版将会被渲染至application模版的{{outlet}} 中。 如果用户跳转到/favorites, Ember将会用favorites模版替换index模版。
    
    一个嵌套路由控制器，比如：
    Router.map(function() {
      this.route('posts', function() {
        this.route('favorites');
      });
    });
    

它等同于：

```app/router.js Router.map(function() { this.route('index', { path: '/' }); this.route('posts', function() { this.route('index', { path: '/' }); this.route('favorites'); }); });

    <br />如果用户跳转到/posts，当前路由将会是posts.index，同时posts/index模版会被渲染至posts模版的{{outlet}}中。
    
    如果用户跳转到/posts/favorites，Ember会使用posts/favorites模版来替换posts模版中的{{outlet}}。
    
    ## 动态段
    路由的职责之一是加载模型。
    
    例如，如果我们有一个路由this.route('posts')，那么路由可能读取所有的博客文章。
    因为/posts代表一个固定的模型，我们不需要任何额外的信息去载入它。  但是，如果我们需要路由来表示一篇博客文章，我们不想（也不能）把每一篇的地址写到路由控制器中。
    
    使用动态段地址！
    
    一个动态段地址是在URL中，由：开始，及其后面跟着标识符的部分。
    
    ```app/router.js
    Router.map(function() {
      this.route('posts');
      this.route('post', { path: '/post/:post_id' });
    });
    

如果用户跳转到posts/5，路由将会调用post_id为5的博客文章。 Ember遵循:model-name_id格式有两个原因。 1、如果你遵循命名规则，路由知道如何获得正确的模型。 2、参数是一个对象，并可以得到一个唯一的键值对。 下面的代码可能无法正确运行：

```app/router.js Router.map(function() { this.route('photo', { path: '/photo/:id' }, function() { this.route('comment', { path: '/comment/:id' }); }); });

    <br />但是下面的示例可以正常运行：
    ```app/router.js
    Router.map(function() {
      this.route('photo', { path: '/photo/:photo_id' }, function() {
        this.route('comment', { path: '/comment/:comment_id' });
      });
    });
    

在下一节【指定一个路由模型】中，你可以学到更多关于如何加载模型的知识。

## 通配符／全局路由

你可以定义一个匹配多条路由的通配路由。 这可能会非常有用，例如，在用户输入错误的路由时，你可以捕捉这些路由并进行处理。 通配路由由一个星号开始。

```app/router.js Router.map(function() { this.route('not-found', { path: '/*path' }); });

    <br />```app/templates/not-found.hbs
    <p>Oops, the page you're looking for wasn't found</p>
    

在上面的示例中，我们使用了一个统配路由去处理所有错误的路由地址，以便当用户导航到一个不存在的路由时会显示一条消息：您要找的页面不存在。

## 路由处理程序

要让路由做一下渲染具有相同名称的模板之外的事情，你需要创建路由处理程序。 以下指南将探讨路由处理程序的不同特性。 更多关于路由的信息，请参阅 API 文档为 [路由控制器](http://emberjs.com/api/classes/Ember.Router.html) 和 [路由处理程序](http://emberjs.com/api/classes/Ember.Route.html).