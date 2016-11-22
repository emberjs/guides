El interior de Ember y la mayoría de código que escribirás en tus aplicaciones ocurre en un bucle de ejecución. El bucle de ejecución es utilizado para el procesamiento por lotes y ordenar (o reordenar) el trabajo en una manera que más efectiva.

Se hace agendando el trabajo en colas específicas. Esas colas tienen una prioridad y son procesadas hasta terminar en orden de prioridad.

Para los escenarios básicos de desarrollo de una aplicación basada en Ember, no necesitas entender el bucle de ejecución o usarlo directamente. Todas las rutas comunes están preparadas para ti y no requieres trabajar con el bucle de ejecución directamente.

El caso más común para usar el bucle de ejecución es la integración con una API no-Ember que incluya algún tipo de llamadas asíncronas. Por ejemplo:

* Actualizaciones del DOM y retornos de llamadas desde eventos
* Los retornos de llamada `setTimeout` y `setInterval`
* Los manejadores de eventos de `postMessage` y `messageChannel`
* Retorno de llamadas de AJAX
* Retorno de llamada de WebSocket

## ¿Por qué es útil el bucle de ejecución?

A menudo, procesar en lotes el trabajo similar tiene beneficios. Los navegadores Web hacen algo muy parecido al procesar en lotes los cambios al DOM.

Considera el siguiente fragmento de código HTML:

```html
<div id="foo"></div>
<div id="bar"></div>
<div id="baz"></div>
```

y ahora ejecuta el siguiente código:

```javascript
foo.style.height = '500px' // write
foo.offsetHeight // read (recalculate style, layout, expensive!)

bar.style.height = '400px' // write
bar.offsetHeight // read (recalculate style, layout, expensive!)

baz.style.height = '200px' // write
baz.offsetHeight // read (recalculate style, layout, expensive!)
```

En este ejemplo, la secuencia de código forzó al navegador a recalcular el estilo y redistribuir después de cada etapa. Sin embargo, si fuéramos capaces de procesar en lote trabajos similares juntos, el navegador tendría que recalcular el estilo y la distribución una sola vez.

```javascript
foo.style.height = '500px' // escritura
bar.style.height = '400px' // escritura
baz.style.height = '200px' // escritura

foo.offsetHeight // lectura (recalcular estilo, distribución, ¡elevado en memoria!)
bar.offsetHeight // lectura (rápido ya que el estilo y la distribución ya se conocen)
baz.offsetHeight // lectura (rápido ya que el estilo y la distribución ya se conocen)
```

Interesantemente, este patrón se mantiene válido para muchos otros tipos de trabajo. Esencialmente, procesando en lote trabajo similar permite una mejor canalización y una posterior optimización.

Veamos un ejemplo similar que está optimizado en Ember, comenzando con un objeto `User`:

```javascript
var User = Ember.Object.extend({
  firstName: null,
  lastName: null,
  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  })
});
```

y una plantilla para mostrar sus atributos:

```handlebars
{{firstName}}
{{fullName}}
```

Si ejecutamos el siguiente código sin el bucle de ejecución:

```javascript
var user = User.create({ firstName: 'Tom', lastName: 'Huda' });
user.set('firstName', 'Yehuda');
// {{firstName}} y {{fullName}} son actualizados

user.set('lastName', 'Katz');
// {{lastName}} y {{fullName}} son actualizados
```

Vemos que el navegador procesará la plantilla 2 veces.

En tanto, si tenemos el bucle de ejecución en el código anterior, el navegador sólo procesará la plantilla una vez que los atributos hayan sido colocados por completo.

```javascript
var user = User.create({ firstName: 'Tom', lastName: 'Huda' });
user.set('firstName', 'Yehuda');
user.set('lastName', 'Katz');
user.set('firstName', 'Tom');
user.set('lastName', 'Huda');
```

En el código anterior con el bucle de ejecución, ya que los atributos del usuario terminan con los mismos valores que antes de la ejecución, ¡incluso la plantilla no se volverá a procesar!

Por supuesto es posible optimizar estos escenarios caso por caso, pero conseguirlo gratis es mucho mejor. Utilizando el bucle de ejecución, podemos aplicar esta clase de optimizaciones no sólo para cada escenario, sino holísticamente para toda la aplicación.

## ¿Cómo funciona el Bucle de Ejecución en Ember?

Como se mencionó anteriormente, agendamos trabajo (en la forma de invocaciones funcionales) en colas y, esas colas, son procesadas por completo por orden de prioridad.

¿Qué son las colas y cuál es su orden de prioridad?

```javascript
Ember.run.queues
// => ["sync", "actions", "routerTransitions", "render", "afterRender", "destroy"]
```

Ya que la prioridad es del primero al último, la cola de "sincronización" tiene una prioridad más alta que las colas de "procesamiento" o "destrucción".

## ¿Qué ocurre en esas colas?

