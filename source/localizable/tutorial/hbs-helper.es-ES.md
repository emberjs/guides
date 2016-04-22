Hasta ahora, nuestra aplicación está mostrando directamente los datos del usuario a partir de nuestros models (modelos) de Ember Data. A medida que crece nuestra aplicación, queremos manipular los datos antes de mostrarlos a nuestros usuarios. Por este motivo, Ember ofrece helpers para los templates de Handlebars para decorar los datos en nuestras templates (plantillas). Vamos a usar un helper de Handlebars para ayudar a nuestros usuarios a que vean rápidamente si una propiedad es "standalone" (independiente) o parte de una "community" (comunidad).

Para empezar, vamos a generar un helper para `rental-property-type`:

```shell
ember g helper rental-property-type
```

This will create two files, our helper and its related test:

```shell
installing helper
  create app/helpers/rental-property-type.js
installing helper-test
  create tests/unit/helpers/rental-property-type-test.js
```

Our new helper starts out with some boilerplate code from the generator:

```app/helpers/rental-property-type.js import Ember from 'ember';

export function rentalPropertyType(params/*, hash*/) { return params; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />Let's update our `rental-listing` component template to use our new helper and pass in `rental.type`:
    
    ```app/templates/components/rental-listing.hbs
    <h2>{{rental.title}}</h2>
    <p>Owner: {{rental.owner}}</p>
    <p>Type: {{rental-property-type rental.type}} - {{rental.type}}</p>
    <p>Location: {{rental.city}}</p>
    <p>Number of bedrooms: {{rental.bedrooms}}</p>
    {{#if isImageShowing }}
      <p><img src={{rental.image}} alt={{rental.type}} width="500px"></p>
      <button {{action "imageHide"}}>Hide image</button>
    {{else}}
      <button {{action "imageShow"}}>Show image</button>
    {{/if}}
    

Ideally we'll see "Type: Standalone - Estate" for our first rental property. Instead, our default template helper is returning back our `rental.type` values. Let's update our helper to look if a property exists in an array of `communityPropertyTypes`, if so, we'll return either `'Community'` or `'Standalone'`:

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]/*, hash*/) { if (communityPropertyTypes.contains(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Handlebars passes an array of arguments from our template to our helper. We are using ES2015 destructuring to get the first item in the array and name it `type`. Then we can check to see if `type` exists in our `communityPropertyTypes` array.

Now in our browser we should see that the first rental property is listed as "Standalone", while the other two are listed as "Community".