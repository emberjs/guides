Beim Entwickeln deiner Ember-Anwendung wirst du wahrscheinlich in manchen Situationen Funktionalität benötigen, die Ember nicht standardmäßig mitbringt. Dabei kann es sich um Authentifizierung handeln oder darum, SASS für deine Stylesheets zu verwenden. Mit den sogenannten [Ember Addons](#toc_addons) stellt Ember CLI ein einheitliches Format zur Verfügung, um wiederverwendbare Bibliotheken zu erstellen und verteilen, die solche Aufgaben lösen. Außerdem möchtest du vielleicht Frontend-Abhängigkeiten wie ein CSS-Framework oder einen JavaScript-Datepicker einsetzen, die nicht spezifisch mit Ember-Anwendungen zusammenhängen. Ember CLI unterstützt das Installieren solcher Pakete mit dem Standard-[Bower-Pakemetmanager](#toc_bower).

## Addons

Ember Addons werden mit NPM installiert (z.B. `npm install --save-dev ember-cli-sass`). Addons können auch weitere Abhängigkeiten einbringen und dadurch die `bower.json`-Datei in deinem Projekt automatisch anpassen.

Eine Übersicht von Addons kannst du auf [Ember Observer](http://emberobserver.com) vorfinden.

## Bower

Ember CLI benutzt den Paketmanager [Bower](http://bower.io), mit dem du deine Frontend-Abhängigkeiten auf einfache Art aktuell halten kannst. Die Bower-Konfigurationsdatei, `bower.json`, befindet sich im Wurzelverzeichnis deines Ember-CLI-Projektes und erfasst die Abhängigkeiten deines Projekts. Durch Ausführen von `bower install` kannst du alle Abhängigkeiten, die in `bower.json` aufgeführt sind, auf einmal installieren.

Ember CLI überwacht `bower.json` auf Änderungen, d.h. es wird deine Anwendung neuladen, wenn du neue Abhängigkeiten mit `bower install <abhaengigkeiten> --save` installierst.

## Andere Ressourcen

Ressourcen, die nicht als Addon oder Bower-Paket verfügbar sind, solltest du im `vendor`-Verzeichnis deines Projekts ablegen.

## Ressourcen kompilieren

Wenn du Abhängigkeiten benutzt, die nicht in einem Addon verteilt werden, musst du Ember CLI anweisen, die benötigten Ressourcen in den Build-Prozess einzubinden. Das geschieht über die Datei `ember-cli-build.js`. Du solltest nach Möglichkeit nur Ressourcen importieren, die sich in einem der Verzeichnisse `bower_components` und `vendor` befinden.

### Globals provided by Javascript assets

The globals provided by some assets (like `moment` in the below example) can be used in your application without the need to `import` them. Provide the asset path as the first and only argument.

```ember-cli-build.js app.import('bower_components/moment/moment.js');

    <br />You will need to add `"moment": true` to the `predef` section in `.jshintrc` to prevent JSHint errors
    about using an undefined variable.
    
    ### AMD Javascript modules
    
    Provide the asset path as the first argument, and the list of modules and exports as the second.
    
    ```ember-cli-build.js
    app.import('bower_components/ic-ajax/dist/named-amd/main.js', {
      exports: {
        'ic-ajax': [
          'default',
          'defineFixture',
          'lookupFixture',
          'raw',
          'request'
        ]
      }
    });
    

You can now `import` them in your app. (e.g. `import { raw as icAjaxRaw } from 'ic-ajax';`)

### Environment Specific Assets

If you need to use different assets in different environments, specify an object as the first parameter. That object's key should be the environment name, and the value should be the asset to use in that environment.

```ember-cli-build.js app.import({ development: 'bower_components/ember/ember.js', production: 'bower_components/ember/ember.prod.js' });

    <br />If you need to import an asset in only one environment you can wrap `app.import` in an `if` statement.
    For assets needed during testing, you should also use the `{type: 'test'}` option to make sure they
    are available in test mode.
    
    ```ember-cli-build.js
    if (app.env === 'development') {
      // Only import when in development mode
      app.import('vendor/ember-renderspeed/ember-renderspeed.js');
    }
    if (app.env === 'test') {
      // Only import in test mode and place in test-support.js
      app.import(app.bowerDirectory + '/sinonjs/sinon.js', { type: 'test' });
      app.import(app.bowerDirectory + '/sinon-qunit/lib/sinon-qunit.js', { type: 'test' });
    }
    

### CSS

Provide the asset path as the first argument:

```ember-cli-build.js app.import('bower_components/foundation/css/foundation.css');

    <br />All style assets added this way will be concatenated and output as `/assets/vendor.css`.
    
    ### Other Assets
    
    All other assets like images or fonts can also be added via `import()`.
    By default, they
    will be copied to `dist/` as they are.
    
    ```ember-cli-build.js
    app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf');
    

This example would create the font file in `dist/font-awesome/fonts/fontawesome-webfont.ttf`.

You can also optionally tell `import()` to place the file at a different path. The following example will copy the file to `dist/assets/fontawesome-webfont.ttf`.

```ember-cli-build.js app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf', { destDir: 'assets' });

    <br />If you need to load certain dependencies before others,
    you can set the `prepend` property equal to `true` on the second argument of `import()`.
    This will prepend the dependency to the vendor file instead of appending it, which is the default behavior.
    
    ```ember-cli-build.js
    app.import('bower_components/es5-shim/es5-shim.js', {
      type: 'vendor',
      prepend: true
    });