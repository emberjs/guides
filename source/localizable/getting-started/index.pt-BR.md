Começar com Ember é fácil. Projetos em Ember são criados e gerenciados pelo Ember CLI, nossa ferramenta de linha de comando. Com essa ferramenta você tem:

* Modern application asset management (including concatenation, minification, and versioning).
* Geradores para ajudar a criar componentes, rotas e muito mais.
* Uma estrutura de projeto padrão, tornando mais fácil entender aplicações Ember existentes.
* Suporte a Javascript ES2015/ES6 através do projeto [Babel](http://babeljs.io/docs/learn-es2015/). Isso inclui suporte para [módulos de JavaScript](http://exploringjs.com/es6/ch_modules.html), que são usados ao longo deste guia.
* Uma estrutura completa de testes [QUnit](https://qunitjs.com/).
* The ability to consume a growing ecosystem of [Ember Addons](https://emberobserver.com/).

## Dependências

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

* Usuários de Windows ou Mac podem baixar e executar [o instalador de Node. js](http://nodejs.org/download/).
* Usuários de Mac podem instalar Node usando [Homebrew](http://brew.sh/). Depois de instalar o Homebrew, execute `brew install node` para instalar o Node.js.
* Linux users can use [this guide for Node.js installation on Linux](https://nodejs.org/en/download/package-manager/).

If you get an outdated version of npm, run `npm install -g npm`.

### Bower

Ember requires Bower to manage additional dependencies. Bower is a command line utility that you install with npm. To install Bower run, ```npm install -g bower```

### Watchman (optional)

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (optional)

You can run your tests from the command line with PhantomJS, without the need for a browser to be open. Consult the [PhantomJS download instructions](http://phantomjs.org/download.html).

## Instalação

Install Ember using npm:

```bash
npm install -g ember-cli
```

To verify that your installation was successful, run:

```bash
ember -v
```

If a version number is shown, you're ready to go.