As they search for a rental, users might also want to narrow their search to a specific city. Let's build a component that will let them filter rentals by city.

To begin, let's generate our new component. We'll call this component `list-filter`, since all we want our component to do is filter the list of rentals based on input.

```shell
ember g component list-filter
```

As before, this creates a Handlebars template (`app/templates/components/list-filter.hbs`), a JavaScript file (`app/components/list-filter.js`), and a component integration test (`tests/integration/components/list-filter-test.js`).

Vamos a empezar a escribir algunos tests que nos permitan pensar acerca de lo que estamos realizando. El component (componente) del filtro debería generar una lista de elementos filtrados respecto a lo que se procese dentro de este, conocido como su bloque de template interno. We want our component to call out to two actions: one action to provide a list of all items when no filter is provided, and the other action to search listings by city.

Para nuestra prueba inicial, simplemente comprobamos que todas las ciudades que proveemos son renderizadas y que el object del anuncio es accesible desde el template (plantilla).

Ya que planeamos utilizar Ember Data como nuestro almacén de modelos, necesitamos llamar nuestras actions (acciones) para traer los datos de forma asíncrona, por lo que retornaremos promises (promesas). Debido a que acceder a los datos persistentes por lo general se realiza de forma asíncrona, queremos utilizar el helper wait al final de nuestro test, que espera que todas las promesas se resuelvan antes de completar el test.

