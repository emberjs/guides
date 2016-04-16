Enquanto buscam por uma locação, usuários podem querer também restringir a pesquisa para uma cidade específica. Vamos construir um componente que vai deixá-los procurar propriedades em uma cidade e também sugerir cidades enquanto eles digitam.

Para começar, vamos gerar nosso novo componente. Nós vamos chama-lo de `filter-listing`.

```shell
ember g component filter-listing
```

Como antes, isso cria um template em Handlebars (`app/templates/components/filter-listing.hbs`) e um arquivo JavaScript (`app/components/filter-listing.js`).

O template Handlebars parece com isso:

```app/templates/components/filter-listing.hbs City: {{input value=filter key-up=(action 'autoComplete')}} <button {{action 'search'}}>Search</button>

{{#each filteredList as |item|}} <li {{action 'choose' item.city}}>{{item.city}}</li> {{/each}} 

    Ele contém um auxiliar [`{{input}}`] (../../ templates/input-helpers) que renderiza como um campo de texto onde o usuário pode digitar para filtrar a lista de cidades utilizadas em uma pesquisa. A propriedade `value` do `input` vai ser vinculada à propriedade do `filter` no nosso componente.
    A propriedade `key-up` vai ser vinculada à ação `autoComplete`.
    
    Ele também contém um botão que está vinculado à ação de `search` em nosso componente.
    
    Por último, ele contém uma lista não ordenada que exibe a propriedade `city` de cada item de `filteredList` do nosso componente. Clicando no item da lista será acionado a ação `choose` passando a propriedade `city` como um parâmetro, que então preencherá o campo `input` com o nome da `city`.
    
    Aqui é como o arquivo JavaScript do componente fica:
    
    
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
    
    

Existe uma propriedade para cada `filter` e `filteredList` e ações como descrito acima. O interessante é que somente a ação de escolha `choose` é definida pelo componente. A lógica real de cada uma das ações `autoComplete` e `search` são puxados das propriedades do componente, o que significa que essas ações devem ser passadas \[passed\] (../../components/triggering-changes-with-actions/#toc_passing-the-action-to-the-component) pelo objeto na chamada, um padrão conhecido como *closure actions*.

Para ver como isso funciona, mude seu template `index.hbs` para ficar assim:

```app/templates/index.hbs 

# Welcome to Super Rentals

We hope you find exactly what you're looking for in a place to stay.   
  
{{filter-listing filteredList=filteredList autoComplete=(action 'autoComplete') search=(action 'search')}} {{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} {{/each}}

{{#link-to 'about'}}About{{/link-to}} {{#link-to 'contact'}}Click here to contact us.{{/link-to}}

    We've added the `filter-listing` component to our `index.hbs` template. We 
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