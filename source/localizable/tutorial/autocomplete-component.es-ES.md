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

# Bienvenido a Super Rentals

Espero que encuentres exactamente lo que buscas en un lugar para quedarte.   
  
{{filter-listing filteredList=filteredList autoComplete=(action 'autoComplete') search=(action 'search')}} {{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} {{/each}}

{{#link-to 'about'}}About{{/link-to}} {{#link-to 'contact'}}Click here to contact us.{{/link-to}}

    Hemos añadido el componente de `filter-listing` a nuestra plantilla 'index.hbs'. Luego pasamos en las funciones y propiedades que queremos que el component (componente) de `filter-listing` a utilizar, para que la página de `index` pueda definir como quiere el component (componente) se comporte, y así que el component (componente) pueda utilizar las propiedades y funciones específicas.
    
    Para que esto funcione, necesitamos introducir un `controller` (controlador) en nuestra aplicación. Genera un controlador para la página de `index` ejecutando lo siguiente:
    
    ```shell
    ember g controller index
    

Ahora bien, define tu nuevo controlador de esta manera:

```app/controllers/index.js import Ember from 'ember';

export default Ember.Controller.extend({ filteredList: null, actions: { autoComplete(param) { if (param !== '') { this.get('store').query('rental', { city: param }).then((result) => this.set('filteredList', result)); } else { this.set('filteredList', null); } }, search(param) { if (param !== '') { this.store.query('rental', { city: param }).then((result) => this.set('model', result)); } else { this.get('store').findAll('rental').then((result) => this.set('model', result)); } } } });

    <br />Como puedes ver, definimos una propiedad en el controller (controlador) llamada `filteredList'` que es referenciada desde dentro del action (acción) `autocomplete`.
     Cuando el usuario escribe en el campo de texto en nuestro component (componente), este es el action (acción) que se llama. Este action (acción) filtra la información de `rental` para buscar por los registros de datos que coincidan con lo que el usuario ha escrito hasta ahora. Cuando se ejecuta esta acción, el resultado de la consulta se coloca en la propiedad `filteredList` que se utiliza para rellenar la lista de autocompletar en el component (componente).
    
    También definimos una action (acción) `search` que se pasa al component(componente), y se llama cuando se hace clic en el botón search. Esto es ligeramente diferente en que el resultado de la consulta realmente se utiliza para actualizar el `model`(modelo) de la ruta `index`, y que cambia el listado completo de alquiler en la página.
    
    Para que estas acciones funcionen, debemos modificar el archivo `config.js` de Mirage para que se vea como este y pueda responder a nuestras consultas.
    
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
    

Con estos cambios, los usuarios pueden buscar propiedades en una ciudad determinada, con un campo de búsqueda que ofrece sugerencias mientras escribe.