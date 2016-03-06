Antes de começar a escrever qualquer código de Ember, é uma boa idéia obter uma visão geral de como funciona um aplicativo Ember.

![ember core concepts](../../images/ember-core-concepts/ember-core-concepts.png)

## Router and Route Handlers

Imagine que estamos escrevendo um aplicativo da web para um sítio que permite ao usuário listar suas propriedades para alugar. At any given time, we should be able to answer questions about the current state like *What rental are they looking at?* and *Are they editing it?* In Ember, the answer to these questions is determined by the URL. A URL pode ser definido de algumas maneiras:

* O usuário carrega o aplicativo pela primeira vez.
* O usuário altera o URL manualmente, por exemplo clicando no botão voltar ou editando a barra de endereços.
* O usuário clica em uma ligação dentro do aplicativo.
* Algum outro evento no aplicativo que faz mudar a URL.

No matter how the URL gets set, the first thing that happens is that the Ember router maps the URL to a route handler.

The route handler then typically does two things:

* Ele renderiza uma template.
* Ele carrega o modelo que estará disponível na template.

## Templates

Ember uses templates to organize the layout of HTML in an application.

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

For example, a property rentals application would want to save the details of a rental when a user publishes it, and so a rental would have a model defining its details, perhaps called the *rental* model.

A model typically persists information to a web server, although models can be configured to save to anywhere else, such as the browser's Local Storage.

## Componentes

Enquanto que as templates descrevem a aparência de uma interface de usuário, os componentes controlam como a interface *se comporta*.

Componentes consisten em duas partes: uma template escrita em Handlebars, e um ficheiro de código escrito em JavaScript que define o seu comportamento. For example, our property rental application might have a component for displaying all the rentals called `all-rentals`, and another component for displaying an individual rental called `rental-tile`. The `rental-tile` component might define a behavior that lets the user hide and show the image property of the rental.

Vamos ver estes conceitos básicos em ação através da construção de uma aplicação de aluguel de propriedade na próxima lição.