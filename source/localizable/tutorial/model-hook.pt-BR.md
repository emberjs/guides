Agora, vamos adicionar uma lista de aluguéis ao template index. Sabemos que os aluguéis não vão ser estáticos, visto que eventualmente os usuários vão poder adicionar, atualizar e apagar. Por esta razão, precisaremos de um modelo *rentals* para guardar a informação sobre os aluguéis. Para manter as coisas simples no início, usaremos um array hard-coded com objetos JavaScript. Mais tarde, passaremos a usar Ember Data, uma biblioteca para gerir robustamente os dados na nossa aplicação.

Aqui está como a nossa homepage parecerá quando acabarmos:

![super rentals homepage with rentals list](../../images/models/super-rentals-index-with-list.png)

No Ember, gerenciamento de rotas (Router) são responsáveis por carregar os dados do modelo (model). Vamos abrir `app/routes/rentals.js` e adicionar os dados fixos como um valor de retorno do `model` hook:

```app/routes/rentals.js import Ember from 'ember';

let rentals = [{ id: 'grand-old-mansion', title: 'Grand Old Mansion', owner: 'Veruca Salt', city: 'San Francisco', type: 'Estate', bedrooms: 15, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg' }, { id: 'urban-living', title: 'Urban Living', owner: 'Mike TV', city: 'Seattle', type: 'Condo', bedrooms: 1, image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg' }, { id: 'downtown-charm', title: 'Downtown Charm', owner: 'Violet Beauregarde', city: 'Portland', type: 'Apartment', bedrooms: 3, image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg' }];

export default Ember.Route.extend({ model() { return rentals; } });

    <br />Aqui, estamos usando a sintaxe de definição de método de ES: `model()` que é o mesmo que escrever `model: function()`.
    
    A função `model` funciona como um **hook**, o que significa dizer que o Ember vai chamar essa função em vários momentos em nossa aplicação.
    O model hook que adicionamos em nosso `rentals` gerenciador de rotas será chamado quando o usuário entrar na rota (route) `rentals`.
    
    O `model`hook retorna nosso _rentals_ array e passa para nosso template `rentals` as propriedades do `model`.
    
    Agora, vamos mudar para o nosso template.
    Podemos usar os dados do modelo para mostrar uma lista de aluguéis.
    Aqui, usaremos outro helper Handlebars comum chamado `{{each}}`.
    Isso irá nos ajudar a percorrer cada objeto em nosso modelo (model):
    
    ```app/templates/rentals.hbs{+13,+14,+15,+16,+17,+18,+19,+20,+21,+22,+23,+24,+25,+26,+27,+28,+29}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>Welcome!</h2>
      <p>
        We hope you find exactly what you're looking for in a place to stay.
        <br>Browse our listings, or use the search box below to narrow your search.
      </p>
      {{#link-to 'about' class="button"}}
        About Us
      {{/link-to}}
    </div>
    
    {{#each model as |rental|}}
      <article class="listing">
        <h3>{{rental.title}}</h3>
        <div class="detail owner">
          <span>Owner:</span> {{rental.owner}}
        </div>
        <div class="detail type">
          <span>Type:</span> {{rental.type}}
        </div>
        <div class="detail location">
          <span>Location:</span> {{rental.city}}
        </div>
        <div class="detail bedrooms">
          <span>Number of bedrooms:</span> {{rental.bedrooms}}
        </div>
      </article>
    {{/each}}
    

Neste template, iteramos cada objecto no modelo e chamamos-lhe *rental*. Por cada <0>rental</0> criamos uma listagem com informações relacionadas com a propriedade.

Agora que estamos listando os aluguéis, nosso teste de aceitação que os aluguéis serão exibidos deve passar:

![list rentals test passing](../../images/model-hook/passing-list-rentals-tests.png)