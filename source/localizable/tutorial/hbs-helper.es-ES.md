Hasta ahora, nuestra aplicación está mostrando directamente los datos del usuario a partir de nuestros models (modelos) de Ember Data. A medida que crece nuestra aplicación, queremos manipular los datos antes de mostrarlos a nuestros usuarios. Por este motivo, Ember ofrece helpers para los templates de Handlebars para decorar los datos en nuestras templates (plantillas). Let's use a handlebars helper to allow our users to quickly see if a property is "Standalone" or part of a "Community".

Para empezar, vamos a generar un helper para `rental-property-type`:

```shell
ember g helper rental-property-type
```

Esto creará dos archivos, nuestro helper y su archivo para pruebas relacionado:

```shell
installing helper
  create app/helpers/rental-property-type.js
installing helper-test
  create tests/integration/helpers/rental-property-type-test.js
```

Nuestro nuevo helper comienza con algún código que viene del generador:

```app/helpers/rental-property-type.js import Ember from 'ember';

export function rentalPropertyType(params/*, hash*/) { return params; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />Let's update our `rental-listing` component template to use our new helper and pass in `rental.propertyType`:
    
    ```app/templates/components/rental-listing.hbs{-11,+12,+13}
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
        <span>Type:</span> {{rental.propertyType}}
        <span>Type:</span> {{rental-property-type rental.propertyType}}
          - {{rental.propertyType}}
      </div>
      <div class="detail location">
        <span>Location:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Number of bedrooms:</span> {{rental.bedrooms}}
      </div>
    </article>
    

Idealmente veremos "Type: Standalone - Estate" para nuestra primera propiedad en alquiler. Instead, our default template helper is returning back our `rental.propertyType` values. Vamos a actualizar nuestro helper para ver si existe una property en un arreglo de `communityPropertyTypes`, si así, retornará `'Community'` o `'Standalone'`:

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([propertyType]) { if (communityPropertyTypes.includes(propertyType)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />Each [argument](https://guides.emberjs.com/v2.12.0/templates/writing-helpers/#toc_helper-arguments) in the helper will be added to an array and passed to our helper. For example, `{{my-helper "foo" "bar"}}` would result in `myHelper(["foo", "bar"])`. Using array [ES2015 destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) assignment, we can name expected parameters within the array. In the example above, the first argument in the template will be assigned to `propertyType`. This provides a flexible, expressive interface for your helpers, including optional arguments and default values.
    
    Now in our browser we should see that the first rental property is listed as "Standalone",
    while the other two are listed as "Community".
    
    
    ### Integration Test
    
    Update the content of the integration test to the following to fix it:
    
    ```/tests/integration/helpers/rental-property-type-test.js{-15,+16}
    
    import { moduleForComponent, test } from 'ember-qunit';
    import hbs from 'htmlbars-inline-precompile';
    
    moduleForComponent('rental-property-type', 'helper:rental-property-type', {
      integration: true
    });
    
    // Replace this with your real tests.
    test('it renders', function(assert) {
      this.set('inputValue', '1234');
    
      this.render(hbs`{{rental-property-type inputValue}}`);
    
      assert.equal(this.$().text().trim(), '1234');
      assert.equal(this.$().text().trim(), 'Standalone');
    });