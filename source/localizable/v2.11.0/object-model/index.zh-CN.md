你会注意到标准的JavaScript类的模式和新的es2015类在Ember中应用还不是很广泛。在Ember中仍然可以看到很多普通的类，有时候称之为“hashed”。

JavaScript 对象不支持属性值变化的观察。 因此，如果一个对象想使用Ember的绑定系统，你可以看到此对象是一个`Ember.Object`实例，而不是一个普通的JavaScript对象。

[Ember.Object](http://emberjs.com/api/classes/Ember.Object.html) 还提供一个支持混合（mixin）和构造函数方法（constructor method）的类系统。 Ember的对象模型中会出现一些在目前的JavaScript类和常见模式中不常见的特性，但是所有的特性都会尽可能的遵循JavaScript标准以及新提出的语言特性。

Ember使用`Ember.Enumerable`接口扩展了JavaScript的[Array](http://emberjs.com/api/classes/Ember.Enumerable.html)原型，提供可以观察数据变化的数组。

最后，Ember还扩展了`String`原型，提供了一些[格式和本地化的方法](http://emberjs.com/api/classes/Ember.String.html)。.