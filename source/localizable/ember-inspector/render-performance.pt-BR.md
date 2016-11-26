Você pode usar o Ember Inspector para medir o tempo de renderização da sua aplicação. Clique em `Render Performance` para iniciar a análise do tempo de renderização.

<img src="../../images/guides/ember-inspector/render-performance-screenshot.png" width="680" />

### Precisão

Usar o Ember Inspector adiciona um delay (atraso) na renderização da sua aplicação, então o tempo de renderização que você vê, não é uma representação exata da velocidade que sua aplicação terá em produção. Use esses tempos para comparar a duração e debugar os gargalos de renderização, mas não use como uma forma de medir com precisão o tempo de renderização.

### Toolbar

Clique no ícone "clear" para remover os logs de renderização existentes.

Para medir os componentes e templates que são renderizados na inicialização da aplicação, clique no botão "Reload" na parte superior. Este botão garante que o Ember Inspector comece a mensurar o tempo de renderização quando a sua aplicação é inicializada.

Para filtrar os logs (registros), digite uma consulta na caixa de pesquisa.