So far, our app is directly showing the user data from our Ember Data models.
As our app grows, we will want to manipulate data further before presenting it to our users.
For this reason, Ember offers Handlebars template helpers to decorate the data in our templates.
Let's use a handlebars helper to allow our users to quickly see if a property is "standalone" or part of a "Community".

To get started, let's generate a helper for `rental-property-type`:

```shell
ember g helper rental-property-type
```

This will create two files, our helper and its related test:

```shell
installing helper
  create app/helpers/rental-property-type.js
installing helper-test
  create tests/unit/helpers/rental-property-type-test.js
```

Our new helper starts out with some boilerplate code from the generator:

```app/helpers/rental-property-type.js
import Ember from 'ember';

export function rentalGroup(params/*, hash*/) {
  return params;
}

export default Ember.Helper.helper(rentalGroup);
```

Let's update our `rental-listing` component template to use our new helper and pass in `rental.type`:

```app/templates/components/rental-listing.hbs
<h2>{{rental.title}}</h2>
<p>Owner: {{rental.owner}}</p>
<p>Type: {{rental-property-type rental.type}} - {{rental.type}}</p>
<p>Location: {{rental.city}}</p>
<p>Number of bedrooms: {{rental.bedrooms}}</p>
{{#if isImageShowing }}
  <p><img src={{rental.image}} alt={{rental.type}} width="500px"></p>
  <button {{action "imageHide"}}>Hide image</button>
{{else}}
  <button {{action "imageShow"}}>Show image</button>
{{/if}}
```

Ideally we'll see "Type: Standalone - Estate" for our first rental property.
Instead, our default template helper is returning back our `rental.type` values.
Let's update our helper to look if a property exists in an array of `communityPropertyTypes`,
if so, we'll return either `'Community'` or `'Standalone'`:

```app/helpers/rental-property-type.js
import Ember from 'ember';

const communityPropertyTypes = [
  'Condo',
  'Townhouse',
  'Apartment'
];

export function rentalGroup([type]/*, hash*/) {
  if (communityPropertyTypes.contains(type)) {
    return 'Community';
  }

  return 'Standalone';
}

export default Ember.Helper.helper(rentalGroup);
```

Handlebars passes an array of arguments from our template to our helper.
We are using ES2015 destructuring to get the first item in the array and name it `type`.
Then we can check to see if `type` exists in our `communityPropertyTypes` array.

Now in our browser we should see that the first rental property is listed as "Standalone",
while the other two are listed as "Community".
