O Ember Inspector inclui um painel que permite visualizar e interagir com os objetos do Ember. Para abri-lo, clique em qualquer objeto Ember. Em seguida, você pode exibir as propriedades do objeto.

### Visualização de objetos

Aqui está o que você vê quando você clica em um objeto:

<img src="../../images/guides/ember-inspector/object-inspector-controller.png" width="450" />

O Ember Inspector exibe os objetos pai e mixins que são compostas para o objeto escolhido, incluindo as propriedades herdadas.

Cada valor de propriedade nesta visualização é vinculado ao seu aplicativo, então se o valor de uma propriedade atualiza em seu aplicativo, isso será refletido no Ember Inspector.

Se um nome de propriedade é precedido por um ícone de calculadora, significa que é uma [propriedade de computado (Computed)](../../object-model/computed-properties). Se ainda não foi calculado o valor de uma propriedade calculada, você pode clicar na calculadora para calcular isso.

### Expor objetos no console

#### Envio de Inspector para o Console

Você pode expor objetos no console, clicando no botão `$E` dentro do Ember Inspetor. Isto irá definir a variável global `$E` ao objeto escolhido.

<img src="../../images/guides/ember-inspector/object-inspector-$E.png"
width="450" />

Você também pode expor propriedades para o console. Quando você passa o mouse sobre as propriedades de um objeto, um botão de `$E` aparecerá ao lado de cada propriedade. Clique nele para expor o valor da propriedade para o console.

<img src="../../images/guides/ember-inspector/object-inspector-property-$E.png" width="450" />

#### Envio do Console para o Inspetor

Você pode enviar objetos Ember e matrizes para o Inspetor usando `EmberInspector.inspect` dentro do console.

```javascript
var object = Ember.Object.create();
EmberInspector.inspect(object);
```

Certifique-se que o inspetor está ativo quando você chamar esse método.

### Editar Propriedades

Você pode editar `String`, `Number` e `Boolean` propriedades no Inspetor. As alterações se refletirão imediatamente no seu app. clique em um valor propriedade para começar a editá-lo.

<img src="../../images/guides/ember-inspector/object-inspector-edit.png"
width="450" />

Edite a propriedade e pressione a tecla `ENTER` para confirmar a alteração, ou `ESC` para cancelar.

### Navegando no Inspetor

Além de inspecionar as propriedades acima, você pode inspecionar propriedades que contenham objetos Ember ou matrizes. Clique sobre o valor da propriedade para inspecioná-lo.

<img src="../../images/guides/ember-inspector/object-inspector-object-property.png" width="450" />

You can continue drill into the Inspector as long as properties contain either an Ember object or an array. Na imagem abaixo, nós clicado na propriedade `model` primeiro, em seguida, clicamos sobre a propriedade de `store`.

<img src="../../images/guides/ember-inspector/object-inspector-nested-objects.png" width="450" />

Você pode ver o caminho para o objeto atual na parte superior do Inspector. Você pode voltar para o objeto anterior clicando na seta para a esquerda no canto superior esquerdo.

### Agrupamento de propriedade personalizada

Apenas algumas propriedades não são agrupadas por herança, mas também pelo nível de semântica. Por exemplo, se você inspecionar um Ember Data, você vai ver grupos de `attributes`, `Belongs To`, `Has Many` e `Flags`.

<img src="../../images/guides/ember-inspector/object-inspector-model.png"
width="450" />

Autores da biblioteca podem personalizar como qualquer objeto é exibido no Inspetor. Definindo um método `_debugInfo`, um objeto pode dizer inspecionado durante o processamento. Para obter um exemplo sobre como personalizar Propriedades de um objeto, consulte [Ember Data's Customization](https://github.com/emberjs/data/blob/f1be2af71d7402d034bc034d9502733647cad295/packages/ember-data/lib/system/debug/debug_info.js).