现在我们将可出租的房屋列表加入到首页index模板中。 我们应该知道出租列表不是一个 静态的页面，因为用户会对其做增删改的操作。 以此我们会需要一个出租房屋的数据模型来存储这些信息。 为了方便起见，我们先用硬编码的 javascript 数组。 稍后，我们 会引入强大的数据操作包 Ember Data。

以下是我们将完成页面的样子。

![超级房屋出租网页有了出租房屋列表。](../../images/models/super-rentals-index-with-list.png)

在Ember中，route handlers 路由处理器用来加载数据模型。我们打开rentals的路由控制器文件`app/routes/rentals.js`并插入我们硬编码的数据模型作为模型`model`的钩子方法的返回值。

```app/routes/rentals.js import Ember from 'ember';

let rentals = [{ id: 'grand-old-mansion', title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' }, { id: 'urban-living', title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' }, { id: 'downtown-charm', title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' }];

export default Ember.Route.extend({ model() { return rentals; } });

    <br />这里我们使用ES6的简化方法定义语法：`model()`等同于之前`model: function()`的写法。
    
    “model”方法像一个钩子，这意味着Ember框架会在程序中不断调用这个模型钩子。而我们加在“rentals”   路由处理器中的钩子方法，会在用户调用”rentals“路由是被调用。
    
    ”model“钩子 方法返回我们定义的_rentals_ 数组并将其作为”model“的属性传递给”rentals“模板。
    
    现在我们切换到模板页面。
    我们使用modal模型数据在出租页面中显示出租房屋列表。
    这里我们用了另外一个Handlebars的帮助类”{{each}}“。
    这个帮助类会循环取出我们定义模型中的每一个对象。
    ```app/templates/rentals.hbs{+13,+14,+15,+16,+17,+18,+19,+20,+21,+22,+23,+24,+25,+26,+27,+28,+29}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>Welcome!</h2>
      <p>
    We hope you find exactly what you're looking for in a place to stay.
        <br>Browse our listings, or use the search box below to narrow your search.
      </p>
      {{#link-to 'about' class="button"}}
        About Us
      {{/link-to}}
    </div>
    
    {{#each model as |rental|}}
      <article class="listing">
        <h3>{{rental.title}}</h3>
        <div class="detail owner">
          <span>Owner:</span> {{rental.owner}}
        </div>
        <div class="detail type">
          <span>Type:</span> {{rental.type}}
        </div>
        <div class="detail location">
          <span>Location:</span> {{rental.city}}
        </div>
        <div class="detail bedrooms">
          <span>Number of bedrooms:</span> {{rental.bedrooms}}
        </div>
      </article>
    {{/each}}
    

在这个模板中，我们循环取出模型中的对象赋给变量*rental*。每一个 rental 会创建一个属性列表。

现在我们有了可出租房屋的列表，我们 用来验证测试列表的测试用例就可以通过测试了。

![出租房屋列表测试通过。](../../images/model-hook/passing-list-rentals-tests.png)