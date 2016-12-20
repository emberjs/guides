在Ember项目中，路由器被用来定义页面路径的访问逻辑。

在“超级房屋出租”网站实例中，网站首页会显示出租房屋列表。在首页我们可以跳转到关于我们和联系我们页面。

我们先来创建”关于我们“页面。 请记住，当URL 路径 `/about` 被加载时，路由器将 URL /about 映射到同一个名的路由处理程序*about.js* 。 然后路由处理程序加载一个页面模板。

## “关于我们” route

如果执行 `ember help generate`，我们可以看到很多生成器工具，Ember用它们来自动生成各种资源文件。 我们将要用路由生成器来生成 `about`路由器。

```shell
ember generate route about
```

或者用命令简写

```shell
ember g route about
```

我们来看下生成器都做了那些操作：

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

创建了3个文件：一个是对应路由处理器文件，一个是路由处理器会渲染的模板页面文件，一个是测试文件。还有第4个文件被修改的是路由器配置文件。

我们打开路由器配置文件，可以看到生成器已经为我们加了一条新的 *about*路由映射信息。这条路由会映射到`about`路由处理器。

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType, rootURL: config.rootURL });

Router.map(function() {this.route('about');});

export default Router;

    <br />”about“路由处理器会默认加载”about.hbs“模板页面。
    这以为这我们不需要在路由处理器”app/routes/about.js“文件中做任何修改来制定对应的模板文件”about.hbs“。
    
    生成器生成好所有路由相关配置，我们就可以直接开始逻辑代码和页面模板的开发了。
    在”关于我们“页面中，我们会加一些HTML代码用来描述网站的相关信息：
    ```app/templates/about.hbs
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        ”超级房屋出租“网站是一个有趣的项目，用来学习Ember框架。
        通过创建这个房屋出租网站，我们可以想象自己在旅行同时创建一个Eber应用。
      </p>
    </div>
    

命令行执行`ember serve`（或者用简写`ember s`）启动Ember开发服务，然后访问 [`http://localhost:4200/about`](http://localhost:4200/about)即刻来查看我们的新应用。

## “联系我们” Route

我们接下来再创建另外一个路由器用来访问公司联系信息页面。我们还会通过生成器来添加一个路由器，一个 路由处理器和一个模板页面。

```shell
ember g route contact
```

我们可以看到生成器在路由配置文件 <0 >app/router.js</code>中创建了`contact`路由，同时生成了对应的路由处理器文件`app/routes/contact.js`。 因为在这个路由处理器中我们会使用默认的同名模板文件`contact` ，所以我们不需要对路由配置文件做额外配置。

在模板文件中 `contact.hbs`，我们可以添加超级访问出租公司的总部信息:

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    联系我们
  </h2>
  
  <p>
    超级出租公司的业务代表很高兴帮助您选择一个目的地或者回答您的任何问题。
  </p>
  
  <p>
    超级租赁总部 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p>
