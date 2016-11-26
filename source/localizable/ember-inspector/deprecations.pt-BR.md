Como parte de fazer os upgrades da sua aplicação serem tão simples quanto possível, o Ember Inspetor reúne suas deprecations, agrupando-as e apresenta-las de uma forma que ajude a corrigi-los.

Para visualizar a lista de deprecations em uma aplicação, clique no menu de `Deprecations`.

<img src="../../images/guides/ember-inspector/deprecations-screenshot.png" width="680" />

Você pode ver o número total de deprecations ao lado do menu de `Deprecations`. Você também pode ver o número de ocorrências para cada deprecations.

### Ember CLI Deprecation

Se você estiver usando Ember CLI e tem source maps habilitado, você pode ver uma lista de fontes para cada deprecation. Se você estiver usando o Chrome ou Firefox, clicando na fonte abre o painel de fontes e leva-o para o código que causou a mensagem de deprecation a ser exibido.

![](../../images/guides/ember-inspector/deprecations-source.png)

<img src="../../images/guides/ember-inspector/deprecations-sources-panel.png" width="550" />

Você pode enviar a mensagem de deprecation ao console clicando no `Trace in the console`.

### Transition Plans

Clique no link "Transition Plans" para obter informações sobre como remover o aviso de deprecation e você será levado para um guia de deprecations no site do Ember.

<img src="../../images/guides/ember-inspector/deprecations-transition-plan.png" width="680" />

### Filtrando e limpando

Você pode filtrar as deprecations digitando uma consulta na caixa de pesquisa. Você também pode limpar as deprecations atuais clicando no ícone de limpeza na parte superior.

<img src="../../images/guides/ember-inspector/deprecations-toolbar.png"
width="300" />