While the Guides [assume you have a working knowledge of JavaScript](/#toc_assumptions),
when learning a new framework it can be hard to know what is JavaScript and what is framework,
especially if you are newer to the ecosystem.

On top of that, new features were introduced to JavaScript with the release of specification like [EcmaScript 2015](https://developer.mozilla.org/en/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla) (also known as ES6).
With the current yearly cadence of EcmaScript specifications,
developers might have not had time to get familiar with all the new features.

In this guide we will be covering some common JavaScript code patterns that appear in Ember applications,
so you can get a clearer sense of where the language ends and the framework starts.

## Object properties

One quirk of the JavaScript language that commonly trips up developers if that if you define an array or object property directly in your class,
every instance of that class will share the same array/object.

Let's look at an example.

We will start with a `Framework` class.
`Framework` has two propert ies, a `language` string, and a `versions` array.
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

## Arrow Functions

You may have noticed the new arrow function `=>` syntax, but not fully grasped its purpose. Arrow functions introduce a more concise syntax for functions, but they also have a number of differences from classic JavaScript functions. 

Arrow functions:

* can make handling `this` binding more convenient. `this`, `super`, `arguments`, and `new.target` bindings are inherited from the closest containing non-arrow function. 
* cannot be called with `new`
* have no prototype
* no arguments object, must rely on named parameters
* no duplicate parameters
* are often better optimized by JavaScript engines

Because the inheritance of `this` re-assigning or binding `this` from a containing function in order to preserve the context can be unnecessary, eliminating common patterns developed around such preservation of context.  

### Syntax of arrow functions

You can create a simple arrow function with a single argument without parens in this way:
```javascript
let someArrowFunc = value => value; // note the lack of parens around the arg value
```
Is just like:
```javascript
let someArrowFunc = function(value) {
  return value;
}
```

You can also create an arrow function passing in multiple arguments, but such a declaration requires parens:
```javascript
let someArrowFunc = (value1, value2) => value1 || value2; // note the parens around the args
```
Is just like:
```javascript
let someArrowFunc = function(value1, value2) {
  return value1 || value2;
}
```

For an arrow function without any arguments you must include an empty set of parens:
```javascript
let someArrowFunc = () => "I have no args"; // note the empty parens
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