* The `sync` queue contains binding synchronization jobs.
* The `actions` queue is the general work queue and will typically contain scheduled tasks e.g. promises.
* The `routerTransitions` queue contains transition jobs in the router.
* The `render` queue contains jobs meant for rendering, these will typically update the DOM.
* The `afterRender` queue contains jobs meant to be run after all previously scheduled render tasks are complete. This is often good for 3rd-party DOM manipulation libraries, that should only be run after an entire tree of DOM has been updated.
* The `destroy` queue contains jobs to finish the teardown of objects other jobs have scheduled to destroy.

## In what order are jobs executed on the queues?

The algorithm works this way:

  1. Let the highest priority queue with pending jobs be: `CURRENT_QUEUE`, if there are no queues with pending jobs the run loop is complete
  2. Let a new temporary queue be defined as `WORK_QUEUE`
  3. Move jobs from `CURRENT_QUEUE` into `WORK_QUEUE`
  4. Process all the jobs sequentially in `WORK_QUEUE`
  5. Return to Step 1

## An example of the internals

Rather than writing the higher level app code that internally invokes the various run loop scheduling functions, we have stripped away the covers, and shown the raw run-loop interactions.

Working with this API directly is not common in most Ember apps, but understanding this example will help you to understand the run-loops algorithm, which will make you a better Ember developer. <iframe src="https://s3.amazonaws.com/emberjs.com/run-loop-guide/index.html" width="678" height="410" style="border:1px solid rgb(170, 170, 170);margin-bottom:1.5em;"></iframe>
## How do I tell Ember to start a run loop?

You should begin a run loop when the callback fires.

The `Ember.run` method can be used to create a run loop. In this example, jQuery and `Ember.run` are used to handle a click event and run some Ember code.

This example uses the `=>` function syntax, which is a \[new ES2015 syntax for callback functions\] (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) that provides a lexical `this`. If this syntax is new, think of it as a function that has the same `this` as the context it is defined in.

```javascript
$('a').click(() => {
  Ember.run(() => {  // begin loop
    // Code that results in jobs being scheduled goes here
  }); // end loop, jobs are flushed and executed
});
```

## What happens if I forget to start a run loop in an async handler?

As mentioned above, you should wrap any non-Ember async callbacks in `Ember.run`. If you don't, Ember will try to approximate a beginning and end for you. Consider the following callback:

```javascript
$('a').click(() => {
  console.log('Doing things...');

  Ember.run.schedule('actions', () => {
    // Haz mas cosas
  });
});
```

The run loop API calls that *schedule* work i.e. [`run.schedule`](http://emberjs.com/api/classes/Ember.run.html#method_schedule), [`run.scheduleOnce`](http://emberjs.com/api/classes/Ember.run.html#method_scheduleOnce), [`run.once`](http://emberjs.com/api/classes/Ember.run.html#method_once) have the property that they will approximate a run loop for you if one does not already exist. These automatically created run loops we call *autoruns*.

Here is some pseudocode to describe what happens using the example above:

```javascript
$('a').click(() => {
  // 1. autoruns do not change the execution of arbitrary code in a callback.
  //    This code is still run when this callback is executed and will not be
  //    scheduled on an autorun.
  console.log('Doing things...');

  Ember.run.schedule('actions', () => {
    // 2. schedule notices that there is no currently available run loop so it
    //    creates one. It schedules it to close and flush queues on the next
    //    turn of the JS event loop.
    if (! Ember.run.hasOpenRunLoop()) {
      Ember.run.start();
      nextTick(() => {
        Ember.run.end()
      }, 0);
    }

    // 3. There is now a run loop available so schedule adds its item to the
    //    given queue
    Ember.run.schedule('actions', () => {
      // Do more things
    });

  });

  // 4. This schedule sees the autorun created by schedule above as an available
  //    run loop and adds its item to the given queue.
  Ember.run.schedule('afterRender', () => {
    // Do yet more things
  });
});
```

Although autoruns are convenient, they are suboptimal. The current JS frame is allowed to end before the run loop is flushed, which sometimes means the browser will take the opportunity to do other things, like garbage collection. GC running in between data changing and DOM rerendering can cause visual lag and should be minimized.

Relying on autoruns is not a rigorous or efficient way to use the run loop. Wrapping event handlers manually are preferred.

## How is run loop behaviour different when testing?

When your application is in *testing mode* then Ember will throw an error if you try to schedule work without an available run loop.

Autoruns are disabled in testing for several reasons:

  1. Autoruns are Embers way of not punishing you in production if you forget to open a run loop before you schedule callbacks on it. While this is useful in production, these are still situations that should be revealed in testing to help you find and fix them.
  2. Some of Ember's test helpers are promises that wait for the run loop to empty before resolving. If your application has code that runs *outside* a run loop, these will resolve too early and give erroneous test failures which are difficult to find. Disabling autoruns help you identify these scenarios and helps both your testing and your application!

## Where can I find more information?

Check out the [Ember.run](http://emberjs.com/api/classes/Ember.run.html) API documentation, as well as the [Backburner library](https://github.com/ebryn/backburner.js/) that powers the run loop.