</div>

    <br />现在我们已经完成了第二个路由器。
    如果访问 URL [`http://localhost:4200/contact`](http://localhost:4200/contact)，我们可以看到联系我们页面。
    
    ## 用链接和{{link-to}} 帮助类进行跳转
    我们真心不希望用户需要记住网站的URL才能浏览我们网站的内容，所以我们会在每个页面下面添加跳转链接。
    我们会在关于我们页面加上联系我们链接以及在联系我们页面加上关于我们链接。
    
    Ember有内置的各种辅助方法 **helpers** 来提供类似于跳转到指定路由器的功能。
    这里我们代码中使用”{{link-to}}“辅助类在不同路由中进行跳转。
    
    ```app/templates/about.hbs{+9,+10,+11}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      Text for Translation
    </p>
      {{#link-to 'contact' class="button"}}
        Get Started!
      {{/link-to}}
    </div>
    

`{{link-to}}` 辅助方法引入了name参数，用来标识需要跳转的目标路由地址，在这里是 `contact`。 这时我们访问关于我们页面 [`http://localhost:4200/about`](http://localhost:4200/about)，就可以看到一个可以跳转到联系我们的链接了。

![“超级访问出租”页面截图](../../images/routes-and-templates/ember-super-rentals-about.png)

接下来，我们要在联系我们页面在加入一个关于我们的跳转链接，这样我们就可以在`about` 和 `contact`两个页面来回跳转。.

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    联系我们
  </h2>
  
  <p>
    超级出租公司的业务代表很高兴帮助您选择一个目的地或者回答您的任何问题。
  </p>
  
  <p>
    超级租赁总部 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p> {{#link-to 'about' class="button"}} About {{/link-to}}
</div>

    <br />## 出租房屋列表路由
    我们的网站需要一个出租房屋列表供网站用户浏览。
    为了这样的一个列表我们需要创建第三个路由”rentals“。
    

我们先修改最新生成的模板文件`rentals.hbs`，加入一些临时标记作为列表页内容。 稍后我们会重新填充真实的出租信息。

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    欢迎！
  </h2>
  
  <p>
    我们希望你找到了梦寐以求的归宿。
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

    <br />## 首页 Route
    
    既然网站已经有了2个静态页面，我们可以制作一个首页来迎接网站用户了。
    目前我们应用的主页就是刚创建的房屋出租列表页。
    所以我们希望首页的route只是简单转发到我们刚创建的`rentals` route 。
    
    依照之前我们创建联系我们和关于我们页面的流程，我们要先创建一个叫 `index`的路由器。
    
    ```shell
    ember g route index
    

我们可以看到熟悉的route生成输出日志：

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

跟我们之前创建的路由器不同， `index` 首页路由器比较特殊：它不需要在路由配置文件中做任何映射 。 我们将会在[nested routes](../subroutes) Ember的级联路由一章中会学到更多关于为什么首页index不需要路由映射。

我们现在可以为index首页开发单元测试了。 我们要测试的结果是首页能跳转到房屋出租列表 `rentals`，所以测试需要验证路由器的 [`replaceWith`](http://emberjs.com/api/classes/Ember.Route.html#method_replaceWith)方法可以被正确调用。 路由器中的`replaceWith`方法跟 `transitionTo`方法类似都是页面跳转，区别是`replaceWith`会把替换浏览器中的浏览历史，而 `transitionTo`则是将跳转地址到浏览历史中。 我们希望`rentals`路由成为主页，所以是用 `replaceWith`方法。 我们的测试需要先在路由中实现 `replaceWith`方法，同时断言`rentals`路由在调用时被正确传入。

```tests/unit/routes/index-test.js import { moduleFor, test } from 'ember-qunit';

moduleFor('route:index', 'Unit | Route | index');

test('should transition to rentals route', function(assert) { let route = this.subject({ replaceWith(routeName) { assert.equal(routeName, 'rentals', 'replace with route name rentals'); } }); route.beforeModel(); });

    <br />在index路由中，我们只需要添加“replaceWith”方法调用。
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      beforeModel() {
        this._super(...arguments);
        this.replaceWith('rentals');
      }
    });
    

现在当你访问根目录 `/`的时候会跳转到 `/rentals` URL。

## 在导航中加入旗帜区块

除了为每个路由提供按钮连接以为，我们还希望提供一个通用的标题旗帜区作为主页的链接。

首先，创建一个应用模板。输入命令：`ember g template application`.

```shell
installing template
  create app/templates/application.hbs
```

当首页模板 `application.hbs`存在后，你向其添加的内容会出现在网站的每个页面。现在我们加以下旗帜区域标记：

    app/templates/application.hbs
    <div class="container">
      <div class="menu">
        {{#link-to 'index'}}
          <h1 class="left">
            <em>SuperRentals</em>
          </h1>
        {{/link-to}}
        <div class="left links">
          {{#link-to 'about'}}
            About
          {{/link-to}}
          {{#link-to 'contact'}}
            Contact
          {{/link-to}}
        </div>
      </div>
      <div class="body">
        {{outlet}}
      </div>
    </div>

请注意在body div标签中的包含的`{{outlet}}` 代码块。 [`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet) 这个标记意味着把该位置代码填充工作交给传入的路由器负责，不同的路由器会产生不同的内容插入到模板中。

至此，我们已经添加了路由和相应的连接，3个导航跳转验证将可以通过测试。

![通过了导航跳转测试](../../images/routes-and-templates/passing-navigation-tests.png)