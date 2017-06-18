Emberでの開発を始めるの難しくはありません。Emberプロジェクトの作成や管理はコマンドライン ビルドツールEmber CLIを利用します。 Ember CLIは、次の機能を提供しています。

* モダンなアプリケーションアセット管理 (結合、ミニフィケーション、バージョン管理など)。
* コンポーネントやルートなどを作成するためのジェネレーター。
* 慣習的なプロジェクトレイアウトは、既存のEmberアプリケーションへの対処を容易にします。
* [Babel](http://babeljs.io/docs/learn-es2015/)プロジェクトをとおしてJavaScript ES2015/ES6 をサポートします。 これには、このガイドでも利用されている[JavaScript モジュール](http://exploringjs.com/es6/ch_modules.html)のサポートも含まれています。
* 完全な [QUnit](https://qunitjs.com/) テストハーネス。
* 急成長する[Ember Addons](https://emberobserver.com/)エコシステムを活用する機能。.

## 依存関係

### Git

Emberは依存関係の多くを管理するのにGitを利用しています。 GitはMac OS Xおよび多くのLinuxディストリビューションにすでに含まれています。 Windows ユーザーは、[この Git のインストーラー](http://git-scm.com/download/win)をダウンロード、実行できます。.

### Node.js とnpm

Ember CLI is built with JavaScript, and requires the most recent LTS version of the [Node.js](https://nodejs.org/) runtime. また、[npm](https://www.npmjs.com/)を通して依存関係のあるライブラリを取得する必要があります。 npmはNode.jsとともにインストールされます。ですので、Node.jsがすでにインストール済みでしたら、あなたは先に進む準備ができています。

If you're not sure whether you have Node.js or the right version, run this on your command line:

```bash
node --version
npm --version
```

もし、*"command not found"*エラーだった場合、またはNodeのバージョンが古かった場合には、次を行ってください。

* WindowsあるいはMacのユーザーは[この Node.js インストーラー](https://nodejs.org/ja/download/)を実行できます。.
* あなたがMacユーザーで、もしNodeのインストールに[Homebrew](http://brew.sh/)を使うのを好むようでしたら、Homebrewをインストールした後で`brew install node`を実行し、Node.jsをインストールしてください。
* Linuxユーザーは[このLinuxへのNode.jsインストールガイド](https://nodejs.org/en/download/package-manager/)を参照できます。.

もしnpmが古い場合には、`npm install -g npm`を実行してください。.

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