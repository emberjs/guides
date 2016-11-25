Bem-vindo ao Tutorial de Ember! Este tutorial destina-se a introduzir os conceitos básicos de Ember ao criar um aplicativo de aparência profissional. Se você ficar preso em algum ponto durante o tutorial, sinta-se livre para visitar <https://github.com/ember-learn/super-rentals> para um exemplo funcional do aplicativo concluído.

Ember CLI, a interface de linha de comando do Ember, fornece uma estrutura de projeto padrão, um conjunto de ferramentas de desenvolvimento e um sistema de addon. Isto permite aos desenvolvedores Ember focar criando aplicativos ao invés de construir as estruturas de apoio que os fazem funcionar. Sua linha de comando, um rápido `ember --help` mostra os comandos que o Ember CLI fornece. Para obter mais informações sobre um comando específico, digite `ember help <nome-do-comando>`.

## Criando um novo aplicativo

Para criar um novo projeto usando o Ember CLI, use o comando `new`. Para preparar para o tutorial na próxima seção, você pode fazer um app chamado `super-rentals`.

```shell
ember new super-rentals
```

## Estrutura de diretórios (pastas)

O comando `new` gera uma estrutura de projeto com os seguintes arquivos e diretórios:

```text
|--app
|--bower_components
|--config
|--dist
|--node_modules
|--public
|--tests
|--tmp
|--vendor

bower.json
ember-cli-build.js
package.json
README.md
testem.js
```

Vamos dar uma olhada nas pastas e arquivos que o Ember CLI gera.

**app**: Aqui é onde as pastas e arquivos de models, components, routes, templates e styles são armazenados. A maior parte de codificação em um projeto Ember acontece nessa pasta.

**bower_components / bower.json**: Bower é uma ferramenta de gerenciamento de dependência. É utilizado no Ember CLI para gerenciar plugins front-end e dependências de componentes (HTML, CSS, JavaScript, etc). Todos os componentes Bower são instalados na pasta `bower_components`. Se abrirmos o arquivo `bower.json`, nós vemos a lista de dependências que são instaladas automaticamente, incluindo Ember, Ember CLI Shims, e QUnit (para testes). Se adicionarmos dependências front-end adicionais, tais como Bootstrap, veremos essas dependências listadas aqui e adicionada ao diretório `bower_components`.

**config**: O diretório de config contém o arquivo `environment.js` onde você pode definir as configurações da sua aplicação.

**dist**: Quando publicamos (deploy) nossa aplicação, os arquivos de saída serão criados aqui.

**node_modules / package.json**: Esse diretório e arquivo são do npm. npm é o gerenciador de pacotes Node.js. Ember é construído com Node usa uma variedade de módulos Node.js para funcionar. O arquivo `package.json` mantém a lista atual de dependências npm da aplicação. Qualquer Ember CLI add-ons que você instalar, também vão aparecer aqui. Os packages listados em `package.json` são instalados no diretório node_modules.

**public**: Esse diretório contém os assets como imagens e fontes.

**vendor**: Esse diretório é onde vai as dependências front-end (como JavaScript ou CSS) que não são gerenciadas pelo Bower.

**tests / testem.js**: Os testes automatizados da nossa aplicação vão na pasta `tests`, e o Ember CLI's test runner **testem** é configurado no arquivo `testem.js`.

**tmp**: arquivos temporários do Ember CLI ficam aqui.

**ember-cli-build.js**: este arquivo descreve como Ember CLI deve construir nosso aplicativo.

## Módulo ES6

Se você der uma olhada no arquivo `app/router.js`, você verá uma sintaxe que pode não ser familiar para você.

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType, rootURL: config.rootURL });

Router.map(function() { });

export default Router;

    <br />Ember CLI usa módulos ECMAScript 2015 (ES2015 ou anteriormente conhecido como ES6) para organizar o código da aplicação.
    Por exemplo, a linha `import Ember from 'ember';` nos dá acesso à atual biblioteca Ember.js com a variável `Ember`. E a linha `import config from
    './config/environment';` nos dá acesso aos dados do arquivo de configuração da nossa aplicação, com a variável `config`. `const` é uma maneira de declarar uma variável read-only, 
    para ter certeza que ela não é acidentalmente reatribuída em outros lugares. No final do arquivo, `export default Router;` faz com que a variável `Router` definida nesse arquivo, fique disponível para outras partes da nossa aplicação.
    
    ## Atualizando Ember
    
    Antes de continuar com o tutorial, verifique se você tem as versões mais recentes de Ember e Ember data instaladas. Se a versão de `ember` no
    `bower.json` é menor do que a versão no canto superior esquerdo desse guia, atualize o número da versão no `bower.json` e então execute o comando`bower install`.
    Da mesma forma, se a versão de `ember-data` no `package.json` é menor, atualize o número da versão e execute o comando `npm install`.
    
    ## O servidor de desenvolvimento
    
    Uma vez que temos um novo projeto, podemos verificar se tudo está funcionando, iniciando o servidor de desenvolvimento do Ember:
    
    ```shell
    ember server
    

ou, se quisermos abreviar:

```shell
ember s
```

Se navegarmos para [`http://localhost:4200`](http://localhost:4200), vamos ver a tela de boas vindas padrão. Quando criarmos nosso próprio arquivo `app/templates/application.hbs`, a tela de boas vindas padrão será substituída com o nosso próprio conteúdo.

![Tela de boas vindas padrão](../../images/ember-cli/default-welcome-page.png)