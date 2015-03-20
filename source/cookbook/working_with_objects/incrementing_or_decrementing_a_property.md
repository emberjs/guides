### Problem
You want to increment or decrement a property.

### Solution
Use the `incrementProperty` or `decrementProperty` methods of `Ember.Object`.

To increment:

```javascript
person.incrementProperty('age');
```

To decrement:

```javascript
person.decrementProperty('age');
```

### Discussion
You can optionally specify a value to increment or decrement by:

```javascript
person.incrementProperty('age', 10);
```

<!---#### Example

<a class="jsbin-embed" href="http://jsbin.com/huxojisaha/1/edit?live">JS Bin</a>-->
