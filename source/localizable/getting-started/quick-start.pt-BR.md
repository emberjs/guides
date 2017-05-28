Este guia vai te ensinar como construir, do zero, um aplicativo simples usando Ember.

Nós vamos cobrir estas etapas:

  1. Instalando o Ember.
  2. Criando um novo aplicativo.
  3. Definindo uma rota.
  4. Escrevendo um componente de UI (User Interface / Interface do Usuário).
  5. Construindo seu aplicativo para ser instalado ("deployed") em produção.

## Instalando o Ember

Você pode instalar o Ember com um único comando usando npm, o gerenciador de pacotes do Node.js. Digite o seguinte comando em seu terminal:

```sh
npm install -g ember-cli
```

Não tem npm? [Aprenda a instalar o Node.js e npm aqui](https://docs.npmjs.com/getting-started/installing-node). Para obter uma lista completa das dependências necessárias para um projeto de Ember CLI, consulte o nosso guia de [Instalação de Ember](../../getting-started/).

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

Vamos ver se tudo está funcionando corretamente. No seu terminal acesse o diretório da aplicação criada e inicie o servidor de desenvolvimento, digitando:

```sh
cd ember-quickstart
ember server
```

Após alguns segundos, você deverá ver a seguinte saída:

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

O template `application` estará sempre na tela, enquanto o usuário tiver com aplicação carregada. No seu editor, abra `app/templates/application.hbs` e adicione o seguinte:

```app/templates/application.hbs 

# PeopleTracker

{{outlet}}

    <br />Observe que o Ember detecta o novo arquivo e automaticamente recarrega a página para você em segundo plano. Você verá que a página de boas-vindas foi substituída por "PeopleTracker". Você também adicionou um `{{outlet}}` para esta página, o que significa que qualquer rota aninhada será processada neste local.
    
    ## Definindo a rota
    
    Vamos fazer uma aplicação que mostra a lista de cientistas. Para isso, o primeiro passo é criar uma rota. Por hora, você pode pensar em Routes como sendo diferentes páginas que compõe sua aplicação.
    
    Ember possui _generators_ que automatizam códigos que são usados repetidamente em tarefas comum. Para criar a rota, escreva isso no seu terminal:
    
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

    <br />No seu navegador, abra
    [`http://localhost:4200/scientists`](http://localhost:4200/scientists). Você deve ver o elemento `<h2>` que você colocou no `scientists.hbs` template, logo abaixo
    `<h1>` do nosso `application.hbs` template.
    
    Agora que temos o "template" `scientists` sendo apresentado, vamos dar a ele alguns dados para mostrar. Para isso, especificamos um _model_ (modelo) para aquela rota, editando `app/routes/scientists.js`.
    
    Vamos pegar o código gerado para nós pelo gerador e adicionar um método`model()`
    ao `Route`:
    
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

    <br />Aqui, usamos o auxiliar `each` para executar um loop sobre cada item do array que fornecemos no `model()` e imprimi-lo dentro de um elemento de `<li>`.
    
    ## Criando um Componente UI
    
    Conforme sua aplicação cresce e você percebe que está repetindo elementos de interface em diversas páginas (ou usando o mesmo elementos várias vezes na mesma página), Ember facilita a criação de componentes reutilizáveis.
    
    Vamos criar um componente `people-list` que podemos usar para mostrar uma lista de pessoas em vários lugares.
    
    Como de costume, há um gerador que faz isto fácil para nós. Faça um novo componente digitando:
    
    ```sh
    ember generate component people-list
    

Copie e cole o template de `scientists` no template do componente `people-list` e edite-o para ter a seguinte aparência:

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />Observer que mudamos o título de uma string fixa ("Lista de Cientistas") para uma propriedade dinâmica (`{{title}}`). Nos também alteramos o nome de `scientist`para um mais genérico `person`, diminuindo o acoplamento do nosso componente onde ele é usado.
    
    Salve esse template and volte novamente para o template de `scientists`. Troque todo o nosso código anterior para nossa nova versão componentizada. Components são como HTML tags, mas em vez de usarem colchetes (`<tag>`) eles usam chaves duplas (`{{component}}`). Nós vamos definir em nosso component:
    
    1. Qual o título usar, através do atributo `title`.
    2. Qual array de pessoas usar, através do atributo `people`. Nós iremos passar o `model` desta rota, como uma lista de pessoas.
    
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

## Click Events

So far, your application is listing data, but there is no way for the user to interact with the information. In web applications, you often want to listen for user events like clicks or hovers. Ember makes this easy to do. First add an `action` helper to the `li` in your `people-list` component.

```app/templates/components/people-list.hbs{-5,+6} 

## {{title}}

{{#each people as |person|}} 

* {{person}}<li {{action "showperson" person}}>{{person}}</li> {{/each}} 

    <br />The `action` helper allows you to add event listeners to elements and call named functions.
    By default, the `action` helper adds a `click` event listener,
    but it can be used to listen for any element event.
    Now, when the `li` element is clicked a `showPerson` function will be called
    from the `actions` object in the `people-list` component.
    Think of this like calling `this.actions.showPerson(person)` from our template.
    
    To handle this function call you need to modify the `people-list` component file
    to add the function to be called.
    In the component, add an `actions` object with a `showPerson` function that
    alerts the first argument.
    
    ```app/components/people-list.js{+4,+5,+6,+7,+8}
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      actions: {
        showPerson(person) {
          alert(person);
        }
      }
    });
    

Now in the browser when a scientist's name is clicked, this function is called and the person's name is alerted.

## Building For Production

Now that we've written our application and verified that it works in development, it's time to get it ready to deploy to our users. To do so, run the following command:

```sh
ember build --env production
```

The `build` command packages up all of the assets that make up your application&mdash;JavaScript, templates, CSS, web fonts, images, and more.

In this case, we told Ember to build for the production environment via the `--env` flag. This creates an optimized bundle that's ready to upload to your web host. Once the build finishes, you'll find all of the concatenated and minified assets in your application's `dist/` directory.

The Ember community values collaboration and building common tools that everyone relies on. If you're interested in deploying your app to production in a fast and reliable way, check out the [Ember CLI Deploy](http://ember-cli-deploy.com/) addon.

If you deploy your application to an Apache web server, first create a new virtual host for the application. To make sure all routes are handled by index.html, add the following directive to the application's virtual host configuration

    FallbackResource index.html