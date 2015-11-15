# Helpers

Sometimes, you may use the same HTML in your application multiple times. In those cases, you can register a custom helper that can be invoked from any Handlebars template.

Helpers allow you to add functionality to your templates beyond what is included
out of the box in Ember. Helpers are most useful for transforming raw values
from models and components into a format more appropriate for your users.

We want to show how many days ago a house was posted on the site. Our app has recorded the date in the [UNIX time format](https://en.wikipedia.org/wiki/Unix_time). This isn’t a very human-friendly way to display a date, so let’s convert it to something more readable.

## How to generate a helper with the CLI

With the command `ember g helper` we can generate the scaffolding necessary for creating our own helper.

```
ember g helper days-ago


installing helper
  create app/helpers/days-ago.js
installing helper-test
  create tests/unit/helpers/days-ago-test.js
```
In addition to `tests/unit/helpers/days-ago-test.js` we get the helper file where we will implement our conversion logic:

```
import Ember from 'ember';

export function daysAgo(params/*, hash*/) {
  return params;
}

export default Ember.Helper.helper(daysAgo);
```

Our goal is to give this helper a Unix timestamp as an argument, and return a “days ago” message from the `daysAgo` function.  So let’s add the JavaScript necessary to convert a timestamp to “x days ago”:

```
export function daysAgo( params ) {
  var suppliedTimestamp = params[0];
  var suppliedDate = new Date(suppliedTimestamp);
  var currentDate = new Date();
  var timeDiff = Math.abs(suppliedDate.getTime() - currentDate.getTime());
  var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

  return diffDays + " days ago";
}
```

Now we have a function that returns what we want, so let’s use our helper to display our dates the way we want to:

In our `rental-template.hbs` we can find where we want our helper to be used.  The model supplied to this template will have a Unix timestamp as its date field.  We can see this by putting `model.date` into the template without the helper.  This gives us a `3287278327878` which is the raw timestamp. Now let’s replace `model.date` with `{{days-ago model.date}}`  Now our date is displaying the way we want it to, and since we’re using a helper to do so, we have this convenience available to us in any template in our project.
