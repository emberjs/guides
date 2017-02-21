You can install the Inspector on Google Chrome, Firefox, other browsers (via a bookmarklet), and on mobile devices by following the steps below.

### Google Chrome

You can install the Inspector on Google Chrome as a new Developer Tool. To begin, visit the Extension page on the [Chrome Web Store](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi).

Click on "Add To Chrome":

<img src="../../images/guides/ember-inspector/installation-chrome-store.png" width="680" />

Once installed, go to an Ember application, open the Developer Tools, and click on the `Ember` tab at the far right.

<img src="../../images/guides/ember-inspector/installation-chrome-panel.png" width="680" />

#### File:// protocol

To use the Inspector with the `file://` protocol, visit `chrome://extensions` in Chrome and check the "Allow access to file URLs" checkbox:

<img src="../../images/guides/ember-inspector/installation-chrome-file-urls.png" width="400" />

#### Enable Tomster

You can configure a Tomster icon to show up in Chrome's URL bar whenever you are visiting a site that uses Ember.

Visit `chrome://extensions`, then click on `Options`.

<img src="../../images/guides/ember-inspector/installation-chrome-tomster.png" width="400" />

Make sure the "Display the Tomster" checkbox is checked.

<img src="../../images/guides/ember-inspector/installation-chrome-tomster-checkbox.png" width="400" />

### Firefox

Visit the Add-on page on the [Mozilla Add-ons site](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/).

Click on "Add to Firefox".

<img src="../../images/guides/ember-inspector/installation-firefox-store.png" width="680" />

Once installed, go to an Ember application, open the Developer Tools, and click on the `Ember` tab.

<img src="../../images/guides/ember-inspector/installation-firefox-panel.png" width="680" />

#### Enable Tomster

To enable the Tomster icon to show up in the URL bar whenever you are visiting a site that uses Ember visit `about:addons`.

Click on `Extensions` -> `Preferences`.

<img src="../../images/guides/ember-inspector/installation-firefox-preferences.png" width="600" />

Then make sure the "Display the Tomster icon when a site runs Ember.js" checkbox is checked.

<img src="../../images/guides/ember-inspector/installation-firefox-tomster-checkbox.png" width="400" />

### Via Bookmarklet

If you are using a browser other than Chrome or Firefox, you can use the bookmarklet option to use the Inspector.

Add the following bookmark:

[Bookmark Me](javascript: (function() { var s = document.createElement('script'); s.src = '//ember-extension.s3.amazonaws.com/dist_bookmarklet/load_inspector.js'; document.body.appendChild(s); }());)

To open the Inspector, click on the new bookmark. Safari blocks popups by default, so you'll need to enable popups before using the bookmarklet.

### Mobile Devices

If you want to run the Inspector on a mobile device, you can use the [Ember CLI Remote Inspector](https://github.com/joostdevries/ember-cli-remote-inspector) addon.