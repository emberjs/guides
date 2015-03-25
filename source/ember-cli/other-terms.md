In addition to the background concepts, there are some other concepts you may
run into and/or find useful as you develop Ember apps. It's not necessary to
understand these fully before building your first Ember app, but you may find it
useful to refer back here as you encounter these topics or want to expand your
skill set.


## CDN (Content Delivery Network)
This is typically a paid service you can use to get great performance for your app. You start by uploading a resource (image, JavaScript file, etc) to a company like Akamai or CloudFlare. That uploaded resource will have an absolute URL which you can reference anywhere in your app. This URL will resolve differently for folks depending on where they're browsing.

Behind the scenes, the CDN will distribute your content geographically with the goal of end-users being able to fetch your content with the lowest latency possible. For example, if a user is in India, they'd likely get content served from India faster than from the United States.


## CoffeeScript, TypeScript
These are both languages which compile to JavaScript. You can write your code in CoffeeScript or TypeScript, and then compile it into JavaScript.

For more information, here's an article with a nice [explanation of CoffeeScript and TypeScript](http://www.stoutsystems.com/articles/coffeescript-versus-typescript/).


## Evergreen browsers
[Evergreen Browsers](http://tomdale.net/2013/05/evergreen-browsers/) are browsers that update themselves, without user intervention.


## ES3, ES5, ES5.1, ES6 (aka ES2015), etc
ES stands for [ECMAScript](https://en.wikipedia.org/wiki/ECMAScript), which is the specification that JavaScript is based on. The number that follows is the version of the specification.

Most browsers support at least ES5, and some even have ES6 (also known as ES2015) support. You can check each browser's [ES5 support](http://kangax.github.io/compat-table/es5/) and [ES6 support](http://kangax.github.io/compat-table/es6/).


## LESS, Sass
[LESS and Sass](https://gist.github.com/chriseppstein/674726) are languages which compile to CSS. Both LESS and Sass are types of CSS preprocessor markup intended to give you much more control over your CSS. During the build process, the LESS or Sass resources "compile" down to vanilla CSS (which is what the end-user downloads and use in their browser).


## Linter
A linter is a validation tool which checks for common issues in your code. You'd usually use this in your build process to enforce quality in your codebase. A great example of something to check for: *making sure you've always got your semicolons*.

Here's an [example of some of the options you can configure](http://jshint.com/docs/options/) for a popular linter, JSHint.


## Polyfill
This is concept that typically means providing JavaScript which tests for features that are missing (prototypes not defined, etc) and "fills" them by providing an implementation.


## Server Side Rendering (SSR)
Ember will soon support [Server-Side Rendering](http://emberjs.com/blog/2014/12/22/inside-fastboot-the-road-to-server-side-rendering.html).


## Transpile
Transpile means to convert from one language to another of a similar abstraction level. In Ember, you'll run into transpiling most often in the context of transpiling your ES6 syntax JavaScript to JavaScript that is supported by current browsers. Ember transpiles ES6 using [Babel](https://babeljs.io/) via the [ember-cli-babel](https://github.com/babel/ember-cli-babel) plugin.


## Shadow DOM
**Not to be confused with Virtual DOM**. Ember's Shadow DOM is still a work in progress, but is basically a proposed way to have an "isolated" DOM encapsulated within your app's DOM.

Creating a re-usable "widget" or control might be a good use-case for this. Browsers implement some of their controls using their own version of a shadow DOM.

Here's a good [explanation of Shadow DOM](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom/), as well as the [W3C Working Draft](http://www.w3.org/TR/shadow-dom/).


## Virtual DOM
**Not to be confused with Shadow DOM**. Ember's [Glimmer engine](https://github.com/emberjs/ember.js/pull/10501) will implement a Virtual DOM to dramatically improve rendering performance.
