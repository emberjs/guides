In Super Rentals we want to arrive at a home page which shows a list of rentals. From there, we should be able to navigate to an about page and a contact page.

Ember provides a [robust routing mechanism](../../routing/) to define logical, addressable pages within our application.

## “关于我们” route

Let's start by building our "about" page. To create a new, URL addressable page in the application, we need to generate a route using Ember CLI.

如果执行 `ember help generate`，我们可以看到很多生成器工具，Ember用它们来自动生成各种资源文件。 我们将要用路由生成器来生成 `about`路由器。

```shell
ember generate route about
```

或者用命令简写

```shell
ember g route about
```

The output of the command displays what actions were taken by the generator:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

A route is composed of the following parts:

  1. An entry in `/app/router.js`, mapping the route name to a specific URI. *`(app/router.js)`*
  2. A route handler JavaScript file, instructing what behavior should be executed when the route is loaded. *`(app/routes/about.js)`*
  3. A route template, describing the page represented by the route. *`(app/templates/about.hbs)`*

Opening `/app/router.js` shows that there is a new line of code for the *about* route, calling `this.route('about')` in the `map` function. Calling the function `this.route(routeName)`, tells the Ember router to load the specified route handler when the user navigates to the URI with the same name. In this case when the user navigates to `/about`, the route handler represented by `/app/routes/about.js` will be used. See the guide for [defining routes](../../routing/defining-your-routes/) for more details.

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
    

Run `ember server` (or `ember serve` or even `ember s` for short) from the shell to start the Ember development server, and then go to [`http://localhost:4200/about`](http://localhost:4200/about) to see our new app in action!

## “联系我们” Route

我们接下来再创建另外一个路由器用来访问公司联系信息页面。我们还会通过生成器来添加一个路由器，一个 路由处理器和一个模板页面。

```shell
ember g route contact
```

The output from this command shows a new `contact` route in `app/router.js`, and a corresponding route handler in `app/routes/contact.js`.

In the route template `/app/templates/contact.hbs`, we can add the details for contacting our Super Rentals HQ:

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
    
    ## Navigating with Links and the {{link-to}} Helper
    
    We'd like to avoid our users having knowledge of our URLs in order to move around our site,
    so let's add some navigational links at the bottom of each page.
    我们会在关于我们页面加上联系我们链接以及在联系我们页面加上关于我们链接。
    
    Ember has built-in template **helpers** that provide functionality for interacting with the framework.
    The [`{{link-to}}`](../../templates/links/) helper provides special ease of use features in linking to Ember routes.
    Here we will use the `{{link-to}}` helper in our code to perform a basic link between routes:
    
    ```app/templates/about.hbs{+9,+10,+11}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      </p>
      {{#link-to 'contact' class="button"}}
        Contact Us
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
    

Let's update the newly generated `app/templates/rentals.hbs` with some basic markup to add some initial content our rentals list page. We'll come back to this page later to add in the actual rental properties.

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

    <br />## An Index Route
    
    With our three routes in place, we are ready to add an index route, which will handle requests to the root URI (`/`) of our site.
    We'd like to make the rentals page the main page of our application, and we've already created a route.
    Therefore, we want our index route to simply forward to the `rentals` route we've already created.
    
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

Let's start by implementing the unit test for our new index route.

Since all we want to do is transition people who visit `/` to `/rentals`, our unit test will make sure that the route's [`replaceWith`](http://emberjs.com/api/classes/Ember.Route.html#method_replaceWith) method is called with the desired route. `replaceWith` is similar to the route's [`transitionTo`](../../routing/redirection/#toc_transitioning-before-the-model-is-known) function; the difference being that `replaceWith` will replace the current URL in the browser's history, while `transitionTo` will add to the history. Since we want our `rentals` route to serve as our home page, we will use the `replaceWith` function.

In our test, we'll make sure that our index route is redirecting by stubbing the `replaceWith` method for the route and asserting that the `rentals` route is passed when called.

A `stub` is simply a fake function that we provide to an object we are testing, that takes the place of one that is already there. In this case we are stubbing the `replaceWith` function to assert that it is called with what we expect.

```tests/unit/routes/index-test.js import { moduleFor, test } from 'ember-qunit';

moduleFor('route:index', 'Unit | Route | index');

test('should transition to rentals route', function(assert) { let route = this.subject({ replaceWith(routeName) { assert.equal(routeName, 'rentals', 'replace with route name rentals'); } }); route.beforeModel(); });

    <br />In our index route, we simply add the actual `replaceWith` invocation.
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      beforeModel() {
        this.replaceWith('rentals');
      }
    });
    

Now visiting the root route `/` will result in the `/rentals` URL loading.

## 在导航中加入旗帜区块

In addition to providing button-style links in each route of our application, we would like to provide a common banner to display both the title of our application, as well as its main pages.

To show something in every page of your application, you can use the application template. The application template is generated when you create a new project. Let's open the application template at `/app/templates/application.hbs`, and add the following banner navigation markup:

    app/templates/application.hbs
    <div class="container">
      <div class="menu">
        {{#link-to 'index'}}
          <h1>
            <em>SuperRentals</em>
          </h1>
        {{/link-to}}
        <div class="links">
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

Notice the inclusion of an `{{outlet}}` within the body `div` element. The [`{{outlet}}`](http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_outlet) in this case is a placeholder for the content rendered by the current route, such as *about*, or *contact*.

Now that we've added routes and linkages between them, the three acceptance tests we created for navigating to our routes should now pass.

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)