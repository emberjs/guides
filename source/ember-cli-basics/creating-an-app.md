To create a new Ember app, run:

```bash
ember new my-app
```

This will create a new `my-app` folder and generate a bunch of files and
folders. Here's an explanation of each one:

<table>
  <thead>
    <tr>
      <th>File/folder</th>
      <th>Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>app/</code></td>
      <td>Your Ember application’s code.</td>
    </tr>
    <tr>
      <td><code>bower_components/</code></td>
      <td>Your Bower dependencies.</td>
    </tr>
    <tr>
      <td><code>config/</code></td>
      <td>Your app's configuration.</td>
    </tr>
    <tr>
    <tr>
      <td><code>node_module/</code></td>
      <td>Your npm dependencies.</td>
    </tr>
    <tr>
      <td><code>public/</code></td>
      <td>This folder will be copied verbatim into the root of your built
          application. Use this for assets that don’t have a build step, such as
          images or fonts.</td>
    </tr>
    <tr>
      <td><code>tests/</code></td>
      <td>Unit and acceptance tests for your app, as well as various helpers to
          load and run your tests.</td>
    </tr>
    <tr>
      <td><code>tmp/</code></td>
      <td>Various temporary output of build steps, as well as the debug output
          of your application (<code>tmp/public</code>).</td>
    </tr>
    <tr>
      <td><code>vendor/</code></td>
      <td>Your external dependencies not installed with <code>Bower</code> or
          <code>npm</code>.</td>
    </tr>
    <tr>
      <td><code>.bowerrc</code></td>
      <td>Bower configuration.</td>
    </tr>
    <tr>
      <td><code>.editorconfig</code></td>
      <td>Configuration for editors and IDEs.</td>
    </tr>
    <tr>
      <td><code>.ember-cli</code></td>
      <td>Ember CLI configuration.</td>
    </tr>
    <tr>
      <td><code>.gitignore</code></td>
      <td>Configures Git to ignore files and folders that shouldn't be tracked
          by version control.</td>
    </tr>
    <tr>
      <td><code>.jshintrc</code></td>
      <td><a href="http://jshint.com/">JSHint</a> configuration.</td>
    </tr>
    <tr>
      <td><code>.travis.yml</code></td>
      <td><a href="https://travis-ci.org">Travis CI</a> configuration.</td>
    </tr>
    <tr>
      <td><code>Brocfile.js</code></td>
      <td>Build specification for
          <a href="https://github.com/joliss/broccoli">Broccoli</a>, which
          Ember CLI uses to build your app.</td>
    </tr>
    <tr>
      <td><code>README.md</code></td>
      <td>A skeleton README file for you to flesh out.</td>
    </tr>
    <tr>
      <td><code>bower.json</code></td>
      <td>Bower configuration and dependency list.</td>
    </tr>
    <tr>
      <td><code>package.json</code></td>
      <td>npm configuration. Mainly used to list the dependencies needed for
          asset compilation.</td>
    </tr>
    <tr>
      <td><code>testem.json</code></td>
      <td>Congiuration for Testem, the test runner Ember CLI uses.</td>
    </tr>
  </tbody>
</table>

Most of the subfolders within the `app/` folder are self-explanatory, but it's
worth pointing out that your CSS goes in the `app/styles/` folder.

Also in the `app/` folder is the `app.js` file. Every Ember.js application has
one instance of `Ember.Application`, which is initialized in this file.

And finally, the `app/` folder contains `index.html`. This is where the basic
DOM structure is laid out, the title attribute is set, your compiled stylesheets
are loaded, and, of coures, your Ember app and its dependencies are loaded.
