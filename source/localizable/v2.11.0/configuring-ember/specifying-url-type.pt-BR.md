O router de Ember tem quatro opções para gerenciar a URL da aplicação: `history`, que usa a API HTML5 de history; o `hash`, que usa URLs baseado em âncora; `auto`, que usa a `history`, se suportado pelo navegador do usuário e devolve para `hash` caso contrário e `none`, que não atualiza a URL. Por padrão, Ember CLI configura o router para usar o `auto`. Você pode mudar esta opção em `config/environment.js` em `ENV.locationType`.

## history

Quando usar a `history`, Ember usa API [history](http://caniuse.com/history) do navegador para produzir URLs com uma estrutura como `/posts/new`.

Dado o seguinte router, entrar com a URL `/posts/new` irá levá-lo para a rota de `posts.new`.

    app/router.js
    Router.map(function() {
      this.route('posts', function() {
        this.route('new');
      });
    });

Tenha em mente que seu servidor deve servir o app Ember de todas as URLs definidas em sua função de `Router.map`. Em outras palavras, se seu usuário navega diretamente para `/posts/new`, o servidor deve ser configurado para servir sua aplicação Ember em resposta.

## hash

A opção de `hash` usa âncora da URL para carregar o estado inicial da sua aplicação e vai mantê-lo em sincronia enquanto você utiliza. Atualmente, se baseia em um evento de [hashchange](http://caniuse.com/hashchange) existente no navegador.

No exemplo de router acima, entrar em `/#/posts/new` irá levá-lo para a rota de `posts.new`.

## none

Finalmente, se você não quiser que a URL do navegador interaja com sua aplicação em tudo, você pode desabilitar a location API inteiramente, definindo `ENV.locationType` para `none`. Isso é útil para testar ou quando você não quer Ember suje sua URL (por exemplo, quando você incorpora sua aplicação em uma página maior).