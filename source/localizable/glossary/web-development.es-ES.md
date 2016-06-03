Unirse a una comunidad de desarrollo web puede ser un desafío en sí mismo, especialmente cuando todos los recursos que visitas asumen que estás familiarizado con otras tecnologías con las que no estás familiarizado.

Nuestro objetivo es ayudarte a evitar ese lío y ayudarte a acelerar tan rápido como sea posible; puedes considerarnos considerar tu amigo de internet.

## CDN

Content Delivery Network

Esto es típicamente un servicio pagado que puede usar para obtener gran rendimiento para tu aplicación. Muchos CDNs actúan como proxies caché en el servidor de origen; algunos requieren subir tus assets a ellos. Estos te dan una URL para cada recurso en su aplicación. Esta URL se resuelve diferente para cada persona dependiendo de donde están navegando.

Detrás de escenas, la CDN distribuirá tu contenido geográficamente con el objetivo que los usuarios finales obtener recuperar su contenido con la menor latencia posible. Por ejemplo, si un usuario está en la India, tenían probabilidades de obtener contenido de India más rápido que el contenido de los Estados Unidos.

## CoffeeScript, TypeScript

Estos son idiomas que compilan a JavaScript. Escribirás el código utilizando la sintaxis que ofrecen y cuando esté listo compilar TypeScript o CoffeeScript a Javascript.

[CoffeeScript vs TypeScript](http://www.stoutsystems.com/articles/coffeescript-versus-typescript/)

## Evergreen browsers

Navegadores que actualizan por sí mismos (sin intervención del usuario).

[Evergreen Browsers](http://tomdale.net/2013/05/evergreen-browsers/)

## ES3, ES5, ES5.1, ES6 (aka ES2015), etc

ES se refiere a ECMAScript, que es la especificación que se basa en JavaScript. El número que sigue es la versión de la especificación.

Most browsers support at least ES5, and some even have ES6 (also known as ES2015) support. You can check each browser's support (including yours) here:

* [ES5 support](http://kangax.github.io/compat-table/es5/)
* [ES6 support](http://kangax.github.io/compat-table/es6/)

[ECMAScript](https://en.wikipedia.org/wiki/ECMAScript)

## LESS, Sass

Both LESS and Sass are types of CSS preprocessor markup intended to give you much more control over your CSS. During the build process, the LESS or Sass resources compile down to vanilla CSS (which can be executed in a browser).

[Sass/Less Comparison](https://gist.github.com/chriseppstein/674726)

## Linter, linting, jslint, jshint

A validation tool which checks for common issues in your JavaScript. You'd usually use this in your build process to enforce quality in your codebase. A great example of something to check for: *making sure you've always got your semicolons*.

[An example of some of the options you can configure](http://jshint.com/docs/options/)

## Polyfill

This is a concept that typically means providing JavaScript which tests for features that are missing (prototypes not defined, etc) and "fills" them by providing an implementation.

## Promise

Asynchronous calls typically return a promise (or deferred). This is an object which has a state: it can be given handlers for when it's fulfilled or rejected.

Ember makes use of these in places like the model hook for a route. Until the promise resolves, Ember is able to put the route into a "loading" state.

* [An open standard for sound, interoperable JavaScript promises](https://promisesaplus.com/)
* [emberjs.com - A word on promises](http://emberjs.com/guides/routing/asynchronous-routing/#toc_a-word-on-promises)

## SSR

Server Side Rendering

[Inside FastBoot: The Road to Server-Side Rendering](http://emberjs.com/blog/2014/12/22/inside-fastboot-the-road-to-server-side-rendering.html)

## Transpile

When related to JavaScript, this can be part of your build process which "transpiles" (converts) your ES6 syntax JavaScript to JavaScript that is supported by current browsers.

Besides ES6, you'll see a lot of content about compiling/transpiling CoffeeScript, a short-hand language which can "compile" to JavaScript.

* Ember CLI specifically uses [Babel](https://babeljs.io/) via the [ember-cli-babel](https://github.com/babel/ember-cli-babel) plugin.

## Shadow DOM

Not to be confused with Virtual DOM. Shadow DOM is still a work in progress, but basically a proposed way to have an "isolated" DOM encapsulated within your app's DOM.

Creating a re-usable "widget" or control might be a good use-case for this. Browsers implement some of their controls using their own version of a shadow DOM.

* [W3C Working Draft](http://www.w3.org/TR/shadow-dom/)
* [What the Heck is Shadow DOM?](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom/)

## Virtual DOM

Not to be confused with Shadow DOM. The concept of a virtual DOM means abstracting your code (or in our case, Ember) away from using the browser's DOM in favor of a "virtual" DOM that can easily be accessed for read/writes or even serialized.