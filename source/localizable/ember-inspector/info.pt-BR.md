Para ver uma lista de bibliotecas usadas em sua aplicação, clique no menu `Info`. Este modo exibe as bibliotecas usadas, justamente com sua versão.

<img src="../../images/guides/ember-inspector/info-screenshot.png" width="680" />

### Registrando uma biblioteca

Se você gostaria de adicionar seu própria aplicação ou biblioteca para a lista, você pode registrá-lo usando:

```javascript
Ember.libraries.register(libraryName, libraryVersion);
```

#### Ember Cli

If you're using the [ember-cli-app-version](https://github.com/embersherpa/ember-cli-app-version) addon, your application's name and version will be added to the list automatically.