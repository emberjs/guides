To use your Ember app in your development environment, run:

```bash
ember server
```

Now, you can go to _http://localhost:4200_ to view your app.

In the background, the Broccoli asset pipeline compiles all of your JavaScript
code from `app/` into `/assets/your-app-name.js`. Additionally, it compiles
`app/styles/app.css` into `/assets/application-name.css`, and other CSS in
`app/styles` into files with the same name in `/assets`. Finally, it compiles
`app/index.html` into `/index.html`.

As part of the compilation process, Ember CLI uses the [ES6 module
transpiler](https://github.com/esnext/es6-module-transpiler) to turn the ES6
modules in your app into into [AMD (RequireJS-style)
modules](http://requirejs.org/) that are compatible with most browsers.

Ember CLI also includes live reloading in development, so when you change a
file, your app automatically refreshes the browser window.

To stop the Ember server, press _CTLR + C_.
