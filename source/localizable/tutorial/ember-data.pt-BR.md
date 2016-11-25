Atualmente, nosso app está usando dados estáticos para *rentals* no gerenciamento de rotas (Router) `rentals` para definir o modelo. Conforme nossa aplicação vai crescendo, queremos ser capazes de criar, atualizar, excluir e salvar essas alterações de rentals em um servidor back-end. Ember vem integrado com uma biblioteca de gerenciamento de dados chamada Ember Data, para nos ajudar a resolver este problema.

Vamos gerar nosso primeiro Ember Data model chamado `rental`:

```shell
ember g model rental
```

Esse comando resulta na criação dos arquivos de model e test:

```shell
installing model
  create app/models/rental.js
installing model-test
  create tests/unit/models/rental-test.js
```

Quando abrimos o arquivo de model, vemos:

```app/models/rental.js import DS from 'ember-data';

export default DS.Model.extend({

});

    <br />Vamos adicionar os mesmos atributos para o nosso rental que usamos na matriz de objetos JavaScript -
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
    

Agora temos um model na nossa Ember Data store.

### Atualizando o Model Hook

Para usar a nossa nova data store, precisamos atualizar o `model` hook em nosso manipulador de rota (route).

```app/routes/rentals.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('rental'); } }); ```

Quando chamamos `this.get('store').findAll('rental')`, o Ember Data fará uma requisição GET em `/rentals`. Você pode ler mais sobre Ember Data na [seção de Models](../../models/).

Uma vez que estamos utilizando ember-cli-mirage em nosso ambiente de desenvolvimento, o próprio Mirage vai retornar os dados que fornecemos. Quando realizamos o deploy da aplicação para um servidor em produção, precisamos fornecer um back-end para se comunicar com o Ember Data.