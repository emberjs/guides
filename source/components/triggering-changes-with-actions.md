You can think of a component as a black box of UI functionality.
So far, you've learned how parent components can pass attributes in to a
child component, and how that component can use those attributes from
both JavaScript and its template.

But what about the opposite direction? How does data flow back out of
the component to the parent? In Ember, components use **actions** to
communicate events and changes.

Let's look at a simple example of how a component can use an action to
communicate with its parent.

Imagine we're building an application where users can have accounts. We
need to build the UI for users to delete their account. Because we don't
want users to accidentally delete their accounts, we'll build a button
that requires the user to confirm in order to trigger some
action.

Once we create this "button with confirmation"
component, we want to be able to reuse it all over our application.

## Creating the Component

Let's call our component `button-with-confirmation`. We can create it by
typing:

```shell
ember generate component button-with-confirmation
```

We'll plan to use the component in a template something like this:

```app/templates/components/user-profile.hbs
{{button-with-confirmation
  text="Click OK to delete your account."
}}
```

We'll also want to use the component elsewhere, perhaps like this:

```app/templates/components/send-message.hbs
{{button-with-confirmation
  text="Click OK to send your message."
}}
```

## Designing the Action

When implementing an action on a component that will be handled outside the component, you need to break it down into two steps:

1. In the parent component, decide how you want to react to the action.
   Here, we want to have the action delete the user's account when it's used in one place, and
   send a message when used in another place.
2. In the component, determine when something has happened, and when to tell the
   outside world. Here, we want to trigger the outside action (deleting the
   account or sending the message) after the user clicks the button and then
   confirms.

Let's take it step by step.

## Implementing the Action

In the parent component, let's first define what we want to happen when the
user clicks the button and then confirms. In the first case, we'll find the user's
account and delete it.

In Ember, each component can
have a property called `actions`, where you put functions that can be
[invoked by the user interacting with the component
itself](../../templates/actions/), or by child components.

Let's look at the parent component's JavaScript file. In this example,
imagine we have a parent component called `user-profile` that shows the
user's profile to them.

We'll implement an action on the parent component called
`userDidDeleteAccount()` that, when called, gets a hypothetical `login`
[service](../../applications/services/) and calls the service's
`deleteUser()` method.

```app/components/user-profile.js
import Ember from 'ember';

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

## Designing the Child Component

Next,
in the child component we will implement the logic to confirm that the user wants to take the action they indicated by clicking the button:

```app/components/button-with-confirmation.js
import Ember from 'ember';

