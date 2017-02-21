Los componentes pueden recibir propiedades ([Pasando Propiedades a un Componente](../passing-properties-to-a-component/)), pero pueden también retornar output para ser utilizado en una expresión de bloque.

### Retornando valores desde un componente con `yield`

```app/templates/index.hbs
{{blog-post post=model}}
```

<pre><code class="app/templates/components/blog-post.hbs">{{yield post.title post.body post.author}}
</code></pre>

Aquí un modelo completo de una publicación de un blog está siendo pasado al componente como una propiedad única de componente. A su vez, el componente está devolviendo valores utilizando `yield`. En este caso, los valores concedidos son traídos desde la publicación que se está pasando, pero también lo que sea que el componente tenga acceso puede ser concedido, como una propiedad interna o algo desde un servicio.

### Consumiendo valores concedidos con parámetros de bloque

La expresión de bloque puede usar parámetros de bloque para enlazar nombres a cualquier valor concedido para uso en el bloque. Esto permite la personalización de la plantilla cuando se usa un componente, donde el formato es proporcionado por la plantilla para consumo, pero cualquier comportamiento de manejo de evento implementado en el componente es retenido, como los manejos de `click()`.

```app/templates/index.hbs
{{#blog-post post=model as |title body author|}}
  <h2>{{title}}</h2>
  <p class="author">by {{author}}</p>
  <div class="post-body">{{body}}</p>
{{/blog-post}}
```

Los nombres son enlazados en el orden en que son pasados a `yield` en la plantilla de componente.

### Utilizando los modos block y non-block de un componente en una plantilla

Es posible el uso de un componente en ambas formas, block y non-block desde una plantilla única de componente utilizando la propiedad `hasBlock`.

<pre><code class="app/templates/components/blog-post.hbs">{{#if hasBlock}}
  {{yield post.title}}
  {{yield post.body}}
  {{yield post.author}}
{{else}}
  &lt;h1&gt;{{post.title}}&lt;/h1&gt;
  &lt;p class="author"&gt;Authored by {{post.author}}&lt;/p&gt;
  &lt;p&gt;{{post.body}}&lt;/p&gt;
{{/if}}
</code></pre>

Esto tiene el efecto de proporcionar una plantilla predeterminada cuando se utiliza un componente en la forma non-block mientras proporciona valores concedidos para uso con los parámetros de bloque cuando se usa una expresión de bloque.