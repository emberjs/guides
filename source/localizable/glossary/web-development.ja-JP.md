Web 開発コミュニティへの参加するだけでも、十分にチャレンジですが、特に目の前にしている技術が、馴染みのない他の技術の理解を前提に説明されているのなおさらです。

私たちの目標は、あなたがそのような混乱を避け、いち早くスピードに乗れるようにすることです、私たちのことを、ネット友達と思ってください。

## CDN

コンテンツデリバリーネットワーク

得てしてこれらは有料のサービスで、アプリケーションのパフォーマンスを上げるのに利用されます、多くのCDNはオリジンサーバーに対してバックプロキシとしコンテンツをキャッシュします、一部のサービスは、あなたがコンテンツをアップロードすることが必要な場合もあります。 そのようなサービスの場合、あなたのアプリケーションの各リソースに特定のURLを付与します。このURLはユーザーがどこからサイトに来ているかによって、適切にリソルブされます。

CDNは舞台裏で、コンテンツが、いち早くユーザーに届くようにCDNはコンテンツをCDN網の地域ごとにキャッシュします。 例えば、ユーザーがインドからアクセスしている場合は、インドにあるコンテンツの方が、アメリカにあるコンテンツより早く提供できる可能性があります。

## CoffeeScript TypeScript

どちらも JavaScript にコンパイルされる言語です。それぞれの言語が持つ構文を使ってコードを書き、書き終えたら、TypeScript またはCoffeeScriptからJavaScript にコンパイルすることができます。

[CoffeeScript vs TypeScript](http://www.stoutsystems.com/articles/coffeescript-versus-typescript/)

## エバーグリーン ブラウザ

(ユーザーが介入することなく) 自動更新を行うブラウザー

[Evergreen Browsers](http://tomdale.net/2013/05/evergreen-browsers/)

## ES3, ES5, ES5.1, ES6 (あるいは ES2015)など

ES は、ECMAScriptの略称です、 JavaScriptのベースとなっている仕様規格です。それに続く数字は仕様のバージョンにあたります。

多くのブラウザの多くは少なくともES5をサポートしています、一部では ES6 (ES2015とも呼ばれています) もサポートしています。各ブラウザのサポート状況は次のリンクから確認することができます。

* [ES5 support](http://kangax.github.io/compat-table/es5/)
* [ES6 support](http://kangax.github.io/compat-table/es6/)

[ECMAScript](https://en.wikipedia.org/wiki/ECMAScript)

## LESS Sass

LESS、SassはともにCSSをよりコントロールできるようにするための、CSSプリプロセッサーです。 LESSもしくはSassはどちらも、ビルドの過程で ( ブラウザが実行できる) CSSのリソースへとコンパイルされます。

[Sass/Less Comparison](https://gist.github.com/chriseppstein/674726)

## Linter linting jslint jshint

JavaScriptでよくありがちな問題を解決する、バリデーションツール。 通常、これはビルドプロセスの一環として、実行されコードベースの品質を補強するために利用されます。 いいサンプルとして*常にセミコロンがあることを確認する。*といった事柄を確認することができます。.

[An example of some of the options you can configure](http://jshint.com/docs/options/)

## Polyfill

現状のJavaScriptには(まだで維持されていないプロトタイプなど) 欠けている機能を、実装することで「埋める」ことを意味しています。

## Promise

非同期の呼び出しは通常プロミス(または、延期)を返します。これは、状態を保持しているオブジェクトで、満たすあるいは拒否するといったことハンドラーを与えることが可能です。

EmberはPromisをルートもモデルフックなどで利用します。Promisが解決するまで、Emberはルートを"ローディング"状態にすることができます。

* [An open standard for sound, interoperable JavaScript promises](https://promisesaplus.com/)
* [emberjs.com - A word on promises](http://emberjs.com/guides/routing/asynchronous-routing/#toc_a-word-on-promises)

## SSR

サーバーサイドレンダリング

[Inside FastBoot: The Road to Server-Side Rendering](http://emberjs.com/blog/2014/12/22/inside-fastboot-the-road-to-server-side-rendering.html)

## Transpile

JavaScriptについて言えば、現在のブラウザーがサポートしていない、ES6の構文を、ビルドプロセスの過程で、されている構文に"トランスパイル" (変換)すること。

ES6の他にも、ショートハンドな言語、CoffeeScriptについてJavaScriptにコンパイルする/トランスパイルするというコンテンツを多く見るでしょう。

* Ember CLI 正確には[ember-cli-babel](https://github.com/babel/ember-cli-babel) プラグインを経由して[Babel](https://babeljs.io/)を利用しています。

## Shadow DOM

バーチャル DOMと混同してはいけません。シャドーDOMは今も進行中の提案で、アプリケーションのDOMとは別の分離されたDOMを保持するものです。

再利用可能な「ウィジェット」やコントロールはシャドーDOMを利用するいい例でしょう。ブラウザーはそれぞれがコントロールした、シャドーDOMの部分的なサポートを実装しています。

* [W3C Working Draft](http://www.w3.org/TR/shadow-dom/)
* [What the Heck is Shadow DOM?](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom/)

## Virtual DOM

シャドー DOMと混同してはいけません。 バーチャルDOMのコンセプトは、コード(今の場合で言えばEmber) をブラウザーのDOMから仮想に抽象化して、容易に読み取り/書き込みあるいは簡単にシリアライズできるものにすることです。