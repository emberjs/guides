Mientras buscan un alquiler, usuarios podrían también querer limitar su búsqueda a una ciudad específica. Vamos a construir un componente que les permitirá buscar propiedades dentro de una ciudad y también les sugerirá ciudades mientras escriben.

Para empezar, vamos a generar nuestro nuevo componente. Llamaremos a este componente `filter-listing`.

```shell
ember g component filter-listing
```

Como antes, esto crea una plantilla de Handlebars (`app/templates/components/filter-listing.hbs`) y un archivo JavaScript (`app/components/filter-listing.js`).

La plantilla de Handlebars se ve así:

```app/templates/components/filter-listing.hbs City: {{input value=filter key-up=(action 'autoComplete')}} <button {{action 'search'}}>Search</button>

{{#each filteredList as |item|}} <li {{action 'choose' item.city}}>{{item.city}}</li> {{/each}} 

    Contiene un ['{{input}}'] (../../templates/input-helpers) ayudante que produce un campo de texto donde el usuario puede escribir un patrón para filtrar la lista de ciudades en una búsqueda. La propiedad `value` del `input` se enlazará a la propiedad `filter` de nuestro componente.
    La propiedad 'key-up' se enlazará a la acción de 'autoComplete'.
    
    También contiene un botón enlazado a la acción de `search` en nuestro componente.
    
    Por último, contiene una lista desordenada que muestra la propiedad de `city` de cada elemento de la propiedad `filteredList` en nuestro componente. Haciendo clic en un elemento de la lista, activará la acción `choose` con la propiedad `city` del elemento como parámetro, que luego populara el campo `input` con el nombre de `city`.
    
    Aqui esta el JavaScript del componente:
    
    ```app/components/filter-listing.js
    export default Ember.Component.extend({
      filter: null,
      filteredList: null,
      actions: {
        autoComplete() {
          this.get('autoComplete')(this.get('filter'));
        },
        search() {
          this.get('search')(this.get('filter'));
        },
        choose(city) {
          this.set('filter', city);
        }
      }
    });
    
    

Hay una propiedad para cada una de las propiedades `filter` y `filteredList` y también para cada una de las acciones descritas anteriormente. Lo interesante es que sólo la acción de `choose` está definida por el componente. La lógica de cada una de las acciones `search` y `autoComplete` serán obtenidas de las propiedades del componente, esto significa que estas acciones tienen que ser pasadas \[passed\] (../../components/triggering-changes-with-actions/#toc_passing-the-action-to-the-component) por el objeto que llama a este componente, este patrón es conocido como acciones de cierre *closure actions*.

Para ver como funciona esto, cambia la plantilla `index.hbs` a esto:

```app/templates/index.hbs 

# Welcome to Super Rentals

We hope you find exactly what you're looking for in a place to stay.   
  
{{filter-listing filteredList=filteredList autoComplete=(action 'autoComplete') search=(action 'search')}} {{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} {{/each}}

{{#link-to 'about'}}About{{/link-to}} {{#link-to 'contact'}}Click here to contact us.{{/link-to}}

    Hemos añadido el componente de `filter-listing` a nuestra plantilla 'index.hbs'. We 
    then pass in the functions and properties we want the `filter-listing` 
    component to use, so that the `index` page can define some of how it wants 
    the component to behave, and so the component can use those specific 
    functions and properties.
    
    For this to work, we need to introduce a `controller` into our app. 
    Generate a controller for the `index` page by running the following:
    
    ```shell
    ember g controller index
    

Now, define your new controller like so:

```app/controllers/index.js import Ember from 'ember';

export default Ember.Controller.extend({ filteredList: null, actions: { autoComplete(param) { if (param !== '') { this.get('store').query('rental', { city: param }).then((result) => this.set('filteredList', result)); } else { this.set('filteredList', null); } }, search(param) { if (param !== '') { this.store.query('rental', { city: param }).then((result) => this.set('model', result)); } else { this.get('store').findAll('rental').then((result) => this.set('model', result)); } } } });

    <br />As you can see, we define a property in the controller called 
    `filteredList`, that is referenced from within the `autoComplete` action.
     When the user types in the text field in our component, this is the 
     action that is called. This action filters the `rental` data to look for 
     records in data that match what the user has typed thus far. When this 
     action is executed, the result of the query is placed in the 
     `filteredList` property, which is used to populate the autocomplete list 
     in the component.
    
    We also define a `search` action here that is passed in to the component,
     and called when the search button is clicked. This is slightly different
      in that the result of the query is actually used to update the `model` 
      of the `index` route, and that changes the full rental listing on the 
      page.
    
    For these actions to work, we need to modify the Mirage `config.js` file 
    to look like this, so that it can respond to our queries.
    
    ```mirage/config.js
    export default function() {
      this.get('/rentals', function(db, request) {
        let rentals = [{
            type: 'rentals',
            id: 1,
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
            id: 2,
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
            id: 3,
            attributes: {
              title: 'Downtown Charm',
              owner: 'Violet Beauregarde',
              city: 'Portland',
              type: 'Apartment',
              bedrooms: 3,
              image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg'
            }
          }];
    
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
    

With these changes, users can search for properties in a given city, with a search field that provides suggestions as they type.