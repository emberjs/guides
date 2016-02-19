Antes de começar a escrever qualquer código de Ember, é uma boa idéia obter uma visão geral de como funciona um aplicativo Ember.

![ember core concepts](../../images/ember-core-concepts/ember-core-concepts.png)

## Router and Route Handlers

Imagine que estamos escrevendo um aplicativo da web para um sítio que permite ao usuário listar suas propriedades para alugar. Em qualquer momento, deve ser capaz de responder a perguntas sobre o estado atual como *que aluguel estão olhando?* e *eles estão a editá-lo?* Em Ember, a resposta a estas perguntas é determinada pelo URL. A URL pode ser definido de algumas maneiras:

* O usuário carrega o aplicativo pela primeira vez.
* O usuário altera o URL manualmente, por exemplo clicando no botão voltar ou editando a barra de endereços.
* O usuário clica em uma ligação dentro do aplicativo.
* Algum outro evento no aplicativo que faz mudar a URL.

No matter how the URL gets set, the first thing that happens is that the Ember router maps the URL to a route handler.

The route handler then typically does two things:

* Ele renderiza uma template.
* Ele carrega o modelo que estará disponível na template.

## Templates

Ember usa templates para organizar a estrutura HTML de um aplicativo.

Most templates in an Ember codebase are instantly familiar, and look like any fragment of HTML. For example:

```handlebars
<div>Hi, this is a valid Ember template!</div>
```

Templates Ember usam a sintaxe [Handlebars](http://handlebarsjs.com). Tudo o que é sintaxe válida do Handlebars é sintaxe válida de Ember.

Templates can also display properties provided to them from their context, which is either a component or a route (technically, a controller presents the model from the route to the template, but this is rarely used in modern Ember apps and will be deprecated soon). For example:

```handlebars
<div>Hi {{name}}, this is a valid Ember template!</div>
```

Aqui, `{{name}}` é uma propriedade fornecida pelo contexto da template.

Além de propriedades, duplas chavetas (`{{}}`) podem conter também auxiliares e componentes, que discutiremos mais tarde.

## Modelos

Modelos representam um estado persistente.

For example, a property rentals application would want to save the details of a rental when a user publishes it, and so a rental would have a model defining its details, perhaps called the *rental* model.

A model typically persists information to a web server, although models can be configured to save to anywhere else, such as the browser's Local Storage.

## Components

While templates describe how a user interface looks, components control how the user interface *behaves*.

Components consist of two parts: a template written in Handlebars, and a source file written in JavaScript that defines the component's behavior. For example, our property rental application might have a component for displaying all the rentals called `all-rentals`, and another component for displaying an individual rental called `rental-tile`. The `rental-tile` component might define a behavior that lets the user hide and show the image property of the rental.

Let's see these core concepts in action by building a property rental application in the next lesson.