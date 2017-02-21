Você pode inspecionar seus models clicando na aba `Data`. Confira abaixo a seção [Construindo um Data Custom Adapter](#toc_building-a-data-custom-adapter) se você mantém a sua própria biblioteca de persistência de dados. Quando você abre a aba de Data, você verá uma lista de model types definido na sua aplicação, juntamente com o número de registros carregados. O Ember Inspector exibe os registros carregados quando você clica em um model type.

<img src="../../images/guides/ember-inspector/data-screenshot.png" width="680" />

### Inspecionando registros

Cada linha da lista corresponde a um registro. Os primeiros quatro atributos do model são mostrados na exibição de lista. Clicando sobre o registro irá abrir o Object Inspector desse registro e exibir todos os atributos.

<img src="../../images/guides/ember-inspector/data-object-inspector.png"
width="680" />

### Estado de registros e Filtros

A aba de Data é mantida em sincronia com os dados carregados em sua aplicação. Qualquer registro adicionado, excluído ou alterado são refletidos imediatamente. Se você tem registros não salvos, eles serão exibidos em verde, clicando sobre a New pill.

<img src="../../images/guides/ember-inspector/data-new-records.png"
width="680" />

Clique sobre a Modified pill para exibir modificações de registro que não foram salvas.

<img src="../../images/guides/ember-inspector/data-modified-records.png"
width="680" />

Você também pode filtrar registros inserindo uma consulta na caixa de pesquisa.

### Construindo um Data Custom Adapter

Você pode usar sua própria biblioteca de persistência de dados com o Ember Inspector. Construa um [data adapter](https://github.com/emberjs/ember.js/blob/3ac2fdb0b7373cbe9f3100bdb9035dd87a849f64/packages/ember-extension-support/lib/data_adapter.js) e você pode inspecionar seus models usando a aba de Data. Use [Ember Data's data adapter](https://github.com/emberjs/data/blob/d7988679590bff63f4d92c4b5ecab173bd624ebb/packages/ember-data/lib/system/debug/debug_adapter.js) como um exemplo de como construir o seu data adapter.