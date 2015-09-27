As part of making your app upgrades as smooth as possible, the Inspector gathers your deprecations, groups them, and displays them in a
way that helps you fix them.

To view the list of deprecations in an app, click on the `Deprecations` menu.

<img src="../../images/guides/ember-inspector/deprecations-screenshot.png" width="680"/>

You can see the total number of deprecations next to the `Deprecations` menu.
You can also see the number of occurrences for each deprecation.

### Ember CLI Deprecation Sources

If you are using Ember CLI and have source maps enabled, you can see a
list of sources for each deprecation. If you are using Chrome or Firefox,
clicking on the source opens the sources panel and takes you to
the code that caused the deprecation message to be displayed.

<img src="../../images/guides/ember-inspector/deprecations-source.png" />

<img src="../../images/guides/ember-inspector/deprecations-sources-panel.png" width="550"/>

You can send the deprecation message's stack trace to the
console by clicking on `Trace in the console`.


### Transition Plans

Click on the "Transition Plan" link for information on how to remove the deprecation warning, and you'll be taken to a helpful deprecation guide on the Ember website.

<img src="../../images/guides/ember-inspector/deprecations-transition-plan.png" width="680" />


### Filtering and Clearing

You can filter the deprecations by typing a query in the search box.
You can also clear the current deprecations by clicking on the clear icon
at the top.

<img src="../../images/guides/ember-inspector/deprecations-toolbar.png"
width="300"/>