export default Ember.Component.extend({

  actions: {
    launchConfirmDialog() {
      this.set('confirmShown', true);
    },

    submitConfirm() {
      // trigger action on parent component
      this.set('confirmShown', false);
    },

    cancelConfirm() {
      this.set('confirmShown', false);
    }
  }
});
```

The component template will have a button and a div that shows the confirmation dialog
based on the value of `confirmShown`.

```app/templates/components/button-with-confirmation.hbs
<button {{action "launchConfirmDialog"}}>{{text}}</button>
{{#if confirmShown}}
  <div class="confirm-dialog">
    <button class="confirm-submit" {{action "submitConfirm"}}>OK</button>
    <button class="confirm-cancel" {{action "cancelConfirm"}}>Cancel</button>
  </div>
{{/if}}
```

## Passing the Action to the Component

Now we need to make it so that the `userDidDeleteAccount()` action defined in the parent component `user-profile` can be triggered from within `button-with-confirmation`.
We'll do this by passing the action to the child component in exactly the same way that we pass other properties.
This is possible since actions are simply functions, just like any other method on a component,
and they can therefore be passed from one component to another like this:

```app/templates/components/user-profile.hbs
{{button-with-confirmation
  text="Click here to delete your account."
  onConfirm=(action "userDidDeleteAccount")
}}
```

This snippet says "take the `userDidDeleteAccount` action from the parent and make it available on the child component as the property `onConfirm`."
Note the use here of the `action` helper,
which serves to return the function named `"userDidDeleteAccount"` that we are passing to the component.

We can do a similar thing for our `send-message` component:

```app/templates/components/send-message.hbs
{{button-with-confirmation
  text="Click to send your message."
  onConfirm=(action "sendMessage")
}}
```

Now, we can use `onConfirm` in the child component to invoke the action on the
parent:

```app/components/button-with-confirmation.js
import Ember from 'ember';

export default Ember.Component.extend({

  actions: {
    launchConfirmDialog() {
      this.set('confirmShown', true);
    },

    submitConfirm() {
      //call the onConfirm property to invoke the passed in action
      this.get('onConfirm')();
    },

    cancelConfirm() {
      this.set('confirmShown', false);
    }
  }
});
```

`this.get('onConfirm')` will return the function passed from the parent as the
value of `onConfirm`, and the following `()` will invoke the function.

Like normal attributes, actions can be a property on the component; the
only difference is that the property is set to a function that knows how
to trigger behavior.

That makes it easy to remember how to add an action to a component. It's
like passing an attribute, but you use the `action` helper to pass
a function instead.

Actions in components allow you to decouple an event happening from how it's handled, leading to modular,
more reusable components.

## Handling Action Completion

Often actions perform asynchronous tasks, such as making an ajax request to a server.
Since actions are functions that can be passed in by a parent component, they are able to return values when called.
The most common scenario is for an action to return a promise so that the component can handle the action's completion.

In our user `button-with-confirmation` component we want to leave the confirmation modal open until we know that the
operation has completed successfully.
This is accomplished by expecting a promise to be returned from `onConfirm`.
Upon resolution of the promise, we set a property used to indicate the visibility of the confirmation modal.

```app/components/button-with-confirmation.js
import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    launchConfirmDialog() {
      this.set('confirmShown', true);
    },

    submitConfirm() {
      // call onConfirm with the value of the input field as an argument
      let promise = this.get('onConfirm')();
      promise.then(() => {
        this.set('confirmShown', false);
      });
    },

    cancelConfirm() {
      this.set('confirmShown', false);
    }
  }
});
```

## Passing Arguments

Sometimes the parent component invoking an action has some context needed for the action that the child component
doesn't.
Consider, for example,
the case where the `button-with-confirmation` component we've defined is used within `send-message`.
The `sendMessage` action that we pass to the child component may expect a message type parameter to be provided as an argument:

```app/components/send-message.js
export default Ember.Component.extend({
  actions: {
    sendMessage(messageType) {
      //send message here and return a promise
    }
  }
});
```

However,
the `button-with-confirmation` component invoking the action doesn't know or care what type of message it's collecting.
In cases like this, the parent template can provide the required parameter when the action is passed to the child.
For example, if we want to use the button to send a message of type `"info"`:

```app/templates/components/send-message.hbs
{{button-with-confirmation text="Click to send your message." onConfirm=(action "sendMessage" "info")}}
```

Within `button-with-confirmation`, the code in the `submitConfirm` action does not change.
It will still invoke `onConfirm` without explicit arguments:

```app/components/button-with-confirmation.js
const promise = this.get('onConfirm')();
```
However the expression `(action "sendMessage" "info")` used in passing the action to the component creates a closure,
i.e. an object that binds the parameter we've provided to the function specified.
So now when the action is invoked, that parameter will automatically be passed as its argument, effectively calling `sendMessage("info")`,
despite the argument not appearing in the calling code.

So far in our example, the action we have passed to `button-with-confirmation` is a function that accepts one argument,
`messageType`.
Suppose we want to extend this by allowing `sendMessage` to take a second argument,
the actual text of the message the user is sending:

```app/components/send-message.js
export default Ember.Component.extend({
  actions: {
    sendMessage(messageType, messageText) {
      //send message here and return a promise
    }
  }
});
```

We want to arrange for the action to be invoked from within `button-with-confirmation` with both arguments.
We've seen already that if we provide a `messageType` value to the `action` helper when we insert `buttton-with-confirmation` into its parent `send-message` template,
that value will be passed to the `sendMessage` action as its first argument automatically when invoked as `onConfirm`.
If we subsequently pass a single additional argument to `onConfirm` explicitly,
that argument will be passed to `sendMessage` as its second argument
(This ability to provide arguments to a function one at a time is known as [currying](https://en.wikipedia.org/wiki/Currying)).

In our case, the explicit argument that we pass to `onConfirm` will be the required `messageText`.
However, remember that internally our `button-with-confirmation` component does not know or care that it is being used in a messaging application.
Therefore within the component's javascript file,
we will use a property `confirmValue` to represent that argument and pass it to `onConfirm` as shown here:

```app/components/button-with-confirmation.js
export default Ember.Component.extend({
  actions: {
    //...
    submitConfirm() {
      // call onConfirm with a second argument
      let promise = this.get('onConfirm')(this.get('confirmValue'));
      promise.then(() => {
        this.set('confirmShown', false);
      });
    },
    //...
  }
});
```

In order for `confirmValue` to take on the value of the message text,
we'll bind the property to the value of a user input field that will appear when the button is clicked.
To accomplish this,
we'll first modify the component so that it can be used in block form and we will [yield](../wrapping-content-in-a-component/) `confirmValue` to the block within the `"confirmDialog"` element:

```app/templates/components/button-with-confirmation.hbs
<button {{action "launchConfirmDialog"}}>{{text}}</button>
{{#if confirmShown}}
  <div class="confirm-dialog">
    {{yield confirmValue}}
    <button class="confirm-submit" {{action "submitConfirm"}}>OK</button>
    <button class="confirm-cancel" {{action "cancelConfirm"}}>Cancel</button>
  </div>
{{/if}}
```

With this modification,
we can now use the component in `send-message` to wrap a text input element whose `value` attribute is set to `confirmValue`:

```app/templates/components/send-message.hbs
{{#button-with-confirmation
    text="Click to send your message."
    onConfirm=(action "sendMessage" "info")
    as |confirmValue|}}
  {{input value=confirmValue}}
{{/button-with-confirmation}}
```

When the user enters their message into the input field,
the message text will now be available to the component as `confirmValue`.
Then, once they click the "OK" button, the `submitConfirm` action will be triggered, calling `onConfirm` with the provided `confirmValue`,
thus invoking the `sendMessage` action in `send-message` with both the `messageType` and `messageText` arguments.

## Invoking Actions Directly on Component Collaborators

Actions can be invoked on objects other than the component directly from the template.  For example, in our
`send-message` component we might include a service that processes the `sendMessage` logic.

```app/components/send-message.js
import Ember from 'ember';

export default Ember.Component.extend({
  messaging: Ember.inject.service(),

  // component implementation
});
```

We can tell the action to invoke the `sendMessage` action directly on the messaging service with the `target` attribute.

```app/templates/components/send-message.hbs
{{#button-with-confirmation
    text="Click to send your message."
    onConfirm=(action "sendMessage" "info" target=messaging)
    as |confirmValue| }}
  {{input value=confirmValue}}
{{/button-with-confirmation}}
```

By supplying the `target` attribute, the action helper will look to invoke the `sendMessage` action directly on the messaging
service, saving us from writing code on the component that just passes the action along to the service.

```app/services/messaging.js
import Ember from 'ember';

export default Ember.Service.extend({
  actions: {
    sendMessage(messageType, text) {
      //handle message send and return a promise
    }
  }
});
```

## Destructuring Objects Passed as Action Arguments

A component will often not know what information a parent needs to process an action, and will just pass all the
information it has.
For example, our `user-profile` component is going to notify its parent, `system-preferences-editor`, that a
user's account was deleted, and passes along with it the full user profile object.


```app/components/user-profile.js
import Ember from 'ember';

export default Ember.Component.extend({
  login: Ember.inject.service(),

  actions: {
    userDidDeleteAccount() {
      this.get('login').deleteUser();
      this.get('didDelete')(this.get('login.currentUserObj'));
    }
  }
});
```

All our `system-preferences-editor` component really needs to process a user deletion is an account ID.
For this case, the action helper provides the `value` attribute to allow a parent component to dig into the passed
object to pull out only what it needs.

```app/templates/components/system-preferences-editor.hbs
{{user-profile didDelete=(action "userDeleted" value="account.id")}}
```

Now when the `system-preferences-editor` handles the delete action, it receives only the user's account `id` string.

```app/components/system-preferences-editor.js
import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    userDeleted(idStr) {
      //respond to deletion
    }
  }
});
```

## Calling Actions Up Multiple Component Layers

When your components go multiple template layers deep, it is common to need to handle an action several layers up the tree. 
Using the action helper, parent components can pass actions to child components through templates alone without adding JavaScript code to those child components.

For example, say we want to move account deletion from the `user-profile` component to its parent `system-preferences-editor`.

First we would move the `deleteUser` action from `user-profile.js` to the actions object on `system-preferences-editor`.

```app/components/system-preferences-editor.js
import Ember from 'ember';

