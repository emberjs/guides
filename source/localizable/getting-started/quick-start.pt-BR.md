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
npm install -g ember-cli@2.4
```

Não tem npm? [Aprenda a instalar Node. js e npm aqui](https://docs.npmjs.com/getting-started/installing-node).

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

No seu editor, altere o texto dentro do `<h2>` de `Welcome to Ember` para `PeopleTracker` e salve o arquivo. Observe que o Ember detecta a mudança que você acabou de fazer e recarrega automaticamente a página para você em segundo plano. Você verá que "Welcome to Ember" mudou para "PeopleTracker".

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

    <br />Aqui, usamos o auxiliar `each` para executar um loop sobre cada item do array que fornecemos no `model()` e imprimi-lo dentro de um elemento de `<li>`.
    
    # # Criar um componente UI
    
    Com o crescimento do seu aplicativo você nota que está compartilhando elementos de interface entre várias páginas (ou usando várias vezes na mesma página), Ember facilita a refatorar seus templates em componentes reutilizáveis.
    
    Vamos criar um componente de `people-list` que podemos usar para mostrar uma lista de pessoas em vários lugares.
    
    Como de costume, há um gerador que faz isto fácil para nós. Fazer um novo componente digitando: 
    
    ```sh
    ember generate component people-list
    

Copie e cole o template de `scientists` no template do componente `people-list` e edite-o para ter a seguinte aparência:

```app/templates/components/people-list.hbs 

## {{title}}

{{#each people as |person|}} 

* {{person}} {{/each}} 

    <br />Note que nós mudamos o título de uma seqüência de caracteres codificada ("List of Scientists") para uma propriedade dinâmica (`{{title}}`). Nós também renomeamos `scientist` para algo mais genérico `person`, diminuindo o acoplamento do nosso componente onde ele é usado.
    
    Salve este template e volte novamente para o template de `scientists`. Substitua todo o nosso velho código com nossa nova versão componentizada. Componentes parecem com tags HTML mas em vez de usar colchetes (`<tag>`) eles usam chaves duplas (`{{component}}`). Nós vamos contar nosso componente: 
    
    1. O título para usar, via o atributo `title`.
    2. Qual array de pessoas usar, via o atributo `pessoas`. Nós forneceremos o `modelo` desta rota, como a lista de pessoas.
    
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

A comunidade Ember valoriza a colaboração e construção de ferramentas comuns que todos possam contar. If you're interested in deploying your app to production in a fast and reliable way, check out the [Ember CLI Deploy](http://ember-cli-deploy.github.io/ember-cli-deploy/) addon.