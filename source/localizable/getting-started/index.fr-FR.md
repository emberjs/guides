L'apprentissage d'Ember est d'une facilitée déconcertante. Les projets Ember sont créés et gérés grâce à notre outil de construction d'application en ligne de commande Ember CLI. Cet outil fournit :

* Les avantages de gestion des applications modernes (incluant la concaténation, la simplification de code et la gestion de version).
* Des générateurs automatique afin d'aider la création de composants, routes et autres.
* Un canevas de projet standardisé, rendant les applications Ember existante plus facile à aborder.
* Un support pour javascript ES2015/ES6 via le projet [Babel](http://babeljs.io/docs/learn-es2015/). Ce qui inclut [les modules Javascript](http://exploringjs.com/es6/ch_modules.html), qui sont utilisés tout au long de ce guide d'apprentissage.
* Une exploitation totale des tests unitaires [QUnit](https://qunitjs.com/).
* La possibilité d'utiliser l'écosystème grandissant des [Addons d'Ember](https://emberobserver.com/).

## Dépendances

### Git

Ember nécessite Git pour gérer un bon nombre de ses dépendances. Git est fourni de série avec les systèmes Mac OS X et la plupart des distributions Linux. Les utilisateurs de Windows peuvent télécharger et lancer [ce programme d'installation de Git](http://git-scm.com/download/win).

### Nodes.js et npm

Ember CLI is built with JavaScript, and requires the most recent LTS version of the [Node.js](https://nodejs.org/) runtime. It also requires dependencies fetched via [npm](https://www.npmjs.com/). npm is packaged with Node.js, so if your computer has Node.js installed you are ready to go.

If you're not sure whether you have Node.js or the right version, run this on your command line:

```bash
node --version
npm --version
```

If you get a *"command not found"* error or an outdated version for Node:

* Windows or Mac users can download and run [this Node.js installer](http://nodejs.org/en/download/).
* Mac users often prefer to install Node using [Homebrew](http://brew.sh/). After installing Homebrew, run `brew install node` to install Node.js.
* Linux users can use [this guide for Node.js installation on Linux](https://nodejs.org/en/download/package-manager/).

If you get an outdated version of npm, run `npm install -g npm`.

### Bower

Ember requires Bower to manage additional dependencies. Bower is a command line utility that you install with npm. To install Bower run, ```npm install -g bower```

### Watchman (optionnel)

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (optional)

You can run your tests from the command line with PhantomJS, without the need for a browser to be open. Consult the [PhantomJS download instructions](http://phantomjs.org/download.html).

## Installation

Installez Ember en utilisant npm :

```bash
npm install -g ember-cli
```

Pour vérifier que l'installation fonctionne, exécuter :

```bash
ember -v
```

Si un numéro de version s'affiche, Ember est bien installé.