Até o momento, nossa aplicação está exibindo os dados de usuário diretamente do nosso model através do Ember Data. Conforme nossa aplicação cresce, vamos querer manipular dados adicionais antes de apresentá-lo aos nossos usuários. Por esta razão, Ember oferece templates helpers em Handlebars para nos ajudar a tratar dados em nossos templates. Vamos usar um handlebars helper para permitir que nossos usuários possam, rapidamente, ver se uma propriedade é "standalone" ou parte de uma "Community".

Para começar, vamos gerar um helper para `rental-property-type`:

```shell
ember g helper rental-property-type
```

Isso irá criar dois arquivos, nosso helper e seu arquivo test relacionado:

```shell
installing helper
  create app/helpers/rental-property-type.js
installing helper-test
  create tests/unit/helpers/rental-property-type-test.js
```

Nosso novo helper vem com um código padrão do generator:

```app/helpers/rental-property-type.js import Ember from 'ember';

export function rentalPropertyType(params/*, hash*/) { return params; }

export default Ember.Helper.helper(rentalPropertyType);

    <br />Vamos atualizar nosso component template `rental-listing` para usar nosso novo helper e passar para o helper o parâmetro `rental.type`:
    
    ```app/templates/components/rental-listing.hbs{-11,+12}
    <article class="listing">
      <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
        <img src="{{rental.image}}" alt="">
        <small>Ampliar</small>
      </a>
      <h3>{{rental.title}}</h3>
      <div class="detail owner">
        <span>Proprietário:</span> {{rental.owner}}
      </div>
      <div class="detail type">
        <span>Tipo:</span> {{rental.type}}
        <span>Tipo:</span> {{rental-property-type rental.type}} - {{rental.type}}
      </div>
      <div class="detail location">
        <span>Localização:</span> {{rental.city}}
      </div>
      <div class="detail bedrooms">
        <span>Número de quartos:</span> {{rental.bedrooms}}
      </div>
    </article>
    

Ideally we'll see "Type: Standalone - Estate" for our first rental property. Instead, our default template helper is returning back our `rental.type` values. Let's update our helper to look if a property exists in an array of `communityPropertyTypes`, if so, we'll return either `'Community'` or `'Standalone'`:

```app/helpers/rental-property-type.js import Ember from 'ember';

const communityPropertyTypes = [ 'Condo', 'Townhouse', 'Apartment' ];

export function rentalPropertyType([type]/*, hash*/) { if (communityPropertyTypes.includes(type)) { return 'Community'; }

return 'Standalone'; }

export default Ember.Helper.helper(rentalPropertyType); ```

Handlebars passes an array of arguments from our template to our helper. We are using ES2015 destructuring to get the first item in the array and name it `type`. Then we can check to see if `type` exists in our `communityPropertyTypes` array.

Now in our browser we should see that the first rental property is listed as "Standalone", while the other two are listed as "Community".