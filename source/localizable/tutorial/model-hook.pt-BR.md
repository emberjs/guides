Agora, vamos adicionar uma lista de alugueres ao template index. Sabemos que os alugueres não vão ser estáticos, visto que eventualmente os utilizadores vão poder adicionar, atualizar e apagar. Por esta razão, precisaremos de um modelo *rentals* para guardar a informação sobre os alugueres. Para manter as coisas simples no início, usaremos um array hard-coded com objetos JavaScript. Mais tarde, passaremos a usar Ember Data, uma biblioteca para gerir robustamente os dados na nossa aplicação.

Aqui está como a nossa homepage parecerá quando acabarmos:

![super rentals homepage with rentals list](../../images/models/super-rentals-index-with-list.png)

In Ember, route handlers are responsible for loading model data. Let's open `app/routes/index.js` and add our hard-coded data as the return value of the `model` hook:

```app/routes/index.js import Ember from 'ember';

var rentals = [{ id: 1, title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' }, { id: 2, title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' }, { id: 3, title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' }];

export default Ember.Route.extend({ model() { return rentals; } });

    <br />Here, we are using the ES6 shorthand method definition syntax: `model()` is the same as writing `model: function()`.
    
    A função `model` age como um **hook**, o que significa que o Ember o invocará por nós em diferentes fases da nossa aplicação.
    O hook model que adicionamos à nossa rota `index` será invocado quando o utilizador entrar na rota `index`.
    
    The `model` hook returns our _rentals_ array and passes it to our `index` template as the `model` property.
    
    Agora, mudemos para o nosso template.
    Podemos usar os dados do modelo para mostrar uma lista de alugueres.
    Aqui, usaremos outro helper Handlebars comum chamado `{{each}}`.
    Este helper permitirá iterar cada um dos objetos no nosso modelo:
    
    ```app/templates/index.hbs
    <h1>Welcome to Super Rentals</h1>
    
    <p>We hope you find exactly what you're looking for in a place to stay.</p>
    
    {{#each model as |rental|}}
      <h2>{{rental.title}}</h2>
      <p>Owner: {{rental.owner}}</p>
      <p>Type: {{rental.type}}</p>
      <p>Location: {{rental.city}}</p>
      <p>Number of bedrooms: {{rental.bedrooms}}</p>
    {{/each}}
    
    {{#link-to "about"}}About{{/link-to}}
    {{#link-to "contact"}}Click here to contact us.{{/link-to}}
    ```
    

Neste template, iteramos cada objecto no modelo e chamamos-lhe *rental*. Por cada <0>rental</0> criamos uma listagem com informações relacionadas com a propriedade.