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

O template `application` estará sempre na tela, enquanto o usuário tiver com aplicação carregada. No seu editor, abra `app/templates/application.hbs` e adicione o seguinte:

```app/templates/application.hbs 

# PeopleTracker

{{outlet}}

    <br />Observe que o Ember detecta o novo arquivo e automaticamente recarrega a página para você em segundo plano. Você verá que a página de boas-vindas foi substituída por "PeopleTracker". Você também adicionou um `{{outlet}}` para esta página, o que significa que qualquer rota aninhada será processada neste local.
    
    ## Definindo a rota
    
    Vamos fazer uma aplicação que mostra a lista de cientistas. Para isso, o primeiro passo é criar uma rota. Por hora, você pode pensar Routes como sendo diferentes páginas que compõe sua aplicação.
    
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
    
    Now that we've got the `scientists` template rendering, let's give it some
    data to render. We do that by specifying a _model_ for that route, and
    we can specify a model by editing `app/routes/scientists.js`.
    
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

## Compilando para produção

Agora que nós escrevemos a nossa aplicação e verificamos que ela funciona em desenvolvimento, é hora de prepará-la para nossos usuários. Para fazer isso, execute o seguinte comando:

```sh
ember build --env production
```

O comando `build` empacota todos seus TDK(assets) que compõem o seu aplicativo&mdash;JavaScript, templates, CSS, web fonts, imagens, e mais.

Neste caso, nós dissemos para o Ember compilar para o ambiente de produção através da etiqueta `--env`. Isso cria um pacote otimizado que está pronto para ser enviado para o seu servidor web. Uma vez que a compilação termine, você encontrará todos os arquivos da sua aplicação concatenados e minificados no diretório `dist /`.

A comunidade Ember valoriza a colaboração e construção de ferramentas comuns que todos possam contar. Se você está interessado em publicar seu aplicativo em produção de forma rápida e confiável, confira o plugin [Ember CLI Deploy](http://ember-cli-deploy.com/).

Se o deploy de sua aplicação for em um servidor Apache, primeiro crie um novo host virtual para aplicação. Para ter certeza que todas as rotas serão controladas pelo index.html, adicione a seguinte diretiva na configuração do host virtual

    FallbackResource index.html