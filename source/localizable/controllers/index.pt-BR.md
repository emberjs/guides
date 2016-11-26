## Controllers

Controllers comportam-se como um tipo especializado de Component que é renderizado pelo router quando entra em uma Route.

O Controller recebe uma unica propriedade da Route – `model` – que é o valor de retorno do método `model` da Route.

Para definir um Controller, execute:

```shell
ember generate controller nome-do-meu-controller
```

O valor de `nome-do-meu-controller` deve corresponder ao nome da Route que o renderiza. Então uma Route denominada `blog-post` teria um controller correspondente chamado `blog-post`.

Você só precisa gerar um controller, se você quer personalizar suas propriedades ou fornecer quaisquer `actions`. Se você não tiver personalizações, Ember irá fornecer uma instância do controller para você em tempo de execução (run time).

Let's explore these concepts using an example of a route displaying a blog post. Presume a `BlogPost` model that is presented in a `blog-post` template.

The `BlogPost` model would have properties like:

* `title`
* `intro`
* `body`
* `author`

Your template would bind to these properties in the `blog-post` template:

```app/templates/blog-post.hbs 

# {{model.title}}

## by {{model.author}}

<div class="intro">
  {{model.intro}}
</div>

* * *

<div class="body">
  {{model.body}}
</div>

    <br />In this simple example, we don't have any display-specific properties
    or actions just yet. For now, our controller's `model` property acts as a
    pass-through (or "proxy") for the model properties. (Remember that
    a controller gets the model it represents from its route handler.)
    
    Let's say we wanted to add a feature that would allow the user to
    toggle the display of the body section. To implement this, we would
    first modify our template to show the body only if the value of a
    new `isExpanded` property is true.
    
    ```app/templates/blog-post.hbs
    <h1>{{model.title}}</h1>
    <h2>by {{model.author}}</h2>
    
    <div class='intro'>
      {{model.intro}}
    </div>
    <hr>
    
    {{#if isExpanded}}
      <button {{action "toggleBody"}}>Hide Body</button>
      <div class="body">
        {{model.body}}
      </div>
    {{else}}
      <button {{action "toggleBody"}}>Show Body</button>
    {{/if}}
    

You can then define what the action does within the `actions` hook of the controller, as you would with a component:

```app/controllers/blog-post.js import Ember from 'ember';

export default Ember.Controller.extend({ actions: { toggleBody() { this.toggleProperty('isExpanded'); } } }); ```