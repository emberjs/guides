Este guia vai te ensinar como construir, do zero, um aplicativo simples usando Ember.

Nós vamos cobrir estas etapas:

  1. Instalando o Ember.
  2. Criando um novo aplicativo.
  3. Definindo uma rota.
  4. Escrevendo um componente de UI (Interface com usuário).
  5. Construindo seu aplicativo para ser instalado ("deployed") em produção.

## Instalando o Ember

Você pode instalar o Ember com um único comando usando npm, o gerenciador de pacotes do Node.js. Digite o seguinte comando em seu terminal:

```sh
npm install -g ember-cli@2.3
```

Não tem npm? [Aprenda a instalar Node. js e npm aqui](https://docs.npmjs.com/getting-started/installing-node).

## Criando um novo aplicativo

Once you've installed Ember CLI via npm, you will have access to a new `ember` command in your terminal. You can use the `ember new` command to create a new application.

```sh
ember new ember-quickstart
```

Este comando irá criar um novo diretório chamado `ember-quickstart` e configurar um novo aplicativo de Ember dentro dela. De cara, seu aplicativo irá incluir:

* Um servidor para desenvolvimento.
* Compilação de "Template".
* "Minificação" de arquivos JavaScript e CSS.
* Funcionalidades ES2015 através da biblioteca Babel.

Ao fornecer, em um pacote integrado, tudo que você precisa para construir aplicações web prontas para produção, Ember faz com que seja uma moleza começar novos projetos.

Let's make sure everything is working properly. `cd` into the application directory `ember-quickstart` and start the development server by typing:

```sh
cd ember-quickstart
ember serve
```

Após alguns segundo, você deverá ver a seguinte saída:

```text
Livereload server on http://localhost:49152
Serving on http://localhost:4200/
```

(Se quiser parar o servidor, digite Ctrl-C a qualquer hora no seu terminal)

Abra [http://localhost:4200/](http://localhost:4200) em seu navegador. Você deve ver uma página que diz "Welcome do Ember" e não muito mais. Parabéns! Você acabou de criar e iniciar seu primeiro aplicativo em Ember.

Alterne para o seu editor e abra `app/templates/application.hbs`. Isto se chama o template do `aplicativo` e está sempre na tela enquanto o usuário tem seu aplicativo carregado.

No seu editor, altere o texto dentro do `< h1 >` de `Welcome do Ember` para `PeopleTracker` e salve o arquivo. Observe que o Ember detecta a mudança que você acabou de fazer e recarrega automaticamente a página para você em segundo plano. Você verá que "Welcome to Ember" mudou para "PeopleTracker".

## Definindo uma Rota

Vamos construir um aplicativo que mostra uma lista de cientistas. Para isso, o primeiro passo é criar uma rota. Por enquanto, você pode pensar em rotas como sendo diferentes páginas que compõem o seu aplicativo.

Ember vem com *geradores* que automatizam o código padrão para tarefas comuns. Para gerar uma rota, digite o seguinte em seu terminal:

```sh
ember generate route scientists
```

Você verá na saída algo assim:

```text
installing route
  create app/routes/scientists.js
  create app/templates/scientists.hbs
updating router
  add route scientists
installing route-test
  create tests/unit/routes/scientists-test.js
```

Isso é Ember dizendo que criou:

  1. Um template a ser exibido quando o usuário visita `/scientists`.
  2. Um objeto `Route` (Rota) que busca o model usado por esse "template".
  3. Uma inserção no roteador do aplicativo (localizado em `app/router.js`).
  4. Um teste unitário para esta rota.

Abra o template recém-criado em `app/templates/scientists.hbs` e adicione o seguinte HTML:

```app/templates/scientists.hbs 

## Lista de Cientistas

    <br />No seu navegador, abra
    [http://localhost:4200/scientists](http://localhost:4200/scientists). Você deverá ver o `<h2>` que colocou no "template" `scientists.hbs`, logo abaixo do `<h1>` do nosso "template" `application.hbs`.
    
    Agora que temos o "template" `scientists` sendo apresentado, vamos dar a ele alguns dados para mostrar. Para isso, especificamos um _model_ (modelo) para aquela rota, editando `app/routes/scientists.js`.
    
    Vamos pegar o código criado pelo gerador e adicionar um método `model()` à `Route` (Rota):
    
     ```app/routes/scientists.js{+4,+5,+6}
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return ['Marie Curie', 'Mae Jemison', 'Albert Hofmann'];
      }
    });
    

