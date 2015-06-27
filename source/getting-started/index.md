Getting started with Ember.js is easy. Ember.js projects are created and managed
through our [command line build tool ember-cli](http://www.ember-cli.com/). The command line tool brings:

* Modern application asset management (including combining, minifying, and versioning).
* Built-in generators to help you create components, routes, and more.
* A conventional project layout so approaching another developer's Ember.js applications is easy.
* Official [JavaScript modules](http://jsmodules.io/) to keep your project organized.
* A complete testing framework.
* Access to a growing ecosystem of [Ember Addons](http://www.emberaddons.com/).


## Installation
Ember.js installs through the [npm](#toc_got-node-npm-and-git). Install the Ember.js
build tools with `npm`.

```bash
npm install -g ember-cli
```

Note that the Ember CLI build tool has a few dependencies of its own. In particular, you will need to install [Bower](http://bower.io/) (if you don't have it already) in order to use Ember's build tool as described in these guides. You'll also want to install [PhantomJS](http://phantomjs.org/), which Ember CLI uses to run tests from the command line (without the need for a browser to be open).

```bash
npm install -g bower
npm install -g phantomjs
```

Read the [Getting Started section](http://www.ember-cli.com/#getting-started) of the `ember-cli` project for more information about Ember CLI's dependencies .

## Testing your installation

When installation completes, test your install to ensure it worked by generating a
new project:

```bash
ember new my-app
```

This will create a new `my-app` directory and generate an application structure for you.

Once the generation process finishes, verify that you can run the newly created application:

```bash
cd my-app
ember server
```

Navigate to `http://localhost:4200` to see your new app in action.

## Troubleshooting

### Got Node, npm, and Git?

ember-cli requires Node.js 0.12 or higher, npm 2.7 or higher, and Git.

Node Package Manager (npm) comes bundled with node.js.  If you're not sure if
you have node.js installed, try running the following command in your terminal:

```bash
node --version
```

If you have node installed you'll see a message like `0.12.x` in your terminal.

If you don't have node 0.12 or higher installed:

* Windows or Mac users [can download and run the installer](http://nodejs.org/download/).
* Linux users [should read through this guide](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) by Joyent for install instructions.

Once you've got node.js installed, run the `node --version` command again to verify your install.

Git comes with Mac OS X and most Linux distributions.
Windows users can [download and run the installer](http://git-scm.com/download/win).
