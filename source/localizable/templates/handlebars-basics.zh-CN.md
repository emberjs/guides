Ember 使用 [Handlebars 模板引擎](http://www.handlebarsjs.com) 来增强应用的用户界面。 Handlebars 模板包含静态 HTML 和 Handlebars 表达式内部的动态内容，Handlebars 表达式的写法是两对大括号： `{{}}`.

Handlebars 表达式内部渲染的动态内容具备数据绑定的特性。 也就是说如果更新了属性，在模版中渲染的该属性也会自动更新到最新的值。

### 显示属性

模板是由上下文对象支撑的。 上下文对象是 Handlebars 表达式读取属性的来源。 在 Ember 中上下文对象通常是一个组件。 对于直接由路由渲染的模板（比如 `application.hbs`），上下文对象是控制器。

例如，下面的 `application.hbs` 模板将会渲染姓氏和名字：

```app/templates/application.hbs Hello, **{{firstName}} {{lastName}}**!

    <br />`firstName` 和 `lastName` 是从上下文对象（此处是 application 控制器）中读取到的，然后渲染在 `<strong>` HTML 标签中。
    
    为了给上面的模板提供 `firstName` 和 `lastName`，必须在 application 控制器中添加这两个属性。 如果你正在使用 Ember CLI 应用程序，你需要创建这样的文件：
    
    ```app/controllers/application.js
    import Ember from 'ember';
    
    export default Ember.Controller.extend({
      firstName: 'Trek',
      lastName: 'Glowacki'
    });
    

上述模版和控制器将会渲染为下面的 HTML：

```html
Hello, <strong>Trek Glowacki</strong>!
```

记住，`{{firstName}}` 和 `{{lastName}}` 是绑定的数据。这意味着如果其中一个属性的值发生更改，将自动更新 DOM。

随着应用程序规模的增长，将会有许多由控制器和组件支撑着的模板。

### Helpers

Ember 可以让你编写自己的 helpers，helpers 可以封装最基本的逻辑并应用于模板之中

For example, let's say you would like the ability to add a few numbers together, without needing to define a computed property everywhere you would like to do so.

```app/helpers/sum.js import Ember from 'ember';

export function sum(params) { return params.reduce((a, b) => { return a + b; }); };

export default Ember.Helper.helper(sum);

    <br />The above code will allow you invoke the `sum()` function as a `{{sum}}` handlebars "helper" in your templates:
    
    ```html
    <p>Total: {{sum 1 2 3}}</p>
    

This helper will output a value of `6`.

Ember ships with several built-in helpers, which you will learn more about in the following guides.

#### Nested Helpers

Helpers have the ability to be nested within other helper invocations and also component invocations.

This gives you the flexibility to compute a value *before* it is passed in as an argument or an attribute of another.

It is not possible to nest curly braces `{{}}`, so the correct way to nest a helper is by using parentheses `()`:

```html
{{sum (multiply 2 4) 2}}
```

In this example, we are using a helper to multiply `2` and `4` *before* passing the value into `{{sum}}`.

Thus, the output of these combined helpers is `10`.

As you move forward with these template guides, keep in mind that a helper can be used anywhere a normal value can be used.

Thus, many of Ember's built-in helpers (as well as your custom helpers) can be used in nested form.