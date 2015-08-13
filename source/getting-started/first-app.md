Now that you have Ember CLI installed, you can create your first Ember app by
running:

```shell
ember new my-new-app
```

This will create a new `my-new-app` directory with your new Ember app inside.

Once the generation process finishes, launch the Ember CLI development server:

```shell
cd my-new-app
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
