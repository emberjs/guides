Getting started with Ember.js is easy. Ember.js projects are created and managed
through our command line build tool Ember CLI.
This tool provides:

* Modern application asset management (including concatenation, minifying, and versioning)
* Generators to help you create components, routes, and more
* A conventional project layout, so approaching existing Ember.js applications is easy
* Support for ES2015/ES6 JavaScript via the [Babel](http://babeljs.io/docs/learn-es2015/)
  project. This includes support for [JavaScript modules](http://exploringjs.com/es6/ch_modules.html), which are used
  throughout this guide.
* A complete [QUnit](https://qunitjs.com/) test harness
* The ability to consume a growing ecosystem of Ember Addons

## Dependencies

### Node.js and npm

Ember CLI is built with JavaScript, and expects the [Node.js](https://nodejs.org/)
runtime. It also requires dependencies fetched via [npm](https://www.npmjs.com/). npm is packaged with Node.js, so if your computer has Node.js
installed you are ready to go.

Ember requires Node.js 0.12 or higher and npm 2.7 or higher.
If you're not sure whether you have Node.js, run this on your
command line:

```bash
node --version
```

The output should say something like `0.12.x`. If it does not:

* Windows or Mac users can download and run [this Node.js installer](http://nodejs.org/download/).
* Mac users often prefer to install Node using [Homebrew](http://brew.sh/). After
installing Homebrew, run `brew install node` to install Node.js.
* Linux users can use [this guide for Node.js installation on Linux](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

Once you've got Node.js installed, re-run `node --version` to verify your
computer's setup.

### Git

Ember requires Git to manage many of its dependencies. Git comes with Mac OS
X and most Linux distributions. Windows users can
download and run [this Git installer](http://git-scm.com/download/win).

### Watchman (optional)

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

## Installation

Install Ember using npm:

```bash
npm install -g ember-cli
```

While you're at it we recommend you also install PhantomJS to run tests from
the command line (without the need for a browser to be open):

```bash
npm install -g phantomjs2
```

To verify that your installation was successful, run:

```bash
ember -v
```

If the result is something like `version: 1.13.0`, you're ready to go.