```tests/integration/components/list-filter-test.js import { moduleForComponent, test } from 'ember-qunit'; import hbs from 'htmlbars-inline-precompile'; import wait from 'ember-test-helpers/wait'; import RSVP from 'rsvp';

moduleForComponent('list-filter', 'Integration | Component | filter listing', { integration: true });

const ITEMS = [{city: 'San Francisco'}, {city: 'Portland'}, {city: 'Seattle'}]; const FILTERED_ITEMS = [{city: 'San Francisco'}];

test('should initially load all listings', function (assert) { // we want our actions to return promises, since they are potentially fetching data asynchronously this.on('filterByCity', (val) => { if (val === '') { return RSVP.resolve(ITEMS); } else { return RSVP.resolve(FILTERED_ITEMS); } });

// with an integration test, you can set up and use your component in the same way your application // will use it. this.render(hbs`{{#list-filter filter=(action 'filterByCity') as |results|}}
      <ul>
      {{#each results as |item|}}
        <li class="city">
          {{item.city}}
        </li>
      {{/each}}
      </ul>
    {{/list-filter}}`);

// the wait function will return a promise that will wait for all promises // and xhr requests to resolve before running the contents of the then block. return wait().then(() => { assert.equal(this.$('.city').length, 3); assert.equal(this.$('.city').first().text().trim(), 'San Francisco'); }); });

    Para el segundo test, comprobamos que escribiendo texto en el filtro realmente ejecutará la action (acción) de filtrado y actualización de la lista que se muestra.
    
    Forzamos la acción mediante la generación de un evento 'keyUp' en el campo input y luego nos aseguramos (assert) que sólo un elemento se renderiza.
    
    ```tests/integration/components/list-filter-test.js
    test('should update with matching listings', function (assert) {
      this.on('filterByCity', (val) => {
        if (val === '') {
          return RSVP.resolve(ITEMS);
        } else {
          return RSVP.resolve(FILTERED_ITEMS);
        }
      });
    
      this.render(hbs`
        {{#list-filter filter=(action 'filterByCity') as |results|}}
          <ul>
          {{#each results as |item|}}
            <li class="city">
              {{item.city}}
            </li>
          {{/each}}
          </ul>
        {{/list-filter}}
      `);
    
      // The keyup event here should invoke an action that will cause the list to be filtered
      this.$('.list-filter input').val('San').keyup();
    
      return wait().then(() => {
        assert.equal(this.$('.city').length, 1);
        assert.equal(this.$('.city').text().trim(), 'San Francisco');
      });
    });
    
    

Next, in our `app/templates/rentals.hbs` file, we'll add our new `list-filter` component in a similar way to what we did in our test. Instead of just showing the city, we'll use our `rental-listing` component to display details of the the rental.

```app/templates/rentals.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    ¡Bienvenido!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

{{#list-filter filter=(action 'filterByCity') as |rentals|}} 

<ul class="results">
  {{#each rentals as |rentalUnit|}} 
  
  <li>
    {{rental-listing rental=rentalUnit}}
  </li> {{/each}}
</ul> {{/list-filter}}

    <br />Ahora que tenemos tests para los fallos y una idea de lo que el contrato del component (componente) debería ser, implementaremos el componente.
    Queremos que el componente simplemente proporcione un campo de entrada y ceda la lista de resultados a su bloque, por lo que nuestra template (plantilla) será simple:
    
    ```app/templates/components/list-filter.hbs
    {{input value=value key-up=(action 'handleFilterEntry') class="light" placeholder="Filter By City"}}
    {{yield results}}
    

La plantilla contiene un helper [`{{input}}`](../../templates/input-helpers) que se renderiza como un campo de texto, en donde el usuario puede escribir un patrón para filtrar la lista de ciudades utilizadas en la búsqueda. La propiedad `value` del campo `input` estará ligada a la propiedad `value` en nuestro component (componente). La propiedad `key-up` estará ligada a la acción `handleFilterEntry`.

Así es como se ve el JavaScript del component (componente):

```app/components/list-filter.js import Ember from 'ember';

export default Ember.Component.extend({ classNames: ['list-filter'], value: '',

init() { this._super(...arguments); this.get('filter')('').then((results) => this.set('results', results)); },

actions: { handleFilterEntry() { let filterInputValue = this.get('value'); let filterAction = this.get('filter'); filterAction(filterInputValue).then((filterResults) => this.set('results', filterResults)); } }

});

    <br />Utilizaremos el gancho `init` para llenar nuestros listados iniciales, llamando la action (acción) `filter` con un valor vacío.
    Nuestra acción 'handleFilterEntry' llama a nuestra acción de filtro basado en el atributo `value` establecido por el helper de campo de texto.
    
    The `filter` action is [passed](../../components/triggering-changes-with-actions/#toc_passing-the-action-to-the-component) in by the calling object. Este es un patrón llamado _closure actions_.
    
    Para implementar estas acciones, crearemos el controller (controlador) index para la aplicación.  El controller (controlador) index es ejecutado cuando el usuario va a la route (ruta) base index de la aplicación.
    
    Generate a controller for the `index` page by running the following:
    
    ```shell
    ember g controller rentals
    

Ahora bien, define tu nuevo controlador de esta manera:

```app/controllers/rentals.js import Ember from 'ember';

export default Ember.Controller.extend({ actions: { filterByCity(param) { if (param !== '') { return this.get('store').query('rental', { city: param }); } else { return this.get('store').findAll('rental'); } } } });

    <br />Cuando el usuario escribe en el campo de texto en nuestro component (componente), este es el action (acción) que se llama.
    Esta acción toma la propiedad `value` y filtra los datos de `rental` para los registros en almacén de datos que coincidan con lo que el usuario ha escrito hasta ahora.
    El resultado de la consulta se devuelve a quien llama la función.
    
    For this action to work, we need to replace our Mirage `config.js` file with the following, so that it can respond to our queries.
    
    ```mirage/config.js
    export default function() {
      this.namespace = '/api';
    
      let rentals = [{
          type: 'rentals',
          id: 'grand-old-mansion',
          attributes: {
            title: 'Grand Old Mansion',
            owner: 'Veruca Salt',
            city: 'San Francisco',
            type: 'Estate',
            bedrooms: 15,
            image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg'
          }
        }, {
          type: 'rentals',
          id: 'urban-living',
          attributes: {
            title: 'Urban Living',
            owner: 'Mike Teavee',
            city: 'Seattle',
            type: 'Condo',
            bedrooms: 1,
            image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg'
          }
        }, {
          type: 'rentals',
          id: 'downtown-charm',
          attributes: {
            title: 'Downtown Charm',
            owner: 'Violet Beauregarde',
            city: 'Portland',
            type: 'Apartment',
            bedrooms: 3,
            image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg'
          }
        }];
    
      this.get('/rentals', function(db, request) {
        if(request.queryParams.city !== undefined) {
          let filteredRentals = rentals.filter(function(i) {
            return i.attributes.city.toLowerCase().indexOf(request.queryParams.city.toLowerCase()) !== -1;
          });
          return { data: filteredRentals };
        } else {
          return { data: rentals };
        }
      });
    }
    

Después de actualizar la configuración de mirage, deberíamos ver los tests pasando, así como un simple filtro en la pantalla principal, que se actualizará la lista de alquiler mientras escribes:

![pantalla de inicio con el componente de filtro](../../images/autocomplete-component/styled-super-rentals-filter.png)

![passing acceptance tests](../../images/autocomplete-component/passing-acceptance-tests.png)