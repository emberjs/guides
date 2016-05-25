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

### Actualizando el Model Hook

Para usar nuestro nuevo almacén de datos, debemos actualizar el gancho `model` en nuestro route (ruta).

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.store.findAll('rental'); } }); ```

Cuando llamamos a `this.store.findAll('rental')`, Ember Data hará una petición GET a `/rentals`. Puedes leer más sobre Ember Data en la [sección de models](../../models/).

Debido a que estamos Mirage en nuestro entorno de desarrollo, Mirage retornará los datos que hemos proporcionado. Cuando despleguemos nuestra aplicación en un servidor de producción, necesitamos proporcionar un backend para que Ember Data se comunique con él.