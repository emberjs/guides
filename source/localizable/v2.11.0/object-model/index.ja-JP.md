標準のJavaScriptクラスパターンと新しいES2015 クラスはEmberでは広く使われていません。プレーンなオブジェクトはまだ見つかるかもしれません。それらは「ハッシュ」と呼ばれます。

JavaScriptのオブジェクトは、プロパティ値の変更の監視をサポートしていません。 したがって、オブジェクトがEmberのバインディングシステムに加わるようなら、あなたはプレーンなオブジェクトの代わりに`Ember.Object`を使うことになるでしょう。

[Ember.Object](http://emberjs.com/api/classes/Ember.Object.html)は、ミックスインやコンストラクタなどの機能をサポートしているクラスシステムも提供しています。 Emberのオブジェクトモデルのいくつかの機能は、現在のJavaScriptクラスや一般的なパターンには無いものですが、それらは全て、可能な限り言語仕様や追加の提案として統一されています。

Emberはまた、配列の変更監視を提供するために、JavaScriptの`Array`プロトタイプを[Ember.Enumerable](http://emberjs.com/api/classes/Ember.Enumerable.html)インターフェイスを持つように拡張しています。

最後に、Emberは`String`プロトタイプに[フォーマットとローカライゼーション用のメソッド](http://emberjs.com/api/classes/Ember.String.html)を拡張しています。.