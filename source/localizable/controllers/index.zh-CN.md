## Controllers

Controllers are very much like components, so much so that in future versions of Ember, controllers will be replaced entirely with components. At the moment, components cannot be routed to, but when this changes, it will be recommended to replace all controllers with components.

Because of this, modern Ember applications don't often use controllers. When they do, their responsibility is strictly limited to two avenues:

* Controllers maintain state based on the current route. In general, models will have properties that are saved to the server, while controllers will have properties that your app does not need to save to the server.
* User actions pass through the controller layer when moving from a component to a route.

The context of templates rendered by a route is a corresponding controller. Ember's following of "convention over configuration" means you should only create a controller if you need one. If not, everything continues to "Just Work".

Let's explore the example of a route displaying a blog post. Presume a `BlogPost` model that is presented in a `blog-post` template.

The `BlogPost` model would have properties like:

* `title`
* `intro`
* `body`
* `author`

Your template would bind to these properties in the `blog-post` template:

```app/templates/blog-post.hbs 

# {{model.title}}

## by {{model.author}}

<div class="intro">
  {{model.intro}}
</div>

* * *

<div class="body">
  {{model.body}}
</div>

    <br />In this simple example, we don't have any display-specific properties
    or actions just yet. For now, our controller's `model` property acts as a
    pass-through (or "proxy") for the model properties. (Remember that
    a controller gets the model it represents from its route handler.)
    
    Let's say we wanted to add a feature that would allow the user to
    toggle the display of the body section. To implement this, we would
    first modify our template to show the body only if the value of a
    new `isExpanded` property is true.
    
    ```app/templates/blog-post.hbs
    <h1>{{model.title}}</h1>
    <h2>by {{model.author}}</h2>
    
    <div class='intro'>
      {{model.intro}}
    </div>
    <hr>
    
    {{#if isExpanded}}
      <button {{action "toggleBody"}}>Hide Body</button>
      <div class="body">
        {{model.body}}
      </div>
    {{else}}
      <button {{action "toggleBody"}}>Show Body</button>
    {{/if}}
    

You can then define what the action does within the `actions` hook of the controller, as you would with a component:

    app/controllers/blog-post.js
    export default Ember.Controller.extend({
      actions: {
        toggleBody() {
          this.toggleProperty('isExpanded');
        }
      }
    });