Currently, our app is using hard-coded data for *rentals* in the `rentals` route handler to set the model. A medida que crece nuestra aplicación, queremos ser capaces de crear nuevos rentals, realizar actualizaciones en ellos, borrarlos y guardar estos cambios en un servidor back-end. Ember utiliza una librería de gestión de datos llamada Ember Data para ayudar a resolver este problema.

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

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />Let's add the same attributes for our rental that we used in our hard-coded array of JavaScript objects -
    _title_, _owner_, _city_, _type_, _image_, _bedrooms_ and _description_:
    
    ```app/models/rental.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      title: DS.attr(),
      owner: DS.attr(),
      city: DS.attr(),
      type: DS.attr(),
      image: DS.attr(),
      bedrooms: DS.attr(),
      description: DS.attr()
    });
    

Ahora tenemos un modelo en nuestro store (depósito) de Ember Data.

### Actualizando el Model Hook

Para usar nuestro nuevo almacén de datos, debemos actualizar el gancho `model` en nuestro route (ruta).

```app/routes/rentals.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('rental'); } }); ```

When we call `this.get('store').findAll('rental')`, Ember Data will make a GET request to `/rentals`. Puedes leer más sobre Ember Data en la [sección de models](../../models/).

Debido a que estamos Mirage en nuestro entorno de desarrollo, Mirage retornará los datos que hemos proporcionado. Cuando despleguemos nuestra aplicación en un servidor de producción, necesitamos proporcionar un backend para que Ember Data se comunique con él.