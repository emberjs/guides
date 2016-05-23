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

### Updating the Model Hook

To use our new data store, we need to update the `model` hook in our route handler.

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.store.findAll('rental'); } }); ```

When we call `this.store.findAll('rental')`, Ember Data will make a GET request to `/rentals`. You can read more about Ember Data in the [Models section](../../models/).

Since we're using Mirage in our development environment, Mirage will return the data we've provided. When we deploy our app to a production server, we will need to provide a backend for Ember Data to communicate with.