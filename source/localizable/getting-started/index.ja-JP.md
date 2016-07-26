Emberでの開発を始めるの難しくはありません。Ember プロジェクトの作成や管理はコマンド ライン ビルド ツール Ember CLI を利用します。 Ember CLI は次の機能をを提供しています。

* モダンなアプリケーション資産管理 (今カテネーション、ミニフィケーション、およびバージョン管理をが含まれています。)
* コンポーネントや、ルートなどの作成するためジェネレーター。
* コンベンショナルなプロジェクトのレイアウトは、既存のEmberアプリケーションへのアプローチを簡単にします。
* [Babel プロジェクト](http://babeljs.io/docs/learn-es2015/)経由で、JavaScript ES2015/ES6 をサポートします。 このガイドでも利用されている [JavaScript モジュール](http://exploringjs.com/es6/ch_modules.html) のサポートも含まれています。
* 完全な [QUnit](https://qunitjs.com/) テスト ハーネス
* 勢いよく成長しているEmber生態系を活用する[Ember Addons](https://emberobserver.com/).

## 依存関係

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

* Windows または Mac のユーザーの場合は [この Node.js インストーラー](http://nodejs.org/download/) を実行することができます。.
* Mac ユーザーは[ Homebrew ](http://brew.sh/) を使用してノードをインストールするのを好むことがあります。Homebrewをインストールした後、Node.js をインストールするには `brew install node` を実行します。
* Linux ユーザの場合はは、この[ガイド](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) を使用できます。.

If you get an outdated version of npm, run `npm install -g npm`.

### Bower

Ember requires Bower to manage additional dependencies. Bower is a command line utility that you install with npm. To install Bower run, ```npm install -g bower```

### Watchman (optional)

On Mac and Linux, you can improve file watching performance by installing [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (optional)

You can run your tests from the command line with PhantomJS, without the need for a browser to be open. Consult the [PhantomJS download instructions](http://phantomjs.org/download.html).

## インストール

Install Ember using npm:

```bash
npm install -g ember-cli
```

To verify that your installation was successful, run:

```bash
ember -v
```

If a version number is shown, you're ready to go.