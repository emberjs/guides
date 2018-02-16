Many new features were introduced to JavaScript with the release of newer specifications like ECMAScript 2015,
also known as [ECMAScript 6 or ES6](https://developer.mozilla.org/en/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla).
While the Guides [assume you have a working knowledge of JavaScript](/#toc_assumptions),
not every feature of the JavaScript language may be familiar to the developer.

In this guide we will be covering some JavaScript features,
and how they are used in Ember applications.

## Variable declarations

A variable declaration, also called binding, is when you assign a value to a variable name.
An example of declaring a variable containing the number 42 is like so:

```javascript
var myNumber = 42;
```

JavaScript initially had two ways to declare variables, globally and `var`.
With the release of ES2015, `const` and `let` were introduced.
We will go through the different ways to declare a variable,
also called bindings because they *bind* a value to a variable name,
and why modern JavaScript tends to prefer `const` and `let`.

### `var`

Variable declarations using `var` exist in the entire body of the function where they are declared.
This is called function-scoping, the existence of the `var` is scoped to the function.
If you try to access a `var` outside of the function it is declared,
you will get an error that the variable is not defined.

For our example, we will declare a `var` named `name`.
We will try to access it both inside the function and outside,
and see the results we get:

```javascript
console.log(name); // ReferenceError: name is not defined

function myFunction() {
  var name = "Tomster";

  console.log(name); // "Tomster"
}
```

This also means that if you have an `if` or a `for` in your code and declare a `var` inside them,
you can still access the variable outside of those blocks:

```javascript
console.log(name); // undefined

if (true) {
  var name = "Tomster";

  console.log(name); // "Tomster"
}
```

In the previous example, we can see that the first `console.log(name)` prints out `undefined` instead of the value.
That is because of a feature of JavaScript called *hoisting*.
Any variable declaration is moved by the programming language to the top of the scope it belongs to.
As we saw at the beginning, `var` is scoped to the function,
so the previous example is the same as:

```javascript
var name;
console.log(name); // undefined

if (true) {
  name = "Tomster";

  console.log(name); // "Tomster"
}
```

### `const` and `let`

There are two major differences between `var` and both `const` and `let`.
`const` and `let` are both block-level declarations, and they are *not* hoisted.

Because of this they are not accessible outside of the given block scope (meaning in a `function` or in `{}`) they are declared in.
You also cannot access them before they are declared, or you will get a [`ReferenceError`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ReferenceError).

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

Something that might be confusing is the behaviour of `let` in `for` loops.

As we saw before, `let` declarations are scoped to the block they belong to.
In `for` loops, any variable declared in the `for` syntax belongs to the loop's block.

Let's look at some code to see what this looks like.
If you use `var`, this happens:

```javascript
for (var i = 0; i < 3; i++) {
  console.log(i) // 0, 1, 2
}

console.log(i) // 3
```

But if you use `let`, this happens instead:

```javascript
for (let i = 0; i < 3; i++) {
  console.log(i) // 0, 1, 2
}

console.log(i) // ReferenceError: i is not defined
```

Using `let` will avoid accidentally leaking and changing the `i` variable from outside of the `for` block.

### Resources

For further reference you can consult Developer Network articles:

* [`var`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/var)
* [`const`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const)
* [`let`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let).
