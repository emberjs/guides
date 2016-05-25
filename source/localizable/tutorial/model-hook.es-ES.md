Ahora, vamos a añadir una lista de los alquileres disponibles en la template (plantilla) index. Sabemos que los rentals no son estáticos, debido a que eventualmente los usuarios podrán agregarlos, actualizarlos y borrarlos. Por esta razón, necesitaremos un model (modelo) de *rentals* para guardar información acerca de los alquileres. Para mantener las cosas simples inicialmente, usaremos un arreglo de objectos JavaScript hardcoded. Después, empezaremos a usar Ember Data, una biblioteca para manejar los datos robustamente en nuestra aplicación.

Así se verá nuestra página principal cuando terminemos:

![super rentals homepage with rentals list](../../images/models/super-rentals-index-with-list.png)

En Ember, los route handlers (manejadores de ruta) son responsables de cargar la información de los modelos. Vamos a abrir `app/routes/index.js` y añadir nuestros datos hardcoded como el valor que retorne el gancho `model`:

```app/routes/index.js import Ember from 'ember';

var rentals = [{ id: 1, title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' }, { id: 2, title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' }, { id: 3, title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' }];

export default Ember.Route.extend({ model() { return rentals; } });

    <br />Acá estamos usando la sintaxis corta de ES6 para la definición de métodos: `model ()` es lo mismo que escribir `model: function ()`.
    
    La función `model` actúa como un **gancho**, lo que significa que Ember lo llamará por nosotros durante diferentes momentos en nuestra aplicación.
    
    El gancho del modelo que hemos agregado para nuestra route (ruta) `index` será llamado cuando un el usuario entre a la route (ruta) `index`.
    
    El gancho `model` retorna nuestro arreglo _rentals_ y la pasa a la template (plantilla) como la propiedad `model`.
    
    Ahora, vamos a pasar a nuestra plantilla.
    We can use the model data to display our list of rentals.
    Here, we'll use another common Handlebars helper called `{{each}}`.
    Este helper nos permitirá recorrer cada uno de los objetos del modelo:
    
    ```app/templates/index.hbs
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>Welcome!</h2>
      <p>
        We hope you find exactly what you're looking for in a place to stay.
        <br>Browse our listings, or use the search box above to narrow your search.
      </p>
      {{#link-to 'about' class="button"}}
        About Us
      {{/link-to}}
    </div>
    
    {{#each model as |rental|}}
      <article class="listing">
        <h3>{{rental.title}}</h3>
        <div class="detail">
          <span>Owner:</span> {{rental.owner}}
        </div>
        <div class="detail">
          <span>Type:</span> {{rental.type}}
        </div>
        <div class="detail">
          <span>Location:</span> {{rental.city}}
        </div>
        <div class="detail">
          <span>Number of bedrooms:</span> {{rental.bedrooms}}
        </div>
      </article>
    {{/each}}
    

In this template, we loop through each model object and call it *rental*. For each rental, we then create a listing with information about the property.