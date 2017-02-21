Ember CLI vem com suporte para gerenciar o ambiente de seu aplicativo. Ember CLI vai configurar um arquivo de configuração de ambiente padrão em `config/environment`. Aqui, você pode definir um objeto `ENV` para cada ambiente, que são atualmente limitados a três: desenvolvimento, teste e produção.

O objeto ENV contém três importantes chaves:

- `EmberENV` pode ser utilizado para definir Ember feature flags (veja o [guia de Feature Flags](../feature-flags/)).
- `APP` pode ser utilizado para passar flags/opções para a instância da sua aplicação.
- `environment` contém o nome do atual ambiente que sua aplicação está rodando: (`development`, `production` ou `test`).

Você pode acessar essas variáveis de ambiente diretamente do código-fonte de seu aplicativo importando `nome-da-sua-aplicacao/config/environment`.

Por exemplo:

```js
import ENV from 'nome-da-sua-aplicacao/config/environment';

if (ENV.environment === 'development') {
  // ...
}
```