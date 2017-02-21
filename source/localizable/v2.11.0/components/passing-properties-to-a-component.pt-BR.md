Componentes são isolados de seu ambiente, por isso qualquer dado que o componente precisa ser passado.

Por exemplo, imagine que você tem um `blog-post` componente que é usado para exibir um post no blog:

```app/templates/components/blog-post.hbs <article class="blog-post"> 

# {{title}}

{{body}}</article>

    <br />Agora imagine o seguinte template e rota (route):
    
    ```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.get('store').findAll('post');
      }
    });
    

Se nós tentarmos usar o componente como este:

' ' app/templates/index.hbs {{#each model as |post|}} {{blog-post}} {{/ cada}}

    <br />Ia ser processado o seguinte HTML: ' ' html < artigo classe = "blog post" >< h1 >< / h1 >< p >< / p >< / artigo >
    

A fim de passar uma propriedade para um componente, você deve passá-lo assim:

```app/templates/index.hbs {{#each model as |post|}} {{blog-post title=post.title body=post.body}} {{/each}}

    <br />É importante observar que essas propriedades permaneçam em sincronia (tecnicamente conhecido como sendo o "bound"). Ou seja, se o valor de 'componentProperty' mudar no componente, 'outerProperty' será atualizado para refletir essa alteração. O inverso também é verdadeiro.
    
    # # Posicional Params 
    Além de passar os parâmetros por nome, você pode passar também por posição.
    Em outras palavras, você pode invocar o exemplo acima do componente assim: ' ' app/templates/index.hbs {{#each model as |post|}} {{blog-post post.title post.body}} {{/ each}}
    

Para configurar o componente para receber parâmetros desta forma, você precisa definir o atributo [`positionalParams`](http://emberjs.com/api/classes/Ember.Component.html#property_positionalParams) na sua classe de componente.

```app/components/blog-post.js import Ember from 'ember';

const BlogPostComponent = Ember.Component.extend({});

BlogPostComponent.reopenClass ({positionalParams: ['título', 'corpo']});

padrão de exportação BlogPostComponent;

    <br />Em seguida, você pode usar os atributos do componente, exatamente como se eles fossem passados '{{blog post title=post.title body=post.body}}'.
    
    Observe que a propriedade 'positionalParams' é adicionada na classe como uma variável estática através de 'reopenClass'. Parâmetros posicionais são sempre declarados na classe do componente e não podem ser alterados enquanto um aplicativo é executado.
    
    Como alternativa, você pode aceitar um número arbitrário de parâmetros definindo 'positionalParams' para uma sequência de caracteres, por exemplo, ' positionalParams: ' params '. Isso permitira que você acesse os paramos como um array:
    
    ```app/components/blog-post.js
    import Ember from 'ember';
    
    const BlogPostComponent = Ember.Component.extend({
      title: Ember.computed('params.[]', function(){
        return this.get('params')[0];
      }),
      body: Ember.computed('params.[]', function(){
        return this.get('params')[1];
      })
    });
    
    BlogPostComponent.reopenClass({
      positionalParams: 'params'
    });