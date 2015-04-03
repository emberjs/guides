Displaying validation errors from a backend server is a common pattern
when attempint to update records based on user feedback.

Every DS.Model has an `errors` property. This can be used to display
validation error messages returned from the server when a
`record.save()` rejects.  This works automatically with
`DS.ActiveModelAdapter`, but you can implement
[ajaxError](/api/data/classes/DS.RESTAdapter.html#method_ajaxError) in
other adapters as well.  For Example, if you had an `User` model that
looked like this:

```app/models/user.js
export default DS.Model.extend({
  username: attr('string'),
  email: attr('string')
});
```
 
And you attempted to save a record that did not validate on the backend.

```js
var user = store.createRecord('user', {
  username: 'tomster',
  email: 'invalidEmail'
});
user.save();
```

Your backend server should return a 422 HTTP status code as well as a
response payload that looks like this. This response will be used to
populate the error object.

```json
{
  "username": ["This username is already taken!"],
  "email": ["Doesn't look like a valid email."]
}
```

Errors can be displayed to the user by accessing their property name
to get an array of all the error objects for that property. Each
error object is a JavaScript object with two keys:
- `message` A string containing the error message from the backend
- `attribute` The name of the property associated with this error message

```handlebars
<label>Username: {{input value=username}} </label>
{{#each error in model.errors.username}}
  <div class="error">
    {{error.message}}
  </div>
{{/each}}
<label>Email: {{input value=email}} </label>
{{#each error in model.errors.email}}
  <div class="error">
    {{error.message}}
  </div>
{{/each}}
```

You can also access the special `messages` property on the error
object to get an array of all the error strings.

```handlebars
{{#each message in model.errors.messages}}
  <div class="error">
    {{message}}
  </div>
{{/each}}
```

