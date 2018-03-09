Along with the records returned from your store, you'll likely need to handle some kind of metadata. *Metadata* is data that goes along with a specific *model* or *type* instead of a record.

Pagination is a common example of using metadata. Imagine a blog with far more posts than you can display at once. You might query it like so:

```js
let result = this.get('store').query('post', {
  limit: 10,
  offset: 0
});
```

To get different *pages* of data, you'd simply change your offset in increments of 10. So far, so good. But how do you know how many pages of data you have? Your server would need to return the total number of records as a piece of metadata.

Each serializer will expect the metadata to be returned differently. For example, Ember Data's JSON deserializer looks for a `meta` key:

```js
{
  "post": {
    "id": 1,
    "title": "Progressive Enhancement is Dead",
    "comments": ["1", "2"],
    "links": {
      "user": "/people/tomdale"
    },
    // ...
  },

  "meta": {
    "total": 100
  }
}
```

Regardless of the serializer used, this metadata is extracted from the response. You can then read it with `.get('meta')`.

This can be done on the result of a `store.query()` call:

```js
store.query('post').then((result) => {
  let meta = result.get('meta');
});
```

On a belongsTo relationship:

```js
let post = store.peekRecord('post', 1);

post.get('author').then((author) => {
  let meta = author.get('meta');
});
```

Or on a hasMany relationship:

```js
let post = store.peekRecord('post', 1);

post.get('comments').then((comments) => {
  let meta = comments.get('meta');
});
```

After reading it, `meta.total` can be used to calculate how many pages of posts you'll have.

To use the `meta` data outside of the `model` hook, you need to return it:

```app/routes/users.js
import Router from '@ember/routing/route';

export default Route.extend({
  model() {
    return this.store.query('user', {}).then((results) => {
      return {
        users: results,
        meta: results.get('meta')
      };
    });
  },
  setupController(controller, { users, meta }) {
    this._super(controller, users);
    controller.set('meta', meta);
  }
});
```

To customize metadata extraction, check out the documentation for your serializer.
