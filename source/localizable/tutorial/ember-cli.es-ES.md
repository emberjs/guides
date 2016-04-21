Ember CLI, la interfaz de línea de comando de Ember, proporciona una estructura de proyecto estándar, un conjunto de herramientas de desarrollo y un sistema de addons. Esto permite a los desarrolladores de Ember enfocarse en la construcción de aplicaciones en vez de desarrollar las estructuras de apoyo que las hacen funcionar. De una línea de comandos, escribir `ember --help` muestra los comandos que Ember CLI proporciona. Para obtener más información acerca de un comando específico, escribe `ember help <command-name>`.

## Crear una nueva aplicación

Para crear un nuevo proyecto utilizando Ember CLI, utiliza el comando `new`. En preparación para el tutorial en la siguiente sección, puedes crear una aplicación llamada `super-rentals`.

```shell
ember new super-rentals
```

## Estructura de directorios

El comando `new` genera una estructura de proyecto con los siguientes archivos y directorios:

```text
|--app
|--bower_components
|--config
|--dist
|--node_modules
|--public
|--tests
|--tmp
|--vendor

bower.json
ember-cli-build.js
package.json
README.md
testem.js
```

Vamos a echar un vistazo a las carpetas y archivos que Ember CLI genera.

**app**: es donde se almacenan las carpetas y archivos para los models (modelos), components (componentes), routes (rutas), templates (plantillas) y styles (estilos). La mayoría del código que escribirás en tu proyecto de Ember será en esta carpeta.

**bower_components / bower.json**: Bower es una herramienta de gestión de dependencias. Es utilizada en Ember CLI para gestionar plugins de front-end y dependencias de las partes de la aplicación (HTML, CSS, JavaScript, etc.). Todos los componentes de Bower se instalan en el directorio `bower_components`. Si abrimos `bower.json`, vemos la lista de dependencias que son instaladas automáticamente como Ember, jQuery, Ember Data y QUnit (para realizar pruebas). Si añadimos dependencias front-end adicionales, como Bootstrap, los veremos listados aquí y serán añadidos al directorio `bower_components`.

**config**: el directorio de configuración contiene el archivo `environment.js` donde puede configurar los ajustes de su aplicación.

**dist**: Cuando compilamos nuestra aplicación para su implementación, los archivos se crean aquí.

**node_modules / package.json**: este directorio y archivo son de npm. npm es el gestor de paquetes para Node.js. Ember está hecho con Node y utiliza una variedad de módulos de Node.js para su funcionamiento. El archivo `package.json` mantiene la lista de las dependencias actuales de npm para la aplicación. Cualquier add-on (complemento) de Ember-CLI que instales también aparecerá aquí. Los paquetes listados `package.json` se instalan en el directorio node_modules.

**public**: este directorio contiene insumos como imágenes y fuentes.

**vendor**: este directorio es donde van las dependencias front-end (como JavaScript o CSS) que no son gestionadas por Bower.

**tests / testem.js**: las pruebas automatizadas para nuestra aplicación van en la carpeta de `tests`, y el ejecutador de pruebas de Ember CLI **testem** es configurado en `testem.js`.

**tmp**: los archivos temporales de Ember CLI van aquí.

**ember-cli-build.js**: este archivo describe cómo Ember CLI debe compilar nuestra aplicación.

## Módulos ES6

Si miras `app/router.js`, notarás alguna sintaxis que puede parecerte extraña.

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType });

Router.map(function() { });

export default Router;

    <br />Ember CLI utiliza módulos ECMAScript 2015 (ES2015 corto o conocido antes como ES6) para organizar el código de la aplicación.
    Por ejemplo, la línea `import Ember from 'ember';` nos da acceso a la biblioteca de Ember.js como la variable `Ember`. Y la línea `import config from './config/environment';`, nos da acceso a los datos de configuración de la aplicación como la variable `config`. `const`es una forma de declarar una variable de solo lectura, para asegurarnos que no se reasigne accidentalmente en otro lado. Al final del archivo, `export default Router;` hace que la variable `Router` definida en este archivo, esté disponible para otras partes de la aplicación.
    
    ## Actualizando Ember 
    
    Antes de continuar con el tutorial, asegúrate de tener la versión más reciente de Ember instalada. Si las versiones de `ember` y `ember-data` en `bower.json` son menores que el número de versión en la esquina superior izquierda de estas guías, actualizar los números de versión en `bower.json` y luego ejecutar `bower install`.
    
    ## El servidor de desarrollo 
    
    Una vez que tenemos un nuevo proyecto, podemos confirmar que todo funciona iniciando el servidor de desarrollo de Ember: 
    
    ```shell
    ember server
    

o, para abreviar:

```shell
ember s
```

Si navegamos a `localhost:4200`, vamos a ver nuestra nueva aplicación mostrando el texto "Welcome to Ember".