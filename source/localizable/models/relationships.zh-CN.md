Ember Data includes several built-in relationship types to help you define how your models relate to each other.

### One-to-One

To declare a one-to-one relationship between two models, use `DS.belongsTo`:

```app/models/user.js import DS from 'ember-data';

export default DS.Model.extend({ profile: DS.belongsTo('profile') });

    <br />```app/models/profile.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      user: DS.belongsTo('user')
    });
    

### One-to-Many

To declare a one-to-many relationship between two models, use `DS.belongsTo` in combination with `DS.hasMany`, like this:

```app/models/blog-post.js import DS from 'ember-data';

export default DS.Model.extend({ comments: DS.hasMany('comment') });

    <br />```app/models/comment.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      blogPost: DS.belongsTo('blog-post')
    });
    

### Many-to-Many

To declare a many-to-many relationship between two models, use `DS.hasMany`:

```app/models/blog-post.js import DS from 'ember-data';

export default DS.Model.extend({ tags: DS.hasMany('tag') });

    <br />```app/models/tag.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      blogPosts: DS.hasMany('blog-post')
    });
    

### Explicit Inverses

Ember Data will do its best to discover which relationships map to one another. In the one-to-many code above, for example, Ember Data can figure out that changing the `comments` relationship should update the `blogPost` relationship on the inverse because `blogPost` is the only relationship to that model.

However, sometimes you may have multiple `belongsTo`/`hasMany`s for the same type. You can specify which property on the related model is the inverse using `DS.belongsTo` or `DS.hasMany`'s `inverse` option. Relationships without an inverse can be indicated as such by including `{ inverse: null }`.

```app/models/comment.js import DS from 'ember-data';

export default DS.Model.extend({ onePost: DS.belongsTo('blog-post', { inverse: null }), twoPost: DS.belongsTo('blog-post'), redPost: DS.belongsTo('blog-post'), bluePost: DS.belongsTo('blog-post') });

    <br />```app/models/blog-post.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      comments: DS.hasMany('comment', {
        inverse: 'redPost'
      })
    });
    

### Reflexive Relations

When you want to define a reflexive relation (a model that has a relationship to itself), you must explicitly define the inverse relationship. If there is no inverse relationship then you can set the inverse to `null`.

Here's an example of a one-to-many reflexive relationship:

```app/models/folder.js import DS from 'ember-data';

export default DS.Model.extend({ children: DS.hasMany('folder', { inverse: 'parent' }), parent: DS.belongsTo('folder', { inverse: 'children' }) });

    <br />Here's an example of a one-to-one reflexive relationship:
    
    ```app/models/user.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      name: DS.attr('string'),
      bestFriend: DS.belongsTo('user', { inverse: 'bestFriend' }),
    });
    

You can also define a reflexive relationship that doesn't have an inverse:

```app/models/folder.js import DS from 'ember-data';

export default DS.Model.extend({ parent: DS.belongsTo('folder', { inverse: null }) });

    <br />### Readonly Nested Data
    
    Some models may have properties that are deeply nested objects of
    readonly data. The naïve solution would be to define models for each
    nested object and use `hasMany` and `belongsTo` to recreate the nested
    relationship. However, since readonly data will never need to be
    updated and saved this often results in the creation of a great deal
    of code for very little benefit. An alternate approach is to define
    these relationships using an attribute with no transform
    (`DS.attr()`). This makes it easy to access readonly values in
    computed properties and templates without the overhead of defining
    extraneous models.
    
    ### Creating Records
    
    Let's assume that we have a `blog-post` and a `comment` model, which are related to each other as follows:
    
    ```app/models/blog-post.js
    import DS from 'ember-data';
    
    export default DS.Model.extend({
      comments: DS.hasMany('comment')
    });
    

```app/models/comment.js import DS from 'ember-data';

export default DS.Model.extend({ blogPost: DS.belongsTo('blog-post') });

    <br />When a user comments on a blogPost, we need to create a relationship between the two records. We can simply set the `belongsTo` relationship in our new comment:
    
    ```javascript
    let blogPost = this.get('store').peekRecord('blog-post', 1);
    let comment = this.get('store').createRecord('comment', {
      blogPost: blogPost
    });
    comment.save();
    

This will create a new `comment` record and save it to the server. Ember Data will also update the blogPost to include our newly created comment in its `comments` relationship.

We could have also linked the two records together by updating the blogPost's `hasMany` relationship:

```javascript
let blogPost = this.get('store').peekRecord('blog-post', 1);
let comment = this.get('store').createRecord('comment', {
});
blogPost.get('comments').pushObject(comment);
comment.save().then(function () {
  blogPost.save();
});
```

In this case the new comment's `belongsTo` relationship will be set to the parent blogPost.

Although `createRecord` is fairly straightforward, the only thing to watch out for is that you cannot assign a promise as a relationship, currently.

For example, if you want to set the `author` property of a blogPost, this would **not** work if the `user` with id isn't already loaded into the store:

```js
this.get('store').createRecord('blog-post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum',
  author: this.get('store').findRecord('user', 1)
});
```

However, you can easily set the relationship after the promise has fulfilled:

```js
let blogPost = this.get('store').createRecord('blog-post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

this.get('store').findRecord('user', 1).then(function(user) {
  blogPost.set('author', user);
});
```

### Updating Existing Records

Sometimes we want to set relationships on already existing records. We can simply set a `belongsTo` relationship:

```javascript
let blogPost = this.get('store').peekRecord('blog-post', 1);
let comment = this.get('store').peekRecord('comment', 1);
comment.set('blogPost', blogPost);
comment.save();
```

Alternatively, we could update the `hasMany` relationship by pushing a record into the relationship:

```javascript
let blogPost = this.get('store').peekRecord('blog-post', 1);
let comment = this.get('store').peekRecord('comment', 1);
blogPost.get('comments').pushObject(comment);
blogPost.save();
```

### Removing Relationships

To remove a `belongsTo` relationship, we can set it to `null`, which will also remove it from the `hasMany` side:

```javascript
let comment = this.get('store').peekRecord('comment', 1);
comment.set('blogPost', null);
comment.save();
```

It is also possible to remove a record from a `hasMany` relationship:

```javascript
let blogPost = this.get('store').peekRecord('blog-post', 1);
let comment = this.get('store').peekRecord('comment', 1);
blogPost.get('comments').removeObject(comment);
blogPost.save();
```

As in the earlier examples, the comment's `belongsTo` relationship will also be cleared by Ember Data.

### Relationships as Promises

While working with relationships it is important to remember that they return promises.

For example, if we were to work on a blogPost's asynchronous comments, we would have to wait until the promise has fulfilled:

```javascript
let blogPost = this.get('store').peekRecord('blog-post', 1);

blogPost.get('comments').then((comments) => {
  // now we can work with the comments
});
```

The same applies to `belongsTo` relationships:

```javascript
let comment = this.get('store').peekRecord('comment', 1);

comment.get('blogPost').then((blogPost) => {
  // the blogPost is available here
});
```

Handlebars templates will automatically be updated to reflect a resolved promise. We can display a list of comments in a blogPost like so:

```handlebars
<ul>
  {{#each blogPost.comments as |comment|}}
    <li>{{comment.id}}</li>
  {{/each}}
</ul>
```

Ember Data will query the server for the appropriate records and re-render the template once the data is received.