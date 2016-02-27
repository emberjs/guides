一般的には、新機能の開発はマスターで行われるべきです。

バグの修正は、新規の API を取り入れたり、既存の API を壊してはいけません、また機能フラグも不要です。

新機能は新 API を導入することができ、機能フラグが必要です。新機能はリリースやベータブランチに対して適用してはいけません、なぜならセマンティックバージョニングでは新機能はマイナーバージョンの更新をする必要があるからです。

セキュリティの問題が既存のAPIを壊す必要がない限り、セキュリティ修正プログラムは新たなAPIを導入してはいけません。そのような修正は最小限に限られるべきです。

### Bug Fixes

#### 緊急のバグ修正

緊急のバグ修正は、既存のリリースブランチに対して適用されるものです。可能であれば、マスターに対して行われ、[BUGFIX release] がつけられるべきです。

#### ベータ版バグ修正

ベータ版バグ修正はベータ版に適用されるべき、バグ修正です。可能であれば、マスターで作成され、 [BUGFIX beta] のタグがつけられるべきです。

#### セキュリティ修正プログラム

セキュリティ修正はベータブランチ、カレントブランチと前のタグに対して行われるべきで、可能であれば、 [SECURITY] とタグを付けマスターにも適用するべきです。

### 機能:

新機能は、必ず、機能フラグでラップする必要があります。新機能のテストもまた、機能フラグでラップする必要があります。

ビルドツールが、機能フラグほ処理するため、機能フラグのフォーマットは正確に次の形式にする必要があります。 ファンクションは、ファンクションはスコープを変えて、早期にreturnしてしまわないように、私たちはブロックではなく、コンディショナルを利用しています。

```js
if (Ember.FEATURES.isEnabled("feature")) {
  // implementation
}
```

テストは必ず全ての機能を有効にして、行われますので、現状のテストに対して、機能テストが引き渡されていることを確認してください。

#### コミット

特定の機能に対するコミットは、次のようなプレフィックスを含める必要があります。 [FEATURE htmlbars] こうすることで、この先、特定の機能を素早く特定することことができるようになります。 機能は決して、ベータやリリースブランチに対しては適用されません。 ベータやリリースブランチが切られたら、そのブランチが持つ機能の全てをすでに含んでいるということになります。

 もし機能がベータやリリースにたどり着いて、もしマスターにその機能のバグを修正するコミットをしたら、上記のようにコミットを行ってください。

#### 機能ネーミング規則

```config/environment.js Ember.FEATURES['<packagename>-<feature>'] // if package specific Ember.FEATURES['container-factory-injections'] Ember.FEATURES['htmlbars']

    <br />### ビルド
    
    カナリーのビルドは、マスターに基づいており、オリジナルのソースを囲った、全ての機能を備えています。 これは、カナリービルドのユーザーはEmberアプリケーションを作成する前に、希望する機能を有効化することができます。
    
    ```config/environment.js
    module.exports = function(environment) {
      var ENV = {
        EmberENV: {
          FEATURES: {
            htmlbars: true
          }
        },
      }
    }
    

### `features.json`

リポジトリのルートにはfeatures.jsonがあり、ベータやリリースをビルドする際に機能のを有効化することができます。

このファイルはブランチを切る際に作成されて、その後、機能の追加は行われませんが削除される可能があります。

```js
{
  "htmlbars": true
}
```

ビルドプロセスはリストにない機能を取り除き、リストから該当の機能の条件を取り除きます。

### トラヴィスのテスト

新規のPRについて

  1. Travis-ciはマスターに対して、全ての機能フラグを有効にしてテストを行います。
  2. もしコミットに [BUGFIX beta] タグが付けられていたら、 Travis はタグが付けられたコミットを選択して、ベータブランチでのテストにも適応します。 もしコミットが正常に適用されない、あるいは失敗する場合は、テストは失敗で終わります。
  3. コミットが [BUGFIX release] とタグ付けされていたら、Travis はタグが付けられたコミットを選択して、リリースブランチでのテストにも適応します。 もしコミットが正常に適用されない、あるいは失敗する場合は、テストは失敗で終わります。

マスターに対する新規コミット

  1. Travis は上記に示したように、テストを行います。
  2. もしビルドに成功すれば、Travis はコミットを選択して該当するブランチに含めます。

The idea is that new commits should be submitted as PRs to ensure they apply cleanly, and once the merge button is pressed, Travis will apply them to the right branches.

### Go/No-Go プロセス

6 週間ごとにコア チームは、次のプロセスを行います。

#### ベータブランチ

All remaining features on the beta branch are vetted for readiness. If any feature isn't ready, it is removed from features.json.

Once this is done, the beta branch is tagged and merged into release.

#### マスター ブランチ

All features on the master branch are vetted for readiness. In order for a feature to be considered "ready" at this stage, it must be ready as-is with no blockers. Features are a no-go even if they are close and additional work on the beta branch would make it ready.

Because this process happens every six weeks, there will be another opportunity for a feature to make it soon enough.

Once this is done, the master branch is merged into beta. A `features.json` file is added with the features that are ready.

### ベータリリース

Every week, we repeat the Go/No-Go process for the features that remain on the beta branch. Any feature that has become unready is removed from the features.json.

Once this is done, a Beta release is tagged and pushed.