Now that you have Ember CLI installed, you can create your first Ember app by
running:

```shell
ember new my-new-app
```

Which will generate a new `my-new-app` directory with your new Ember app inside. Change into it using:

```shell
cd my-new-app
```

Currently, [Ember CLI still installs Ember v1.13](https://github.com/ember-cli/ember-cli/issues/4671), this will change in the future. In the meantime to install Ember v2.0, you can use Bower to grab the latest version (if asked which version you want, press the number for ember 2), do this by:

```shell
bower install ember
```

To start with your development, launch the Ember CLI development server using:

```shell
ember server
```

Navigate to `http://localhost:4200` to see your new app in action.

The Ember CLI development server is great for developing your app, because it
provides features like rebuilding your app every time a file changes, and a
mock server for setting up fake data for testing your app. In a production
environment, though, features like these slow your app down; instead, you'll
want to build a fast, optimized version of your app you can copy to your
production server.

To build your app for production, run:

```shell
ember build --environment=production
```

When this finishes running, the `dist/` directory will contain a version of your
application suitable for use in production. You can then copy the contents of
this folder to your production server.
