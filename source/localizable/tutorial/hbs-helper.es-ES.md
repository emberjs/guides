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
    
    ```app/templates/components/rental-listing.hbs{-11,+12}
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
        <span>Type:</span> {{rental.type}}
        <span>Type:</span> {{rental-property-type rental.type}} - {{rental.type}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

Idealmente veremos "Type: Standalone - Estate" para nuestra primera propiedad en alquiler. En cambio, template helper por defecto retorna los valores de `rental.type`. Vamos a actualizar nuestro helper para ver si existe una property en un arreglo de `communityPropertyTypes`, si así, retornará `'Community'` o `'Standalone'`:

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]) { if (communityPropertyTypes.includes(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Each [argument](https://guides.emberjs.com/v2.12.0/templates/writing-helpers/#toc_helper-arguments) in the helper will be added to an array and passed to our helper. For example, `{{my-helper "foo" "bar"}}` would result in `myHelper(["foo", "bar"])`. Using array [ES2015 destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) assignment, we can name expected parameters within the array. In the example above, the first argument in the template will be assigned to `type`. This provides a flexible, expressive interface for your helpers, including optional arguments and default values.

Ahora en nuestro navegador deberíamos ver que la rental property aparece como "Standalone", mientras que los otros dos aparecen como "Community".