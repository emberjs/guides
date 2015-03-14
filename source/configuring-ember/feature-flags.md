New features are added to Ember.js within conditional statements.

Code behind these flags can be conditionally enabled
(or completely removed) based on you project's configuration. This
allows newly developed features to be selectively released when the
Ember.js community considers them ready for production use.

## Feature Life-Cycle
A newly-flagged feature is only available in canary builds and can be enabled
at runtime through your project's configuration file.

At the start of a beta cycle the Ember core team evaluates each new feature.
Features deemed stable are made available in the next beta and enabled by default.

Beta features that receive negative feedback from the community are disabled in the next beta point
release, and are not included in the next stable release. They may still be included
in the next beta cycle if the issues/concerns are resolved.

Once the beta cycle has completed the next stable release will include any features that
were enabled during the beta cycle. At this point the feature flags will be removed from
the canary and future beta branches and the feature becomes of the framework.

## Flagging Details
The flag status in the generated build is controlled by the `features.json`
file in the root of the Ember.js project. This file lists all new features and their current status.

A feature can have one of a three flags:

* `true` - The feature is **present** and **enabled**: the code behind the flag is always enabled in
  the generated build.
* `null` - The feature is **present** but **disabled** in the build output. It must be enabled at
  runtime.
* `false` - The feature is entirely **disabled**: the code behind the flag is not present in
  the generated build.

The process of removing the feature flags from the resulting build output is
handled by [`defeatureify`](https://github.com/thomasboyt/defeatureify).

## Feature Listing ([`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md))

When a developer adds a new feature `canary` channel (i.e. the `master` branch on github), they
also add an entry to [`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md)
explaining what the feature does and linking to their originating pull request.
This list is kept current, and reflects what is available in each channel
(`stable`, `beta`, and `master`).

## Enabling At Runtime
When using the Ember.js canary or beta builds you can enable any "**present** but **disabled**"
by setting its flag value to `true` before your application boots:

```config/environment.js
var ENV = {
  EmberENV: {
    FEATURES: {
      'link-to': true
    }
  }
};

export default ENV;
```

For the truly ambitious developer, setting `ENV.EmberENV.ENABLE_ALL_FEATURES` to `true` will enable all
experimental features.
