Você pode responder a eventos em seu componente como duplo click, hover e key press com event handlers. Apenas implemente o nome do evento que você quer responder como um método em seu componente (component).

Como por exemplo, imagine que nos temos um template assim:

```hbs
{{#double-clickable}}
  This is a double clickable area!
{{/double-clickable}}
```

Vamos implementar `double-clickable`, dessa forma quando for clicado um alerta é exibido:

```app/components/double-clickable.js import Ember from 'ember';

export default Ember.Component.extend({ doubleClick() { alert("DoubleClickableComponent was clicked!"); } });

    <br />Eventos no navegador podem se propagar para cima (bubble up) no DOM e dessa forma atingirem component(s) pai. Para permitir isso `return true;` no método implementado em seu componente (component).
    
    ```app/components/double-clickable.js
    import Ember from 'ember';
    
    export default Ember.Component.extend({
      doubleClick() {
        Ember.Logger.info("DoubleClickableComponent was clicked!");
        return true;
      }
    });
    

Consulte a lista de nomes de evento no final desta página. Qualquer evento pode ser definido como um método (event handler) em seu componente.

## Envio de ações

Em alguns casos, seu componente precisa definir métodos (event handlers), talvez para oferecer suporte a vários comportamentos arrastáveis. Por exemplo, um componente pode ser necessário enviar um `id` quando ele recebe um evento de drop:

```hbs
{{drop-target action=(action "didDrop")}}
```

Você pode definir métodos (event handlers) no componente para gerenciar o evento de drop. E se você precisar, você também pode parar eventos de propagação (bubble up), usando `return false;`.

```app/components/drop-target.js import Ember from 'ember';

export default Ember.Component.extend({ attributeBindings: ['draggable'], draggable: 'true',

dragOver() { return false; },

drop(event) { let id = event.dataTransfer.getData('text/data'); this.get('action')(id); } });

    <br />Na componente acima, 'didDrop' é a 'action' passada. Esta ação é chamada no método 'drop' e passa um argumento para a action - o valor do 'id' encontrado através do objeto de evento 'drop'.
    
    
    Outra maneira de preservar o evento nativo é usar uma action, ou seja atribuir uma closure action para um método (event handler). Considere o modelo abaixo, que inclui um método de 'onclick' em um elemento 'button': ' ' hbs < botão onclick ={{action 'signUp'}} > Sign Up < / botão >
    

A ação de `signUp` é simplesmente uma função definida sobre o hash de `action` de um componente. Desde que a ação é atribuída a um método, a definição da função receberá o objeto de evento como seu primeiro parâmetro.

```js
actions: {
  signUp: function(event){ 
    // Only when assigning the action to an inline handler, the event object
    // is passed to the action as the first parameter.
  }
}
```

O comportamento normal para uma função definida em `actions` não recebe o evento do navegador como um argumento. Então, a definição da função para action não pode definir um parâmetro para evento. O exemplo a seguir demonstra o comportamento padrão usando uma ação.

```hbs
<button {{action 'signUp'}}>Sign Up</button>
```

```js
actions: {
  signUp: function(){
    // No event object is passed to the action.
  }
}
```

Para utilizar um objeto de `event` como um parâmetro de função:

* Defina o método no componente (que é projetado para receber o objeto de evento do navegador).
* Ou, atribua uma action ao event handler no template (que cria uma closure action e recebe o objeto de evento como um argumento).

## Nomes de eventos

Os exemplos de manipulação de evento descritos acima respondem a um conjunto de eventos. Os nomes dos eventos internos estão listados abaixo. Eventos personalizados podem ser registrados usando o [Ember.Application.customEvents](http://emberjs.com/api/classes/Ember.Application.html#property_customEvents).

Eventos de toque:

* `touchStart`
* `touchMove`
* `touchEnd`
* `touchCancel`

Eventos de teclado

* `keyDown`
* `keyUp`
* `keyPress`

Eventos de mouse

* `mouseDown`
* `mouseUp`
* `contextMenu`
* `click`
* `doubleClick`
* `mouseMove`
* `focusIn`
* `focusOut`
* `mouseEnter`
* `mouseLeave`

Eventos de formulário:

* `submit`
* `change`
* `focusIn`
* `focusOut`
* `input`

HTML5 arrastar e soltar eventos:

* `dragStart`
* `drag`
* `dragEnter`
* `dragLeave`
* `dragOver`
* `dragEnd`
* `drop`