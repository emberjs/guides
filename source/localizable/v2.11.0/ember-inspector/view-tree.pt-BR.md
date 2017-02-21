Você pode usar a View Tree para inspecionar o estado atual da sua aplicação. A View Tree exibe os templates, models, controllers e components corrente em um formato de árvore. Para vê-la, clique no menu `View Tree` à esquerda.

<img src="../../images/guides/ember-inspector/view-tree-screenshot.png" width="680" />

Utilize as dicas descritas no [Object Inspector](../object-inspector) para inspecionar models e controllers. Veja abaixo para inspecionar templates e components.

### Inspeção de Templates

Para ver como um templates foi renderizado por Ember, clique no template na View Tree. Se você estiver usando o Chrome ou Firefox, você será enviado para o painel de elementos com esse elemento DOM selecionado.

<img src="../../images/guides/ember-inspector/view-tree-template.png"
width="350" />

<img src="../../images/guides/ember-inspector/view-tree-elements-panel.png"
width="450" />

### Components e Inline Views

A View Tree ignora components e inline views por padrão. Para carregá-los na View Tree, verifique as caixas de seleção (checkbox) de `Components` e `All Views`.

<img src="../../images/guides/ember-inspector/view-tree-components.png"
width="600" />

Em seguida, você pode inspecionar os components usando o Object Inspector.

### Highlighting Templates

#### Hover sobre a View Tree

Quando você passa o mouse sobre os itens nas View Tree, os templates relacionados vão ser destacados (highlighted) na sua aplicação. Para cada template destacado, você poderá ver o nome do template e seus objetos associados.

<img src="../../images/guides/ember-inspector/view-tree-highlight.png" width="680" />

#### Hover sobre a aplicação

Se você quer destacar um template ou component diretamente dentro de sua aplicação, clique na lupa dentro do Ember Inspector e então passe o mouse sobre a aplicação. Como o nosso mouse passa sobre ela, o template ou component relacionado será destacado.

<img src="../../images/guides/ember-inspector/view-tree-magnifying-glass.png" width="500" />

Se você clicar em um template ou component destacado, o Ember Inspector vai selecioná-lo. Em seguida, você pode clicar sobre os objetos para enviá-los para o Object Inspector.

![](../../images/guides/ember-inspector/view-tree-inspect.png)

Clique no botão `X` para cancelar a seleção de um template.

### Duração

A coluna duration (duração) exibe o tempo de renderização para um determinado template, incluindo os filhos desse template.

<img src="../../images/guides/ember-inspector/view-tree-duration.png"
width="500" />

Ao medir o tempo de renderização, o Ember Inspector adiciona um pequeno delay (atraso) no processo de renderização. Como tal, a duração não é uma representação exata do tempo de renderização esperado para uma aplicação Ember em produção. Assim, a duração de renderização é mais útil para comparar tempo do que como uma media absoluta de performance.