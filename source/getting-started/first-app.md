### Generating a new Ember app

Now that you have Ember CLI installed, you can create your first Ember app by
running:

```shell
ember new my-new-app
```

This will create a new `my-new-app` directory with your new Ember app inside.


### Launching the development server

Once the process finishes, launch the Ember development server:

```shell
cd my-new-app
ember server
```

Navigate to `http://localhost:4200` using your web browser to see your app in action.

The Ember CLI development server
provides features like rebuilding your app every time a file changes, and a
mock server for setting up fake data when testing your app.


### Modifying the Application template
Using your text editor or IDE, modify `app/templates/application.hbs` from

```app/templates/application.hbs
Welcome to Ember.js!

{{ outlet }}
```

to

```app/templates/application.hbs
Welcome {{ myName }} to Ember.js!

{{ outlet }}
```


### Creating the Application controller

The handlebars expression `{{ myName }}` found above contains a property called `myName`. Ember.js will look for it on the application controller.

So let's provide an application controller by creating the following:

```app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  myName: 'Juan'
});
```

Everytime you save your files, ember-cli will automatically reload the server. This will save you the necessity to refresh your browser.


#### Production Build
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
