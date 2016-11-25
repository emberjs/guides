Para definir um componente, execute:

```shell
ember generate component my-component-name
```

Components must have at least one dash in their name. So `blog-post` is an acceptable name, and so is `audio-player-controls`, but `post` is not. This prevents clashes with current or future HTML element names, aligns Ember components with the W3C [Custom Elements](https://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/custom/index.html) spec, and ensures Ember detects the components automatically.

A sample component template could look like this:

```app/templates/components/blog-post.hbs <article class="blog-post"> 

# {{title}}

{{yield}}

Edit title: {{input type="text" value=title}}</article>

    <br />Dado o template acima, você pode agora usar o componente `{{blog-post}}`:
    
    ```app/templates/index.hbs
    {{#each model as |post|}}
      {{#blog-post title=post.title}}
        {{post.body}}
      {{/blog-post}}
    {{/each}}
    

Its model is populated in `model` hook in the route handler:

```app/routes/index.js import Ember from 'ember';

export default Ember.Route.extend({ model() { return this.get('store').findAll('post'); } });

    <br />Each component, under the hood, is backed by an element. By default
    Ember will use a `<div>` element to contain your component's template.
    To learn how to change the element Ember uses for your component, see
    [Customizing a Component's
    Element](../customizing-a-components-element).
    
    
    ## Defining a Component Subclass
    
    Often times, your components will just encapsulate certain snippets of
    Handlebars templates that you find yourself using over and over. In
    those cases, you do not need to write any JavaScript at all. Define
    the Handlebars template as described above and use the component that is
    created.
    
    If you need to customize the behavior of the component you'll
    need to define a subclass of [`Ember.Component`][1]. For example, you would
    need a custom subclass if you wanted to change a component's element,
    respond to actions from the component's template, or manually make
    changes to the component's element using JavaScript.
    
    [1]: http://emberjs.com/api/classes/Ember.Component.html
    
    Ember knows which subclass powers a component based on its filename. For
    example, if you have a component called `blog-post`, you would create a
    file at `app/components/blog-post.js`. If your component was called
    `audio-player-controls`, the file name would be at
    `app/components/audio-player-controls.js`.
    
    ## Dynamically rendering a component
    
    The [`{{component}}`][2] helper can be used to defer the selection of a component to
    run time. The `{{my-component}}` syntax always renders the same component,
    while using the `{{component}}` helper allows choosing a component to render on
    the fly. This is useful in cases where you want to interact with different
    external libraries depending on the data. Using the `{{component}}` helper would
    allow you to keep different logic well separated.
    
    The first parameter of the helper is the name of a component to render, as a
    string. So `{{component 'blog-post'}}` is the same as using `{{blog-post}}`.
    
    The real value of [`{{component}}`][2] comes from being able to dynamically pick
    the component being rendered. Below is an example of using the helper as a
    means of choosing different components for displaying different kinds of posts:
    
    [2]: http://emberjs.com/api/classes/Ember.Templates.helpers.html#method_component
    
    ```app/templates/components/foo-component.hbs
    <h3>Hello from foo!</h3>
    <p>{{post.body}}</p>
    

```app/templates/components/bar-component.hbs 

### Hello from bar!

<div>
  {{post.author}}
</div>

    <br />```app/routes/index.js
    import Ember from 'ember';
    
    export default Ember.Route.extend({
      model() {
        return this.get('store').findAll('post');
      }
    });
    

    app/templates/index.hbs
    {{#each model as |post|}}
      {{!-- either foo-component or bar-component --}}
      {{component post.componentName post=post}}
    {{/each}}

When the parameter passed to `{{component}}` evaluates to `null` or `undefined`, the helper renders nothing. When the parameter changes, the currently rendered component is destroyed and the new component is created and brought in.

Picking different components to render in response to the data allows you to have different template and behavior for each case. The `{{component}}` helper is a powerful tool for improving code modularity.