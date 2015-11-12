Getting started with Ember.js is easy. Ember.js projects are created and managed
through our command line build tool, Ember CLI.

This tool provides:

* Modern application asset management (including concatenation, minifying, and
  versioning)
* Generators to help you create components, routes, and more
* A conventional project layout, so approaching existing Ember.js applications
is easy
* Support for ES2015/ES6 JavaScript via the
[Babel](http://babeljs.io/docs/learn-es2015/)
  project. This includes support for [JavaScript modules](http://exploringjs.com/es6/ch_modules.html), which are used
  throughout this guide.
* A complete [QUnit](https://qunitjs.com/) test harness
* The ability to consume a growing ecosystem of Ember Addons

## Dependencies

### Node.js and npm

Ember CLI is built with JavaScript, and expects the
[Node.js](https://nodejs.org/)
runtime. It also requires dependencies fetched via [npm](https://www.npmjs.com/)
, the package manager for Node.js. npm is packaged with Node.js, so if your
computer has Node.js
installed, you are ready to go.

Ember requires Node.js 0.12 or higher and npm 2.7 or higher.
If you're not sure whether you have Node.js, run this on your
command line:

```bash
node --version
```

The output should give a version number. If it gives a "command not found" error
instead:

* Windows or Mac users can download and run [this Node.js installer](http://nodejs.org/download/).
* Mac users often prefer to install Node using [Homebrew](http://brew.sh/).
After
installing Homebrew, run `brew install node` to install Node.js.
* Linux users can use [this guide for Node.js installation on Linux](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

Once you've got Node.js installed, re-run `node --version` to verify your
computer's setup.

If you already have npm and Node.js installed, it's a good idea to make sure
you're on the latest version of npm since it gets updated more frequently than
Node.js does.

To update npm, run:

```bash
npm install -g npm
```

For those unfamiliar with npm, the reason why you are using `-g` is to install
the tool globally, meaning it can be used across your entire computer in any
project through your command line. In contrast, npm also allows you to install
Node.js packages locally, installed without the `-g`, meaning that the software
will be installed inside a particular folder for use in that folder or project
only. We'll also be installing Ember and Ember CLI globally later on.

### Git

Ember requires Git to manage many of its dependencies. Git comes with Mac OS
X and most Linux distributions. Windows users can
download and run [this Git installer](http://git-scm.com/download/win).

### Watchman (optional)

On Mac and Linux, you can improve file watching performance and receive alerts
when files change or get
deleted/added by installing
[Watchman](https://facebook.github.io/watchman/docs/install.html).

## Installation

Ember CLI is installed using npm.

To install, run:

```bash
npm install -g ember-cli
```

While you're at it, we recommend you also install PhantomJS to run tests from
the command line without the need for a browser to be open.

To install PhantomJS, run:

```bash
npm install -g phantomjs2
```

If you run into any problems with this step, consult the [PhantomJS download
instructions](http://phantomjs.org/download.html).

Once we have everything installed, we'll be able to run commands with Ember
CLI's executable, which is `ember`. There are many commands available by running
the executable `ember` along with another command. A list of all commands is
available by simply running `ember` or `ember help` from the command line.

To check if the install was successful, run:

```bash
ember -v
```

If the previous command printed a version to the terminal, you're ready to go.
