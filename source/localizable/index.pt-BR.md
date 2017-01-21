Bem vindo ao guia de Ember.js! Esse guia irá te levar de iniciante a perito em Ember.

## Organização

Ao lado esquerdo de cada página dos Guias há uma tabela de conteúdo, organizado em seções, que podem ser expandidas para mostrar os tópicos que eles cobrem. Ambas seções e os tópicos dentro de cada seção são ordenados dos conceitos mais básicos para os mais avançados.

Os guias tem o objetivo de conter explicações práticas de como construir aplicativos em Ember, enfocando os recursos mais utilizados do Ember.js. Para documentação detalhada de todos os recursos de Ember e da API, consulte a [documentação da API Ember.js](http://emberjs.com/api/).

Os guias começam com uma explicação de como começar com Ember, seguido de um tutorial sobre como criar seu primeiro aplicativo em Ember. Se você é novo em Ember, recomendamos que comece por essas duas primeiras seções do guia.

## Pré-Requisitos

Enquanto tentamos deixar o guia mais amigável para iniciantes, precisamos estabelecer uma base para que o guia possam manter o foco nas funcionalidades de Ember.js. Vamos tentar linkar a documentação adequada sempre que um conceito for introduzido.

Para tirar o máximo de proveito dos guias, você deve ter conhecimento básico de:

* **HTML, CSS, JavaScript** - a base para construção de páginas web. Você pode encontrar a documentação de cada uma destas tecnologias em [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web).
* **Promises** - a maneira nativa para lidar com assincronia no seu código JavaScript. Consulte a seção relevante do [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).
* **Módulos ES2015** - você vai entender melhor a estrutura de projeto do [Ember CLI](https://ember-cli.com/) e caminhos de importação, se você estiver confortável com [Módulos de JavaScript ES6](http://jsmodules.io/).
* **ES2015 sintaxe** - Ember CLI vem com Babel.js por padrão, então você pode tirar proveito dos novos recursos de linguagem, como funções de seta, template strings, desestruturação e mais. Você pode verificar a [documentação de Babel.js](https://babeljs.io/docs/learn-es2015/) ou ler [compreendendo ECMAScript 6](https://leanpub.com/understandinges6/read) on-line.

## A Note on Mobile Performance

Ember will do a lot to help you write fast apps, but it can't prevent you from writing a slow one. This is especially true on mobile devices. To deliver a great experience, it's important to measure performance early and often, and with a diverse set of devices.

Make sure you are testing performance on real devices. Simulated mobile environments on a desktop computer give an optimistic-at-best representation of what your real world performance will be like. The more operating systems and hardware configurations you test, the more confident you can be.

Due to their limited network connectivity and CPU power, great performance on mobile devices rarely comes for free. You should integrate performance testing into your development workflow from the beginning. This will help you avoid making costly architectural mistakes that are much harder to fix if you only notice them once your app is nearly complete.

In short:

  1. Always test on real, representative mobile devices.
  2. Measure performance from the beginning, and keep testing as your app develops.

These tips will help you identify problems early so they can be addressed systematically, rather than in a last-minute scramble.

## Reporting a problem

Typos, missing words, and code samples with errors are all considered documentation bugs. If you spot one of them, or want to otherwise improve the existing guides, we are happy to help you help us!

Some of the more common ways to report a problem with the guides are:

* Usando o ícone de lápis na parte superior direita de cada página do guia
* Abrindo uma issue ou pull request para [o repositório no GitHub](https://github.com/emberjs/guides/)

Clicking the pencil icon will bring you to GitHub's editor for that guide so you can edit right away, using the Markdown markup language. This is the fastest way to correct a typo, a missing word, or an error in a code sample.

If you wish to make a more significant contribution be sure to check our [issue tracker](https://github.com/emberjs/guides/issues) to see if your issue is already being addressed. If you don't find an active issue, open a new one.

If you have any questions about styling or the contributing process, you can check out our [contributing guide](https://github.com/emberjs/guides/blob/master/CONTRIBUTING.md). If your question persists, reach us at `#-team-learning` on the [Slack group](https://ember-community-slackin.herokuapp.com/).

Good luck!