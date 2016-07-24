You can think of a component as a black box of UI functionality. So far, you've learned how parent components can pass attributes in to a child component, and how that component can use those attributes from both JavaScript and its template.

But what about the opposite direction? How does data flow back out of the component to the parent? In Ember, components use **actions** to communicate events and changes.

Let's look at a simple example of how a component can use an action to communicate with its parent.

Imagine we're building an application where users can have accounts. We need to build the UI for users to delete their account. Because we don't want users to accidentally delete their accounts, we'll build a button that requires the user to confirm in order to trigger some action.

Once we create this "button with confirmation" component, we want to be able to reuse it all over our application.

## Creating the Component

Let's call our component `button-with-confirmation`. We can create it by typing:

```shell
ember generate component button-with-confirmation
```

We'll plan to use the component in a template something like this:

```app/templates/components/user-profile.hbs {{button-with-confirmation text="Click OK to delete your account."}}

    <br />We'll also want to use the component elsewhere, perhaps like this:
    
    ```app/templates/components/send-message.hbs
    {{button-with-confirmation text="Click OK to send your message."}}
    

## Designing the Action

When implementing an action on a component, you need to break it down into two steps:

  1. In the parent component, decide how you want to react to the action. Here, we want to have the action delete the user's account in one place, and send a message in another place.
  2. In the component, determine when something has happened, and when to tell the outside world. Here, we want to trigger the outside action (deleting the account or sending the message) after the user clicks the button and then confirms.

Let's take it step by step.

## Implementing the Action

In the parent component, let's first define what we want to happen when the user clicks the button and then confirms. In this case, we'll find the user's account and delete it.

In Ember, each component can have a property called `actions`, where you put functions that can be [invoked by the user interacting with the component itself](../../templates/actions/), or by child components.

Let's look at the parent component's JavaScript file. In this example, imagine we have a parent component called `user-profile` that shows the user's profile to them.

We'll implement an action on the parent component called `userDidDeleteAccount()` that, when called, gets a hypothetical `login` [service](../../applications/services/) and calls the service's `deleteUser()` method.

```app/components/user-profile.js export default Ember.Component.extend({ login: Ember.inject.service(),

actions: { userDidDeleteAccount() { this.get('login').deleteUser(); } } });

    <br />Now we've implemented our action, but we have not told Ember when we
    want this action to be triggered, which is the next step.
    
    ## Designing the Child Component
    
    Next, let's implement the logic to confirm that the user wants to take
    the action from the component:
    
    ```app/components/button-with-confirmation.js
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
    

The component template will have a button and a div that shows the confirmation dialog based on the value of `confirmShown`.

```app/templates/components/button-with-confirmation.hbs <button {{action "launchconfirmdialog"}}>{{text}}</button> {{#if confirmShown}} 

<div class="confirm-dialog">
  <button class="confirm-submit" {{action "submitconfirm"}}>OK</button> <button class="confirm-cancel" {{action "cancelconfirm"}}>Cancel</button>
</div> {{/if}}

    <br /><br />## Passing the Action to the Component
    
    Now we need to make it so that the `onConfirm()` event in the
    `button-with-confirmation` component triggers the
    `userDidDeleteAccount()` action in the `user-profile` component.
    One important thing to know about actions is that they're functions
    you can call, like any other method on your component.
    So they can be passed from one component to another like this:
    
    ```app/templates/components/user-profile.hbs
    {{button-with-confirmation text="Click here to delete your account." onConfirm=(action "userDidDeleteAccount")}}
    

This snippet says "take the `userDidDeleteAccount` action from the parent and make it available on the child component as `onConfirm`."

We can do a similar thing for our `send-message` component:

```app/templates/components/send-message.hbs {{button-with-confirmation text="Click to send your message." onConfirm=(action "sendMessage")}}

    <br />Now, we can use `onConfirm` in the child component to invoke the action on the
    parent:
    
    ```app/components/button-with-confirmation.js
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
    

