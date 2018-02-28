Ember relied on jQuery in the past, and it still ships with it by default.
However, in Ember 3.x it is an optional dependency that you can opt out from.

To do so, install the [`@ember/optional-features`](https://github.com/emberjs/ember-optional-features) addon
and disable the `jquery-integration` flag:

```shell
ember install @ember/optional-features
ember feature:disable jquery-integration
```

This will remove jQuery from your `vendor.js` bundle and disable any use of jQuery in Ember itself.
Now your app will be about 30KB lighter!

## Caveats

Without jQuery, any code that still relies on it will break, especially any usage of

* [`this.$()`](https://www.emberjs.com/api/ember/release/classes/Component/methods/$?anchor=%24) in components
* `jQuery` or `$` directly as a global, through `Ember.$()` or by importing it (`import jQuery from jquery;`) 
* global acceptance test helpers like `find()` or `click()`
* `this.$()` in component tests

Note that this also applies to all addons that your app uses, so make sure they support being used without jQuery.
