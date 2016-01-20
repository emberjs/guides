One of the first things you will want to do in your Ember application is load data.
In the most common scenario in Ember, you will do so in a `model` hook in your route.

For example, if you are creating an Instagram clone, you will want to load a picture.
either using mock data
```
CODE HERE
MOCK DATA
```
or from a server call
```
CODE HERE
JQUERY GET
```

You can see how hardcoding these calls as your app grows will become hard to manage and refactor.

Ember Data provides a unified way for accessing your records.
```
store.findRecord
```
This method will try to retrieve the picture with id 1 and will return a Promise, which will fullfil once
the data has been loaded. Promises are important, please familiarize if dont know.

`store.findRecord('picture', 1)` will by default go to `/pictures/1` and expect a JSON API formatted document from the server.

This Guide will be assuming you are using a JSON API compatible server. If you are not, please take
a look at the adapter/serializer guide for how to pick the adapter for your server or mock data.

The last missing piece for this refactor to work is to provide a schema to ember data, so it can understand
what the data it is expecting looks like. Ember, as part of its MVC architecture uses model classes to describe
how the data stored on the server looks like. For our Instagram picture for example, you would create a picture model class using
Ember Cli

```bash
ember generate model picture
```

This will create a file that looks like:
```app/models/picture.js
import DS from ember-data;

export default DS.Model.extend({
});
```

After we have created the model file, the call to `store.findRecord('picture', 1)` will succeed, because ember data will know to look up
the model class located at `app/models/picture.js`

However, our model is not very useful right now, as the default schema we have generated does not describe any attributes or relationships.
We can add the title attribute by adding it to the picture class.
```app/models/picture.js
export default DS.Model.extend({
  title: DS.attr()
});
```

You can learn more about attributes at XXX add link.

Now, once our route finishes loading data, in our template we will be able to access the title attribute.
```
{{picture.title}}
```

