A aba de Routes (rotas) exibe uma lista de rotas da sua aplicação.

Para o seguinte código:

```javascript
this.route('posts', function() {
  this.route('new');
});
```

O Ember Inspector exibe estas rotas:

<img src="../../images/guides/ember-inspector/routes-screenshot.png" width="680" />

Como você pode ver, o Ember Inspector mostra as rotas que você definiu bem como as rotas geradas automaticamente pelo Ember.

### Visualizando a Rota atual

O Ember Inspector destaca as rotas atualmente ativas. No entanto, se a sua aplicação tiver crescido muito, ao ponto dessa solução não ser mais útil, você pode usar a opção `Current Route Only` para esconder todas as rotas, exceto a que está atualmente ativa.

<img src="../../images/guides/ember-inspector/routes-current-route.png"
width="680" />