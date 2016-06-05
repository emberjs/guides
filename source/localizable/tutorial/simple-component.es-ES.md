Como un usuario mira a través de la lista de los alquileres, puede tener algunas opciones interactivas para ayudarle a tomar una decisión. Vamos a agregar la capacidad para cambiar el tamaño de la imagen de cada alquiler. Para ello, vamos a usar un componente.

Vamos a generar un component (componente) `rental-listing` que gestionará el comportamiento de cada uno de nuestros alquileres. Un guión es necesario en cada nombre de componente para evitar conflicto con un posible elemento HTML, así que `rental-listing` es aceptable pero `Alquiler` no.

```shell
ember g component rental-listing
```

Ember CLI generará entonces varios de archivos de nuestro component (componente):

```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

Empezaremos implementando una prueba de fallos con el comportamiento de alternar la imagen que deseamos.

Para nuestra prueba de integración, vamos a crear un stub para el alquiler que tiene todas las propiedades que tiene nuestro model (modelo) de rental (alquiler). Aseguraremos que el component (componente) se renderice inicialmente sin el nombre de la clase `wide`. Hacer clic en la imagen añadirá la clase `wide` a nuestro elemento y haciendo clic una segunda vez eliminará la clase `wide`. Tenga en cuenta que encontraremos el elemento de la imagen usando el selector CSS `.image`.

```tests/integration/components/rental-listing-test.js import { moduleForComponent, test } from 'ember-qunit'; import hbs from 'htmlbars-inline-precompile'; import Ember from 'ember';

moduleForComponent('rental-listing', 'Integration | Component | rental listing', { integration: true });

test('should toggle wide class on click', function(assert) { assert.expect(3); let stubRental = Ember.Object.create({ image: 'fake.png', title: 'test-title', owner: 'test-owner', type: 'test-type', city: 'test-city', bedrooms: 3 }); this.set('rentalObj', stubRental); this.render(hbs`{{rental-listing rental=rentalObj}}`); assert.equal(this.$('.image.wide').length, 0, 'initially rendered small'); this.$('.image').click(); assert.equal(this.$('.image.wide').length, 1, 'rendered wide after click'); this.$('.image').click(); assert.equal(this.$('.image.wide').length, 0, 'rendered small after second click'); });

    <br />Un componente consta de dos partes:
    
    * una plantilla que define cómo se verá ('app/templates/components/rental-listing.hbs')
    * Un archivo de código JavaScript ('app/components/rental-listing.js') que define cómo se comportará.
    
    Nuestro nuevo componente 'rental-listing' gestionará cómo un usuario ve e interactúa con un alquiler.
    To start, let's move the rental display details for a single rental from the `index.hbs` template into `rental-listing.hbs` and add the image field:
    
    ```app/templates/components/rental-listing.hbs{+2}
    <article class="listing">
      <img src="{{rental.image}}" class="image" alt="">
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Type:</span> {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

En nuestra template (plantilla) `index.hbs`, reemplacemos el código HTML antiguo dentro de nuestro loop `{{#each}}` con nuestro nuevo component (componente) `rental-listing`:

```app/templates/index.hbs{+14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29} 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    ¡Bienvenido!
  </h2>
  
  <p>
    Esperamos que encuentres exactamente lo que buscas en un lugar para quedarte. <br />Navega nuestro listado, o usa la búsqueda en la parte superior para refinar tu búsqueda.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

{{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} <article class="listing"> 

### {{rental.title}}

<div class="detail owner">
  <span>Owner:</span> {{rental.owner}}
</div>

<div class="detail type">
  <span>Type:</span> {{rental.type}}
</div>

<div class="detail location">
  <span>Location:</span> {{rental.city}}
</div>

<div class="detail bedrooms">
  <span>Number of bedrooms:</span> {{rental.bedrooms}}
</div></article> {{/each}}

    Aquí invocamos el componente (compoente) `rental-listing` utilizando su nombre y asignamos cada `rentalUnit` como el atributo `rental` del component (componente).
    
    ## Ocultando y mostrando una imagen 
    
    Ahora podemos añadir la funcionalidad que mostrará la imagen de un alquiler cuando sea solicitado por el usuario.
    
    Vamos a usar el ayudante `{{#if}}`para mostrar nuestra imagen actual de alquiler más grande sólo cuando `isWide` se defina como true, estableciendo el nombre de la clase de elemento como `wide`. También vamos a añadir algún texto para indicar que la imagen puede cliquearse y envolverla con un enlace, dándole `image` como nombre de clase para que nuestro test puede encontrarla.
    
    ```app/templates/components/rental-listing.hbs{+2,+4,+5}
    <article class="listing">
      <a class="image {{if isWide "wide"}}">
        <img src="{{rental.image}}" alt="">
        <small>View Larger</small>
      </a>
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Type:</span> {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

El valor de `isWide` viene del archivo JavaScript de nuestro componente, en este caso `rental-listing.js`. Ya que no queremos que la imagen sea más pequeña al principio, la propiedad inicia como `false`:

```app/components/rental-listing.js import Ember from 'ember';

export default Ember.Component.extend({ isWide: false });

    <br />Para permitir al usuario ampliar la imagen, tendremos que añadir una action (acción) que cambia el valor de 'isWide'.
    Let's call this action `toggleImageSize`
    
    ```app/templates/components/rental-listing.hbs{+2}
    <article class="listing">
      <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
        <img src="{{rental.image}}" alt="">
        <small>View Larger</small>
      </a>
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Type:</span> {{rental-property-type rental.type}} - {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

Hacer click al enlace, enviará la action (acción) al component (componente). Ember entonces irá al hash `actions` y llamará a la función `toggleImageSize`. Creemos la función `toggleImageSize` y cambiaremos la propiedad `isWide` en el component (componente):

```app/components/rental-listing.js{+5,+6,+7,+8,+9} import Ember from 'ember';

export default Ember.Component.extend({ isWide: false, actions: { toggleImageSize() { this.toggleProperty('isWide'); } } }); ```

Cuando hagamos clic en la imagen o el enlace `View Larger` en nuestro navegador, veremos nuestra imagen de muestra más grande, o cuando hagamos clic en la imagen ampliada otra vez la veremos más pequeña.

![listado de alquileres con expandir](../../images/simple-component/styled-rental-listings.png)