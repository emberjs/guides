Juntar-se a nossa comunidade de desenvolvimento web pode ser, por si só, um desafio. Especialmente quando todos os materiais que você lê assumem que você já está familiarizado com tecnologias com as quais você não está.

Nosso objetivo é ajudá-lo a evitar essa confusão e destravá-lo o mais rápido possível; considere-nos seu amigo da internet.

## CDN

Content Delivery Network (Rede de Fornecimento de Conteúdo)

Normalmente é um serviço pago, usado para que seu aplicativo obtenha alto desempenho. Muitos CDNs agem como proxies de cache do seu servidor origem; alguns requerem que os ativos de desenvolvimento (assets) sejam armazenados neles. Eles dão uma URL para cada recurso no seu aplicativo. Essa URL irá resolver de forma diferente para cada usuário, dependendo de onde, fisicamente, eles estão navegando.

Por trás dos panos, o CDN vai distribuir o seu conteúdo geograficamente com o objetivo de fazer com que os usuários finais possam baixar seu conteúdo com a menor latência possível. Por exemplo, se um usuário está na Índia, eles provavelmente terão conteúdo servido da Índia mais rapidamente do que dos Estados Unidos.

## CoffeeScript, TypeScript

Essas duas linguagens compilam para JavaScript. Você pode escrever seu código usando a sintaxe delas e, quando estiver pronto, compilar seu TypeScript ou CoffeeScript para JavaScript.

[CoffeeScript vs TypeScript](http://www.stoutsystems.com/articles/coffeescript-versus-typescript/)

## Navegadores Evergreen

Navegadores que atualizam automaticamente (sem intervenção do usuário).

[Navegadores Evergreen](http://tomdale.net/2013/05/evergreen-browsers/)

## ES3, ES5, ES5.1, ES6 (vulgo ES2015), etc

ES é um acrônimo para ECMAScript, a especificação sobre a qual JavaScript se baseia. O número que acompanha é a versão da especificação.

A maioria dos navegadores suporta pelo menos ES5, e alguns até suportam ES6 (vulgo ES2015). Você pode checar suporte de cada navegador (incluindo o seu) aqui:

* [Suporte ES5](http://kangax.github.io/compat-table/es5/)
* [Suporte ES6](http://kangax.github.io/compat-table/es6/)

[ECMAScript](https://en.wikipedia.org/wiki/ECMAScript)

## LESS, Sass

Tanto LESS quanto Sass são tipos de pré-processadores de CSS capazes de dar muito mais controle sobre o seu CSS. Durante o processo de montagem (build process), os recursos LESS ou Sass compilam para CSS "feijão-com-arroz" (que pode ser executado em um navegador).

[Comparação Saas/Less](https://gist.github.com/chriseppstein/674726)

## Linter, linting, jslint, jshint

Ferramentas de validação que checam erros comuns no seu JavaScript. Geralmente usados durante o processo de montagem (build process) para forçar qualidade na base de código. Um bom exemplo de algo a se checar: *ter certeza que você colocou todos os ponto e vírgulas*.

[Um exemplo de algumas opções que você pode configurar](http://jshint.com/docs/options/)

## Polyfill

Esse é um conceito que normalmente significa prover código Javascript que testa por funcionalidades não implementadas (protótipos não definidos, etc) e "preenchem" com uma implementação.

## Promise (Promessa)

Chamadas assíncronas normalmente retornam uma promessa (ou deferido). Este é um objeto que tem um estado: podendo retornar manipuladores para quando ele for completado ou rejeitado.

Ember faz uso disso em lugares como na chamada de um model em uma rota. Até que a promise finalize, Ember é capaz de colocar a rota em um estado de "carregando".

* [Especificação completa das Promises/A+ no JavaScript](https://promisesaplus.com/)
* [emberjs.com - Recursos avançados para lidar com Promise em seu aplicativo](http://emberjs.com/guides/routing/asynchronous-routing/#toc_a-word-on-promises)

## SSR

Server-Side Rendering

[Por dentro do FastBoot: A estrada para o processamento do lado do servidor (em inglês)](http://emberjs.com/blog/2014/12/22/inside-fastboot-the-road-to-server-side-rendering.html)

## Transpilação

Quando relacionado a JavaScript, isso tem a ver com o processo de montagem (build process) que "transpila" (converte) seu código JavaScript com sintaxe ES6 em JavaScript suportado pelos navegadores atuais.

Além de ES6, você encontrará muito conteúdos sobre compilação/transpilação CoffeeScript, uma linguagem que pode ser "compilada" para JavaScript.

* Ember CLI usa especificamente [Babel](https://babeljs.io/) via o plugin [ember-cli-babel](https://github.com/babel/ember-cli-babel).

## Shadow DOM

Não confundir com Virtual DOM. Shadow DOM é ainda um trabalho em andamento, mas basicamente é uma proposta de ter um DOM "isolado" encapsulado no DOM do seu aplicativo.

Criar um "widget" re-utilizável ou controle pode ser um bom caso de uso para isso. Navegadores implementam alguns dos seus controles usando sua própria versão de Shadow DOM.

* [W3C Working Draft](http://www.w3.org/TR/shadow-dom/)
* [What the Heck is Shadow DOM?](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom/)

## Virtual DOM

Não confundir com Shadow DOM. O conceito de um DOM virtual significa abster seu código (no nosso caso, do Ember) de usar o DOM do navegador e usar, ao invés, um DOM "virtual" que pode ser mais facilmente acessado para leitura/escrita e até serializado (serialized).