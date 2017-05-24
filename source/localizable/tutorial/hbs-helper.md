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

export function rentalPropertyType(params/*, hash*/) {
  return params;
}

export default Ember.Helper.helper(rentalPropertyType);
```

Let's update our `rental-listing` component template to use our new helper and pass in `rental.propertyType`:

```app/templates/components/rental-listing.hbs{-11,+12,+13}
<article class="listing">
  <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
    <img src="{{rental.image}}" alt="">
    <small>View Larger</small>
  </a>
  <h3>{{rental.title}}</h3>
  <div class="detail owner">
    <span>Owner:</span> {{rental.owner}}
  </div>
  <div class="detail type">
    <span>Type:</span> {{rental.propertyType}}
    <span>Type:</span> {{rental-property-type rental.propertyType}}
      - {{rental.propertyType}}
  </div>
  <div class="detail location">
    <span>Location:</span> {{rental.city}}
  </div>
  <div class="detail bedrooms">
    <span>Number of bedrooms:</span> {{rental.bedrooms}}
  </div>
</article>
```

Ideally we'll see "Type: Standalone - Estate" for our first rental property.
Instead, our default template helper is returning back our `rental.propertyType` values.
Let's update our helper to look if a property exists in an array of `communityPropertyTypes`,
if so, we'll return either `'Community'` or `'Standalone'`:

```app/helpers/rental-property-type.js
import Ember from 'ember';

const communityPropertyTypes = [
  'Condo',
  'Townhouse',
  'Apartment'
];

export function rentalPropertyType([propertyType]) {
  if (communityPropertyTypes.includes(propertyType)) {
    return 'Community';
  }

  return 'Standalone';
}

export default Ember.Helper.helper(rentalPropertyType);
```

Each [argument](https://guides.emberjs.com/v2.12.0/templates/writing-helpers/#toc_helper-arguments) in the helper will be added to an array and passed to our helper. For example, `{{my-helper "foo" "bar"}}` would result in `myHelper(["foo", "bar"])`. Using array [ES2015 destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) assignment, we can name expected parameters within the array. In the example above, the first argument in the template will be assigned to `propertyType`. This provides a flexible, expressive interface for your helpers, including optional arguments and default values.

Now in our browser we should see that the first rental property is listed as "Standalone",
while the other two are listed as "Community".
