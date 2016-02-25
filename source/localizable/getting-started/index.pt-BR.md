Começar em Ember.js é fácil. Projetos Ember.js são criados e gerenciados através da Ember CLI, nossa ferramenta de linha de comando. Essa ferramenta fornece:

* Gerenciamento moderno de ativos de aplicação (incluindo concatenação, "minificação" e controle de versão).
* Geradores para ajudar a criar componentes, rotas e muito mais.
* Um layout padrão de projeto, tornando mais fácil entender aplicações Ember.js existentes.
* Suporte a Javascript ES2015/ES6 através do projeto [Babel](http://babeljs.io/docs/learn-es2015/). Isso inclui suporte para [módulos de JavaScript](http://exploringjs.com/es6/ch_modules.html), que são usados ao longo deste guia.
* Uma estrutura completa de testes [QUnit](https://qunitjs.com/).
* A capacidade de consumir Addons Ember de um ecossistema crescente.

## Dependências

### Node. js e npm

Ember CLI é construída com JavaScript e espera o "runtime" [Node.js](https://nodejs.org/). Ela também precisa de dependências buscadas através do [npm](https://www.npmjs.com/). npm é empacotado com Node.js, então, se seu computador tem Node.js instalado, você está pronto para começar.

Ember requer Node.js 0.12 ou superior e npm 2.7 ou superior. Caso não tenha certeza se tem a versão correta, execute isso na sua linha de comando:

```bash
node --version
npm --version
```

Se você receber um erro *"command not found"* ou tiver uma versão desatualizada de Node:

* Usuários de Windows ou Mac podem baixar e executar [o instalador de Node. js](http://nodejs.org/download/).
* Usuários de Mac podem instalar Node usando [Homebrew](http://brew.sh/). Depois de instalar o Homebrew, execute `brew install node` para instalar o Node.js.
* Os usuários de Linux podem usar [este guia para instalação de Node.js no Linux](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

Se você estiver com uma versão desatualizada do npm, execute `npm install -g npm`.

### Git

Ember requer Git para gerenciar muitas de suas dependências. Git vem com o Mac OS X e na maioria das distribuições Linux. Usuários Windows podem baixar e executar [este instalador Git](http://git-scm.com/download/win).

### Watchman (opcional)

No Mac e no Linux, você pode melhorar o desempenho da observação de arquivos ("file watching") instalando [Watchman](https://facebook.github.io/watchman/docs/install.html).

### PhantomJS (opcional)

Com PhantomJs, você pode rodar seus testes da linha de comando, sem precisar abrir um navegador. Consulte as [instruções para baixar PhantomJs](http://phantomjs.org/download.html).

## Instalação

Instale o Ember CLI usando npm:

```bash
npm install -g ember-cli@2.3
```

Para verificar se a instalação foi bem-sucedida, execute:

```bash
ember -v
```

Se um número de versão for exibido, você está pronto para começar.