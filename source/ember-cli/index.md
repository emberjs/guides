Installing Ember is easy using *Ember CLI*, Ember's build tool.

Ember CLI provides:

* State of the art asset management (including combining, minifying, and versioning)
* Built-in generators to create components, routes, and more (and their test cases!)
* A standard project layout to make jumping into other Ember apps is easy
* Native [JavaScript modules](http://jsmodules.io/) to keep your project organized
* A framework for unit and integration tests
* Access to a growing ecosystem of [Ember Addons](http://www.emberaddons.com/)

## Prerequisites

Ember CLI is installed using npm (the Node Package Manager), which is bundled
with Node.js. If you're not sure whether you have Node.js, try running from your
command line:

```bash
node --version
```

If you get back something like `0.10.x`, you've got Node.js and npm!

If you **don't**:

* Windows or Mac users [can simply download and run the installer](http://nodejs.org/download/).
* Mac users often prefer to install Node using [Homebrew](http://brew.sh/). After
installing Homebrew, run `brew install node` to install Node.js.
* Linux users [can check out this great guide](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) by Joyent for install instructions.

Once you've got Node.js installed, re-run `node --version` to verify your install.

## Optional prerequisites

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

## Installation

Install Ember using [npm](#toc_got-node-and-npm). While you're at it we recommend
you also install PhantomJS to run tests from the command line (without the need
for a browser to be open).

```bash
npm install -g ember-cli
npm install -g phantomjs
```

To verify that your installation was successful, run:

```bash
ember -v
```

If you get back something like `version: 0.2.0`, you're ready to go.


## Testing your installation

To make sure everything works properly, let's run the generator to create a project:

```bash
ember new my-app
```

This will create a new `my-app` folder and generate an application structure for you.

Once the generation process finishes, let's verify that we can launch the newly created app:

```bash
cd my-app
ember server
```

Navigate to `http://localhost:4200` to see your new app in action.
