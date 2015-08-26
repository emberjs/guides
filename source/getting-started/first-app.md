Now that you have Ember CLI installed, you can create your first Ember app by
running:

```shell
ember new my-new-app
```

This will create a new `my-new-app` directory with your new Ember app inside.

Once the process finishes, launch the Ember development server:

```shell
cd my-new-app
ember server
```

Navigate to `http://localhost:4200` to see your app in action.

The Ember CLI development server
provides features like rebuilding your app every time a file changes, and a
mock server for setting up fake data when testing your app.

In a production environment, you'll
want to build an optimized version of your website assets that can be copied to a
server. To build your app for production, run:

```shell
ember build --environment=production
```

When this finishes the `dist/` directory will contain a version of your
application suitable for production use. Copy the contents of
this folder to your production server. Alternatively you can, explore the
[ember-cli-deploy](http://ember-cli.github.io/ember-cli-deploy/) addon for
more advanced functionality.
