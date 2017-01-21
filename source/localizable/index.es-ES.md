Bienvenido a la guía de Ember.js! Esta documentación te llevará de principiante a experto de Ember.

## Organización

A la izquierda de cada una de las páginas de la Guía se encuentra la tabla de contenidos, organizada en secciones que pueden ser expandidas para mostrar los temas que cubren. Tanto las secciones como los temas en cada sección están ordenados de conceptos básicos a avanzados.

Las guías pretenden contener explicaciones prácticas de cómo crear aplicaciones de Ember, centrándose en las características más usadas de Ember.js. Para una documentación completa de cada función de Ember y el API, consulte la [documentación del API de Ember.js](http://emberjs.com/api/).

Las guías comienzan con una explicación de cómo empezar con Ember, seguido por un tutorial sobre cómo crear tu primera aplicación de Ember. Si eres nuevo en Ember, recomendamos empezar siguiendo estas dos primeras partes de las guías.

## Supuestos

Mientras que tratamos de hacer las guías amigables para principiantes como sea posible, debemos establecer una base para que las guías pueden mantenerse enfocadas en la funcionalidad de Ember.js. Trataremos de enlazar documentación apropiada cuando se introduzca un concepto.

Para hacer la mayoría de las guías, deberías tener conocimientos de:

* **HTML, CSS, JavaScript** - los elementos básicos de las páginas web. Puedes encontrar documentación de cada una de estas tecnologías en la [Red de desarrolladores de Mozilla](https://developer.mozilla.org/en-US/docs/Web).
* **Promises (promesas)** - la manera nativa de trabajar con asincronía en tu código JavaScript. Vea la sección relevante en la [Red de desarrolladores de Mozilla](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).
* **Módulos de ES2015** - entenderás mejor la estructura de proyecto de la [Línea de Comandos de Ember](https://ember-cli.com/) y rutas de importación si estás cómodo con los [Módulos de JavaScript ES6](http://jsmodules.io/).
* **Sintaxis de ES2015** - Ember CLI utiliza Babel.js por defecto para tomar ventaja de las nuevas características del lenguaje como arrow functions, template strings, destructuring y más. Puedes consultar la [documentación de Babel.js](https://babeljs.io/docs/learn-es2015/) o leer [entendiendo ECMAScript 6](https://leanpub.com/understandinges6/read) en línea.

## A Note on Mobile Performance

Ember will do a lot to help you write fast apps, but it can't prevent you from writing a slow one. This is especially true on mobile devices. To deliver a great experience, it's important to measure performance early and often, and with a diverse set of devices.

Make sure you are testing performance on real devices. Simulated mobile environments on a desktop computer give an optimistic-at-best representation of what your real world performance will be like. The more operating systems and hardware configurations you test, the more confident you can be.

Due to their limited network connectivity and CPU power, great performance on mobile devices rarely comes for free. You should integrate performance testing into your development workflow from the beginning. This will help you avoid making costly architectural mistakes that are much harder to fix if you only notice them once your app is nearly complete.

In short:

  1. Always test on real, representative mobile devices.
  2. Measure performance from the beginning, and keep testing as your app develops.

These tips will help you identify problems early so they can be addressed systematically, rather than in a last-minute scramble.

## Reporting a problem

Typos, missing words, and code samples with errors are all considered documentation bugs. If you spot one of them, or want to otherwise improve the existing guides, we are happy to help you help us!

Some of the more common ways to report a problem with the guides are:

* Utilizando el icono de lápiz en la derecha superior de cada página de guía
* Abriendo un ticket o solicitud de pull en [el repositorio de GitHub](https://github.com/emberjs/guides/)

Clicking the pencil icon will bring you to GitHub's editor for that guide so you can edit right away, using the Markdown markup language. This is the fastest way to correct a typo, a missing word, or an error in a code sample.

If you wish to make a more significant contribution be sure to check our [issue tracker](https://github.com/emberjs/guides/issues) to see if your issue is already being addressed. If you don't find an active issue, open a new one.

If you have any questions about styling or the contributing process, you can check out our [contributing guide](https://github.com/emberjs/guides/blob/master/CONTRIBUTING.md). If your question persists, reach us at `#-team-learning` on the [Slack group](https://ember-community-slackin.herokuapp.com/).

Good luck!