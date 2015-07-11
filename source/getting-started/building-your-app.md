Now you're familiar with the [core concepts](core-concepts) and the [naming conventions](naming-conventions), it's time to get started on your app. Assuming you have `ember` [installed](..), it's as easy as running:

```bash
ember new <app-name>
```

This will generate the complete filetree for your app and install the required dependencies. Once this process is complete, you can `cd` into your directory to start working on your app. **Ember CLI is extremely powerfull and completely documented on [ember-cli.com](http://ember-cli.com)**. We'll cover the most important cases here.

### Running the development server

While you're working on your app, you can run a built in development server which will serve your application and automatically reload it if any of the files change:

```bash
ember serve
```

### Running tests

Ember comes bundled with QUnit support but you can basically use any testing framework you'd like.

```bash
ember test
```

### Building a deployable version

In development mode, Ember serves unmified files and usually serves the development versions of libraries (if available). Once your app is ready for deploy, you can build a minified production version:

```bash
ember build --enviroment=production
```