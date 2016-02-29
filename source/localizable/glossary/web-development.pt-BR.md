Juntar-se a nossa comunidade de desenvolvimento web pode ser, por si só, um desafio. Especialmente quando todos os materiais que você lê assumem que você já está familiarizado com tecnologias com as quais você não está.

Nosso objetivo é ajudá-lo a evitar essa confusão e destravá-lo o mais rápido possível; considere-nos seu amigo da internet.

## CDN

Content Delivery Network (Rede de Fornecimento de Conteúdo)

Normalmente é um serviço pago, usado para que seu aplicativo obtenha alto desempenho. Muitos CDNs agem como proxies de cache do seu servidor origem; alguns requerem que os ativos de desenvolvimento (assets) sejam armazenados neles. Eles dão uma URL para cada recurso no seu aplicativo. Essa URL irá resolver de forma diferente para cada um, dependendo de onde, fisicamente, eles estão navegando.

Por trás dos panos, o CDN vai distribuir o seu conteúdo geograficamente com o objetivo de fazer com que os usuários finais possam baixar seu conteúdo com a menor latência possível. Por exemplo, se um usuário está na Índia, eles provavelmente terão conteúdo servido da Índia mais rapidamente do que dos Estados Unidos.

## CoffeeScript, TypeScript

Essas duas linguagens compilam para JavaScript. Você pode escrever seu código usando a sintaxe delas e, quando estiver pronto, compilar seu TypeScript ou CoffeeScript para JavaScript.

[CoffeeScript vs TypeScript](http://www.stoutsystems.com/articles/coffeescript-versus-typescript/)

## Evergreen browsers

Browsers that update themselves (without user intervention).

[Evergreen Browsers](http://tomdale.net/2013/05/evergreen-browsers/)

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

Asynchronous calls typically return a promise (or deferred). This is an object which has a state: it can be given handlers for when it's fulfilled or rejected.

Ember makes use of these in places like the model hook for a route. Until the promise resolves, Ember is able to put the route into a "loading" state.

* [An open standard for sound, interoperable JavaScript promises](https://promisesaplus.com/)
* [emberjs.com - A word on promises](http://emberjs.com/guides/routing/asynchronous-routing/#toc_a-word-on-promises)

## SSR

Server Side Rendering

[Inside FastBoot: The Road to Server-Side Rendering](http://emberjs.com/blog/2014/12/22/inside-fastboot-the-road-to-server-side-rendering.html)

## Transpilação

Quando relacionado a JavaScript, isso tem a ver com o processo de montagem (build process) que "transpila" (converte) seu código JavaScript com sintaxe ES6 em JavaScript suportado pelos navegadores atuais.

Além de ES6, você encontrará muito conteúdos sobre compilação/transpilação CoffeeScript, uma linguagem que pode ser "compilada" para JavaScript.

* Ember CLI usa especificamente [Babel](https://babeljs.io/) via o plugin [ember-cli-babel](https://github.com/babel/ember-cli-babel).

## Shadow DOM

Não confundir com Virtual DOM. Shadow DOM é ainda um trabalho em andamento, mas basicamente é uma proposta de ter um DOM "isolado" encapsulado no DOM do seu aplicativo.

Creating a re-usable "widget" or control might be a good use-case for this. Browsers implement some of their controls using their own version of a shadow DOM.

* [W3C Working Draft](http://www.w3.org/TR/shadow-dom/)
* [What the Heck is Shadow DOM?](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom/)

## Virtual DOM

Não confundir com Shadow DOM. O conceito de um DOM virtual significa abster seu código (no nosso caso, do Ember) de usar o DOM do navegador e usar, ao invés, um DOM "virtual" que pode ser mais facilmente acessado para leitura/escrita e até serializado (serialized).