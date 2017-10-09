While the Guides [assume you have a working knowledge of JavaScript](/#toc_assumptions),
when learning a new framework it can be hard to know what is JavaScript and what is framework,
especially if you are newer to the ecosystem and less familiar with JavaScript.

On top of that, many new features were introduced to JavaScript with the release of newer specifications like ECMAScript 2015,
also known as [ECMAScript 6 or ES6](https://developer.mozilla.org/en/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla).
With the current yearly cadence of ECMAScript specifications,
developers might have not had time to get familiar with all the new features.

In this guide we will be covering some common JavaScript code patterns that appear in Ember applications,
and in particular those that explore the new features provided in ES6,
so you can get a clearer sense of where the language ends and the framework starts.

## `const` and `let` variable declarations

In JavaScript, prior to ES6, there was only one variable declaration known as `var`. With ES6's `const` and `let` declarations there are now a few additional ways to declare variables that change when and how variables can be used.

### `var`

Classic `var` variable declarations are treated as if they were declared at the top of the function they are declared in irrespective of where in the function they are actually declared,
including whether they are declared in a block such as an if statement. This treatment of `var` declarations is sometimes known as *hoisting*.
Note that such hoisting only applies to a variable's declaration, not its initialization/assignment.

Because of hoisting, classic `var` variable declarations in JavaScript can sometimes be tricky and create confusion over a variable's life cycle.

Lets take a look at an example of hoisting with `var`:  

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

### `const` and `let`

By introducing the block-level variables (also sometimes called bindings) `const` and `let` in ES6, variable scope has been made easier to more explicitly control.

#### Block-Level Bindings

`const` and `let` are both block-level bindings.
Because of this they are not accessible outside of the given block scope (meaning in a `function` or in `{}`) they are declared in.
Also, `const` and `let` both have specific characteristics that allow you to infer more about what the variables are being used for.

`let` more or less can be used as a `var` was used,
but with the important distinction that `let` declarations are *not* hoisted to the top of their enclosing block,
so it's best to place them above where you will need to make reference to them.

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

`const` declarations are not hoisted either, but they differ from `let` declarations in that they are treated as constants, meaning their values cannot changed once they are set. As such, `const` declarations must be initialized where declared.  

``` javascript
const firstName; // invalid, no initialization
const firstName = 'Gob'; // valid
firstName = 'George Michael'; // invalid, no re-assignment
```

Both `const` and `let` declarations cannot be accessed until after their declaration,
and any attempt to access such bindings before their declarations occurs in what is known in the community as the temporal dead zone.

#### Deeper Dive, Global Variables

Additionally, when `var` is used in the global scope a new global variable is created,
which is a property on the global object (for example, the window object in a browser).

For `let` or `const`, a new variable is created, but no property on the global object is generated.

The result is that you cannot overwrite a global variable using `let` or `const` declarations,
only shadowing is possible.

#### Deeper Dive, Loop behavior

Furthermore, `let` corrects some problematic behavior of `var` in loops.

First, `let` behaves closer to expectations by restricting the accessibility of the counter variable to the block-level of the loop, while `var` does not.

``` javascript
for (var i = 0; i < 3; i++) {
  // some code here using i
}
// i still accessible here
```

Because loop variables are accessible from outside the scope of a loop,
when creating a function inside of a loop, the counter variable is shared across each iteration,
potentially causing unexpected behavior.

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

While an immediately invoked function expression (IIFE) could be used to correct for this unexpected behavior,
the use of `let` declaration for the counter variable makes this unnecessary and arguably more cleanly solves the issue creating a new counter variable on each iteration through the loop.

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

Lets look at an example.

We will start with a `Framework` class.
`Framework` has two properties, a `language` string, and a `versions` array.
If you are not familiar with the `class` syntax, you can read about it on [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) documentation.
We'll then create two instances of that class, `ember` and `phoenix`.

```javascript
const Framework = Object.create({
  language: "JavaScript",
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

## Arrow Functions

You may have noticed the new arrow function `=>` syntax, but not fully grasped its purpose.
Arrow functions introduce a more concise syntax for functions,
but they also have a number of differences from classic JavaScript functions.

Arrow functions:

* can make handling `this` binding more convenient. `this`, `super`, `arguments`, and `new.target` bindings are inherited from the closest containing non-arrow function.
* cannot be called with `new`
* have no prototype
* no arguments object, must rely on named parameters
* no duplicate parameters
* are often better optimized by JavaScript engines

Because the inheritance of `this` re-assigning or binding `this` from a containing function in order to preserve the context can be unnecessary, eliminating common patterns developed around such preservation of context.  

### Syntax of arrow functions

You can create a simple arrow function with a single argument without parenthesis in this way:

```javascript
let someArrowFunc = value => value; // note the lack of parenthesis around the arg value
```

This is similar to:

```javascript
let someArrowFunc = (value) => { return value; }
```

You can also create an arrow function passing in multiple arguments, but such a declaration requires parenthesis:

```javascript
let someArrowFunc = (value1, value2) => value1 || value2; // note the parenthesis around the args
```

Is just like:

```javascript
let someArrowFunc = function(value1, value2) {
  return value1 || value2;
}
```

For an arrow function without any arguments you must include an empty set of parenthesis:

```javascript
let someArrowFunc = () => "I have no args"; // note the empty parenthesis
```

Is just like:

```javascript
let someArrowFunc = function() {
  return "I have no args";
}
```

Of course you can also include a function body wrapped in `{}`:

```javascript
let someArrowFunc = (value) => {
  return value;
}
```

Is just like:

```javascript
let someArrowFunc = function(value) {
  return value;
}
```

And arrow functions can also be used as callbacks functions as well:

```javascript
this.someArray.map((element) => {
  // note the anonymous arrow callback function passed to map
  // some code
});
```

## Object Literal Shorthand

ES6 introduced a new more succinct syntax for object literal properties and methods.

### Property Initializer Syntax

Properties can now be set on object literals by including the name of the property only without the typical colon and value. This prevents some duplication when the object property is the same as the local variable you intend to set as the value of that property.

For example, this:

```javascript
  let firstName = "Yehuda";
  let lastName  = "Katz";

  let person = {
    firstName: firstName,
    lastName: lastName
  };
```

Can be written in ES6 as:

```javascript  
let firstName = "Yehuda";
let lastName  = "Katz";

let person = {
  firstName, // no colon and value
  lastName
};
```

However the property name and the name of the value being set needs to match in order for this to work. For example, this does *not* work in ES6:

```javascript  
let foreName = "Yehuda";
let surName  = "Katz";

let person = {
  firstName, // does not work
  lastName
};
```

Note that if duplication is your intent you can now set duplicate properties on objects without throwing an error when in strict mode, which was not possible in ES5. For example, this does work in ES6:

```javascript  
  "use strict";

  let person = {
    firstName: "Yehuda",
    firstName: "Tom" // no error here
  };
```

### Concise Methods

ES6 also eliminates the colon and function keyword from assigning methods to object literals.

For example, this:

```javascript
let firstName = "Yehuda";
let lastName  = "Katz";

let person = {
  firstName,
  lastName,
  fullName: function() {
	//some code
  }
};
```

Can be written in ES6 as:

```javascript
let firstName = "Yehuda";
let lastName  = "Katz";

let person = {
  firstName,
  lastName,
  fullName() { // no colon and function keyword
	//some code
  }
};
```

The one difference with concise methods is that they can use super to access an object's prototype whereas regular methods cannot.

For further reference on property initializer and concise method syntax see: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Object_initializer

## Destructuring

Destructuring simplifies the extraction of values from arrays and objects into variables. Previously in order to pull data out of an object and assign it to variables this was necessary:

```javascript
let person = {
  firstName: "Gob",
  lastName: "Bluth"
};

let firstName = person.firstName;
let lastName = person.lastName;
```

In ES6 with destructuring this can be achieved with less ceremony:

```javascript
let person = {
  firstName: "Tom",
  lastName: "Dale"
};

let {firstName, lastName} = person;

console.log(firstName); // outputs "Tom"
console.log(lastName); // outputs "Dale"
```

On the right-hand side of the assignment is a reference to the object being destructured, this is sometimes known as the initializer.

On the left-hand side of the assignment are the values to be unpacked from the sourced variable.

Note that in above example the variable has the same as the property on the object. This is similar to the property initializer syntax discussed in object literals. However, this does not have to be the case, you can assign to new variable names. For example:

```javascript
let person = {
  firstName: "Tom",
  lastName: "Dale"
};

let {firstName: foo, lastName: bar} = person;

console.log(foo); // outputs "Tom"
console.log(bar); // outputs "Dale"
```

Destructuring can also be used on arrays:

```javascript
let people = ["Link", "Zelda", "Ganon"];

let [firstPerson, secondPerson] = people;

console.log(firstPerson); // outputs "Link"
console.log(secondPerson; // outputs "Zelda"
```

Default values can also be assigned to variables in destructuring to prevent them from being undefined:

```javascript
let person = {
  firstName: "George",
  lastName: "Bluth"
};

let {firstName = "George", middleName= "Oscar", lastName = "Bluth"} = person;

console.log(middleName); // outputs "Oscar"
```

And, destructuring can be used to unpack more complicated structures like nested objects and arrays:

```javascript
let person =
  {
    name: "Michael Bluth",
    family: {
      mother: "Jane Smith",
      father: "George Oscar Bluth, Sr.",
      siblings: [ "Lindsay Bluth Fünke","George Oscar Bluth II" ],
      child: "George Michael Bluth"
    }
  };

let { family: familyMembers, family: {siblings: [sister]} } = person;

console.log(familyMembers.mother); // outputs "Jane Smith"
console.log(sister); // outputs "Lindsay Bluth Fünke"
```

[For more on destructuring assignments.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
