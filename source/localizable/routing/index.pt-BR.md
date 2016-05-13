Imagine que estamos escrevendo um aplicativo web para gerenciar um blog. Em determinado momento, ele deve ser capaz de responder a perguntas como *que post eles estão olhando?* e *eles estão editando este post?* Em Ember.js, a resposta para estas perguntas é determinada pela URL.

A URL pode ser definida de algumas maneiras:

* O usuário carrega o aplicativo pela primeira vez.
* O usuário altera o URL manualmente, clicando no botão voltar ou editando a barra de endereços, por exemplo.
* O usuário clica em um link dentro do aplicativo.
* Algum outro evento no aplicativo faz com que a URL mude.

Independentemente de como a URL seja alterada, o router de Ember mapeia a URL para um ou mais route handlers. Um route handler pode fazer várias coisas:

* Renderiza uma template.
* Carrega o model que estará eventualmente disponível para a template.
* Ele pode redirecionar para um outro route, se o usuário não tem permissão de acessar aquela parte do aplicativo, por exemplo.
* Ele pode lidar com ações que envolvem a mudança de um modelo ou em transição para outro route.