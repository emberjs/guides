Em geral, desenvolvimento de uma nova funcionalidade deve ser feito no master.

Correções de bugs não devem introduzir novas APIs ou quebrar APIs atuais, e não precisa de marcadores de recurso.

Funcionalidades novas podem introduzir novas APIs e precisam ser marcados (tags). Elas não devem ser aplicadas ao branch de lançamento ou beta, desde que SemVer requer uma versão secundária para introduzir novas funcionalidades.

Correções de segurança não devem introduzir novas APIs, mas podem, se realmente necessário, quebrar APIs existentes. Tais quebras devem ser o quanto possível evitadas.

### Correções de Bugs

#### Correções urgentes

Correções urgentes são correções de bugs que precisam ser aplicadas ao branch de lançamento existente. Se possível, devem ser feitas no master e com o prefixo [BUGFIX release].

#### Correções de bugs do beta

Correções de bugs do beta são correções de bugs que precisam ser aplicadas ao branch do beta. Se possível, deverão ser feitas no master e marcados com [BUGFIX beta].

#### Correções de segurança

Correções de segurança devem ser aplicados no branch de beta, no branch da versão atual e na última etiqueta. Se possível, deverão ser feitas no master e marcados com [SECURITY].

### Funcionalidades

Funcionalidades sempre devem ser organizados com uma etiqueta de funcionalidade. Testes para a funcionalidade também devem ser organizados com uma etiqueta de funcionalidade.

Como as ferramentas de compilação irão processar as etiquetas de funcionalidades, essas etiquetas devem usar precisamente este formato. Estamos escolhendo condicionais, ao invés de uma forma de bloco, porque funções alteram o escopo em torno e podem apresentar problemas com retorno antecipado.

```js
if (Ember.FEATURES.isEnabled("feature")) {
  // implementação
}
```

Testes serão sempre executados com todos os recursos ativos, então certifique-se de que todos os testes para a funcionalidade estão passando de acordo com a versão atual.

#### Commits

Commits relacionados a uma funcionalidade específica devem incluir um prefixo como [FEATURE htmlbars]. Isso nos permitirá identificar rapidamente todos os commits para uma funcionalidade específica no futuro. Funcionalidades novas nunca serão aplicadas aos branches beta ou de lançamento. Uma vez que um branch beta ou release for eliminado, todas essas funcionalidades novas serão perdidas.

Se uma funcionalidade tiver sido feita no branch beta ou de lançamento, e você fizer um commit no master que corrija um bug, você deverá tratar como um bugfix conforme descrito acima.

#### Convenções de nomenclatura de funcionalidades

```config/environment.js Ember.FEATURES['<packagename>-<feature>'] // if package specific Ember.FEATURES['container-factory-injections'] Ember.FEATURES['htmlbars']

    <br /># # # Builds 
    
    A compilação Canary (Canary build), que é baseado no master, incluirá todas as funcionalidades, guiados pelas condicionais na fonte original. Isto significa que os usuários da compilação Canária podem ativar qualquer características que desejarem, bastando ativa-las antes de criar sua Ember.Application.
    
    ```config/environment.js
    module.exports = function(environment) {
      var ENV = {
        EmberENV: {
          FEATURES: {
            htmlbars: true
          }
        },
      }
    }
    

### `features.json`

Na raiz do repositório existirá um arquivo features.json, que irá conter uma lista de funcionalidades que devem ser ativados para compilações beta ou de lançamento.

Este arquivo é preenchido quando branching, e não pode ganhar novas funcionalidades após o branch original. Ele deverá remover funcionalidades.

```js
{
  "htmlbars": true
}
```

O processo de compilação irá remover qualquer funcionalidade não incluída na lista e removerá as condicionais das funcionalidades incluídas.

### Testes do Travis

Para um novo PR:

  1. Travis vai testar contra o master com todas as sinalizações de funcionalidades ativas.
  2. Se um commit for marcado com [BUGFIX beta], Travis também vai apontar este commit para o beta e executar os testes naquele branch. Se um commit não aplicar corretamente ou os testes falharem, os testes irão falhar.
  3. Se um commit estiver marcado com [BUGFIX release], Travis também vai apontar este commit para o release e executar o teste naquele branch. Se um commit não aplicar corretamente ou os testes falharem, os testes irão falhar.

Para um novo commit ao master:

  1. Travis executará os testes conforme descrito acima.
  2. Se a compilação passar, Travis vai apontar os commits aos branches apropriados.

A idéia é que novos commits devem ser enviados como PRs para garantir que eles se aplicam de forma limpa, e uma vez que for pressionado o botão de merge, Travis vai aplicá-los aos branches corretos.

### Processo de avançar/não avançar

A cada seis semanas, a equipe do núcleo passa pelo seguinte processo.

#### Beta Branch

Todos os recursos restantes no branch beta são prontamente verificados. Se qualquer recurso não estiver pronto, ele é removido do features.json.

Depois disso, o branch beta é marcado e mesclado no branch de lançamento.

#### Master Branch

Todas as funcionalidades no branch master são prontamente verificados. Para que uma funcionalidade seja considerada "pronta" nesta fase, deve estar finalizada sem bloqueios. Funcionalidades são canceladas, mesmo que elas estejam quase prontas, e um trabalho adicional no beta irá torná-la pronta.

Como esse processo acontece a cada seis semanas, haverá logo outra oportunidade para uma funcionalidade ser publicada.

Depois disso, o branch master é mesclado no beta. Um arquivo `features.json` é adicionado com as funcionalidades que estão prontas.

### Versões Beta

Toda semana, repetimos o processo de avançar/não avançar para as funcionalidades que permanecem no branch beta. Qualquer funcionalidade que não estiver pronta é removida do features.json.

Depois disso, uma versão Beta é marcada e enviada.