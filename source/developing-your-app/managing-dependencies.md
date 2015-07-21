Ember CLI uses [Bower](http://bower.io/) for dependency management.

### Bower Configuration

The Bower configuration file, `bower.json`, is located at the root of your Ember
CLI project, and lists the dependencies for your project. Changes to your
dependencies should be managed through this file, rather than manually
installing packages individually.

Executing `bower install` will install all of the dependencies listed in
`bower.json` in one step.

Ember CLI is configured to have git ignore your `bower_components` directory by
default. Using the Bower configuration file allows collaborators to fork your
repo and get their dependencies installed locally by executing
`bower install` themselves.

Ember CLI watches `bower.json` for changes. Thus it reloads your app if you
install new dependencies via `bower install <dependencies> --save`.

Further documentation about Bower is available at their
[official documentation page](http://bower.io/).

### Compiling Assets

In your `Brocfile.js` specify a dependency before calling `app.toTree()`. You
can only import assets that are within the `bower_components` or `vendor`
directories. The following example scenarios illustrate how this works.

#### Javascript Assets

##### Standard Non-AMD Asset

Provide the asset path as the first and only argument:

```Brocfile.js
app.import('bower_components/moment/moment.js');
```

From here you would use the package as specified by it's documentation, usually a global variable.
In this case it would be:

```js
import Ember from 'ember';
/* global moment */
// No import for moment, it's a global called `moment`

// ...
var day = moment('Dec 25, 1995');
```

_Note: Don't forget to make JSHint happy by adding a `/* global MY_GLOBAL */` to your module, or
by defining it within the `predefs` section of your `.jshintrc` file._

##### Standard AMD Asset

Provide the asset path as the first argument, and the list of modules and exports as the second:

```Brocfile.js
app.import('bower_components/ic-ajax/dist/named-amd/main.js', {
  exports: {
    'ic-ajax': [
      'default',
      'defineFixture',
      'lookupFixture',
      'raw',
      'request',
    ]
  }
});
```

To use this asset in your app, import it.
For example, with `ic-ajax`, when to use `ic.ajax.raw`:

```js
import { raw as icAjaxRaw } from 'ic-ajax';
//...
icAjaxRaw( /* ... */ );
```

##### Environment Specific Assets

If you need to use different assets in different environments, specify an object as the first parameter. That object's key should be the environment name, and the value should be the asset to use in that environment.

```Brocfile.js
app.import({
  development: 'bower_components/ember/ember.js',
  production:  'bower_components/ember/ember.prod.js'
});
```

If you need to import an asset in one environment but not import it or any alternatives in other environments then you can wrap `app.import` in an `if` statement.

```Brocfile.js
if (app.env === 'development') {
  app.import('vendor/ember-renderspeed/ember-renderspeed.js');
}
```

##### Customizing a built-in Asset

This is somewhat non-standard and discouraged, but suppose that due to a requirement in your application that you need to use the full version of
Handlebars even in the production environment.  You would simply provide the path to the `EmberApp` constructor:

```Brocfile.js
var app = new EmberApp({
  vendorFiles: {
    'handlebars.js': {
      production: 'bower_components/handlebars/handlebars.js'
    }
  }
});
```

Alternatively, if you want to exclude the built-in asset from being
automatically included in `vendor.js`, you can set its value to `false`:

```Brocfile.js
var app = new EmberApp({
  vendorFiles: {
    'handlebars.js': false
  }
});

```

_Note: The built-in assets are required dependencies needed by the environment
to run your app. If you use the above method to specifically exclude
some, you should still be including them in some other way._

##### Test Assets

You may have additional libraries that should only be included when running tests (such as qunit-bdd or sinon). These can be imported into your app in your Brocfile.js:

```Brocfile.js
var EmberApp = require('ember-cli/lib/broccoli/ember-app'),
    isProduction = EmberApp.env() === 'production';

var app = new EmberApp();

if ( !isProduction ) {
    app.import( app.bowerDirectory + '/sinonjs/sinon.js', { type: 'test' } );
    app.import( app.bowerDirectory + '/sinon-qunit/lib/sinon-qunit.js', { type: 'test' } );
}

module.exports = app.toTree();
```

**Notes:**
- Be sure to pass `{ type: 'test' }` as the second argument to `app.import`.  This will ensure that your libraries are compiled into the `test-support.js` file.

#### Styles

##### Static CSS

Provide the asset path as the first argument:

```Brocfile.js
app.import('bower_components/foundation/css/foundation.css');
```

All style assets added this way will be concatenated and output as `/assets/vendor.css`.

##### Dynamic Styles (SCSS, LESS, etc)

The vendor trees that are provided upon instantiation are available to your dynamic style files.  Take the following example (in `app/styles/app.scss`):

```scss
@import "bower_components/foundation/scss/normalize.scss";
```

#### Other Assets

##### Using app.import()

All other assets like images or fonts can also be added via `import()`. By default, they
will be copied to `dist/` as they are.

```Brocfile.js
app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf');
```

This example would create the font file in `dist/font-awesome/fonts/fontawesome-webfont.ttf`.

You can also optionally tell `import()` to place the file at a different path.
The following example will copy the file to `dist/assets/fontawesome-webfont.ttf`.

```Brocfile.js
app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf', {
  destDir: 'assets'
});
```

If you need to load certain dependencies before others, you can set the `prepend` property equal to `true` on the second argument of `import()`. This will prepend the dependency to the vendor file instead of appending it, which is the default behavior.

```Brocfile.js
app.import('bower_components/es5-shim/es5-shim.js', {
  type: 'vendor',
  prepend: true
});
```

##### Using broccoli-funnel

With the [broccoli-funnel](https://github.com/broccolijs/broccoli-funnel) package,
(parts of) a bower-installed package can be used as assets as-is. First ensure that the Broccoli
package needed to build is installed:

```bash
npm install broccoli-funnel --save-dev
```

Add this import to the top of `Brocfile.js`, just below the `EmberApp` require:

```Brocfile.js
var Funnel = require('broccoli-funnel');
```

At the bottom of `Brocfile.js` we merge assets from a bower dependency with the main app tree:

```Brocfile.js
// Remove this line:
// module.exports = app.toTree()

// Copy only the relevant files. For example the WOFF-files and stylesheets for a webfont:
var extraAssets = new Funnel('bower_components/a-lovely-webfont', {
   srcDir: '/',
   include: ['**/*.woff', '**/stylesheet.css'],
   destDir: '/assets/fonts'
});

// Providing additional trees to the `toTree` method will result in those
// trees being merged in the final output.
module.exports = app.toTree(extraAssets);
```

In the above example the assets from the fictive bower dependency called `a-lovely-webfont` can now
be found under `/assets/fonts/`, and might be linked to from `index.html` like so:

```index.html
<link rel="stylesheet" href="assets/fonts/lovelyfont_bold/stylesheet.css">
```

You can exclude assets from the final output in a similar fashion. For example, to exclude all `.gitkeep` files from the final output:

```Brocfile.js
// Again, add this import to the top of `Brocfile.js`, just below the `EmberApp` require:
var Funnel = require('broccoli-funnel');

// Normal Brocfile contents

// Filter toTree()'s output
var filteredAssets = new Funnel(app.toTree(), {
  // Exclude gitkeeps from output
  exclude: ['**/.gitkeep']
});

// Export filtered tree
module.exports = filteredAssets;
```

_Note: [broccoli-static-compiler](https://github.com/joliss/broccoli-static-compiler) is deprecated. Use [broccoli-funnel](https://github.com/broccolijs/broccoli-funnel) instead._
