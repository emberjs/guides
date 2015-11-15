## Creating Records

Let's assume that we have a `post` and a `comment` model, which are related to each other as follows:

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

When a user comments on a post, we need to create a relationship between the two records. We can simply set the `belongsTo` relationship in our new comment:

```javascript
let post = this.store.peekRecord('post', 1);
let comment = this.store.createRecord('comment', {
  post: post
});
comment.save();
```

This will create a new `comment` record and save it to the server. Ember Data will also update the post to include our newly created comment in its `comments` relationship.

We could have also linked the two records together by updating the post's `hasMany` relationship:

```javascript
let post = this.store.peekRecord('post', 1);
let comment = this.store.createRecord('comment', {
});
post.get('comments').pushObject(comment);
comment.save();
```

In this case the new comment's `belongsTo` relationship will be set to the parent post.

## Updating Existing Records

Sometimes we want to set relationships on already existing records. We can simply set a `belongsTo` relationship:

```javascript
let post = this.store.peekRecord('post', 1);
let comment = this.store.peekRecord('comment', 1);
comment.set('post', post);
comment.save();
```

Alternatively, we could update the `hasMany` relationship by pushing a record into the relationship:

```javascript
let post = this.store.peekRecord('post', 1);
let comment = this.store.peekRecord('comment', 1);
post.get('comments').pushObject(comment);
post.save();
```

## Removing Relationships

To remove a `belongsTo` relationship, we can set it to `null`, which will also remove it from the `hasMany` side:

```javascript
let comment = this.store.peekRecord('comment', 1);
comment.set('post', null);
comment.save();
```

It is also possible to remove a record from a `hasMany` relationship:

```javascript
let post = this.store.peekRecord('post', 1);
let comment = this.store.peekRecord('comment', 1);
post.get('comments').removeObject(comment);
post.save();
```

As in the earlier examples, the comment's `belongsTo` relationship will also be cleared by Ember Data.

## Relationships as Promises

While working with relationships it is important to remember that they return promises.

For example, if we were to work on a post's asynchronous comments, we would have to wait until the promise has fulfilled:

```javascript
let post = this.store.peekRecord('post', 1);

post.get('comments').then((comments) => {
  // now we can work with the comments
});
```

The same applies to `belongsTo` relationships:

```javascript
let comment = this.store.peekRecord('comment', 1);

comment.get('post').then((post) => {
  // the post is available here
});
```

Handlebars templates will automatically be updated to reflect a resolved promise. We can display a list of comments in a post like so:

```handlebars
<ul>
  {{#each post.comments as |comment|}}
    <li>{{comment.id}}</li>
  {{/each}}
</ul>
```

Ember Data will query the server for the appropriate records and re-render the template once the data is received.