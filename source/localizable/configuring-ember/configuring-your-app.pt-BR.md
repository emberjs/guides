Ember CLI vem com suporte para gerenciar o ambiente de seu aplicativo. Ember CLI vai configurar um arquivo de configuração de ambiente padrão em `config/environment`. Aqui, você pode definir um objeto `ENV` para cada ambiente, que são atualmente limitados a três: desenvolvimento, teste e produção.

O objeto ENV contém três importantes chaves:

- `EmberENV` can be used to define Ember feature flags (see the [Feature Flags guide](../feature-flags/)).
- `APP` can be used to pass flags/options to your application instance.
- `environment` contains the name of the current environment (`development`,`production` or `test`).

Você pode acessar essas variáveis de ambiente diretamente do código-fonte de seu aplicativo importando `your-application-name/config/environment`.

Por exemplo:

```js
import ENV from 'your-application-name/config/environment';

if (ENV.environment === 'development') {
  // ...
}
```