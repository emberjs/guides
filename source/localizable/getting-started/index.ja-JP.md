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

Ember CLIはJavaScriptで作られていて、実行には[Node.js](https://nodejs.org/)ランタイムが必要となります。 また、[npm](https://www.npmjs.com/)を通して依存関係のあるライブラリを取得する必要があります。 npmはNode.jsとともにインストールされます。ですので、Node.jsがすでにインストール済みでしたら、あなたは先に進む準備ができています。

EmberはNode.js 0.12かそれ以上、npm 2.7かそれ以上を必要とします。もしNode.jsがインストールされているかわからない、あるいはバージョンが不明な場合は、コマンドライン上で以下を実行してください。

```bash
node --version
npm --version
```

もし、*"command not found"*エラーだった場合、またはNodeのバージョンが古かった場合には、次を行ってください。

* WindowsあるいはMacのユーザーは[この Node.js インストーラー](http://nodejs.org/download/)を実行できます。.
* あなたがMacユーザーで、もしNodeのインストールに[Homebrew](http://brew.sh/)を使うのを好むようでしたら、Homebrewをインストールした後で`brew install node`を実行し、Node.jsをインストールしてください。
* Linuxユーザーは[このLinuxへのNode.jsインストールガイド](https://nodejs.org/en/download/package-manager/)を参照できます。.

もしnpmが古い場合には、`npm install -g npm`を実行してください。.

### Bower

Emberは追加の依存関係を管理するためにBower を利用しています。Bowerは npm でインストール可能なコマンドラインのユーティリティです。Bowerをインストールするために次のコマンドを実行してください。 ```npm install -g bower```

### Watchman (optional)

Mac 及び Linux の場合は、[Watchman](https://facebook.github.io/watchman/docs/install.html) をインストールすることで、ファイルウォッチングのパフォーマンスを向上することができます。.

### PhantomJS (オプション)

テストをPhantomJS とともにコマンドラインから実行することで、ブラウザを開く必要が必要がなくなります。[PhantomJS ダウンロードの手順](http://phantomjs.org/download.html) を参照にしてください。.

## インストール

Ember のインストールには npm を利用します。

```bash
npm install -g ember-cli
```

To verify that your installation was successful, run:

```bash
ember -v
```

バージョンナンバーが表示されたら、次に進む準備が整いました。