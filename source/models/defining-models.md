A model is a class that defines the properties and behavior of the
data that you present to the user. Anything that the user expects to see
if they leave your app and come back later (or if they refresh the page)
should be represented by a model.

When you want a new model for your application you need to create a new file
under the models folder and extend from `DS.Model`. This is more conveniently
done by using one of Ember CLI's generator commands. For instance, let's create
a `person` model:

```bash
ember generate model person
```

This will generate the following file:

```app/models/person.js
export default DS.Model.extend({
});
```

After you have defined a model class, you can start [finding](../finding-records)
and [working with records](../creating-updating-and-deleting-records) of that type.


### Defining Attributes

The `person` model we generated earlier didn't have any attributes. Let's
add first and last name, as well as the birthday, using `DS.attr`:

```app/models/person.js
export default DS.Model.extend({
  firstName: DS.attr(),
  lastName: DS.attr(),
  birthday: DS.attr()
});
```

Attributes are used when turning the JSON payload returned from your
server into a record, and when serializing a record to save back to the
server after it has been modified.

You can use attributes just like any other property, including as part of a
computed property. Frequently, you will want to define computed
properties that combine or transform primitive attributes.

```app/models/person.js
export default DS.Model.extend({
  firstName: DS.attr(),
  lastName: DS.attr(),

  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  })
});
```

For more about adding computed properties to your classes, see [Computed
Properties](../../object-model/computed-properties).

#### Transforms

You may find the type of an attribute returned by the server does not
match the type you would like to use in your JavaScript code. Ember
Data allows you to define simple serialization and deserialization
methods for attribute types called transforms. You can specify that
you would like a transform to run for an attribute by providing the
transform name as the first argument to the `DS.attr` method.

For example if you would like to transform an
[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) string to a
JavaScript date object you would define your attribute like this:

```app/models/person.js
export default DS.Model.extend({
  birthday: DS.attr('date')
});
```

Ember Data supports attribute types of `string`, `number`, `boolean`,
and `date`. Which coerce the value to the JavaScript type that matches
its name.

Transforms are not required. If you do not specify a transform name
Ember Data will do no additional processing of the value.

#### Options

`DS.attr` can also take a hash of options as a second parameter. At the moment
the only option available is `defaultValue`, which can use a string or a
function to set the default value of the attribute if one is not supplied.

In the following example we define that `verified` has a default value of
`false` and `createdAt` defaults to the current date at the time of the model's
creation:

```app/models/user.js
export default DS.Model.extend({
  username: DS.attr('string'),
  email: DS.attr('string'),
  verified: DS.attr('boolean', { defaultValue: false }),
  createdAt: DS.attr('string', {
    defaultValue() { return new Date(); }
  })
});
```


### Defining Relationships

Ember Data includes several built-in relationship types to help you
define how your models relate to each other.

#### One-to-One

To declare a one-to-one relationship between two models, use
`DS.belongsTo`:

```app/models/user.js
export default DS.Model.extend({
  profile: DS.belongsTo('profile')
});
```

```app/models/profile.js
export default DS.Model.extend({
  user: DS.belongsTo('user')
});
```

#### One-to-Many

To declare a one-to-many relationship between two models, use
`DS.belongsTo` in combination with `DS.hasMany`, like this:

```app/models/post.js
export default DS.Model.extend({
  comments: DS.hasMany('comment')
});
```

```app/models/comment.js
export default DS.Model.extend({
  post: DS.belongsTo('post')
});
```

#### Many-to-Many

To declare a many-to-many relationship between two models, use
`DS.hasMany`:

```app/models/post.js
export default DS.Model.extend({
  tags: DS.hasMany('tag')
});
```

```app/models/tag.js
export default DS.Model.extend({
  posts: DS.hasMany('post')
});
```

#### Explicit Inverses

Ember Data will do its best to discover which relationships map to one
another. In the one-to-many code above, for example, Ember Data can figure out that
changing the `comments` relationship should update the `post`
relationship on the inverse because `post` is the only relationship to
that model.

However, sometimes you may have multiple `belongsTo`/`hasMany`s for
the same type. You can specify which property on the related model is
the inverse using `DS.belongsTo` or `DS.hasMany`'s `inverse`
option. Relationships without an inverse can be indicated as such by
including `{ inverse: null }`.


```app/models/comment.js
export default DS.Model.extend({
  onePost: DS.belongsTo('post', { inverse: null }),
  twoPost: DS.belongsTo('post'),
  redPost: DS.belongsTo('post'),
  bluePost: DS.belongsTo('post')
});
```

```app/models/post.js
export default DS.Model.extend({
  comments: DS.hasMany('comment', {
    inverse: 'redPost'
  })
});
```

#### Reflexive relation

When you want to define a reflexive relation (a model that relation to
itself), you must explicitly define the inverse relationship. If there
is no inverse relationship then you can set the inverse to null.

##### One To Many Reflexive Relationship

```app/models/folder.js
export default DS.Model.extend({
  children: DS.hasMany('folder', { inverse: 'parent' }),
  parent: DS.belongsTo('folder', { inverse: 'children' })
});
```

##### One To One Reflexive Relationship

```app/models/user.js
export default DS.Model.extend({
  name: DS.attr('string'),
  bestFriend: DS.belongsTo('user', {async: true, inverse: 'bestFriend' }),
});
```

##### No Inverse Reflexive Relationship

```app/models/folder.js
export default DS.Model.extend({
  parent: DS.belongsTo('folder', { inverse: null })
});
```

#### Readonly Nested Data

Some Models may have properties that are deeply nested objects of
readonly data. The naive solution would be to define models for each
nested object and use `hasMany` and `belongsTo` to recreate the nested
relationship. However, since readonly data will never need to be
updated and saved this often results in the creation of a great deal
of code for very little benefit. An alternate approch is to define
these relationships using an attribute with no transform
(`DS.attr()`). This makes it easy to access readonly values in
computed properties and templates without the overhead of defining
extraneous models.

---

Models, attributes and relationships help you define how your data is
structured. In the next section, we will learn about how to fetch
records and their relationships from your backend.

