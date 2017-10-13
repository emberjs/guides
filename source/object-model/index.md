You'll notice standard JavaScript class patterns and the new ES2015
classes aren't widely used in Ember. Plain objects can still be found,
and sometimes they're referred to as "hashes".

JavaScript objects don't support the observation of property value changes.
Consequently, if an object is going to participate in Ember's binding
system you may see an `Ember.Object` instead of a plain object.

[Ember.Object](https://www.emberjs.com/api/ember/2.16/modules/@ember%2Fobject) also provides a class system, supporting features like mixins
and constructor methods. Some features in Ember's object model are not present in
JavaScript classes or common patterns, but all are aligned as much as possible
with the language and proposed additions.

Ember also extends the JavaScript `Array` prototype with its
[Ember.Enumerable](http://emberjs.com/api/classes/Ember.Enumerable.html) interface to provide change observation for arrays.

Finally, Ember extends the `String` prototype with a few [formatting and
localization methods](https://www.emberjs.com/api/ember/2.16/classes/String).