`this.get('onConfirm')` will return the function passed from the parent as the value of `onConfirm`, and the following `()` will invoke the function.

Like normal attributes, actions can be a property on the component; the only difference is that the property is set to a function that knows how to trigger behavior.

That makes it easy to remember how to add an action to a component. It's like passing an attribute, but you use the `action` helper to pass a function instead.

Actions in components allow you to decouple an event happening from how it's handled, leading to modular, more reusable components.

## Handling Action Completion

Often actions perform asynchronous tasks, such as making an ajax request to a server. Since actions are functions that can be passed in by a parent component, they are able to return values when called. The most common scenario is for an action to return a promise so that the component can handle the action's completion.

In our user `button-with-confirmation` component we want to leave the confirmation modal open until we know that the operation has completed successfully. This is accomplished by expecting a promise to be returned from `onConfirm`. Upon resolution of the promise, we set a property used to indicate the visibility of the confirmation modal.

```app/components/button-with-confirmation.js export default Ember.Component.extend({ actions: { launchConfirmDialog() { this.set('confirmShown', true); },

    submitConfirm() {
      //call onConfirm with the value of the input field as an argument
      const promise = this.get('onConfirm')();
      promise.then(() => {
        this.set('confirmShown', false);
      });
    },
    
    cancelConfirm() {
      this.set('confirmShown', false);
    }
    

} });

    <br />## Passing Arguments
    
    Sometimes the parent component invoking an action has some context needed for the action that the child component
    doesn't.
    For these cases, actions passed to a component via the action helper may be invoked with arguments.
    For example, we'll update the `send-message` action to take a message type in addition to the message itself.
    Since the `button-with-confirmation` component doesn't know or care about what type of message its collecting, we want
    to provide a message type from `send-message` when we define the action.
    
    ```app/templates/components/send-message.hbs
    {{button-with-confirmation text="Click to send your message." onConfirm=(action "sendMessage" "info")}}
    

In this case, the code in `button-with-confirmation` does not change. It will still invoke `onConfirm` with no arguments. The action helper will add the arguments provided in the template to the call.

Action arguments curry, meaning that you can provide partial arguments to the action helper and provide the rest of the arguments when you call the function within the component javascript file. For example, our `button-with-confirmation` component will now [yield](../wrapping-content-in-a-component/) the content of the confirmation dialog to collect extra information to be sent along with the `onConfirm` action:

```app/templates/components/button-with-confirmation.hbs <button {{action "launchconfirmdialog"}}>{{text}}</button> {{#if confirmShown}} 

<div class="confirm-dialog">
  {{yield confirmValue}} <button class="confirm-submit" {{action "submitconfirm"}}>OK</button> <button class="confirm-cancel" {{action "cancelconfirm"}}>Cancel</button>
</div> {{/if}}

    <br />The `send-message` component provides an input as block content to the `button-with-confirmation` component, setting
    `confirmValue`.
    
    ```app/templates/components/send-message.hbs
    {{#button-with-confirmation
        text="Click to send your message."
        onConfirm=(action "sendMessage" "info")
        as |confirmValue|}}
      {{input value=confirmValue}}
    {{/button-with-confirmation}}
    

Now when the `submitConfirm` action is invoked, we call it with the value provided by our yielded input.

```app/components/button-with-confirmation.js export default Ember.Component.extend({ actions: { launchConfirmDialog() { this.set("confirmShown", true); },

    submitConfirm() {
      //call onConfirm with the value of the input field as an argument
      const promise = this.get('onConfirm')(this.get('confirmValue'));
      promise.then(() => {
        this.set('confirmShown', false);
      });
    },
    
    cancelConfirm() {
      this.set('confirmShown', false);
    }
    

} });

    This action will call our bound `sendMessage` function with both the message type we provided earlier, and the template
    and the message value provided in the component JavaScript.
    
    
    ```app/components/send-message.js
    export default Ember.Component.extend({
      actions: {
        sendMessage(messageType, messageText) {
          //send message here and return a promise
        }
      }
    });
    

