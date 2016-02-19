Ember.js を始めるは簡単です。Ember.js プロジェクトを作成して、コマンド ライン ビルド ツール Ember CLI を利用して管理します。 Ember CLI は次の機能をを提供しています。

* Modern application asset management (including concatenation, minifying, and versioning).
* Generators to help create components, routes, and more.
* コンベンショナルなプロジェクトのレイアウトは、既存のEmber.jsアプリケーションへのアプローチを簡単にします。
* Support for ES2015/ES6 JavaScript via the [Babel](http://babeljs.io/docs/learn-es2015/) project. This includes support for [JavaScript modules](http://exploringjs.com/es6/ch_modules.html), which are used throughout this guide.
* A complete [QUnit](https://qunitjs.com/) test harness.
* The ability to consume a growing ecosystem of Ember Addons.

## 依存関係

### Node.js とnpm

Ember CLI は JavaScript、で作られており、 [Node.js](https://nodejs.org/)のランタイムを必要としています。 また、依存関係の取得のために、[npm](https://www.npmjs.com/) が必要です。 npmは、Node.js とともにインストールされるので、すでに、Node.js があなたのコンピューターにインストールされている場合は、次に進む準備ができています。

Ember は Node.js 0.12 または、それ以上 npm 2.7 または、それ以上 が必要です。 Node.js がインストールされているかわからない、またはバージョンが不明な場合は、コマンドラインで、次のコマンドを実行してください。

```bash
node --version
npm --version
```

もし、 *"command not found"* エラー、または Node のバージョンが古い時は

* Windows または Mac のユーザーの場合は [この Node.js インストーラー](http://nodejs.org/download/) を実行することができます。.
* Mac ユーザーは[ Homebrew ](http://brew.sh/) を使用してノードをインストールするのを好むことがあります。Homebrewをインストールした後、Node.js をインストールするには `brew install node` を実行します。
* Linux ユーザの場合はは、この[ガイド](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) を使用できます。.

もし npm が古い場合は、`npm install -g npm` を実行してください。.

### Git

Ember は、多くの依存関係の管理で Git を利用しています。 Git は Mac OS X と 多くのLinux ディストリビューションすでに含まれています。 Windows ユーザーは、[この Git のインストーラー](http://git-scm.com/download/win) ダウンロードすることで、実行できます。.

### Watchman (オプション)

Mac 及び Linux の場合は、[Watchman](https://facebook.github.io/watchman/docs/install.html) をインストールすることで、ファイルウォッチングのパフォーマンスを向上することができます。.

### PhantomJS (オプション)

テストをPhantomJS とともにコマンドラインから実行することで、ブラウザを開く必要が必要がなくなります。[PhantomJS ダウンロードの手順](http://phantomjs.org/download.html) を参照にしてください。.

## インストール

Ember のインストールには npm を利用します。

```bash
npm install -g ember-cli@2.3
```

インストールが成功したことを確認するには、次のコマンドを実行します。

```bash
ember -v
```

バージョンナンバーが表示されたら、次に進む準備が整いました。