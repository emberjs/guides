標準のJavaScriptクラスパターンと新しいES2015 クラスはEmberでは広く使われていません。プレーンなオブジェクトはまだ見つかるかもしれません。それらは「ハッシュ」と呼ばれます。

JavaScript objects don't support the observation of property value changes. Consequently, if an object is going to participate in Ember's binding system you may see an `Ember.Object` instead of a plain object.

[Ember.Object](http://emberjs.com/api/classes/Ember.Object.html) also provides a class system, supporting features like mixins and constructor methods. Some features in Ember's object model are not present in JavaScript classes or common patterns, but all are aligned as much as possible with the language and proposed additions.

Ember also extends the JavaScript `Array` prototype with its [Ember.Enumerable](http://emberjs.com/api/classes/Ember.Enumerable.html) interface to provide change observation for arrays.

Finally, Ember extends the `String` prototype with a few [formatting and localization methods](http://emberjs.com/api/classes/Ember.String.html).