Emberでの開発を始めるの難しくはありません。Ember プロジェクトの作成や管理はコマンド ライン ビルド ツール Ember CLI を利用します。 Ember CLI は次の機能をを提供しています。

* モダンなアプリケーション資産管理 (連結、縮小、およびバージョン管理をが含まれています。)
* コンポーネントや、ルートなどの作成するためジェネレーター。
* コンベンショナルなプロジェクトのレイアウトは、既存のEmberアプリケーションへのアプローチを簡単にします。
* [Babel プロジェクト](http://babeljs.io/docs/learn-es2015/)経由で、JavaScript ES2015/ES6 をサポートします。 このガイドでも利用されている [JavaScript モジュール](http://exploringjs.com/es6/ch_modules.html) のサポートも含まれています。
* 完全な [QUnit](https://qunitjs.com/) テスト ハーネス
* 成長を続ける、Ember Addonsのエコシステムが利用できます。

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
npm install -g ember-cli
```

インストールが成功したことを確認するには、次のコマンドを実行します。

```bash
ember -v
```

バージョンナンバーが表示されたら、次に進む準備が整いました。