export default Ember.Component.extend({
  login: Ember.inject.service(),
  actions: {
    deleteUser(idStr) {
      return this.get('login').deleteUserAccount(idStr);
    }
  }
});
```

Then our `system-preferences-editor` template passes its local `deleteUser` action into the `user-profile` as that
component's `deleteCurrentUser` property.

```app/templates/components/system-preferences-editor.hbs
{{user-profile
  deleteCurrentUser=(action 'deleteUser' login.currentUser.id)
}}
```

The action `deleteUser` is in quotes, since `system-preferences-editor` is where the action is defined now. Quotes indicate that the action should be looked for in `actions` local to that component, rather than in those that have been passed from a parent.

In our `user-profile.hbs` template we change our action to call `deleteCurrentUser` as passed above.

```app/templates/components/user-profile.hbs
{{button-with-confirmation
  onConfirm=(action deleteCurrentUser)
  text="Click OK to delete your account."
}}
```

Note that `deleteCurrentUser` is no longer in quotes here as opposed to [previously](#toc_passing-the-action-to-the-component). Quotes are used to initially pass the action down the component tree, but at every subsequent level you are instead passing the actual function reference (without quotes) in the action helper.

Now when you confirm deletion, the action goes straight to the `system-preferences-editor` to be handled in its local context.
