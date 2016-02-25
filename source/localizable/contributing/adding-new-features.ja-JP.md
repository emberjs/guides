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

Features must always be wrapped in a feature flag. Tests for the feature must also be wrapped in a feature flag.

Because the build-tools will process feature-flags, flags must use precisely this format. We are choosing conditionals rather than a block form because functions change the surrounding scope and may introduce problems with early return.

```js
if (Ember.FEATURES.isEnabled("feature")) {
  // implementation
}
```

Tests will always run with all features on, so make sure that any tests for the feature are passing against the current state of the feature.

#### コミット

Commits related to a specific feature should include a prefix like [FEATURE htmlbars]. This will allow us to quickly identify all commits for a specific feature in the future. Features will never be applied to beta or release branches. Once a beta or release branch has been cut, it contains all of the new features it will ever have.

If a feature has made it into beta or release, and you make a commit to master that fixes a bug in the feature, treat it like a bugfix as described above.

#### 機能ネーミング規則

```config/environment.js Ember.FEATURES['<packagename>-<feature>'] // if package specific Ember.FEATURES['container-factory-injections'] Ember.FEATURES['htmlbars']

    <br />### Builds
    
    The Canary build, which is based off master, will include all features,
    guarded by the conditionals in the original source. This means that
    users of the canary build can enable whatever features they want by
    enabling them before creating their Ember.Application.
    
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

The root of the repository will contain a features.json file, which will contain a list of features that should be enabled for beta or release builds.

This file is populated when branching, and may not gain additional features after the original branch. It may remove features.

```js
{
  "htmlbars": true
}
```

The build process will remove any features not included in the list, and remove the conditionals for features in the list.

### Travis Testing

For a new PR:

  1. Travis will test against master with all feature flags on.
  2. If a commit is tagged with [BUGFIX beta], Travis will also cherry-pick the commit into beta, and run the tests on that branch. If the commit doesn't apply cleanly or the tests fail, the tests will fail.
  3. If a commit is tagged with [BUGFIX release], Travis will also cherry-pick the commit into release, and run the test on that branch. If the commit doesn't apply cleanly or the tests fail, the tests will fail.

For a new commit to master:

  1. Travis will run the tests as described above.
  2. If the build passes, Travis will cherry-pick the commits into the appropriate branches.

The idea is that new commits should be submitted as PRs to ensure they apply cleanly, and once the merge button is pressed, Travis will apply them to the right branches.

### Go/No-Go プロセス

Every six weeks, the core team goes through the following process.

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