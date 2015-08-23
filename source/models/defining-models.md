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
and [creating records](../creating-and-deleting-records) of that type.


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

If you don't specify the type of the attribute, it will be whatever was
provided by the server. You can make sure that an attribute is always
coerced into a particular type by passing a `type` to `attr`:

```app/models/person.js
export default DS.Model.extend({
  birthday: DS.attr('date')
});
```

The default adapter supports attribute types of `string`,
`number`, `boolean`, and `date`. Custom adapters may offer additional
attribute types, and new types can be registered as transforms. See the
[documentation section on the REST Adapter](../../models/the-rest-adapter).

**Please note:** Ember Data serializes and deserializes dates according to
                 [ISO 8601][]. For example: `2014-05-27T12:54:01`

[ISO 8601]: http://en.wikipedia.org/wiki/ISO_8601

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

However, sometimes you may have multiple `belongsTo`/`hasMany`s for the
same type. You can specify which property on the related model is the
inverse using `DS.hasMany`'s `inverse` option:

```app/models/comment.js
export default DS.Model.extend({
  onePost: DS.belongsTo('post'),
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

You can also specify an inverse on a `belongsTo`, which works how you'd expect.

#### Reflexive relation

When you want to define a reflexive relation, you must either explicitly define
the other side, and set the explicit inverse accordingly, and if you don't need the
other side, set the inverse to null.

```app/models/folder.js
export default DS.Model.extend({
  children: DS.hasMany('folder', { inverse: 'parent' }),
  parent: DS.belongsTo('folder', { inverse: 'children' })
});
```

or

```app/models/folder.js
export default DS.Model.extend({
  parent: DS.belongsTo('folder', { inverse: null })
});
```
