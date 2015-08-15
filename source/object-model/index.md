You'll notice that standard JavaScript class patterns, and the new ES2015
classes, aren't used widely in Ember. Plain objects can still be found,
and sometimes they are referred to as "hashes".

JavaScript objects don't support the observation of property value changes.
Consequently, if an object is going to participate in Ember's binding
system you may see an `Ember.Object` instead of a plan object.

`Ember.Object` also provides a class system, supporting features like mixins
and constructor methods. Some features in Ember's object model are not present in
JavaScript classes or common patterns, but all are aligned as much as possible
with the language and proposed additions.

Ember also extends the JavaScript `Array` prototype with its
`Ember.Enumerable` interface to provide change observation for arrays.

Finally, Ember extends the `String` prototype with a few [formatting and
localization methods](http://emberjs.com/api/classes/Ember.String.html).
