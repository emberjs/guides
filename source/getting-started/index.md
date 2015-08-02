Getting started with Ember.js is easy. Ember.js projects are created and managed
through our [command line build tool ember-cli](http://www.ember-cli.com/). The command line tool brings:

* Modern application asset management (including combining, minifying, and versioning).
* Built-in generators to help you create components, routes, and more.
* A conventional project layout so approaching other developers' Ember.js applications is easy.
* Official [JavaScript modules](http://jsmodules.io/) to keep your project organized.
* A complete testing framework.
* Access to a growing ecosystem of [Ember Addons](http://www.emberaddons.com/).


## Dependencies

### Node.js and npm

Ember CLI is installed using npm (the Node Package Manager), which is bundled
with Node.js. Ember requires Node.js 0.12 or higher and npm 2.7 or higher.
If you're not sure whether you have Node.js, try running from your
command line:

```bash
node --version
```

If you get back something like `0.12.x`, you're ready to go.

If you **don't**:

* Windows or Mac users [can simply download and run the installer](http://nodejs.org/download/).
* Mac users often prefer to install Node using [Homebrew](http://brew.sh/). After
installing Homebrew, run `brew install node` to install Node.js.
* Linux users [can check out this great guide](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) by Joyent for install instructions.

Once you've got Node.js installed, re-run `node --version` to verify your install.

### Git

Ember requires Git to manage many of its dependencies.
Git comes with Mac OS X and most Linux distributions.
Windows users can [download and run the installer](http://git-scm.com/download/win).

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

If you get back something like `version: 1.13.0`, you're ready to go.
