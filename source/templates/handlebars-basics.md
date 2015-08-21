Ember.js uses the [Handlebars templating library](http://www.handlebarsjs.com)
to power your app's user interface. Handlebars templates are just like
regular HTML, but also give you the ability to embed expressions that
change what is displayed.

Ember takes Handlebars and extends it with many powerful features. It may
help to think of your Handlebars templates as an HTML-like DSL for
describing the user interface of your app. And, once you've told
Ember.js to render a given template on the screen, you don't need to
write any additional code to make sure it keeps up-to-date.

### Defining Templates

The first thing you should change is your [application template](../the-application-template) that is created
automatically for you and is displayed when your app loads.

Next, you can define templates in the `app/templates` folder. By default,
a route will render a template with the same name as the route.

```app/templates/kittens.hbs
<h1>Kittens</h1>
<p>Kittens are the cutest!</p>
```

If you would like to create a template that is shared across many areas of your site, you should investigate [components](../../components/defining-a-component/).

### Handlebars Expressions

Each template has an associated _controller_: this is where the template
finds the properties that it displays.

You can display a property from your controller by wrapping the property
name in curly braces, like this:

```handlebars
Hello, <strong>{{firstName}} {{lastName}}</strong>!
```

This would look up the `firstName` and `lastName` properties from the
controller, insert them into the HTML described in the template, then
put them into the DOM.

By default, your top-most application template is bound to your application controller. Note that this file is not shown by default because it is created behind the scenes by Ember CLI. To customize the controller, create the following file:

```app/controllers/application.js
export default Ember.Controller.extend({
  firstName: 'Trek',
  lastName: 'Glowacki'
});
```

The above template and controller would combine to display the following
rendered HTML:

```html
Hello, <strong>Trek Glowacki</strong>!
```

These expressions (and the other Handlebars features you will learn
about next) are _bindings aware_. That means that if the values used
by your templates ever change, your HTML will be updated automatically.

As your application grows in size, it will have many templates, each
bound to different controllers.
