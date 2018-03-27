Ember CLI by default uses [Babel.js](https://babeljs.io/) to allow you to use tomorrow's JavaScript, today.

It will ensure that you can use the newest features in the language and know that they will be transformed to JavaScript that can run in every browser you support.
That usually means generating ES5-compatible code that can work on any modern browser, back to Internet Explorer 11.

But ES5 code is usually more verbose than the original Javascript, and over time, as browsers gain the ability to execute the new features in JavaScript and older browsers lose users, many users won't really want this verbose code as it increases their app's size and load times.

That is why Ember CLI exposes a way of configuring what browsers your app targets.
It can figure out automatically what features are supported by the browsers you are targeting,
and apply the minimum set of transformations possible to your code.

If you open `config/targets.js`, you will find the following code:

```config/targets.js
const browsers = [
  'last 1 Chrome versions',
  'last 1 Firefox versions',
  'last 1 Safari versions'
];

const isCI = !!process.env.CI;
const isProduction = process.env.EMBER_ENV === 'production';

if (isCI || isProduction) {
  browsers.push('ie 11');
}

module.exports = {
  browsers
};
```

That default configuration has two parts.
In `production` environment it matches the wider set of browsers that Ember.js itself supports.
In non-production builds a narrower subset of browsers is used to provide the best experience 
for developers to debug code that is much closer to what they actually wrote.

However, if your app does not need to support IE anymore, you could change it to:

```config/targets.js
module.exports = {
  browsers: [
    'last 1 edge versions',
    'last 1 Chrome versions',
    'last 1 Firefox versions',
    'last 1 Safari versions'
  ]
};
```

You are left with browsers that have full support of ES2015 and ES2016.
If you inspect the compiled code, you will see that some features are not compiled to ES5 code anymore, such as arrow functions and async/await.

This feature is backed by [Browserlist](https://github.com/ai/browserslist) and [Can I Use](http://caniuse.com/).
These websites track usage stats of browsers, so you can use complex queries based on the user base of every browser.

If you want to target all browsers with more than a 4% market share in Canada,
you'd have the following options:

```config/targets.js
module.exports = {
  browsers: [
    '> 4% in CA'
  ]
};
```

It is very important that you properly configure the targets of your app so you get the smallest and fastest code possible.

Build targets can also be leveraged in other ways.

Some addons might conditionally include polyfills only if needed.
Some linters may emit warnings when using features not yet fully supported in your targets.
Some addons may even automatically prefix unsupported CSS properties.
