Antes de empezar a escribir código, es buena idea obtener una visión general de cómo funciona una aplicación de Ember.

![conceptos básicos de Ember](../../images/ember-core-concepts/ember-core-concepts.png)

## Enrutador y gestores de ruta

Supongamos que vamos a escribir una aplicación web que permite a los usuarios anunciar una o varias propiedades para ser alquiladas. En un momento dado, deberíamos ser capaces de responder a preguntas sobre el estado actual como *¿qué propiedad están buscando?* o *¿se está simplemente visualizando o está siendo editada?* En Ember.js, la respuesta a estas dos posibles preguntas viene determinada por la URL. La URL se puede establecer de varias formas:

* El usuario carga la aplicación por primera vez.
* El usuario cambia la URL manualmente, como por ejemplo haciendo clic en el botón de retroceder o editando la barra de direcciones.
* El usuario hace clic en un enlace dentro de la aplicación.
* Y otros eventos dentro de la aplicación que provocan también un cambio de URL.

Al margen de cómo se establezca la URL, lo primero que ocurre es que el enrutador de Ember asocia la URL a un gestor de ruta.

Por lo tanto, el gestor de ruta hace básicamente dos cosas:

* Renderiza una plantilla.
* Carga un modelo que estará disponible para la plantilla.

## Plantillas

Ember.js utiliza plantillas para organizar el layout HTML de una aplicación.

La mayoría de plantillas en Ember nos resultan familiares, ya que no son más que fragmentos de HTML. Por ejemplo:

```handlebars
< div > ¡Hola! Esta es una plantilla de Ember perfectamente válida. < / div >
```

En Ember, las plantillas utilizan adicionalmente la sintaxis de [Handlebars](http://handlebarsjs.com). Todo lo que sea válido en Handlebars es asimismo válido en Ember.

Las plantillas también pueden mostrar propiedades establecidas en su contexto, que puede ser un componente o una ruta (técnicamente, podrían proceder también de un controlador, pero últimamente ya casi no se utiliza de este modo, y de hecho pronto esta práctica pronto quedará obsoleta). Por ejemplo:

```handlebars
< div > ¡Hola {{nombre}}! Esta es una plantilla de Ember totalmente válida. < / div >
```

Donde `{{nombre}}` es una propiedad proporcionada por el contexto de la plantilla.

Además de propiedades, las llaves dobles (`{{}}`) pueden contener también helpers y componentes, que analizaremos más adelante.

## Modelos

Los modelos representan un estado persistente.

Por ejemplo, una aplicación que gestione el alquiler de propiedades debería guardar los detalles de un alquiler cuando un usuario lo publica, con lo que un alquiler tendría un modelo que define sus detalles, que podría llamarse *alquiler*.

Un modelo típicamente persiste información a un servidor web, aunque los modelos se pueden configurar para ser guardados en cualquier otro lugar, como el almacenamiento local del navegador.

## Componentes

Mientras que las plantillas describen cómo se ve una interfaz de usuario, los componentes controlan su *comportamiento*.

Los componentes constan de dos partes: una plantilla de Handlebars y un archivo de código fuente escrito en JavaScript que define el comportamiento del componente. Por ejemplo, nuestra aplicación de gestión de alquileres podría tener un componente para mostrar todos los alquileres llamada `lista-alquileres` y otra para la visualización de un alquiler individual llamada `alquiler`. El componente de `alquiler` podría definir un comportamiento que permita al usuario ocultar y mostrar una imagen de la propiedad a alquilar.

Vamos a ver estos conceptos básicos en acción mediante la construcción de una aplicación de gestión de alquileres de propiedades en la siguiente sección.