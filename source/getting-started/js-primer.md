The ECMAScript 2015 specification (also known as ES2015 or ES6) introduced new features to the JavaScript language.
While the Guides [assume you have a working knowledge of JavaScript](/#toc_assumptions),
not every feature of the JavaScript language may be familiar to the developer.

This guide will cover some JavaScript features, and how to use them in Ember applications.
To see a full set of features added in ES2015, check the [Mozilla Developer Network Docs](https://developer.mozilla.org/en/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla).

## Variable declarations

A variable declaration is when you assign a variable name to a location in memory.
This creates a place in memory to store data and allows lookup for that data by name.
The following code declares a variable called `myNumber` and stores the number 42:

```javascript
var myNumber = 42;
```

The values of most Javascript variables can be changed using the `=` operator in code.
However, changing the value of an existing variable should not use the `var`, `let` or `const` keywords since using the keyword will try to declare a new variable with the same name.
The following code declares the variable `text` and changes the value.

```javascript
var text = "Hello World";

text = "Hello Browser";
```

Before ES2015, JavaScript had to one way to declare variables using the `var` keyword.
ES2015 introduced two new variable keywords: `const` and `let`.
Each of these keywords has a different way of declaring variables.
This guide will review the differences between `var`, `const` and `let`; and will discuss when to choose between them.

### `var`

Variables declared using the `var` keyword only exist within that function.
This is called *function-scoping*.
Trying to access a variable declared with `var` outside of its function will throw an error.
This is because the variable is not declared in the current scope.

The following code declares a variable using  `var` inside of a function.
Then, the variable is logged both inside and outside of that function:

```javascript
function myFunction() {
 var name = "Tomster";

 console.log(name); // "Tomster"
}

console.log(name); // ReferenceError: name is not defined
```

Unlike some other languages, variables declared with `var` are not effected by blocks like `if` or `for`.
This also means a var declared inside of an `if` or `for` block, can still be accessed outside of those blocks:

```javascript
if (true) {
 var name = "Tomster";

 console.log(name); // "Tomster"
}

console.log(name); // "Tomster"
```

Another odd behavior of the `var` keyword is something called *hoisting*.
Javascript sets aside memory for variables when it enters a function.
So, variables declared with `var` are available from the start of that function to the end, even before the `var` keyword.
But, even though the variable is available, the value is not set until that line is executed.

In this example, the variable `name` is declared at the bottom of the `getName` function and set to `Tomster`.
When the `name` variable is logged at the top, it is available because of hoisting, but the value has not been set yet.

```javascript
function getName() {
  console.log(name); // undefined

  var name = "Tomster";

  return name;
}
```

To reduce hoisting confusion it is best practice to declare variables using `var` at the top of functions.
This is possible because when using the `var` keyword, a variable does not have to be set when it is declared.
The following code has the same result as `getName` above:

```javascript
function getName() {
  var name;

  console.log(name); // undefined

  name = "Tomster";

  return name;
}
```

### `const` and `let`

There are two major differences between `var` and both `const` and `let`.
`const` and `let` are both block-level declarations, and they are *not* hoisted.

Because of this, they are not accessible outside of the given block scope (meaning in a `function` or in `{}`) they are declared in.
You can also not access them before they are declared, or you will get a [`ReferenceError`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ReferenceError).

```javascript
console.log(name) // ReferenceError: name is not defined

if (person) {
 console.log(name) // ReferenceError: name is not defined

 let name = 'Gob Bluth'; // "Gob Bluth"
} else {
 console.log(name) // ReferenceError: name is not defined
}
```

`const` declarations have an additional restriction, they are *constant references*,
they always refer to the same thing.
To use a `const` declaration you have to specify the value it refers,
and you cannot change what the declaration refers to:

```javascript
const firstName; // Uncaught SyntaxError: Missing initializer in const declaration
const firstName = 'Gob';
firstName = 'George Michael'; // Uncaught SyntaxError: Identifier 'firstName' has already been declared
```

Note that `const` does not mean that the value it refers to cannot change.
If you have an array or an object, you can change their properties:

```javascript
const myArray = [];
const myObject = { name: "Tom Dale" };

myArray.push(1);
myObject.name = "Leah Silber";

console.log(myArray); // [1]
console.log(myObject); // {name: "Leah Silber"}
```

### `for` loops

Something that might be confusing is the behavior of `let` in `for` loops.

As we saw before, `let` declarations are scoped to the block they belong to.
In `for` loops, any variable declared in the for syntax belongs to the loop's block.

Let's look at some code to see what this looks like.
If you use `var`, this happens:

```javascript
for (var i = 0; i < 3; i++) {
 console.log(i) // 0, 1, 2, 3
}

console.log(i) // 3
```

But if you use `let`, this happens instead:

```javascript
for (let i = 0; i < 3; i++) {
 console.log(i) // 0, 1, 2, 3
}

console.log(i) // ReferenceError: i is not defined
```

Using `let` will avoid accidentally leaking and changing the `i` variable from outside of the `for` block.

### Resources

For further reference you can consult Developer Network articles:

* [`var`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/var)
* [`const`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const)
* [`let`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let).
* [`hoisting`](https://developer.mozilla.org/en-US/docs/Glossary/Hoisting)