(Este código exemplifica usos das funcionalidades mais recentes em JavaScript, algumas que talvez não lhe sejam muito familiares. Saiba mais com este [resumo das funcionalidades mais novas do JavaScript](https://ponyfoo.com/articles/es6).)

No método `model()` de uma rota, você deve retornar qualquer dado que queira tornar disponível para a "template". Se precisar buscar dados assíncronamente, o método `model()` suporta qualquer biblioteca que use [Promessas ("Promises") JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).

Agora vamos dizer para o Ember como transformar aquele vetor ("array") de strings em HTML. Abra o "template" `scientists` e adicione um código Handlebars que itere o vetor e o imprima:

```app/templates/scientists.hbs{+3,+4,+5,+6,+7} 

## Lista de Cientistas

{#each model as |scientist|} 

* {{scientist}} {{/each}} 

    <br />Here, we use the `each` helper to loop over each item in the array we
    provided from the `model()` hook and print it inside an `<li>` element.
    
    ## Create a UI Component
    
    As your application grows and you notice you are sharing UI elements
    between multiple pages (or using them multiple times on the same page),
    Ember makes it easy to refactor your templates into reusable components.
    
    Let's create a `people-list` component that we can use
    in multiple places to show a list of people.
    
    As usual, there's a generator that makes this easy for us. Make a new
    component by typing:
    
    ```sh
    ember generate component people-list
    

Copy and paste the `scientists` template into the `people-list` component's template and edit it to look as follows:

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />Note that we've changed the title from a hard-coded string ("List of
    Scientists") to a dynamic property (`{{title}}`). We've also renamed
    `scientist` to the more-generic `person`, decreasing the coupling of our
    component to where it's used.
    
    Save this template and switch back to the `scientists` template. Replace all
    our old code with our new componentized version. Components look like
    HTML tags but instead of using angle brackets (`<tag>`) they use double
    curly braces (`{{component}}`). We're going to tell our component:
    
    1. What title to use, via the `title` attribute.
    2. What array of people to use, via the `people` attribute. We'll
       provide this route's `model` as the list of people.
    
    ```app/templates/scientists.hbs{-1,-2,-3,-4,-5,-6,-7,+8}
    <h2>List of Scientists</h2>
    
    <ul>
      {{#each model as |scientist|}}
        <li>{{scientist}}</li>
      {{/each}}
    </ul>
    {{people-list title="List of Scientists" people=model}}
    

Go back to your browser and you should see that the UI looks identical. The only difference is that now we've componentized our list into a version that's more reusable and more maintainable.

You can see this in action if you create a new route that shows a different list of people. As an exercise for the reader, you may try to create a `programmers` route that shows a list of famous programmers. By re-using the `people-list` component, you can do it in almost no code at all.

## Building For Production

Now that we've written our application and verified that it works in development, it's time to get it ready to deploy to our users. To do so, run the following command:

```sh
ember build --env production
```

The `build` command packages up all of the assets that make up your application&mdash;JavaScript, templates, CSS, web fonts, images, and more.

In this case, we told Ember to build for the production environment via the `--env` flag. This creates an optimized bundle that's ready to upload to your web host. Once the build finishes, you'll find all of the concatenated and minified assets in your application's `dist/` directory.

The Ember community values collaboration and building common tools that everyone relies on. If you're interested in deploying your app to production in a fast and reliable way, check out the [Ember CLI Deploy](http://ember-cli.github.io/ember-cli-deploy/) addon.