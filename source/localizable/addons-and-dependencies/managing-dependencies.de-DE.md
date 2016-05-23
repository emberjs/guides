Beim Entwickeln deiner Ember-Anwendung wirst du wahrscheinlich in manchen Situationen Funktionalität benötigen, die Ember nicht standardmäßig mitbringt. Dabei kann es sich um Authentifizierung handeln oder darum, SASS für deine Stylesheets zu verwenden. Mit den sogenannten [Ember Addons](#toc_addons) stellt Ember CLI ein einheitliches Format zur Verfügung, um wiederverwendbare Bibliotheken zu erstellen und verteilen, die solche Aufgaben lösen. Außerdem möchtest du vielleicht Frontend-Abhängigkeiten wie ein CSS-Framework oder einen JavaScript-Datepicker einsetzen, die nicht spezifisch mit Ember-Anwendungen zusammenhängen. Ember CLI unterstützt das Installieren solcher Pakete mit dem Standard-[Bower-Pakemetmanager](#toc_bower).

## Addons

Ember Addons can be installed using [Ember CLI](http://ember-cli.com/extending/#developing-addons-and-blueprints) (e.g. `ember install ember-cli-sass`). Addons können auch weitere Abhängigkeiten einbringen und dadurch die `bower.json`-Datei in deinem Projekt automatisch anpassen.

Eine Übersicht von Addons kannst du auf [Ember Observer](http://emberobserver.com) vorfinden.

## Bower

Ember CLI benutzt den Paketmanager [Bower](http://bower.io), mit dem du deine Frontend-Abhängigkeiten auf einfache Art aktuell halten kannst. Die Bower-Konfigurationsdatei, `bower.json`, befindet sich im Wurzelverzeichnis deines Ember-CLI-Projektes und erfasst die Abhängigkeiten deines Projekts. Durch Ausführen von `bower install` kannst du alle Abhängigkeiten, die in `bower.json` aufgeführt sind, auf einmal installieren.

Ember CLI überwacht `bower.json` auf Änderungen, d.h. es wird deine Anwendung neuladen, wenn du neue Abhängigkeiten mit `bower install <abhaengigkeiten> --save` installierst.

## Andere Ressourcen

Ressourcen, die nicht als Addon oder Bower-Paket verfügbar sind, solltest du im `vendor`-Verzeichnis deines Projekts ablegen.

## Ressourcen kompilieren

Wenn du Abhängigkeiten benutzt, die nicht in einem Addon verteilt werden, musst du Ember CLI anweisen, die benötigten Ressourcen in den Build-Prozess einzubinden. Das geschieht über die Datei `ember-cli-build.js`. Du solltest nach Möglichkeit nur Ressourcen importieren, die sich in einem der Verzeichnisse `bower_components` und `vendor` befinden.

### Globale Variablen

Manche externen Bibliotheken stellen globale Variablen zur Verfügung (wie `moment` im folgenden Beispiel). Es ist nicht nötig, diese globalen Variablen in den einzelnen Quelldateien zu importieren (mit `import`). Um sie in deiner Anwendung zu benutzen, musst du sie allerdings einmalig beim Build-Prozess einbinden. Im folgenden Beispiel sollte der Pfad zur Bibliothek das erste und einzige Argument sein.

```ember-cli-build.js app.import('bower_components/moment/moment.js');

    <br />Es ist nötig, `"moment": true` zum `predef`-Abschnitt der `.jshintrc` hinzuzufügen, um Fehlermeldungen zu unterdrücken, dass eine undefinierte Variable benutzt werde.
    
    ### AMD-Javascript-Module
    
    Hier ist es nötig, den Pfad zur Ressource als das erste Argument und die Liste der Module und exports als das zweite Argument mitzugeben.
    
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
    

Diese können nun in deinen Anwendungsdateien mit `import` importiert werden. (z.B. `import { raw as icAjaxRaw } from 'ic-ajax';`)

### Umgebungsabhängige Ressourcen

Falls du in verschiedenen Umgebungen unterschiedliche Ressourcen benutzen musst, kannst du ein Objekt als ersten Parameter spezifizieren. Die Keys dieses Objekts sind die Umgebungsnamen und die Werte sind die Ressourcen, die in den jeweiligen Umgebungen benutzt werden sollen.

```ember-cli-build.js app.import({ development: 'bower_components/ember/ember.js', production: 'bower_components/ember/ember.prod.js' });

    <br />Falls du eine Ressource nur in einer Umgebung benötigst, kannst du `app.import` in ein `if`-Statement einschließen.
    Für Ressourcen, die für Tests benötigt werden, solltest du auch die `{type: 'test'}`-Option benutzen, um sicherzustellen, dass sie auch im Test-Modus verfügbar sind.
    
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

Der Pfad zur Ressource sollte das erste Argument sein:

```ember-cli-build.js app.import('bower_components/foundation/css/foundation.css');

    <br />Alle Stylesheet-Ressourcen, die so hinzugefügt werden, werden zusammengefügt und in die `/assets/vendor.css` geschrieben.
    
    ### Andere Ressourcen
    
    Alle anderen Ressourcen wie Bilder oder Schriftarten können auch mit `import()` hinzugefügt werden.
    Standardmäßig werden sie unverändert nach `dist/` kopiert.
    
    ```ember-cli-build.js
    app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf');
    

Dieses Beispiel erzeugt die Schriftart-Datei in `dist/font-awesome/fonts/fontawesome-webfont.ttf`.

Du kannst optional `import()` auch mitteilen, die Datei unter einem anderen Pfad zu plazieren. Das folgende Beispiel kopiert die Datei nach `dist/assets/fontawesome-webfont.ttf`.

```ember-cli-build.js app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf', { destDir: 'assets' });

    <br />Falls du manche Abhängigkeiten vor anderen laden musst, kannst du im zweiten Argument von `import()` die `prepend`-Eigenschaft auf `true` setzen.
    Dadurch wird die Abhängigkeit in der vendor-Datei am Anfang eingefügt anstatt am Ende, wie es das Standard-Verhalten wäre.
    
    ```ember-cli-build.js
    app.import('bower_components/es5-shim/es5-shim.js', {
      type: 'vendor',
      prepend: true
    });