Hasta ahora, nuestra aplicación está mostrando directamente los datos del usuario a partir de nuestros models (modelos) de Ember Data. A medida que crece nuestra aplicación, queremos manipular los datos antes de mostrarlos a nuestros usuarios. Por este motivo, Ember ofrece helpers para los templates de Handlebars para decorar los datos en nuestras templates (plantillas). Vamos a usar un helper de Handlebars para ayudar a nuestros usuarios a que vean rápidamente si una propiedad es "standalone" (independiente) o parte de una "community" (comunidad).

Para empezar, vamos a generar un helper para `rental-property-type`:

```shell
ember g helper rental-property-type
```

Esto creará dos archivos, nuestro helper y su archivo para pruebas relacionado:

```shell
installing helper
  create app/helpers/rental-property-type.js
installing helper-test
  create tests/unit/helpers/rental-property-type-test.js
```

Nuestro nuevo helper comienza con algún código que viene del generador:

```app/helpers/rental-property-type.js import Ember from 'ember';

export function rentalPropertyType(params/*, hash*/) { return params; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />Let's update our `rental-listing` component template to use our new helper and pass in `rental.type`:
    
    ```app/templates/components/rental-listing.hbs
    <article class="listing">
      <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
        <img src="{{rental.image}}" alt="">
        <small>View Larger</small>
      </a>
      <h3>{{rental.title}}</h3>
      <div class="detail">
        <span>Owner:</span> {{rental.owner}}
      </div>
      <div class="detail">
        <span>Type:</span> {{rental-property-type rental.type}} - {{rental.type}}
      </div>
      <div class="detail">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
      {{location-map location=rental.city}}
    </article>
    

Idealmente vamos a ver "Type: Standalone - Estate" para nuestro primer rental property. En cambio, template helper por defecto retorna los valores de `rental.type`. Vamos a actualizar nuestro helper para ver si existe una property en un arreglo de `communityPropertyTypes`, si así, retornará `'Community'` o `'Standalone'`:

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]/*, hash*/) { if (communityPropertyTypes.contains(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Handlebars pasa un arreglo de argumentos de nuestra plantilla a nuestro helper. Estamos utilizando desestructuración de ES2015 para obtener el primer elemento de la matriz y llamarlo `tipo`. Así podremos comprobar si `type`. existe en nuestro arreglo de `communityPropertyTypes`.

Ahora en nuestro navegador deberíamos ver que la rental property aparece como "Standalone", mientras que los otros dos aparecen como "Community".