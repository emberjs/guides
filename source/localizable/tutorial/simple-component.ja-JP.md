レンタル品をユーザーが閲覧している時に、ユーザーが決断できるように後押しする、いくつかのインタラクティブな選択肢があるのを望んでいるかもしれません。 各レンタル品の画像を表示したり、消したりする機能を追加してみましょう。 これを実現するために、コンポーネントを利用します。

各レンタル品の、動作を管理する`rental-listing` コンポーネントを自動生成しましょう。 A dash is required in every component name to avoid conflicting with a possible HTML element. So `rental-listing` is acceptable but `rental` would not be.

```shell
ember g component rental-listing
```

Ember CLI will then generate a handful of files for our component:

```shell
installing component
  create app/components/rental-listing.js
  create app/templates/components/rental-listing.hbs
installing component-test
  create tests/integration/components/rental-listing-test.js
```

A component consists of two parts: a Handlebars template that defines how it will look (`app/templates/components/rental-listing.hbs`) and a JavaScript source file (`app/components/rental-listing.js`) that defines how it will behave.

Our new `rental-listing` component will manage how a user sees and interacts with a rental. To start, let's move the rental display details for a single rental from the `index.hbs` template into `rental-listing.hbs`:

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}}

    <br />`index.hbs` テンプレートにある古いHTMLを、新たな `rental-listing`コンポーネントの`{{#each}}` ループと置き換えましょう。
    
    ```app/templates/index.hbs
    <h1> Welcome to Super Rentals </h1>
    
    We hope you find exactly what you're looking for in a place to stay.
    
    {{#each model as |rentalUnit|}}
      {{rental-listing rental=rentalUnit}}
    {{/each}}
    

Here we invoke the `rental-listing` component by name, and assign each `rentalUnit` as the `rental` attribute of the component.

## Hiding and Showing an Image

Now we can add functionality that will show the image of a rental when requested by the user.

Let's use the `{{#if}}` helper to show our current rental image only when `isImageShowing` is set to true. Otherwise, let's show a button to allow our user to toggle this:

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}} {{#if isImageShowing}} 

<img src={{rental.image}} alt={{rental.type}} width="500"> {{else}} 

<button>Show image</button> {{/if}}

    <br />The value of `isImageShowing` comes from our component's JavaScript file, in this case `rental-listing.js`.
    Since we do not want the image to be showing at first, we will set the property to start as `false`:
    
    ```app/components/rental-listing.js
    export default Ember.Component.extend({
      isImageShowing: false
    });
    

To make it where clicking on the button shows the image to the user, we will need to add an action that changes the value of `isImageShowing` to `true`. Let's call this action `imageShow`

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}} {{#if isImageShowing}} 

<img src={{rental.image}} alt={{rental.type}} width="500"> {{else}} <button {{action "imageshow"}}>Show image</button> {{/if}}

    <br />Clicking this button will send the action to the component.
    Ember will then go into the `actions` hash and call the `imageShow` function.
    コンポーネントの`imageShow` ファンクションを作って `isImageShowing` を `true` にしましょう。
    
    ```app/components/rental-listing.js
    export default Ember.Component.extend({
      isImageShowing: false,
      actions: {
        imageShow() {
          this.set('isImageShowing', true);
        }
      }
    });
    

Now when we click the button in our browser, we can see our image.

We should also let users hide the image. In our template, let's add a button with an `imageHide` action:

```app/templates/components/rental-listing.hbs 

## {{rental.title}}

Owner: {{rental.owner}}

Type: {{rental.type}}

Location: {{rental.city}}

Number of bedrooms: {{rental.bedrooms}} {{#if isImageShowing}} 

<img src={{rental.image}} alt={{rental.type}} width="500"><button {{action "imagehide"}}>Hide image</button> {{else}} <button {{action "imageshow"}}>Show image</button> {{/if}}

    <br />`imageHide`アクションハンドラの `isImageShowing` を `false`に設定します。
    
    ```app/components/rental-listing.js
    export default Ember.Component.extend({
      isImageShowing: false,
      actions: {
        imageShow() {
          this.set('isImageShowing', true);
        },
        imageHide() {
          this.set('isImageShowing', false);
        }
      }
    });
    

Now our users can toggle images on and off using the "Show image" and "Hide image" buttons.