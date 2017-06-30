Na maioria dos casos, toda a Interface de Usuário (UI) da sua aplicação será criada por templates que são gerenciados por rotas.

Mas se você tiver uma aplicação Ember.js que você precisa embedar (incorporar) em uma página que já existe ou rodar junto com outro framework JavaScript ou rodar sobre o mesmo domínio como se fosse uma outra aplicação?

### Trocando o elemento raiz

Por padrão, sua aplicação irá renderizar a [application template](../../routing/defining-your-routes/#toc_the-application-route) e anexá-la ao elemento `body` do documento. 

Você pode dizer à aplicação para acrescentar a application template para um elemento diferente, especificando sua propriedade `rootElement`:

```app/app.js{+4} …

App = Ember.Application.extend({ rootElement: '#app' modulePrefix: config.modulePrefix, podModulePrefix: config.podModulePrefix, Resolver });

…

    <br />Esta propriedade pode ser especificada como um elemento ou uma [cadeia de caracteres compatível com seletor jQuery] (http://api.jquery.com/category/selectors/).
    
    ### Disabling URL Management
    
    You can prevent Ember from making changes to the URL by [changing the
    router's `location`](../specifying-url-type) to
    `none`:
    
    ```config/environment.js{-8,+9}
    /* eslint-env node */
    
    module.exports = function(environment) {
      var ENV = {
        modulePrefix: 'my-blog',
        environment: environment,
        rootURL: '/',
        locationType: 'auto',
        locationType: 'none',
        …
      };
    
      …
    
      return ENV;
    }
    

### Especificando uma URL raiz

If your Ember application is one of multiple web applications served from the same domain, it may be necessary to indicate to the router what the root URL for your Ember application is. By default, Ember will assume it is served from the root of your domain.

For example, if you wanted to serve your blogging application from `http://emberjs.com/blog/`, it would be necessary to specify a root URL of `/blog/`.

This can be achieved by configuring the `rootURL` property on `ENV`:

```config/environment.js{-7,+8} /* eslint-env node */

module.exports = function(environment) { var ENV = { modulePrefix: 'my-blog', environment: environment, rootURL: '/', rootURL: '/blog/', locationType: 'auto', … }; }

    <br />You will notice that this is then used to configure your application's router:
    
    ```app/router.js
    import Ember from 'ember';
    import config from './config/environment';
    
    const Router = Ember.Router.extend({
      location: config.locationType,
      rootURL: config.rootURL
    });
    
    Router.map(function() {
    });
    
    export default Router;