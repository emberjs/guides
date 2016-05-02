Es sencillo empezar con Ember. Un proyecto de Ember se crea y se mantiene gracias a un comando de consola llamado Ember CLI. Este herramienta proporciona:

* Gestión de recursos (incluyendo concatenación, minificado y versionado).
* Generadores para crear componentes, rutas y otros elementos.
* Una estructura de proyecto genérica, lo cual facilita la comprensión de las aplicaciones ya existentes de Ember.
* Soporte para JavaScript ES2015/ES6 gracias al proyecto [Babel](http://babeljs.io/docs/learn-es2015/). Se incluye soporte para los [módulos de JavaScript](http://exploringjs.com/es6/ch_modules.html), que se utilizarán a lo largo de esta guía.
* Soporte integrado de testing con [QUnit](https://qunitjs.com/).
* Poder disponer de funcionalidad extra gracias al creciente ecosistema de addons de Ember.

## Dependencias

### Node.js y npm

Ember CLI es una utilidad programada en JavaScript, y necesita la plataforma [Node.js](https://nodejs.org/) para ser ejecutada. También necesita [npm](https://www.npmjs.com/) para obtener sus dependencias. npm viene empaquetado junto con Node.js, así que si ya tienes instalado este último en tu ordenador, no es necesario hacer nada más para poder usarlo.

Ember necesita Node.js 0.12 o superior y npm 2.7 o superior. Si no estás seguro de tener las versiones correctas, ejecuta esto en la línea de comandos:

```bash
node --version
npm --version
```

Si obtienes un error similar a *"comando no encontrado"* o tu versión de Node es demasiado antigua:

* Los usuarios de Windows o Mac pueden descargar y ejecutar [este instalador de Node.js](http://nodejs.org/download/).
* Los usuarios de Mac a veces prefieren instalar Node mediante [Homebrew](http://brew.sh/). Después de instalar Homebrew, hay que ejecutar `brew install node` para instalar Node.js.
* Los usuarios de Linux pueden utilizar [esta guía para instalar Node.js en Linux](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

Si tienes una versión antigua únicamente de npm, sólo necesitas ejecutar `npm install -g npm`.

### Git

Ember requiere Git para obtener la mayoría de sus dependencias. Git viene por defecto con Mac OS X y la mayoría de las distribuciones de Linux. Los usuarios de Windows pueden descargar y ejecutar [este instalador de Git](http://git-scm.com/download/win).

### Watchman (opcional)

En Mac y Linux, se puede mejorar el rendimiento del proceso que observa los cambios en los ficheros instalando [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (opcional)

Se pueden ejecutar los tests desde la línea de comandos con PhantomJS, sin necesidad de tener un navegador abierto. Consulta las [instrucciones para descargar PhantomJS](http://phantomjs.org/download.html).

## Instalación

Instalación de Ember con npm:

```bash
npm install -g ember-cli
```

Para verificar que todo funciona como debe tras la instalación:

```bash
ember -v
```

Si aparece un número de versión, Ember está correctamente instalado y preparado.