Actualmente, nuestra aplicación está utilizando datos hardcoded para *rentals* en el route (ruta) `Índice` para establecer el modelo. A medida que crece nuestra aplicación, queremos ser capaces de crear nuevos rentals, realizar actualizaciones en ellos, borrarlos y guardar estos cambios en un servidor back-end. Ember utiliza una librería de gestión de datos llamada Ember Data para ayudar a resolver este problema.

Vamos a generar nuestro primer model (modelo) en Ember Data llamado `rental`:

```shell
ember g model rental
```

Esto se traduce en la creación de un archivo para el model y otro archivo para realizar una prueba:

```shell
installing model
  create app/models/rental.js
installing model-test
  create tests/unit/models/rental-test.js
```

Cuando abrimos el archivo del model (modelo), vemos:

```app/models/rental.js import Model from 'ember-data/model';

export default Model.extend({

});

    <br />Agreguemos los mismos atributos para nuestro rental que hemos utilizado previamente  en nuestro arreglo hardcoded de objetos Javascript -
    _title_, _owner_, _city_, _type_, _image_, y _bedrooms_:
    
    ```app/models/rental.js
    import Model from 'ember-data/model';
    import attr from 'ember-data/attr';
    
    export default Model.extend({
      title: attr(),
      owner: attr(),
      city: attr(),
      type: attr(),
      image: attr(),
      bedrooms: attr()
    });
    

Ahora tenemos un modelo en nuestro store (depósito) de Ember Data.

## Usando Mirage con Ember Data

Ember Data configurase para guardar datos en una variedad de maneras, pero a menudo se configura para trabajar con un servidor backend de tipo API. Para este tutorial, usaremos [Mirage](http://www.ember-cli-mirage.com). Esto nos permitirá crear datos falsos para trabajar con en el desarrollo de nuestra aplicación y simular un servidor back-end.

Empecemos instalando Mirage:

```shell
ember install ember-cli-mirage
```

Si te encuentras ejecutando `ember serve` en otra línea de comandos, reinicia el servidor para incluir Mirage en tu compilación.

Vamos a configurar ahora Mirage para enviar nuestros rentals que hemos definido anteriormente mediante la actualización de `app/mirage/config.js`:

```app/mirage/config.js export default function() { this.get('/rentals', function() { return { data: [{ type: 'rentals', id: 1, attributes: { title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' } }, { type: 'rentals', id: 2, attributes: { title: 'Urban Living', owner: 'Mike Teavee', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' } }, { type: 'rentals', id: 3, attributes: { title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' } }] }; }); }

    <br />Esto configura Mirage para que cada vez que Ember Data hace una petición GET a `/rentals`, Mirage retornará este objeto JavaScript como JSON.
    
    ### Actualización del Hook del Model
    
    Para usar nuestro nuevo almacén de datos, debemos actualizar el hook de `model` en nuestro route.
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.store.findAll('rental');
      }
    });
    

Cuando llamamos a `this.store.findAll('rental')`, Ember Data hará una petición GET a `/rentals`. Puedes leer más sobre Ember Data en la [sección de models](../../models/).

Debido a que estamos Mirage en nuestro entorno de desarrollo Mirage, Mirage retornará los datos que hemos proporcionado. Cuando despleguemos nuestra aplicación en un servidor de producción, necesitamos proporcionar un backend para que Ember Data se comunique con él.