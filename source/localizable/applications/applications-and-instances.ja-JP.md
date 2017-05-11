全てのEmberアプリケーションは、[`Ember.Application`](http://emberjs.com/api/classes/Ember.Application.html)を継承したクラスとして表現されます。 このクラスは、アプリケーションを構成する多くのオブジェクトを宣言し構成するために使われます。

起動すると、アプリケーションは状態管理に使用する[`Ember.ApplicationInstance`](http://emberjs.com/api/classes/Ember.ApplicationInstance.html)を作成します。 このインスタンスは、アプリケーション用にインスタンス化されたオブジェクトの「所用者」として機能します。

基本的に、`ApplicationInstance`が*状態を管理*し、`Application`が*アプリケーションを定義*します.

このような関心ごとの分離は、アプリケーションのアーキテクチャを明らかにするだけでなく、その効果も向上させます。 これはアプリケーションをテスト中に繰り返し起動したり、あるいはサーバーレンダリング (例えば[FastBoot](https://github.com/tildeio/ember-cli-fastboot)経由で) を行う必要がある場合には、特に当てはまります。 このような場合には、単一`Application`の構成を一度行った後で、複数のステートフルな`ApplicationInstance`の間で共有できます。 これらのインスタンスは必要がなくなれば破棄することもできます (例えば、テストを実行している時やFastBootのリクエストが終了した時など)。