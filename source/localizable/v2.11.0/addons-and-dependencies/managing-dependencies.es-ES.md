Mientras estás desarrollando tu aplicación de Ember, probablemente te encontrarás con estos escenarios que no son abordados por Ember, como autenticación o utilizar SASS para las hojas de estilo. Ember CLI proporciona un formato común llamado [Ember Addons](#toc_addons) para la distribución de librerías reutilizables para resolver estos problemas. Además, puede que desee hacer uso de las dependencias front-end como un framework CSS o un selector de fechas hecho en JavaScript que no son hechos especificamente para aplicaciones de Ember. Ember CLI soporta la instalación de estos paquetes a través del [gestor de paquetes de Bower](#toc_bower) estándar.

## Addons

Los Addons de Ember pueden ser instalados utilizando la [Línea de Comandos de Ember](http://ember-cli.com/extending/#developing-addons-and-blueprints) (p.ej. `ember install ember-cli-sass`). Los Addons pueden tener otras dependencias modificando automáticamente el archivo `bower.json` del proyecto.

Puedes encontrar un listado de addons en [Ember Observer](http://emberobserver.com).

## Bower

Ember CLI utiliza el gestor de paquetes [Bower](http://bower.io), haciendo fácil de mantener al día tus dependencias de front-end. El archivo de configuración de Bower, `bower.json`, se encuentra en la raíz de tu proyecto de Ember CLI y lista las dependencias para su proyecto. Ejecutar `bower install` instalará todas las dependencias enumeradas en el archivo `bower.json` en un solo paso.

Ember CLI observa el archivo `bower.json` para ver si ha cambiado. Así recargará tu aplicación si instalas nuevas dependencias vía `bower install <dependencies> --save`.

## Otros assets

El JavaScript de terceros no disponible como addon o paquete de Bower debería ser colocado en el directorio `vendor` dentro de tu proyecto.

Your own assets (such as `robots.txt`, `favicon`, custom fonts, etc) should be placed in the `public/` folder in your project.

## Compilando insumos

When you're using dependencies that are not included in an addon, you will have to instruct Ember CLI to include your assets in the build. This is done using the asset manifest file `ember-cli-build.js`. You should only try to import assets located in the `bower_components` and `vendor` folders.

### Globals provided by JavaScript assets

The globals provided by some assets (like `moment` in the below example) can be used in your application without the need to `import` them. Provide the asset path as the first and only argument.

```ember-cli-build.js app.import('bower_components/moment/moment.js');

    <br />You will need to add `"moment"` to the `predef` section in `.jshintrc` to prevent JSHint errors
    about using an undefined variable.
    
    ### AMD JavaScript modules
    
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

### Environment-Specific Assets

If you need to use different assets in different environments, specify an object as the first parameter. That object's key should be the environment name, and the value should be the asset to use in that environment.

```ember-cli-build.js app.import({ development: 'bower_components/ember/ember.js', production: 'bower_components/ember/ember.prod.js' });

    <br />If you need to import an asset in only one environment you can wrap `app.import` in an `if` statement.
    For assets needed during testing, you should also use the `{type: 'test'}` option to make sure they
    are available in test mode.
    
    ```ember-cli-build.js
    if (app.env === 'development') {
      // Solo importar en modo de desarrollo
      app.import('vendor/ember-renderspeed/ember-renderspeed.js');
    }
    if (app.env === 'test') {
      // Only import in modo de test y poner en test-support.js
      app.import(app.bowerDirectory + '/sinonjs/sinon.js', { type: 'test' });
      app.import(app.bowerDirectory + '/sinon-qunit/lib/sinon-qunit.js', { type: 'test' });
    }
    

### CSS

Provide the asset path as the first argument:

```ember-cli-build.js app.import('bower_components/foundation/css/foundation.css');

    <br />All style assets added this way will be concatenated and output as `/assets/vendor.css`.
    
    ### Other Assets
    
    All assets located in the `public/` folder will be copied as is to the final output directory, `dist/`.
    
    For example, a `favicon` located at `public/images/favicon.ico` will be copied to `dist/images/favicon.ico`.
    
    All third-party assets, included either manually in `vendor/` or via a package manager like Bower, must be added via `import()`.
    
    Third-party assets that are not added via `import()` will not be present in the final build.
    
    By default, `import`ed assets will be copied to `dist/` as they are, with the existing directory structure maintained.
    
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