Esta guía te enseñará cómo construir una aplicación simple usando Ember desde cero.

Daremos estos pasos:

  1. Instalación de Ember.
  2. Creación de una nueva aplicación.
  3. Definir una ruta.
  4. Escribir un componente.
  5. Construir la aplicación para ser desplegada en producción.

## Instalar Ember

Ember se puede instalar mediante un solo comando usando npm, el gestor de paquetes de Node.js. Escribe esto en tu terminal:

```sh
npm install -g ember-cli
```

¿No tienes npm? [Aprende a instalar Node.js y npm aquí](https://docs.npmjs.com/getting-started/installing-node).

## Crear una nueva aplicación

Una vez que has instalado Ember CLI mediante npm, ya puedes ejecutar el nuevo comando `ember` en la terminal. En concreto y para empezar, puedes utilizar el comando `ember new` para crear una nueva aplicación.

```sh
ember new ember-quickstart
```

Este comando creará un nuevo directorio llamado `ember-quickstart` y configurará una nueva aplicación de Ember en su interior. Por defecto, esta nueva aplicación permitirá:

* Utilizar un servidor de desarrollo.
* Compilar las plantillas.
* Minificar los ficheros de JavaScript y CSS.
* Usar las nuevas características de ES2015 gracias a Babel.

Proporcionando todo lo necesario para construir aplicaciones web en un paquete integrado, Ember facilita enormemente el inicio de nuevos proyectos.

Comprobemos que todo esté funcionando correctamente. Accedamos al directorio de la aplicación mediante `cd ember-quickstart` y arranquemos el servidor de desarrollo escribiendo:

```sh
cd ember-quickstart
ember serve
```

Después de unos segundos, deberías leer en el terminal algo parecido a esto:

```text
Livereload server on http://localhost:49152
Serving on http://localhost:4200/
```

(Para detener el servidor en cualquier momento, haz Ctrl-C en el terminal.)

Abre [http://localhost:4200 /](http://localhost:4200) en tu navegador. Deberías ver una página que dice "Welcome to Ember". ¡Felicidades! Acabas de crear y arrancar tu primera aplicación de Ember.

Ahora, en tu editor de texto abre `app/templates/application.hbs`. Esta es la plantilla de `application` y su contenido siempre se mostrará mientras la aplicación esté en ejecución.

Modifica el texto dentro de `<h2>`, de modo que donde dice `Welcome to Ember` cámbialo por `PeopleTracker` y guarda el archivo. Date cuenta de que Ember detecta el cambio que acabas de hacer y automáticamente vuelve a cargar la página. Deberías ver que "Welcome to Ember" ha sido reemplazado por "PeopleTracker".

## Definir una ruta

Vamos a crear una aplicación que muestra una lista de científicos. Para ello, el primer paso es crear una ruta. Por ahora, puedes entender las rutas como las diferentes páginas que componen la aplicación.

Ember viene con *generadores* que crearán por ti el código base que se repite para tareas habituales. Para generar una ruta, escribe esto en tu terminal:

```sh
ember generate route scientists
```

Verás una salida como esta:

```text
installing route
  create app/routes/scientists.js
  create app/templates/scientists.hbs
updating router
  add route scientists
installing route-test
  create tests/unit/routes/scientists-test.js
```

Se trata de Ember diciendo que ha creado:

  1. Una plantilla que aparecerá cuando el usuario visite `/scientists`.
  2. Un objeto de tipo `Route` que obtendrá el modelo utilizado por esa plantilla.
  3. Una entrada en el enrutador de la aplicación (ubicado en `app/router.js`).
  4. Una test unitario para esta ruta.

Abre la plantilla recién creada en `app/templates/scientists.hbs` y agrega el siguiente código HTML:

'''app/templates/scientists.hbs 

## Lista de científicos

    <br />En el navegador, abre [http://localhost:4200/scientists] (http://localhost:4200/scientists). Deberías ver el `<h2>` que escribiste en la plantilla `scientist.hbs`, justo debajo del ``<h2>` de nuestra plantilla `application.hbs`.
    
    Ahora que tenemos la plantilla de `scientists` funcionando, vamos a darle información para que muestre. Para lograrlo, especificamos un _model_ para esa ruta. Para hacer eso debemos editar `app/routes/scientists.js`.
    
    Tomaremos el código que el generado creó para nosotros y añadiremos el método `model()` a la `Route`:
    
    ```app/routes/scientists.js{+4,+5,+6}
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return ['Marie Curie', 'Mae Jemison', 'Albert Hofmann'];
      }
    });
    

(Este ejemplo de código utiliza las últimas características de JavaScript, algunas de las cuales pueden no serte familiares aún. Aprende más sobre ellas con este [resumen de las nuevas características de JavaScript](https://ponyfoo.com/articles/es6).)

En el método `model()` de la ruta retornamos la información que quieres tener disponible en la plantilla. Si necesitas obtener datos asincrónicamente, el método `model()` soporta cualquier librería que utilice [JavaScript Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).

Ahora le indicaremos a Ember cómo convertir esa matriz de cadenas en HTML. Abre la plantilla `scientists` y añade el código Handlebars necesario para recorrer el array y mostrarlo:

```app/templates/scientists.hbs{+3,+4,+5,+6,+7} 

## Lista de científicos

{{#each model as |scientist|}} 

* {{scientist}} {{/each}} 

    <br />Aquí usamos el helper `each` para iterar sobre cada elemento en el array que proveímos en el hook de `model()` y lo imprimimos en un elemento `<li>`.
    
    ## Crear un componente de la interfaz gráfica
    
    A medida que tu aplicación crece y empiezas a notar elementos de la interfaz gráfica que se comparten entre múltiples páginas (o se utilizan varias veces en la misma página), 
    Ember hace fácil refactorizar tus plantillas en componentes reusables.
    
    Creemos ahora un component `people-list` que usaremos en múltiples lugares para mostrar una lista de personas.
    
    Como habitualmente, hay un generator que hace esto fácil para nosotros. Crea un nuevo componente escribiendo el siguiente comando:
    
    ```sh
    ember generate component people-list
    

Copia y pega la plantilla de `scientists` en la plantilla del componente `people-list` y modifícala para que se vea de la siguiente forma:

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />Puedes notar que hemos cambiado el título estático ("List of Scientists") para que sea una propiedad dinámica (`{{title}}`). `scientist` por uno más genérico `person`, disminuyendo el acoplamiento del componente respecto de donde es usado.
    
    Guardar este template (plantilla) y volver al template (plantilla) de `scientists`. Reemplazar todo nuestro código antiguo con la nueva versión que utiliza components (components). Los components (componentes) se ven como tags HTML, pero en vez de utilizar paréntesis angulares (`<tag>`), utilizan llaves (`{{component}}`). Le diremos a nuestro componente:
    
    1. Que título utilizar a través del atributo `title`.
    2. Que array de personas usar, a través del atributo `people`. Proveeremos el `model (modelo)` de esta route (ruta) como la lista de personas.
    
    ```app/templates/scientists.hbs{-1,-2,-3,-4,-5,-6,-7,+8}
    <h2>List of Scientists</h2>
    
    <ul>
      {{#each model as |scientist|}}
        <li>{{scientist}}</li>
      {{/each}}
    </ul>
    {{people-list title="List of Scientists" people=model}}
    

Regresa al navegador y verás que la interfaz de usuario se ve idéntica. La única diferencia es que ahora hemos componentizado nuestra lista en una versión que es más reusable y más fácil de mantener.

Puedes ver esto en acción si creas una nueva ruta que muestra una lista diferente de personas. Como ejercicio para el lector, puedes tratar de crear una route (ruta) `programmers` que muestre una lista de programadores famosos. Reusando el component (componente) `people-list`, puedes hacerlo prácticamente sin escribir más código.

## Compilando para producción

Ahora que hemos escrito nuestra aplicación y verificado que funciona en el entorno de desarrollo, es tiempo de tenerla lista para desplegar. Para hacerlo, ejecuta el siguiente comando:

```sh
ember build --env production
```

El comando `build` empaqueta todos los insumos que componen tu aplicación&mdash;JavaScript, templates, CSS, fuentes, imágenes, y más.

En este caso, le decimos a Ember que compile para el entorno de producción utilizando la bandera `--env`. Esto crea un paquete optimizado, listo para subir a tu servidor web. Una vez que la compilación termine, encontrarás todos los insumos concatenados y minificados en el directorio `dist` de la aplicación.

La comunidad de Ember valora la colaboración y la creación de herramientas comunes en las que todos confíen. If you're interested in deploying your app to production in a fast and reliable way, check out the [Ember CLI Deploy](http://ember-cli-deploy.github.io/ember-cli-deploy/) addon.

If you deploy your application to an Apache web server, first create a new virtual host for the application. To make sure all routes are handled by index.html, add the following directive to the application's virtual host configuration

    FallbackResource index.html