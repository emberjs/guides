Antes de começar a escrever qualquer código em Ember, é uma boa idéia obter uma visão geral de como funciona um aplicativo Ember.

![ember core concepts](../../images/ember-core-concepts/ember-core-concepts.png)

## Roteador e manipuladores de rotas

Imagine que estamos escrevendo um aplicativo da web para um sítio que permite ao usuário listar suas propriedades para alugar. A qualquer momento, devemos ser capazes de responder a perguntas sobre o estado atual, como *que aluguel eles estão olhando?* e *eles estão editando?* Em Ember, a resposta a estas perguntas é determinada pela URL. A URL pode ser definida de algumas maneiras:

* O usuário carrega o aplicativo pela primeira vez.
* O usuário altera o URL manualmente, por exemplo clicando no botão voltar ou editando a barra de endereços.
* O usuário clica em uma ligação dentro do aplicativo.
* Algum outro evento no aplicativo que faz mudar a URL.

Não importa como a URL foi definida, a primeira coisa que acontece é que o roteador do Ember mapeia a URL para um manipulador de rotas.

O manipulador de rota então normalmente faz duas coisas:

* Ele renderiza um template.
* Ele carrega o modelo que estará disponível na template.

## Templates

Ember usa templates para organizar a estrutura HTML de um aplicativo.

A maioria das templates em um projeto Ember são familiares, e se parecem com um qualquer fragmento de HTML. Por exemplo:

```handlebars
<div>Hi, this is a valid Ember template!</div>
```

As templates do Ember usam a sintaxe [Handlebars](http://handlebarsjs.com). Tudo o que é sintaxe válida do Handlebars é sintaxe válida de Ember.

As templates podem também mostrar propriedades fornecidas através do contexto, que pode ser tanto um component como uma rota. Por exemplo:

```handlebars
<div>Hi {{name}}, this is a valid Ember template!</div>
```

Aqui, `{{name}}` é uma propriedade fornecida pelo contexto da template.

Além de propriedades, duplas chavetas (`{{}}`) podem conter também auxiliares e componentes, que discutiremos mais tarde.

## Modelos

Modelos representam um estado persistente.

Por exemplo, um aplicativo de aluguel de propriedades iria querer salvar os detalhes de uma locação quando um usuário publica-lo, e então uma locação teria um modelo definindo seus detalhes, talvez chamando o modelo de *locação*.

Um modelo tipicamente persiste informações para um servidor web, apesar de modelos poderem ser configurados para salvar em qualquer outro lugar, como armazenamento local no navegador (Local Storage).

## Componentes

Enquanto que as templates descrevem a aparência de uma interface de usuário, os componentes controlam como a interface *se comporta*.

Componentes consisten em duas partes: uma template escrita em Handlebars, e um ficheiro de código escrito em JavaScript que define o seu comportamento. Por exemplo, nossa aplicação de aluguel de propriedades pode ter um componente para exibir todos as locações chamado de `locacoes-todos` e outro componente para exibir uma locação individual chamado `locacoes-item`. O componente `locacoes-item` pode definir um comportamento que permite ao usuário ocultar e mostrar a imagem da propriedade.

Vamos ver estes conceitos básicos em ação através da construção de uma aplicação de aluguel de propriedade na próxima lição.