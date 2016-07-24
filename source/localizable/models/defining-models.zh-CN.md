A model is a class that defines the properties and behavior of the data that you present to the user. Anything that the user expects to see if they leave your app and come back later (or if they refresh the page) should be represented by a model.

When you want a new model for your application you need to create a new file under the models folder and extend from `Model`. This is more conveniently done by using one of Ember CLI's generator commands. For instance, let's create a `person` model:

```bash
ember generate model person
```

This will generate the following file:

```app/models/person.js import Model from 'ember-data/model';

export default Model.extend({ });

    <br />After you have defined a model class, you can start [finding](../finding-records)
    and [working with records](../creating-updating-and-deleting-records) of that type.
    
    
    ## Defining Attributes
    
    The `person` model we generated earlier didn't have any attributes. Let's
    add first and last name, as well as the birthday, using [`attr`](http://emberjs.com/api/data/classes/DS.html#method_attr):
    
    ```app/models/person.js
    import Model from 'ember-data/model';
    import attr from 'ember-data/attr';
    
    export default Model.extend({
      firstName: attr(),
      lastName: attr(),
      birthday: attr()
    });
    

Attributes are used when turning the JSON payload returned from your server into a record, and when serializing a record to save back to the server after it has been modified.

You can use attributes like any other property, including as part of a computed property. Frequently, you will want to define computed properties that combine or transform primitive attributes.

```app/models/person.js import Model from 'ember-data/model'; import attr from 'ember-data/attr';

export default Model.extend({ firstName: attr(), lastName: attr(),

fullName: Ember.computed('firstName', 'lastName', function() { return `${this.get('firstName')} ${this.get('lastName')}`; }) });

    <br />For more about adding computed properties to your classes, see [Computed
    Properties](../../object-model/computed-properties).
    
    ### Transforms
    
    You may find the type of an attribute returned by the server does not
    match the type you would like to use in your JavaScript code. Ember
    Data allows you to define simple serialization and deserialization
    methods for attribute types called transforms. You can specify that
    you would like a transform to run for an attribute by providing the
    transform name as the first argument to the `attr` method. Ember Data
    supports attribute types of `string`, `number`, `boolean`, and `date`,
    which coerce the value to the JavaScript type that matches its name.
    
    ```app/models/person.js
    import Model from 'ember-data/model';
    import attr from 'ember-data/attr';
    
    export default Model.extend({
      name: attr('string'),
      age: attr('number'),
      admin: attr('boolean'),
      birthday: attr('date')
    });
    

The `date` transform will transform an [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) string to a JavaScript date object.

The `boolean` transform can handle values other than `true` or `false`. The strings `"true"` or `"t"` in any casing, `"1"`, and the number `1` will all coerce to `true`, and `false` otherwise.

Transforms are not required. If you do not specify a transform name Ember Data will do no additional processing of the value.

#### Custom Transforms

You can also create custom transforms with Ember CLI's `transform` generator:

```bash
ember generate transform dollars
```

Here is a simple transform that converts values between cents and US dollars.

```app/transforms/dollars.js import Transform from 'ember-data/transform';

export default Transform.extend({ deserialize: function(serialized) { return serialized / 100; // returns dollars },

serialize: function(deserialized) { return deserialized * 100; // returns cents } });

    <br />A transform has two functions: `serialize` and `deserialize`. Deserialization
    converts a value to a format that the client expects. Serialization does the
    reverse and converts a value to the format expected by the persistence layer.
    
    You would use the custom `dollars` transform like this:
    
    ```app/models/product.js
    import Model from 'ember-data/model';
    import attr from 'ember-data/attr';
    
    export default Model.extend({
      spent: attr('dollars')
    });
    

### Options

`attr` can also take a hash of options as a second parameter. At the moment the only option available is `defaultValue`, which can use a value or a function to set the default value of the attribute if one is not supplied.

In the following example we define that `verified` has a default value of `false` and `createdAt` defaults to the current date at the time of the model's creation:

```app/models/user.js import Model from 'ember-data/model'; import attr from 'ember-data/attr';

export default Model.extend({ username: attr('string'), email: attr('string'), verified: attr('boolean', { defaultValue: false }), createdAt: attr('date', { defaultValue() { return new Date(); } }) }); ```