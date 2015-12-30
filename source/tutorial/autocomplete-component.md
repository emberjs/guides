As they search for a rental, a user might also want to narrow their search to a specific city. Let's build a component that will let them search for properties within a city, and also suggest cities to them as they type.

To begin, let's generate our new component. We'll call this component `filter-listing`.

```shell
ember g component filter-listing
```
As before, this creates a Handlebars template (`app\templates\components\filter-listing.hbs`) and a JavaScript file (`app\components\filter-listing.js`).

The Handlebars template looks like this:

```app\templates\components\filter-listing.hbs
City: {{input value=filter key-up=(action 'keyUp' filter)}} 
<button {{action 'click'}}>Search</button>

<ul>
{{#each filteredList as |item|}}
  <li {{action 'choose' item.city}}>{{item.city}}</li>
{{/each}}
</ul>
```
It contains an `input` component, that renders as a text field that the user can type in to look for properties in a given city. The `value` property of the `input` will be bound to the `filter` property in our backing JavaScript object. The `key-up` property will be bound to a `keyUp` action in our backing object, and passes the `filter` property as a parameter.

It also contains a button, whose `action` parameter is bound to the `click` action in our component.

Lastly, it contains an unordered list, that uses the `filteredList` property for data, and displays the `city` property of each item in the list. Clicking the list item will fire the `choose` action, which will populate the `input` field with the name of the `city` in the clicked list item.

Here is what the component's JavaScript looks like:

```app\components\filter-listing.js
import Ember from 'ember';

export default Ember.Component.extend({
  filter: null,
  filteredList: null,
  actions: {
    keyUp() {
      this.attrs.autoComplete(this.filter);
    },
    click() {
      this.attrs.search(this.filter);
    },
    choose(city) {
      this.set('filter',city);
    }
  }
});

```
There's a property for each of the `filter` and `filteredList`, and actions as described above. What's interesting is that only the `choose` action is defined by the component. The actual logic of each of the `keyUp` and `click` actions are pulled from the component's `attrs` object, which means that those actions need to be passed in by the calling object, a pattern known as _closure actions_.

To see how this works, change your `index.hbs` template to look like this:

```app\templates\index.hbs
<h1>Welcome to Super Rentals</h1>

We hope you find exactly what you're looking for in a place to stay.
<br /><br />
{{filter-listing filteredList=filteredList 
autoComplete=(action 'autoComplete') search=(action 'search')}}
{{#each model as |rental-unit|}}
  {{rental-listing rental=rental-unit}}
{{/each}}

{{#link-to 'about'}}About{{/link-to}}
{{#link-to 'contact'}}Click here to contact us.{{/link-to}}
```
We've added the `filter-listing` component to our `index.hbs` template. We then pass in the functions and properties we want the `filter-listing` component to use, so that the `index` page can define some of how it wants the component to behave, and so the component can have some narrowly-defined access to aspects of the calling scope.

For this to work, we need to introduce a `controller` into our app. Generate a controller for the `index` page by running the following:

```shell
ember g controller index
```

Now, define your new controller like so:

```app\controllers\index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  filteredList: null,
  actions: {
    autoComplete(param) {
      if(param !== undefined && param !== "") {
        let result = this.store.query('rental', {city: param});
        this.set('filteredList',result);
      }
      else
        this.set('filteredList',null);
    },
    search(param) {
      if(param !== undefined && param !== "") {
        let result = this.store.query('rental', {city: param});
        this.set('model',result);
      }
      else
        this.set('model',null);
    }
  }
});

```

As you can see, we define a property in the controller called `filteredList`, that is referenced from within the `autoComplete` action. When the user types in the text field in our component, this is the action that is called. This action filters the `rental` data to look for records in data that match what the user has typed thus far. When this action is executed, the result of the query is placed in the `filteredList` property, which is used to populate the autocomplete list in the component.

We also define a `search` action here that is passed in to the component, and called when the search button is clicked. This is slightly different in that the result of the query is actually used to update the `model` of the `index` route, and that changes the full rental listing on the page.

For these actions to work, we need to modify the Mirage `config.js` file to look like this, so that it can respond to our queries.

```app\mirage\config.js
export default function() {
  this.get('/rentals', function(db,request) {
    let rentals = [{
        type: 'rentals',
        id: 1,
        attributes: {
          title: 'Grand Old Mansion',
          owner: 'Veruca Salt',
          city: 'San Francisco',
          type: 'Estate',
          bedrooms: 15,
          image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg'
        }
      }, {
        type: 'rentals',
        id: 2,
        attributes: {
          title: 'Urban Living',
          owner: 'Mike Teavee',
          city: 'Seattle',
          type: 'Condo',
          bedrooms: 1,
          image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg'
        }
      }, {
        type: 'rentals',
        id: 3,
        attributes: {
          title: 'Downtown Charm',
          owner: 'Violet Beauregarde',
          city: 'Portland',
          type: 'Apartment',
          bedrooms: 3,
          image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg'
        }
      }];

    if(request.queryParams.city !== undefined) {
      let filteredRentals = rentals.filter(function(i) {
        return i.attributes.city.toLowerCase().indexOf(request.queryParams.city.toLowerCase()) !== -1;
      });
      return { data: filteredRentals };
    }
    else {
      return { data: rentals };
    }
  });
}
```

With these changes, users can search for properties in a given city, with a search field that provides suggestions as they type.


