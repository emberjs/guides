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
npm install -g ember-cli
```

Não tenho npm? [Aprenda a instalar o Node.js e npm aqui](https://docs.npmjs.com/getting-started/installing-node). Para obter uma lista completa das dependências necessárias para um projeto de Ember CLI, consulte o nosso guia de [Instalação de Ember](../../getting-started/).

## Criando um novo aplicativo

Uma vez instalado Ember através do npm, você terá acesso a um novo comando `ember` em seu terminal. Você pode usar o comando `ember new` para criar um novo aplicativo.

```sh
ember new ember-quickstart
```

Este comando irá criar um novo diretório chamado `ember-quickstart` e configurar um novo aplicativo de Ember dentro dela. De cara, seu aplicativo irá incluir:

* Um servidor para desenvolvimento.
* Compilação de "Template".
* "Minificação" de arquivos JavaScript e CSS.
* Funcionalidades ES2015 através da biblioteca Babel.

Ao fornecer, em um pacote integrado, tudo que você precisa para construir aplicações web prontas para produção, Ember faz com que seja uma moleza começar novos projetos.

Vamos ver se tudo está funcionando corretamente. `cd` para o diretório de aplicativo `ember-quickstart` e iniciar o servidor de desenvolvimento, digitando:

```sh
cd ember-quickstart
ember server
```

Após alguns segundo, você deverá ver a seguinte saída:

```text
Livereload server on http://localhost:49152
Serving on http://localhost:4200/
```

(Se quiser parar o servidor, digite Ctrl-C a qualquer hora no seu terminal)

Abra [http://localhost:4200/](http://localhost:4200) em seu navegador. Você deverá ver uma página de boas-vindas de Ember. Parabéns! Você acabou de criar seu primeiro aplicativo em Ember.

Vamos criar um novo template, usando o comando `ember generate`.

```sh
ember generate template application
```

The `application` template is always on screen while the user has your application loaded. In your editor, open `app/templates/application.hbs` and add the following:

```app/templates/application.hbs 

# PeopleTracker

{{outlet}}

    <br />Notice that Ember detects the new file and automatically reloads the
    page for you in the background. You should see that the welcome page
    has been replaced by "PeopleTracker". You also added an `{{outlet}}` to this page, which means that any nested route will be rendered in that place.
    
    ## Define a Route
    
    Let's build an application that shows a list of scientists. To do that,
    the first step is to create a route. For now, you can think of routes as
    being the different pages that make up your application.
    
    Ember comes with _generators_ that automate the boilerplate code for
    common tasks. To generate a route, type this in your terminal:
    
    ```sh
    ember generate route scientists
    

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

    <br />In your browser, open
    [`http://localhost:4200/scientists`](http://localhost:4200/scientists). You should
    see the `<h2>` you put in the `scientists.hbs` template, right below the
    `<h1>` from our `application.hbs` template.
    
    Now that we've got the `scientists` template rendering, let's give it some
    data to render. We do that by specifying a _model_ for that route, and
    we can specify a model by editing `app/routes/scientists.js`.
    
    We'll take the code created for us by the generator and add a `model()`
    method to the `Route`:
    
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
    

Copie e cole o template de `scientists` no template do componente `people-list` e edite-o para ter a seguinte aparência:

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
    

Volte para o seu navegador e você verá que a interface parece idêntica. A única diferença é que agora nós já componentizamos nossa lista em uma versão que é mais reutilizável e mais passível de manutenção.

Você pode ver isso em ação, se você criar uma nova rota que mostra uma lista diferente de pessoas. Como um exercício para o leitor, você pode tentar criar uma rota de `programadores` que mostra uma lista de programadores famosos. Re-usando o componente `people-list`, você pode fazer isso com praticamente nenhum código.

## Building For Production

Agora que nós escrevemos a nossa aplicação e verificamos que ela funciona em desenvolvimento, é hora de prepará-la para nossos usuários. Para fazer isso, execute o seguinte comando:

```sh
ember build --env production
```

O comando `build` empacota todos seus TDK(assets) que compõem o seu aplicativo&mdash;JavaScript, templates, CSS, web fonts, imagens, e mais.

Neste caso, nós dissemos para o Ember compilar para o ambiente de produção através da etiqueta `--env`. Isso cria um pacote otimizado que está pronto para ser enviado para o seu servidor web. Uma vez que a compilação termine, você encontrará todos os arquivos da sua aplicação concatenados e minificados no diretório `dist /`.

A comunidade Ember valoriza a colaboração e construção de ferramentas comuns que todos possam contar. If you're interested in deploying your app to production in a fast and reliable way, check out the [Ember CLI Deploy](http://ember-cli-deploy.com/) addon.

If you deploy your application to an Apache web server, first create a new virtual host for the application. To make sure all routes are handled by index.html, add the following directive to the application's virtual host configuration

    FallbackResource index.html