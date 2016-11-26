Na maioria dos casos, toda a Interface de Usuário (UI) da sua aplicação será criada por templates que são gerenciados por rotas.

Mas se você tiver uma aplicação Ember.js que você precisa embedar (incorporar) em uma página que já existe ou rodar junto com outro framework JavaScript ou rodar sobre o mesmo domínio como se fosse uma outra aplicação?

### Trocando o elemento raiz

Por padrão, sua aplicação irá renderizar a [application template](../../routing/defining-your-routes/#toc_the-application-route) e anexá-la ao elemento `body` do documento. 

Você pode dizer à aplicação para acrescentar a application template para um elemento diferente, especificando sua propriedade `rootElement`:

```app/app.js import Ember from 'ember';

export default Ember.Application.extend({ rootElement: '#app' });

    <br />Esta propriedade pode ser especificada como um elemento ou uma [cadeia de caracteres compatível com seletor jQuery] (http://api.jquery.com/category/selectors/).
    
    ### Desativando gerenciamento de URL
    
    Você pode impedir que o Ember faça alterações na URL, alterando by [alterando`location` do router](../specifying-url-type) para
    `none`:
    
    ```config/environment.js
    var ENV = {
      locationType: 'none'
    };
    

### Especificando uma URL raiz

Se sua aplicação Ember é uma das várias aplicações web, servidas no mesmo domínio, pode ser necessário indicar ao router qual é a URL raiz para sua aplicação Ember. Por padrão, Ember vai assumir que é servido na raiz do seu próprio domínio.

Por exemplo, se você queria servir a sua aplicação de blog de `http://emberjs.com/blog/`, seria necessário especificar uma URL raiz do `/blog/`.

Isso é possível através da configuração do `rootURL` no seu router:

    app/router.js
    Ember.Router.extend({
      rootURL: '/blog/'
    });