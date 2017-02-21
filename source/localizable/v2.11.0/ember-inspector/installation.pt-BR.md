Você pode instalar o Ember Inspector no Google Chrome, Firefox e outros browsers (através de bookmarklet) e em dispositivos mobile seguindo os passos abaixo.

### Google Chrome

Você pode instalar o Ember Inspector no Google Chrome como uma nova ferramenta de desenvolvedor. Para começar, visite a página de Extensões no [Chrome Web Store](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi).

Clique em "Adicionar ao Chrome":

<img src="../../images/guides/ember-inspector/installation-chrome-store.png" width="680" />

Uma vez instalado, vá para uma aplicação Ember, abra as ferramentas de desenvolvedor e clique na guia `Ember` na extrema direita.

<img src="../../images/guides/ember-inspector/installation-chrome-panel.png" width="680" />

#### File:// protocol

Para usar o Ember Inspector com o protocolo `file://`, acesse `chrome://extensions` no Chrome e marque a opção "Permitir o acesso a URLs de arquivo":

<img src="../../images/guides/ember-inspector/installation-chrome-file-urls.png" width="400" />

#### Habilitar Tomster

Você pode configurar um ícone Tomster para aparecer na barra de URL do Google Chrome, sempre que você estiver visitando um site que usa o Ember.

Acesse `chrome://extensions`, e em seguida clique em `Opções`.

<img src="../../images/guides/ember-inspector/installation-chrome-tomster.png" width="400" />

Verifique se a caixa de seleção (checkbox) "Display the Tomster" está marcada.

<img src="../../images/guides/ember-inspector/installation-chrome-tomster-checkbox.png" width="400" />

### Firefox

Acesse a página de add-on no [site Mozilla Add-ons](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/).

Clique em "Add to Firefox".

<img src="../../images/guides/ember-inspector/installation-firefox-store.png" width="680" />

Uma vez instalado, vá para uma aplicação Ember, abra as ferramentas de desenvolvedor e clique na aba `Ember` na extrema direita.

<img src="../../images/guides/ember-inspector/installation-firefox-panel.png" width="680" />

#### Habilitar Tomster

Para habilitar o ícone Tomster para aparecer na barra de URL, sempre que você estiver visitando um site que usa Ember, acesse `about:addons`.

Clique em `Extensions` -> `Preferences`.

<img src="../../images/guides/ember-inspector/installation-firefox-preferences.png" width="600" />

Então verifique se a caixa de seleção (checkbox) "Display the Tomster icon when a site runs Ember.js" está marcada.

<img src="../../images/guides/ember-inspector/installation-firefox-tomster-checkbox.png" width="400" />

### Via Bookmarklet

Se você estiver usando um navegador diferente do Chrome ou Firefox, você pode usar a opção bookmarklet para usar o Ember Inspector.

Adicione o seguinte bookmark:

[Bookmark Me](javascript: (function() { var s = document.createElement('script'); s.src = '//ember-extension.s3.amazonaws.com/dist_bookmarklet/load_inspector.js'; document.body.appendChild(s); }());)

Para abrir o Ember Inspector, clique sobre o novo bookmark. Safari bloqueia pop-ups por padrão, então você precisará habilitar pop-ups antes de usar o bookmarklet.

### Dispositivos Mobile

Se você deseja executar o Ember Inspector em um dispositivo móvel, você pode usar o add-on [Ember CLI Remote Inspector](https://github.com/joostdevries/ember-cli-remote-inspector).