Ember CLI, Ember's command line interface, provides a standard project
structure, a set of development tools, and an addon system.
This allows Ember developers to focus on building apps rather
than building the support structures that make them run.
In the terminal, a quick `ember --help` shows
the commands Ember CLI provides. For more information on a specific command,
type `ember help <command-name>`.

## Creating a New App

To create a new project using Ember CLI, use the `new` command. In preparation
for the tutorial in the next section, you can make an app called `super-rentals`.

```shell
ember new super-rentals
```

## Directory Structure

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

Let's take a look at the folders and files Ember CLI generates.

**app**: This is where folders and files for models, components, routes,
templates and styles are stored. The majority of your coding on an Ember
project happens in this folder.

**bower_components / bower.json**: Bower is a dependency management tool.
It is used in Ember CLI to manage front-end plugins and component dependencies
(HTML, CSS, JavaScript, etc).  All Bower components are installed in the
`bower_components` directory.  If we open `bower.json`, we see the list of
dependencies that are installed automatically including Ember, jQuery, Ember
Data and QUnit (for testing). If we add additional front-end dependencies,
such as Bootstrap, we will see them listed here and added to the
`bower_components` directory.

**config**: The config directory contains the `environment.js` where you can
configure settings for your app.

**dist**: When we build our app for deployment, the output files will be created
here.

**node_modules / package.json**: This directory and file are from npm.
npm is the package manager for Node.js. Ember is built with Node and uses a
variety of Node.js modules for operation. The `package.json` file maintains the
list of current npm dependencies for the app.  Any Ember-CLI
add-ons you install will also show up here. Packages listed in `package.json`
are installed in the node_modules directory.

**public**: This directory contains assets such as images and fonts.

**vendor**: This directory is where front-end dependencies (such as JavaScript
or CSS) that are not managed by Bower go.

**tests / testem.json**: Automated tests for our app go in the `tests` folder,
and Ember CLI's test runner **testem** is configured in `testem.json`.

**tmp**: Ember CLI temporary files live here.

**ember-cli-build.js**: This file describes how Ember CLI should build our app.

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

## The Development Server

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
