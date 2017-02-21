Além de configurar seu próprio aplicativo, você também pode configurar o Ember CLI. Essas configurações podem ser feitas adicionando-as ao arquivo `.ember-cli` na raiz do seu projeto. Muitos também podem ser feitos passando-os como argumentos através da linha de comando.

Por exemplo, é comum querer mudar a porta em que o Ember CLI serve o aplicativo. É possível passar o número da porta direto da linha de comando com `ember server --port 8080`. Para fazer essa configuração permanente, edit o seu arquivo `.ember-cli` deste modo:

```json
{
  "port": 8080
}
```

Para obter uma lista completa das opções de linha de comando, execute `ember help`.