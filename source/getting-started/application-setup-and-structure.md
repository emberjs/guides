Ember is designed to minimize the amount of configuration necessary to get an
application up and running.  To do this, a number of peripheral tasks to
application development have been streamlined, such as testing, compiling, and
serving files.  This allows Ember developers to focus on building apps rather
than building the support structures that make them run.

Ember includes a _command line interface_ called Ember CLI with helpful tools
that are immediately available.  In the terminal, a quick `ember --help` shows
the commands we can use.  For more information on a specific command, we can
type `ember help <command-name>`.  This shows us the details of how the command is
  used.

## Creating a New Ember App

To start a new project called `super-rentals`, we navigate to the directory
where we want to work and use the `new` command:

```shell
ember new super-rentals
```

## The Ember CLI Directory Structure

The `new` command generates a project structure with the following files and
directories:

```text
|--app
|--bower_components
|--config
|--dist
|--node_modules
|--public
|--tests
|--tmp
|--vendor

bower.json
ember-cli-build.js
package.json
README.md
testem.json
```

Let's quickly take a look at the anatomy of an Ember application.

**app**: This is where folders and files for models, components, routes,
templates and styles are stored. As we'll see, the majority of our coding on a
project happens in this folder.

**bower_components / _bower.json**: **bower** is a dependency management tool.
It is used in Ember to manage front-end plugins and component dependencies
(HTML, CSS, JavaScript, etc).  All bower components are installed in the
bower_components directory.  If we open `bower.json`, we see the list of
dependencies that are installed automatically including Ember, jQuery, Ember
Data and QUnit (for testing). If we add additional front-end dependencies,
such as `bootstrap`, we will see them listed here and added to the
`bower_components` directory.

**config**: The config directory contains the _environment.js_ file which lists
environmental settings for our app.

**dist**: When we build our app for deployment, the output files will be created
  here.

**node_modules / package.json**: This directory and file are from **npm**.
_npm_ is the package manager for Node.js. Ember is built with Node and uses a
variety of Node.js modules for operation. The _package.json_ file maintains the
list of current npm dependencies for the app.  If we open the file, we see the
packages needed for Broccoli and Ember-CLI are listed here. Any Ember-CLI
add-ons you install will also show up here. Packages listed in `package.json`
are installed in the node_modules directory.

**public**: This directory contains assets such as images and fonts.

**vendor**: This directory is where front-end dependencies (such as JavaScript
or CSS) that are NOT managed by bower go.

**tests / testem.json**: Automated tests for our app go in the `tests` folder,
and Ember CLI's test runner **testem** is configured in `testem.json`.

**tmp**: Ember CLI temporary files live here.

**ember-cli-build.js**: Ember CLI uses **Broccoli** behind the scenes to quickly
  compile our code.  This file describes how Broccoli should build our app.

## ES6 Modules

If you take a look at `app/router.js`, you'll notice some syntax that may be
unfamiliar to you.

```app/router.js
import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('rentals');
  this.route('about');
  this.route('contact');
});

export default Router;
```

Ember CLI uses ECMAScript 6 (or ES6 for short) modules to organize application
code.
For example, the line `import Ember from 'ember';` gives us access to the actual
  Ember.js library as the variable `Ember`. And the `import config from
  './config/environment';` line gives us access to our app's configuration data
  as the variable `config`. At the end of the file, `export default Router;
  ` makes the `Router` variable defined in this file available to other parts
  of the app.

## Starting the Ember Development Server

Once we have a new project in place, we can confirm everything is working by
starting the Ember development server:

```shell
ember server
```

or, for short:

```shell
ember s
```

If we navigate to `localhost:4200`, we'll see our brand new app displaying
the text "Welcome to Ember.js".