## Invoking Actions Directly on Component Collaborators

Actions can be invoked on objects other than the component directly from the template. For example, in our `send-message` component we might include a service that processes the `sendMessage` logic.

```app/components/send-message.js export default Ember.Component.extend({ messaging: Ember.inject.service(),

// component implementation });

    <br />We can tell the action to invoke the `sendMessage` action directly on the messaging service with the `target` attribute.
    
    ```app/templates/components/send-message.hbs
    {{#button-with-confirmation
        text="Click to send your message."
        onConfirm=(action "sendMessage" "info" target=messaging)
        as |confirmValue| }}
      {{input value=confirmValue}}
    {{/button-with-confirmation}}
    

By supplying the `target` attribute, the action helper will look to invoke the `sendMessage` action directly on the messaging service, saving us from writing code on the component that just passes the action along to the service.

```app/services/messaging.js export default Ember.Service.extend({ actions: { sendMessage(messageType, text) { //handle message send and return a promise } } });

    <br />## Destructuring Objects Passed as Action Arguments
    
    A component will often not know what information a parent needs to process an action, and will just pass all the
    information it has.
    For example, our `user-profile` component is going to notify its parent, `system-preferences-editor`, that a
    user's account was deleted, and passes along with it the full user profile object.
    
    
    ```app/components/user-profile.js
    export default Ember.Component.extend({
      login: Ember.inject.service(),
    
      actions: {
        userDidDeleteAccount() {
          this.get('login').deleteUser();
          this.get('didDelete')(this.get('login.currentUserObj'));
        }
      }
    });
    

All our `system-preferences-editor` component really needs to process a user deletion is an account ID. For this case, the action helper provides the `value` attribute to allow a parent component to dig into the passed object to pull out only what it needs.

```app/templates/components/system-preferences-editor.hbs {{user-profile didDelete=(action "userDeleted" value="account.id")}}

    <br />Now when the `system-preferences-editor` handles the delete action, it receives only the user's account `id` string.
    
    ```app/components/system-preferences-editor.js
    export default Ember.Component.extend({
      actions: {
        userDeleted(idStr) {
          //respond to deletion
        }
      }
    });
    

## Calling Actions Up Multiple Component Layers

When your components go multiple template layers deep, its common to need to handle an action several layers up the tree. Using the action helper, it is possible to make actions defined in parent components available at the bottom layers of your component tree without adding JavaScript code to the components in between.

For example, we want to take account deletion out of the `user-profile` component and handle deletion in its parent. In our template in `user-profile.hbs`, we can change our action to call `deleteCurrentUser`, which will be defined on `system-preferences-editor`.

```app/templates/components/user-profile.hbs {{button-with-confirmation onConfirm=(action deleteCurrentUser) text="Click OK to delete your account."}}

    <br />Note that `deleteCurrentUser` is not in quotes as was the case [previously](#toc_passing-the-action-to-the-component)
    when the action was local to `user-profile`.  When you pass an actual function reference (without quotes) to the action
    helper, it will call the function from the component's local context.
    
    Alternately, when you pass a string to the action helper, Ember will attempt to call that function from the
    component's local `actions` object.
    
    Here our `system-preferences-editor` template passes its `deleteUser` action into the `user-profile`
    component's local `deleteCurrentUser` property.
    
    ```app/templates/components/system-preferences-editor.hbs
    {{user-profile deleteCurrentUser=(action 'deleteUser' login.currentUser.id)}}
    

Now when you confirm deletion, the action goes straight to the `system-preferences-editor` to handle.

```app/components/system-preferences-editor.js import Ember from 'ember';

export default Ember.Component.extend({ login: Ember.inject.service(), actions: { deleteUser(idStr) { return this.get('login').deleteUserAccount(idStr); } } }); ```