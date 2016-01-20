Once you have managed to load records from a server, the next step is to edit them.
Ember Data records behave like normal Ember Objects but they also come with some built
in niceties for making it easy to edit and persist them.


## Editing Records

Making changes to Ember Data records is as simple as setting the attribute you
want to change:

```js
this.store.findRecord('image', 1).then(function(image) {
  // ...after the record has loaded
  image.set('title', "Yollo");
});
```

The changes that you make to a record are not automatically saved to the server, they will
only be reflected in your UI and Javascript code. In order to persist the changes you made you will need
to explicitly call save on your record.

## Saving Records

You can save records by calling the `save` method on them.

```js
image.save().then(() => {
  console.log("save successful");
  }, (reason) => {
    console.log("save not successfull because", reason);
  }
);
```

The `save` call will by default make a  PUT network request to a URL that looks like `/images/:id` to update your record.
If you need to modify this or are not using the default JSON API adapter, you can read about how to modify
the defaults in LINK HERE

The call to `save` will return a promise which lets you handle success and failure cases.
Ember Data comes with built in functionality for handling basic errors and validations.
For more information, you should look at the Handling Errors and Validations section. LINK HERE


## Creating new records

You can create records by calling the `createRecord` method on the store.

```js
let image = store.createRecord('image', {
  title: 'Rails is Omakase',
});
```


`createRecord` creates a new local record with the data you assigned it. It will not automatically save the new record on the server,
so you have a chance to wait on user input or do more complex manipulations before saving it.
In order to save the newly created record, you need to call `.save` on it.

```js
let image = store.createRecord('image', {
  title: 'Rails is Omakase',
});
image.get('isNew'); // => true
image.save().then(() => {
  console.log("record successfully created");
  }, (reason) => {
    console.log("creationg not successfull because", reason);
  }
);
```
By default, Ember Data would `POST` this record to the `/images` URL. If you need to modify this, you can LINK HERE

## Deleting Records

In order to delete a record, you should call `deleteRecord` on the record instance.

```js
store.findRecord('image', 1).then(function(image) {
  image.deleteRecord();
  image.get('isDeleted'); // => true
  image.save(); // => DELETE to /posts/1
});
```

Similarly to create and update, deleting a record will not persist automatically, but will wait until you call
`.save` on it. This makes it easy to show confirmation windows to the user, as well as greyed out UI for deletions 
not yet persisted.

Once the deletion has been confirmed, Ember Data will remove the record from all record arrays and relationships it
was a part of.

BETTER EXAMPLE HERE
