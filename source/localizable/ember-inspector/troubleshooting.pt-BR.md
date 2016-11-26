Abaixo estão alguns problemas comuns que você encontrar quando utilizar o Ember Inspector, juntamente com as medidas necessárias para resolvê-los. Se seu problema não está listado abaixo, por favor, crie uma issue no repositório GitHub do [Ember Inspector](https://github.com/emberjs/ember-inspector)..

### Aplicação Ember não detectada

Se o Ember Inspector não puder detectar uma aplicação Ember, você verá a seguinte mensagem:

<img
src="../../images/guides/ember-inspector/troubleshooting-application-not-detected.png" width="350" />

Algumas das razões pelas quais isso pode acontecer:

- Isto não é uma aplicação Ember
- Você está usando uma versão antiga do Ember ( < 1.0 ).
- Você está usando um protocolo diferente de http ou https. Para o protocolo file:// siga [estes passos](../installation/#toc_file-protocol).
- A aplicação Ember está dentro de um iframe em uma área restrita sem nenhuma URL (se você estiver usando JS Bin, siga [estes passos](#toc_using-the-inspector-with-js-bin).

### Usando o Ember Inspector com JS Bin

Devido à forma como JS Bin usa iframes, o Ember Inspector não funciona com o modo de edição. Para usar o Ember Inspector com JS Bin, mude para o modo "live preview" , clicando na seta dentro de um círculo abaixo. 

<img src="../../images/guides/ember-inspector/troubleshooting-jsbin.png" width="350" />

### Aplicação não é detectada sem o Reload

Se você sempre tem que recarregar sua aplicação depois que você abre o Ember Inspector, isto pode significar que a inicialização da aplicação está corrompida. Isso acontece se você chamar `advanceReadiness` ou `deferReadiness` depois que a aplicação já estiver sido iniciada.

### Data Adapter não detectado

Quando você clica na tab de Data e vê esta mensagem:

<img src="../../images/guides/ember-inspector/troubleshooting-data-adapter.png" width="350" />

Isso significa que a biblioteca de persistência de dados que você está usando não suporta o Ember Inspector. Se você é autor da biblioteca, [consulte esta seção](../data/#toc_building-a-data-custom-adapter) para adicionar suporte de Ember Inspector para sua biblioteca.

### Promises não detectadas

Quando você clica na tab de Promises e você vê esta mensagem:

<img src="../../images/guides/ember-inspector/troubleshooting-promises-not-detected.png" width="350" />

Isso acontece se você estiver usando uma versão do Ember < 1.3.

#### Falta de Promises

Se a tab de Promises está funcionando, mas há Promises que você não consegue encontrar, é provavelmente porque estas promises foram criadas antes que o Ember Inspector fosse ativado. Para detectar as Promises no momento que a aplicação inicializa, clique no botão `Reload` abaixo:

<img src="../../images/guides/ember-inspector/troubleshooting-promises-toolbar.png" width="350" />

#### Ember Inspector versão antiga do Firefox

Os add-ons do Firefox precisam passar por um processo de revisão em cada atualização, então o Ember Inspector é geralmente uma versão mais antiga.

Infelizmente, não temos controle sobre o processo de revisão do Firefox, então se você precisa da versão mais recente do Ember Inspector, baixe e instale manualmente do [GitHub](https://github.com/emberjs/ember-inspector)..