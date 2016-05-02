As they search for a rental, users might also want to narrow their search to a specific city. Let's build a component that will let them search for properties within a city, and also suggest cities to them as they type.

To begin, let's generate our new component. We'll call this component `filter-listing`.

```shell
ember g component filter-listing
```

As before, this creates a Handlebars template (`app/templates/components/filter-listing.hbs`) and a JavaScript file (`app/components/filter-listing.js`).

O template Handlebars parece com isso:

```app/templates/components/filter-listing.hbs City: {{input value=filter key-up=(action autoComplete filter)}}

<button {{action search filter}}>Search</button>

{{#each filteredList as |item|}} <li {{action 'choose' item.city}}>{{item.city}}</li> {{/each}} 

    <br />The template contains an [`{{input}}`](../../templates/input-helpers)
    helper that renders as a text field, in which the user can type a pattern
    to filter the list of cities used in a search. A propriedade `value` do `input` vai ser vinculada à propriedade do `filter` no nosso componente.
    The `key-up` property will be bound to the `autoComplete` action,
    passed in to the component from the `index` controller. The `autoComplete`
    action takes the `filter` property as the argument when invoked.
    
    The template also contains a button that is bound to the `search` action.
    Similar to the `autoComplete` action, the `search` action is passed in from
    the `index` controller and takes the `filter` property when invoked.
    
    Lastly, the `filter-listing.hbs` template contains an unordered list,
    that displays the `city` property of each item in the `filteredList`
    property in our component. Clicking the list item will fire the `choose`
    action with the `city` property of the item as a parameter, which will
    then populate the `input` field with the name of that `city`.
    
    Here is what the component's JavaScript looks like:
    
    ```app/components/filter-listing.js
    export default Ember.Component.extend({
      filter: null,
      filteredList: null,
    
      actions: {
        choose(city) {
          this.set('filter', city);
        }
      }
    });
    

There's a property for each of the `filter` and `filteredList`, and the `choose` action as described above.

Only the `choose` action is defined by the `filter-listing.js` component. Both the `autoComplete` and `search` actions are \[passed\] (../../components/triggering-changes-with-actions/#toc_passing-the-action-to-the-component) in by the calling object. This is a pattern known as *closure actions*.

To see how this works, change your `index.hbs` template to look like this:

```app/templates/index.hbs 

# Welcome to Super Rentals 

We hope you find exactly what you're looking for in a place to stay.   
  


{{filter-listing filteredList=filteredList autoComplete=(action 'autoComplete') search=(action 'search')}}

{{#each model as |rentalUnit|}} {{rental-listing rental=rentalUnit}} {{/each}}

{{#link-to 'about'}}About{{/link-to}} {{#link-to 'contact'}}Click here to contact us.{{/link-to}}

    <br />We've added the `filter-listing.js` component to our `index.hbs` template.
    We then pass in the functions and properties that we want the `filter-listing`
    component to use. The `index` page defines some of the logic for
    how the component should behave, and the component uses those specific
    functions and properties.
    
    For this to work, we need to introduce a `controller` into our app.
    Generate a controller for the `index` page by running the following:
    
    ```shell
    ember g controller index
    

Now, define your new controller like so:

```app/controllers/index.js import Ember from 'ember';

export default Ember.Controller.extend({ filteredList: null, actions: { autoComplete(param) { if (param !== '') { this.get('store').query('rental', { city: param }).then((result) => this.set('filteredList', result)); } else { this.set('filteredList', null); } }, search(param) { if (param !== '') { this.get('store').query('rental', { city: param }).then((result) => this.set('model', result)); } else { this.get('store').findAll('rental').then((result) => this.set('model', result)); } } } });

    <br />As you can see, we define a property in the controller called `filteredList`,
    that is referenced from within the `filter-listing.hbs` template.
    
    When the user types in the text field in our component, the `autoComplete`
    action in the controller is called. This action takes in the `filter`
    property, and filters the `rental` data for records in data store that match
    what the user has typed thus far. The result of the query is set as the
    `filteredList` property, which is used to populate the autocomplete list
    in the component.
    
    We also define a `search` action here that is passed in to the component,
    and called when the search button is clicked. This is slightly different
    in that the result of the query is actually used to update the `model`
    of the `index` route, and that changes the full rental listing on the
    page.
    
    For these actions to work, we need to modify the Mirage `config.js` file
    to look like this, so that it can respond to our queries.
    
    ```mirage/config.js
    export default function() {
      this.get('/rentals', function(db, request) {
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
        } else {
          return { data: rentals };
        }
      });
    }
    

With these changes, users can search for properties in a given city, with a search field that provides suggestions as they type.