While the Guides [assume you have a working knowledge of JavaScript](/#toc_assumptions),
when learning a new framework it can be hard to know what is JavaScript and what is framework,
especially if you are newer to the ecosystem and less familiar with JavaScript.

On top of that, many new features were introduced to JavaScript with the release of newer specifications like ECMAScript 2015 (also known as ECMAScript 6 or ES6, https://developer.mozilla.org/en/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla). With the current yearly cadence of ECMAScript specifications, developers might have not had time to get familiar with all the new features.

In this guide we will be covering some common JavaScript code patterns that appear in Ember applications, and in particular those that explore the new features provided in ES6, so you can get a clearer sense of where the language ends and the framework starts.
## const & let variable declarations

Unlike some other programming languages, in JavaScript where your variables are created depends on how you declare them. Because of this, classic `var` variable declarations in JavaScript can sometimes be tricky and create confusion over a variable's life cycle.

By introducing the block-level variables (also sometimes called bindings) `const` and `let` in ES6, variable scope has been made easier to more explicitly control.

### var

In specifications prior to ES6 `var` variable declarations are *hoisted* to the top of the function they are declared irrespective of where in the function they are actually declared, including whether they are declared in a block such as an if statement. Note that such hoisting only applies to variable declaration, not its initialization/assignment.

Let's take a look at an example:  

``` javascript
function getName(person) {
  // name declaration hoisted up here to the top of the function, and 'exists', but it is still currently unassigned and thus undefined
  if (person) {
    var name = 'Gob Bluth'; // assignment occurs and name is no longer undefined   
    return name;
  } else {
    // because of the hoisting name exists here, but is also similarly undefined
    return null;
  }
}
```

### const & let

#### The Basics, Block-Level Bindings

On the other hand, `const` and `let` are both block-level bindings, and because of this they are not accessible outside of the given block scope (meaning in a `function` or in `{}`) they are declared in. Also, `const` and `let` both have specific characteristics that allow you to infer more about what the variables are being used for.

`let` more or less can be used as a `var` was used, but with the important distinction that `let` declarations are *not* hoisted to the top of their enclosing block, so it's best to place them above where you will need to make reference to them.

``` javascript
function getName(person) {
  // name does not exist here, no hoisting
  if (person) {
    let name = 'Gob Bluth'; // name only exists here
    return name;
  } else {
    // name does not exist here, no hoisting
    return null;
  }
}
```

`const` declarations are not hoisted either, but they differ from `let` declarations in that they are treated as `constants`, meaning their values cannot changed once they are set. As such, `const` declarations must be initialized where declared.  

``` javascript
const firstName; // invalid, no initialization
const firstName = 'Gob'; // valid
firstName = 'George Michael'; // invalid, no re-assignment
```

Both `const` and `let` declarations cannot be accessed until after their declaration, and any attempt to access such bindings before their declarations occurs in what is known in the community as the temporal dead zone.

#### Deeper Dive, Global Variables

Additionally, when `var` is used in the global scope a new global variable is created, which is a property on the global object (for example, the window object in a browser).

For `let` or `const`, a new variable is created, but no property on the global object is generated.

The result is that you cannot overwrite a global variable using `let` or `const` declarations, only shadowing is possible.

#### Deeper Dive, Loop behavior

Furthermore, `let` corrects some problematic behavior of `var` in loops.

First, `let` behaves closer to expectations by restricting the accessibility of the counter variable to the block-level of the loop, while `var` does not.

``` javascript
for (var i = 0; i < 3; i++) {
  // some code here using i
}
// i still accessible here
```

Because loop variables are accessible from outside the scope of a loop, when creating a function inside of a loop, the counter variable is shared across each iteration, potentially causing unexpected behavior.

``` javascript
var someArray = [];
for (var i = 0; i < 3; i++) {
  someArray.push(function(){
    console.log(i);
  });
}

someArray.forEach(function(item) {
  item(); // logs the number "3" three times, but expected the log to be 0, then 1, then 2
});
```

While an immediately invoked function expression (IIFE) could be used to correct for this unexpected behavior, the use of `let` declaration for the counter variable makes this unnecessary and arguably more cleanly solves the issue creating a new counter variable on each iteration through the loop.

``` javascript
var someArray = [];
for (let i = 0; i < 3; i++) {
  someArray.push(function(){
    console.log(i);
  });
}

someArray.forEach(function(item) {
  item(); // logs the numbers 0, then 1, then 2, as expected
});
```

#### More Resources

For further reference of `var`, `const` and `let` see: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/var
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let

## Object properties

One quirk of the JavaScript language that commonly trips up developers if that if you define an array or object property directly in your class,
every instance of that class will share the same array/object.

Let's look at an example.

We will start with a `Framework` class.
`Framework` has two properties, a `language` string, and a `versions` array.
If you are not familiar with the `class` syntax, you can read about it on [the MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes)
We will be using the `class` syntax, if you are not familiar you can read more on
We'll then create two instances of that class, `ember` and `phoenix`.

```javascript
const Framework = Object.create({
  language: 'JavaScript',
  versions: []
});

let ember = Object.create(Framework);
let phoenix = Object.create(Framework);
```

```javascript
export default Ember.Component.extend({
  todos: [
    …
  ]
});
```

```javascript
export default Ember.Component.extend({
  todos: null,

  init() {
    this._super(...arguments);
    this.todos = [
      …
    ]
  }
});
```
