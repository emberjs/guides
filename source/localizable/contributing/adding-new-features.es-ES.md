Por lo general, desarrollo de una función nueva debe realizarse en la rama maestra.

Las correcciones de errores (bugfixes) no deberían introducir APIs nuevas ni romper las APIs existentes, y así no necesitan <<feature flags>> (indicadores para nueva funcionalidad).

Las funciones nuevas pueden introducir APIs nuevas y necesitan <<feature flags>>. No se debe aplicar a las ramas de release o beta, dado que SemVer (Versionamiento Semántico) requiere incrementar la versión menor al introducir nueva funcionalidad.

Un patch de seguridad no debe introducir nuevas APIs, pero puede, si es absolutamente necesario, romper las API existentes. Estas roturas deben ser lo más limitadas posible.

### Bug Fixes (Arreglos de Bugs)

#### Bug Fixes Urgentes

Los bugfixes urgentes son correcciones de errores que deben ser aplicadas a la rama actual. Si es posible, deben ser realizados en la rama maestra con el prefijo [BUGFIX release].

#### Bug Fixes Beta

Los bugfixes beta son correcciones de errores que deben ser aplicados a la rama beta. Si es posible, deben ser realizados en la rama maestra y etiquetados con [BUGFIX beta].

#### Security Fixes (Fixes de Seguridad)

Los security fixes deben ser aplicados a la rama beta, la rama actual, y la etiqueta anterior. Si es posible, los cambios deben ser aplicados en la rama maestra y etiquetados con [SECURITY].

### Features (Funcionalidades)

Nueva funcionalidad siempre debe ser marcada por un <<feature flag>>. Las pruebas para esta nueva funcionalidad también deben ser marcada por un <<feature flag>>.

Dado que las <<build-tools>> procesa los feature flags, hay que usar los flags precisamente en esta manera. Elegimos usar condicionales en vez de un bloque porque las funciones cambian el scope y pueden introducir problemas con un <<return>> precoz.

```js
if (Ember.FEATURES.isEnabled("feature")) {
  // implementation
}
```

Las pruebas siempre se ejecutan con toda la funcionalidad, así que asegúrate que todas las pruebas para la funcionalidad nueva corren bien con el estado actual de la funcionalidad.

#### Commits

Commits related to a specific feature should include a prefix like [FEATURE htmlbars]. This will allow us to quickly identify all commits for a specific feature in the future. Features will never be applied to beta or release branches. Once a beta or release branch has been cut, it contains all of the new features it will ever have.

If a feature has made it into beta or release, and you make a commit to master that fixes a bug in the feature, treat it like a bugfix as described above.

#### Feature Naming Conventions

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

### Go/No-Go Process

Every six weeks, the core team goes through the following process.

#### Beta Branch

All remaining features on the beta branch are vetted for readiness. If any feature isn't ready, it is removed from features.json.

Once this is done, the beta branch is tagged and merged into release.

#### Master Branch

All features on the master branch are vetted for readiness. In order for a feature to be considered "ready" at this stage, it must be ready as-is with no blockers. Features are a no-go even if they are close and additional work on the beta branch would make it ready.

Because this process happens every six weeks, there will be another opportunity for a feature to make it soon enough.

Once this is done, the master branch is merged into beta. A `features.json` file is added with the features that are ready.

### Beta Releases

Every week, we repeat the Go/No-Go process for the features that remain on the beta branch. Any feature that has become unready is removed from the features.json.

Once this is done, a Beta release is tagged and pushed.