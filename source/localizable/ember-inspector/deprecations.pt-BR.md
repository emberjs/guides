Como parte de fazer os upgrades da sua aplicação serem tão simples quanto possível, o Ember Inspetor reúne suas deprecations, agrupando-as e apresenta-las de uma forma que ajude a corrigi-los.

Para visualizar a lista de deprecations em uma aplicação, clique no menu de `Deprecations`.

<img src="../../images/guides/ember-inspector/deprecations-screenshot.png" width="680" />

Você pode ver o número total de deprecations ao lado do menu de `Deprecations`. Você também pode ver o número de ocorrências para cada deprecations.

### Ember CLI Deprecation

Se você estiver usando Ember CLI e tem source maps habilitado, você pode ver uma lista de fontes para cada deprecation. Se você estiver usando o Chrome ou Firefox, clicando na fonte abre o painel de fontes e leva-o para o código que causou a mensagem de deprecation a ser exibido.

![](../../images/guides/ember-inspector/deprecations-source.png)

<img src="../../images/guides/ember-inspector/deprecations-sources-panel.png" width="550" />

You can send the deprecation message's stack trace to the console by clicking on `Trace in the console`.

### Transition Plans

Click on the "Transition Plan" link for information on how to remove the deprecation warning, and you'll be taken to a helpful deprecation guide on the Ember website.

<img src="../../images/guides/ember-inspector/deprecations-transition-plan.png" width="680" />

### Filtering and Clearing

You can filter the deprecations by typing a query in the search box. You can also clear the current deprecations by clicking on the clear icon at the top.

<img src="../../images/guides/ember-inspector/deprecations-toolbar.png"
width="300" />