## Controllers

Controllers comportam-se como um tipo especializado de Component que é renderizado pelo router quando entra em uma Route.

O Controller recebe uma unica propriedade da Route – `model` – que é o valor de retorno do método `model` da Route.

Para definir um Controller, execute:

```shell
ember generate controller nome-do-meu-controller
```

O valor de `nome-do-meu-controller` deve corresponder ao nome da Route que o renderiza. Então uma Route denominada `blog-post` teria um controller correspondente chamado `blog-post`.

Você só precisa gerar um controller, se você quer personalizar suas propriedades ou fornecer quaisquer `actions`. Se você não tiver personalizações, Ember irá fornecer uma instância do controller para você em tempo de execução (run time).

Vamos explorar esses conceitos, usando um exemplo de uma Route exibindo um post de blog. Vamos supor que exista um model `BlogPost` que é exibido em um template de `blog-post`.

O modelo de `BlogPost` teria propriedades como:

* `title`
* `intro`
* `body`
* `author`

Seu template deve vincular essas propriedades no template de `blog-post`:

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

    <br />Neste exemplo simples, ainda não temos nenhuma property de exibição específica ou actions. For now, our controller's `model` property acts as a
    pass-through (or "proxy") for the model properties. (Lembre-se que um controller recebe o model que representa a partir do seu route handler). 
    
    Digamos que nós queremos adicionar uma feature que permita que o usuário alterne (toggle) a exibição de uma div com class body. Para implementar isso, nós primeiro devemos modificar nosso template para mostrar o body somente se o valor da propriedade `isExpanded` for true.
    
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
    

Podemos então definir o que a action faz dentro do hook de `actions` do controller, como você faria com um component:

```app/controllers/blog-post.js import Ember from 'ember';

export default Ember.Controller.extend({ actions: { toggleBody() { this.toggleProperty('isExpanded'); } } }); ```