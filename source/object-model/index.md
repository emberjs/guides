You'll soon notice that standard JavaScript objects aren't used widely in Ember,
except as key-value pairs (often referred to as _hashes_). This is because
JavaScript objects don't support the ability to observe when an object changes,
which Ember needs to update data throughout an application.
Ember's object model builds on standard JavaScript objects to enable this
functionality, as well as bring several features like mixins and initialization
to make working with them a more pleasant experience. Although these features
aren't available in standard JavaScript, many of them are designed to align with
proposed additions to the ECMAScript standard.

In addition to bringing its own object model, Ember also extends the built-in
JavaScript `Array` prototype with its Enumerable interface to enable it to
observe changes and provide more features.

Finally, Ember extends the `String` prototype with a few [formatting and
localization methods](http://emberjs.com/api/classes/Ember.String.html).
