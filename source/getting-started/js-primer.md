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

## Object Literal Shorthand

In ES6 some functionality was added that allows the use of terser syntax for object literal properties and methods, along with some enhanced functionality for property names.

### Property intializer syntax

Now properties can be set on object literals without by including the name of the property without the typical colon and value if the object property the same as the local variable you intend to set as the value of that property. This helps reduce duplication. 

For example:
```javascript  
function someFunc(thing1, thing2) {
  return {
    thing1, // is equivalent to thing1: thing1
    thing2 // is equivalent to thing2: thing2
  };
}
```
However, you can now also set duplicate properties (where properties named the same) on objects without throwing an error when in strict mode.

### Concise Methods

ES6 eliminates the colon and function keyword from assigning methods to object literals. For example:

```javascript
let someObject = {
  thing1,
  someFunc() { // is essentially equivalent to someFunc: function() {
	//some code;
  }
};
```

The one difference with concise methods is that they can use super to access an object's prototype whereas regular methods cannot.

### Computed property names

Not to be confused with computed ember `computed properties`, computed property *names*, which were available previously, in ES6 can now be used to include expressions to define the name of a property. For example:

```javascript
let some = "thing ";
let object = {
	[some + "1"]: "This is the thing."
};
console.log(["thing 1"]); // outputs "This is the thing."
```  

