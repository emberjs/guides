Como você está desenvolvendo seu app de Ember, você provavelmente vai encontrar cenários comuns que não são abordados pelo Ember em si, como autenticação ou usar SASS para suas folhas de estilo. Ember CLI fornece um formato comum chamado [Ember Addons](#toc_addons) para a distribuição de bibliotecas reutilizáveis para resolver estes problemas. Additionally, you may want to make use of front-end dependencies like a CSS framework or a JavaScript datepicker that aren't specific to Ember apps. Ember CLI supports installing these packages through the standard [Bower package manager](#toc_bower).

## Addons

Ember Addons podem ser instalando usando [Ember CLI](http://ember-cli.com/extending/#developing-addons-and-blueprints) (por exemplo, `ember install ember-cli-sass`). Addons podem trazer outras dependências mudando automaticamente o arquivo `bower.json` de seu projeto.

Você pode encontrar uma lista de addons no [Ember Observer](http://emberobserver.com).

## Bower

Ember CLI uses the [Bower](http://bower.io) package manager, making it easy to keep your front-end dependencies up to date. The Bower configuration file, `bower.json`, is located at the root of your Ember CLI project, and lists the dependencies for your project. Executing `bower install` will install all of the dependencies listed in `bower.json` in one step.

Ember CLI watches `bower.json` for changes. Thus it reloads your app if you install new dependencies via `bower install <dependencies> --save`.

## Outros assets

JavaScript de terceiros não disponíveis como addon ou via Bower devem ser colocados na pasta `vendor/` do seu projeto.

Seus próprios assets (como `robots.txt`, `favicon`, arquivos fonts específicos, etc) devem ser colocados na pasta `public/` do seu projeto.

## Compilando Assets

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
    

Agora você pode importá-los para seu aplicativo. (por exemplo, `import { raw as icAjaxRaw } from 'ic-ajax';`)

### Environment-Specific Assets

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