So far, you've learned how parent components can pass attributes in to a
child component, and how that component can use those attributes from
both JavaScript and its Handlebars template.

But what about the opposite direction? How does data flow back out of
the component to the parent?

In Ember, components use something called **actions** to communicate
events and changes. Actions allow you to write a function that you pass
into a component. At the appropriate time, the component will trigger
the action, and any behavior you put inside will be run. That code can
do anything, from communicating with services to re-rendering the child
component with new data.

To the outside world, a component is entirely self-contained: a black
box where attributes go in, and actions come out.

### A Simple Action

Let's look at a simple example of how a component can use an action to
communicate with its parent.

Imagine we work on an application where users have accounts, and we've
been tasked with building the UI for users to delete their account.
Because this is something we don't want users to do accidentally, we'll
build a button that requires the user to double click it in order to
trigger its behavior.

Best of all, because components are "black boxes" that aren't coupled to
their parent component, once we create this "double click button"
component, we can reuse it all over our application.

#### Creating the Component

Let's call our component `double-click-button`. We can create it by
typing:

```text
ember generate component double-click-button
```

Remember that you can use this component from a template like this:

```hbs
{{double-click-button}}
```

#### Designing the Action

When implementing an action, it can help to break the process down into
two steps:

1. In the outside world, what do you want to happen when the action is
   triggered?
2. In the component, when do you trigger the action?

In this example, that means:

1. In the parent component, we should write an action that deletes the
   user's account.
2. In the button component, we should trigger the provided action when
   the user has double clicked.

Let's take it step by step.

#### Implementing the Action

First, we'll define what we want to happen when the user double clicks
the button. In this case, we'll find the user's account and delete it.

Where do you put the code for an action? In Ember, each component can
have a property called `actions`, where you put functions that can be
triggered by child components.

Let's look at the parent component's JavaScript file. In this example,
imagine we have a parent component called `user-profile` that shows the
user's profile to them.

We'll implement an action on the parent component called
`userDidDeleteAccount()` that, when called, gets a hypothetical `login`
service and calls the service's `deleteUser()` method.

```app/components/user-profile.js
export default Ember.Component.extend({
  login: Ember.inject.service(),

  actions: {
    userDidDeleteAccount() {
      this.get('login').deleteUser();
    }
  }
});
```

Now we've implemented our action, but we have not told Ember when we
want this action to be triggered, which is the next step.

#### Passing the Action to the Component

What comes next is arguably the most important part of building a
component, since it defines the public API: deciding what to call an
action when it gets passed in.

In this example, we want something to happen whenever the component is
double clicked. So, when we give the action to the component, we're
going to call it `onDoubleClick`:

```app/components/user-profile.hbs
{{double-click-button onDoubleClick=(action 'userDidDeleteAccount')}}
```

This snippet says "take the `userDidDeleteAccount` action from the
parent and make it available on the child component as
`onDoubleClick`."

### Triggering the Action

Next, how do we detect that a user has double clicked our component?
Ember has built-in support for common browser events like this. In our
component's JavaScript, we can implement a method called
`doubleClick()`. Every time the user double clicks this component, Ember
will call the `doubleClick()` method.

```app/components/double-click-button.js
export default Ember.Component.extend({
  tagName: 'button',

  // This method is called every time the user double clicks the
  // component.
  doubleClick() {
  }
});
```

Now that we've implemented the `doubleClick()`  method, we still need to
trigger the `userDidDeleteAccount` action that we've been given.  Let's
do that now.

When you provide an action, it get turned into a method on the component
you can call. Above we said:

```hbs
onDoubleClick=(action 'userDidDeleteAccount')`
```

That means that calling the component's `onDoubleClick` method will call
the parent's `userDidDeleteAccount` action.

```app/components/double-click-button.js
doubleClick() {
  // Call the component's `onDoubleClick()` method to trigger
  // the parent's `userDidDeleteAccount` action.
  this.onDoubleClick();
}
```

Actions are **just functions** you can call, like any other method on your component.

That's it! Under the hood, `onDoubleClick` is a function that knows how
to access the parent component and trigger its `userDidDeleteAccount`
action. When the user double clicks your component, the component will
call `this.onDoubleClick()`, which will trigger the parent component's
`userDidDeleteAccount` action, deleting the account.

### Thinking About Actions

#### Actions and Attributes

Like normal attributes, actions set a property on the component; the
only difference is that the property is set to a function that knows how
to trigger behavior.

That makes it easy to remember how to add an action to a component. It's
just like passing an attribute, but you use the `action` helper to pass
a function instead.

In the future versions of our `double-click-button` component, for
example, we may want to be able to pass a `title` attribute. You can see
how similar the syntax is:

```app/component/user-profile.hbs
{{double-click-button
  title="Delete Account"
  onDoubleClick=(action 'userDidDeleteAccount')}}
```

#### Actions and Callbacks

You may have noticed that component actions are similar to another
concept in JavaScript: **callbacks**. You can think of actions as being
like callbacks for components.

In JavaScript, you can pass a callback to a function that it can invoke
at a later time. For example, we might write a helper function that takes
a callback and adds it as an event listener to an element:

```js
function onClick(element, onClickFunc) {
  element.addEventListener('click', onClickFunc);
}

let element = document.getElementById('delete-button');
let displayAlert = () => {
  alert("button clicked!");
};

onClick(element, displayAlert);
```

In this example, we pass a callback function to the `onClick` function
that will be called whenever the button is clicked. This pattern allows
us to separate the functionality of listening for a click (the `onClick`
function) from what should happen when the click happens (the passed
callback).

Like callbacks in JavaScript, actions in components allow you to
decouple what happens in an function from how it's triggered, leading to
modular, more reusable components.

#### Mapping Action Names

Here's another similarity between component actions and callbacks: they
allow you to call a function one thing on the outside and another thing
on the inside.

In our example `onClick` function above, we created a `displayAlert`
function to let the user know when the button was clicked. This name
describes the behavior when it is called.

However, the `onClick` function is generic and can be used to add any
function as an event listener to an element. Calling the function
`displayAlert` in that context wouldn't make any sense, because you have
no idea what the functions people pass in may do; indeed, there may be
many different callbacks passed in that do very different things.

In JavaScript, you can call a callback one thing where it's
created, and something else where it's used. This allows you to separate
how the callback is created and how it's used, and give it the most
appropriate name in each context.

In the above example, we call the callback `displayAlert` where it's
created, then pass it to the `onClick` function as the second argument.

In the `onClick` definition, you can see that we call the second
argument `onClickFunc`:

```js
function onClick(element, onClickFunc) {
```

When we pass `displayAlert` to `onClick`, it gets _renamed_ to
`onClickFunc` inside that function. It's important to note that it's
still the same function; we've just given it a more meaningful name
inside `onClick`.

The same idea is true for components. In the parent component, we called
the action `userDidDeleteAccount`. But if the button component had to
know to call the action by that name, it would tightly couple the button
to that functionality. Other parts of our app that may want to use this
button would have to write their own, since this one only knew how to
delete an account.

Conversely, we called the action `onDoubleClick` inside the button
component. But this name is very vague outside the context of the
button. It tells you _when_ the action happens but not _what_ happens.
It would not be very meaningful to someone reading our code.

When you give an action to a component, you're **mapping** the action
name from the outside context to the component's context. Like with our
JavaScript example, it's the _same_ action, just with a different name
in each context.

With reusable components, it's common to map from a _generic name_ in the
component to a _semantic name_ where it's used. In our
`double-click-button` example, we map from the generic, reusable name
`onDoubleClick` to a name more meaningful for where it's used:
`userDidDeleteAccount`.
