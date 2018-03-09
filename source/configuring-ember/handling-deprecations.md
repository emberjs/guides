A valuable attribute of the Ember framework is its use of [Semantic Versioning](http://semver.org/) to aid projects in keeping up with
changes to the framework.  Before any functionality or API is removed it first goes through a deprecation period where the functionality is
still supported, but usage of it generates a warning logged to the browser console.  These warnings can pile up between major releases to a point where the amount of
deprecation warnings that scroll through the console becomes overwhelming.

<img width="675px" title="Deprecations Clouding up the Browser JavaScript Console" src="../../images/guides/configuring-ember/handling-deprecations/deprecations-in-console.png"/>

Fortunately, Ember provides a way for projects to deal with deprecations in an organized and efficient manner.

## Filtering Deprecations

When your project has a lot of deprecations, you can start by filtering out deprecations that do not have to be addressed right away.  You
can use the [deprecation handlers](https://emberjs.com/api/ember/2.15/classes/Ember.Debug/methods/registerDeprecationHandler?anchor=registerDeprecationHandler) API to check for what
release a deprecated feature will be removed.  An example handler is shown below that filters out all deprecations that are not going away
in release 2.0.0.


``` app/initializers/main.js
import Ember from 'ember';

export function initialize() {
  if (Ember.Debug && typeof Ember.Debug.registerDeprecationHandler === 'function') {
    Ember.Debug.registerDeprecationHandler((message, options, next) => {
      if (options && options.until && options.until !== '2.0.0') {
        return;
      } else {
        next(message, options);
      }
    });
  }
}

export default { initialize };
```

The deprecation handler API was released in Ember 2.1.  If you would like to leverage this API in a prior release of Ember you can install
the [ember-debug-handlers-polyfill](http://emberobserver.com/addons/ember-debug-handlers-polyfill) addon into your project.

## Deprecation Workflow

Once you've removed deprecations that you may not need to immediately address, you may still be left with many deprecations.  Also, your remaining
deprecations may only occur in very specific scenarios that are not obvious.  How then should you go about finding and fixing these?  This
is where the [ember-cli-deprecation-workflow](http://emberobserver.com/addons/ember-cli-deprecation-workflow) addon can be extremely helpful.

Once installed, the addon works in 3 steps:

### 1. Gather deprecations into one source

The ember-cli-deprecation-workflow addon provides a command that will collect deprecations from your console and generate JavaScript code listing
its findings.

To collect deprecations, first run your in-browser test suite by starting your development server and navigating to [`http://localhost:4200/tests`](http://localhost:4200/tests).  If your test suite isn't fully covering your app's functionality, you may also
manually exercise functionality within your app where needed.  Once you've exercised the app to your satisfaction, run the following command within
your browser console: `deprecationWorkflow.flushDeprecations()`.  This will print to the console JavaScript code, which you should then copy to a
new file in your project called `/config/deprecation-workflow.js`

<img width="675px" title="Generated Deprecation Code from Browser Console" src="../../images/guides/configuring-ember/handling-deprecations/generate-deprecation-code.png"/>

Here's an example of a deprecation-workflow file after generated from the console:

``` /config/deprecation-workflow.js
window.deprecationWorkflow = window.deprecationWorkflow || {};
window.deprecationWorkflow.config = {
  workflow: [
    { handler: "silence", matchMessage: "Ember.Handlebars.registerHelper is deprecated, please refactor to Ember.Helper.helper." },
    { handler: "silence", matchMessage: "`lookup` was called on a Registry. The `initializer` API no longer receives a container, and you should use an `instanceInitializer` to look up objects from the container." },
    { handler: "silence", matchMessage: "Using `Ember.HTMLBars.makeBoundHelper` is deprecated. Please refactor to using `Ember.Helper` or `Ember.Helper.helper`." },
    { handler: "silence", matchMessage: "Accessing 'template' in <web-directory@component:x-select::ember1381> is deprecated. To determine if a block was specified to <web-directory@component:x-select::ember1381> please use '{{#if hasBlock}}' in the components layout." },
    { handler: "silence", matchMessage: "Accessing 'template' in <web-directory@component:x-select::ember1402> is deprecated. To determine if a block was specified to <web-directory@component:x-select::ember1402> please use '{{#if hasBlock}}' in the components layout." },
    { handler: "silence", matchMessage: "Accessing 'template' in <web-directory@component:x-select::ember1407> is deprecated. To determine if a block was specified to <web-directory@component:x-select::ember1407> please use '{{#if hasBlock}}' in the components layout." }
  ]
};
```

You might notice that you have a lot of duplicated messages in your workflow file, like the 3 messages in the above example that start with
`Accessing 'template' in...`.  This is because some of the deprecation messages provide context to the specific deprecation, making them
different than the same deprecation in other parts of the app.  If you want to consolidate the
duplication, you can use a simple regular expression with a wildcard (`.*`) for the part of the message that varies per instance.

Below is the same deprecation-workflow file as above, now with a regular expression on line 7 to remove some redundant messages. Note that the double quotes around `matchMessage` have also been replaced with forward slashes.

``` /config/deprecation-workflow.js
window.deprecationWorkflow = window.deprecationWorkflow || {};
window.deprecationWorkflow.config = {
  workflow: [
    { handler: "silence", matchMessage: "Ember.Handlebars.registerHelper is deprecated, please refactor to Ember.Helper.helper." },
    { handler: "silence", matchMessage: "`lookup` was called on a Registry. The `initializer` API no longer receives a container, and you should use an `instanceInitializer` to look up objects from the container." },
    { handler: "silence", matchMessage: "Using `Ember.HTMLBars.makeBoundHelper` is deprecated. Please refactor to using `Ember.Helper` or `Ember.Helper.helper`." },
    { handler: "silence", matchMessage: /Accessing 'template' in .* is deprecated. To determine if a block was specified to .* please use '{{#if hasBlock}}' in the components layout./ }
  ]
};
```

Rerun your test suite as you make updates to your workflow file and you should validate that your deprecations are gone. Once that is completed,
you can proceed with enhancing your application without the sea of deprecation warnings clouding your log.

### 2. "Turn on" a deprecation
Once you have built your `deprecation-workflow.js` file and your deprecations are silenced, you can begin to work on deprecations one by one
at your own leisure.  To find deprecations, you can change the handler value of that message to either `throw` or `log`.  Throw will
throw an actual exception when the deprecation is encountered, so that tests that use the deprecated feature will fail.  Choosing to log will
simply log a warning to the console as before.  These settings give you some flexibility on how you want to go about fixing the
deprecations.

The code below is the deprecation-workflow file with the first deprecation set to throw an exception on occurrence.  The image demonstrates what
that deprecation looks like when you run your tests.

``` /config/deprecation-workflow.js
window.deprecationWorkflow = window.deprecationWorkflow || {};
window.deprecationWorkflow.config = {
  workflow: [
    { handler: "throw", matchMessage: "Ember.Handlebars.registerHelper is deprecated, please refactor to Ember.Helper.helper." },
    { handler: "silence", matchMessage: "`lookup` was called on a Registry. The `initializer` API no longer receives a container, and you should use an `instanceInitializer` to look up objects from the container." },
    { handler: "silence", matchMessage: "Using `Ember.HTMLBars.makeBoundHelper` is deprecated. Please refactor to using `Ember.Helper` or `Ember.Helper.helper`." },
    { handler: "silence", matchMessage: /Accessing 'template' in .* is deprecated. To determine if a block was specified to .* please use '{{#if hasBlock}}' in the components layout./ }
  ]
};
```
<img width="675px" src="../../images/guides/configuring-ember/handling-deprecations/failed-test-from-deprecation.png"/>


### 3. Fix and Repeat
After fixing a deprecation and getting your scenarios working again, you might want to leave the deprecation message in the workflow file with the
throw handler enabled.  This will ensure you haven't missed anything, and ensure no new deprecated calls of that type are introduced to your project.
Next, it's just a matter of going down the list, updating the handler, and fixing each remaining deprecation.

In the end, your deprecations can be fully turned on as "throw" and you should be able to use your application without error.  At this point, you can
go ahead and update your Ember version!  When you upgrade, be sure you remove the deprecations you've fixed from the deprecation workflow file,
so that you can start the process over for the next release.

## Silencing Deprecation Warnings During Compile

As you upgrade between releases, you might also notice that your terminal log begins to stream template-related deprecation warnings during the compile process, making
it difficult to review your compilation logs.

<img width="675px" src="../../images/guides/configuring-ember/handling-deprecations/compile-deprecations.png" title="Compile Deprecations Clouding Log"/>

If you are using the deprecation workflow process above, you will likely prefer to gather these warnings during runtime execution instead.  The way to hide these
warnings during compile is to install the [ember-cli-template-lint](http://emberobserver.com/addons/ember-cli-template-lint) addon.  It suppresses
template deprecation warnings during compile in favor of showing them in the browser console during test suite execution or application usage.

## Deprecation Handling in Ember Inspector

Ember Inspector also provides deprecation handling capability.  It can work complimentary to ember-cli-deprecation-workflow.  As you unsilence deprecations to
fix them, the inspector can allow you to more quickly find where in your code a deprecation occurs when you run into it at runtime, reducing the amount of
stack trace browsing you have to do.  For more information on using deprecation handling in Ember Inspector, see its [guides section](../../ember-inspector/deprecations/).
