Es sencillo empezar con Ember. Un proyecto de Ember se crea y se mantiene gracias a un comando de consola llamado Ember CLI. Este herramienta proporciona:

* Una moderna gestión de recursos (incluye concatenación, mistificación y control de versiones).
* Generadores para crear componentes, rutas y otros elementos.
* Una estructura de proyecto genérica, lo cual facilita la comprensión de las aplicaciones ya existentes de Ember.
* Soporte para JavaScript ES2015/ES6 gracias al proyecto [Babel](http://babeljs.io/docs/learn-es2015/). Se incluye soporte para los [módulos de JavaScript](http://exploringjs.com/es6/ch_modules.html), que se utilizarán a lo largo de esta guía.
* Soporte integrado de testing con [QUnit](https://qunitjs.com/).
* La habilidad de consumir de un ecosistema de [Ember Addons](https://emberobserver.com/) en crecimiento.

## Dependencias

### Git

Ember requires Git to manage many of its dependencies. Git comes with Mac OS X and most Linux distributions. Windows users can download and run [this Git installer](http://git-scm.com/download/win).

### Node.js and npm

Ember CLI is built with JavaScript, and expects the [Node.js](https://nodejs.org/) runtime. It also requires dependencies fetched via [npm](https://www.npmjs.com/). npm is packaged with Node.js, so if your computer has Node.js installed you are ready to go.

Ember requires Node.js 0.12 or higher and npm 2.7 or higher. If you're not sure whether you have Node.js or the right version, run this on your command line:

```bash
node --version
npm --version
```

If you get a *"command not found"* error or an outdated version for Node:

* Los usuarios de Windows o Mac pueden descargar y ejecutar [este instalador de Node.js](http://nodejs.org/download/).
* Los usuarios de Mac a veces prefieren instalar Node mediante [Homebrew](http://brew.sh/). Después de instalar Homebrew, hay que ejecutar `brew install node` para instalar Node.js.
* Linux users can use [this guide for Node.js installation on Linux](https://nodejs.org/en/download/package-manager/).

If you get an outdated version of npm, run `npm install -g npm`.

### Bower

Ember requires Bower to manage additional dependencies. Bower is a command line utility that you install with npm. To install Bower run, ```npm install -g bower```

### Watchman (optional)

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (optional)

You can run your tests from the command line with PhantomJS, without the need for a browser to be open. Consult the [PhantomJS download instructions](http://phantomjs.org/download.html).

## Instalación

Install Ember using npm:

```bash
npm install -g ember-cli
```

To verify that your installation was successful, run:

```bash
ember -v
```

If a version number is shown, you're ready to go.