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

#### Commits (cambios)

Los commits relacionados con una feature en particular deben incluir un prefijo como [FEATURE htmlbars]. Esto nos permitirá identificar todos los commits relacionados con una sola feature. Las features nuevas nunca se aplican a las ramas beta o release. Desde el momento en que se prepara la rama beta o release, ya contiene todas sus features.

Si una feature logra ser incluida en la rama beta o release, y haces un commit a la rama maestra para arreglar un bug de esa feature, seguir el procedimiento para los bugfixes descrito arriba.

#### Convenciones de nomenclatura de las features

```config/environment.js Ember.FEATURES['<packagename>-<feature>'] // if package specific Ember.FEATURES['container-factory-injections'] Ember.FEATURES['htmlbars']

    <br />### Compilaciones
    
    La compilación canary, que está basada en master, incluye todas las características, protegidas por condicionales en el código fuente original. Esto significa que los usuarios de la compilación canary pueden habilitar cualquier características que deseen antes de crear su Ember.Application.
    
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

La raíz del repositorio contendrá un archivo features.json, que contendrá una lista de características que deben ser habilitados para las compilaciones beta o release.

Este archivo se llena cuando se hace branching, y no deberá recibir características adicionales más allá que las del del branch original. Puede eliminar características.

```js
{
  "htmlbars": true
}
```

El proceso de compilación removerá cualquier característica no incluida en la lista y eliminará los condicionales para las características en la lista.

### Pruebas co Travis

Para un nuevo PR:

  1. Travis probará respecto a master con todas las banderas de características activadas.
  2. Si un commit es etiquetado con [BUGFIX beta], Travis también escogerá el commit en beta y ejecutar las pruebas en ese branch. Si el commit no se aplica correctamente o las pruebas fallan, las pruebas fallarán.
  3. Si un commit es etiquetado con [BUGFIX release], Travis también escogerá el commit en release y ejecutar la prueba en ese branch. Si el commit no se aplica correctamente o las pruebas fallan, las pruebas fallarán.

Para un nuevo commit a master:

  1. Travis ejecutará las pruebas como se describió anteriormente.
  2. Si la construcción pasa, Travis escogerá los commits en las branches apropiadas.

La idea es que los nuevos commits deben presentarse como PRs para se aplican limpiamente, y una vez que se presiona el botón de merge, Travis los aplicará a las branches adecuadas.

### Proceso de Go/No-Go

Cada seis semanas, el equipo sigue el siguiente proceso.

#### La rama beta

Se revisa el nivel de preparación de todas las funciones restantes en la rama beta. Si alguna feature no está lista, se la quita de features.json.

Una vez hecho esto, se etiqueta la rama beta y se la une con la rama release.

#### La rama maestra

Se revisa el nivel de preparación de todas las features en la rama maestra. Una feature se considera como <<lista>> en esta etapa sólo cuando está lista tal y como es, sin ningún bloqueador. Las features son un <<no-go>> (no entran) incluso si están casi terminadas y lo único que les falta ya está en la rama beta.

Dado que este proceso se repite cada seis semanas, siempre va a haber otra oportunidad para incluir la feature pronto.

Una vez hecho esto, la rama maestra se une con la rama beta. Se agrega un archivo `features.json` con todas las features que están listas.

### Lanzamientos Beta

Cada semana, repetimos el proceso de Go/No-Go para las características que permanecen en la branch beta. Cualquier característica que se conviertan en no listas extraen de features.json.

Una vez hecho esto, una versión Beta es etiquetada y enviada.