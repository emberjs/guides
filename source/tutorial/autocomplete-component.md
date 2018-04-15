As they search for a rental, users might also want to narrow their search to a specific city.
While our [initial](../simple-component/) rental listing component only displayed rental information, this new filter component will also allow the user to provide input in the form of filter criteria.

To begin, let's generate our new component.
We'll call this component `list-filter`, since all we want our component to do is filter the list of rentals based on input.

```shell
ember g component list-filter
```

As before when we created the [`rental-listing` component](../simple-component), the "generate component" CLI command creates

* a Handlebars template (`app/templates/components/list-filter.hbs`),
* a JavaScript file (`app/components/list-filter.js`),
* and a component integration test (`tests/integration/components/list-filter-test.js`).

#### Providing Markup to a Component

In our `app/templates/rentals.hbs` template file, we'll add a reference to our new `list-filter` component.

Notice that below we "wrap" our rentals markup inside the open and closing mentions of `list-filter` on lines 12 and 20.
This is an example of the [**block form**](../../components/wrapping-content-in-a-component) of a component,
which allows a Handlebars template to be rendered _inside_ the component's template wherever the `{{yield}}` expression appears.

In this case we are passing, or "yielding", our filter data to the inner markup as a variable called `filteredResults` (line 14).

```app/templates/rentals.hbs{+12,+13,+14,+15,+16,+17,+18,+19,+20,-21,-22,-23}
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>Welcome!</h2>
  <p>
    We hope you find exactly what you're looking for in a place to stay.
  </p>
  {{#link-to "about" class="button"}}
    About Us
  {{/link-to}}
</div>

{{#list-filter
   filter=(action 'filterByCity')
   as |filteredResults|}}
  <ul class="results">
    {{#each filteredResults as |rentalUnit|}}
      <li>{{rental-listing rental=rentalUnit}}</li>
    {{/each}}
  </ul>
{{/list-filter}}
{{#each model as |rentalUnit|}}
  {{rental-listing rental=rentalUnit}}
{{/each}}
```

#### Accepting Input to a Component

We want the component to simply provide an input field and yield the results list to its block, so our template will be simple:

```app/templates/components/list-filter.hbs
{{input value=value
        key-up=(action 'handleFilterEntry')
        class="light"
        placeholder="Filter By City"}}
{{yield results}}
```

The template contains an [`{{input}}`](../../templates/input-helpers) helper that renders as a text field, in which the user can type a pattern to filter the list of cities used in a search.
The `value` property of the `input` will be kept in sync with the `value` property in the component.

Another way to say this is that the `value` property of `input` is [**bound**](../../object-model/bindings/) to the `value` property of the component.
If the property changes, either by the user typing in the input field, or by assigning a new value to it in our program,
the new value of the property is present in both the rendered web page and in the code.

The `key-up` property will be bound to the `handleFilterEntry` action.

The `handleFilterEntry` action will apply the search term filter to the list of rentals, and set a component attribute called `results`. The `results` are passed to the `{{yield}}` helper in the template. In the yielded block component, those same `results` are referred to as `|filteredResults|`. Let's apply the filter to our rentals:

```app/components/list-filter.js
import Component from '@ember/component';

export default Component.extend({
  classNames: ['list-filter'],
  value: '',

  init() {
    this._super(...arguments);
    this.get('filter')('').then((results) => this.set('results', results));
  },

  actions: {
    handleFilterEntry() {
      let filterInputValue = this.get('value');
      let filterAction = this.get('filter');
      filterAction(filterInputValue).then((filterResults) => this.set('results', filterResults));
    }
  }

});
```

#### Filtering Data Based on Input

In the above example we use the `init` hook to seed our initial listings by calling the `filter` action with an empty value.
Our `handleFilterEntry` action calls a function called `filter` based on the `value` attribute set by the input helper.

The `filter` function is passed in by the calling object. This is a pattern known as [closure actions](../../components/triggering-changes-with-actions/#toc_passing-the-action-to-the-component).

Notice the `then` function called on the result of calling the `filter` function.
The code expects the `filter` function to return a promise.
A [promise](https://www.emberjs.com/api/ember/release/classes/Promise) is a JavaScript object that represents the result of an asynchronous function.
A promise may or may not be executed at the time you receive it.
To account for this, it provides functions, like `then` that let you give it code it will run when it eventually does receive a result.


To implement the `filter` function to do the actual filter of rentals by city, we'll create a `rentals` controller.
[Controllers](../../controllers/) contain actions and properties available to the template of its corresponding route.
In our case we want to generate a controller called `rentals`.
Ember will know that a controller with the name of `rentals` will apply to the route with the same name.

Generate a controller for the `rentals` route by running the following:

```shell
ember g controller rentals
```

Now, define your new controller like so:

```app/controllers/rentals.js
import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    filterByCity(param) {
      if (param !== '') {
        return this.get('store').query('rental', { city: param });
      } else {
        return this.get('store').findAll('rental');
      }
    }
  }
});
```

When the user types in the text field in our component, the `filterByCity` action in the controller is called.
This action takes in the `value` property, and filters the `rental` data for records in data store that match what the user has typed thus far.
The result of the query is returned to the caller.

#### Faking Query Results

For this action to work, we need to replace our Mirage `config.js` file with the following, so that it can respond to our queries.
Instead of simply returning the list of rentals, our Mirage HTTP GET handler for `rentals` will return rentals matching the string provided in the URL query parameter called `city`.

```mirage/config.js{+4,-5,-6,-7,-44,-45,+47,+48,+49,+50,+51,+52,+53,+54,+55,+56,+57}
export default function() {
  this.namespace = '/api';

  let rentals = [{
  this.get('/rentals', function() {
    return {
      data: [{
      type: 'rentals',
      id: 'grand-old-mansion',
      attributes: {
        title: 'Grand Old Mansion',
        owner: 'Veruca Salt',
        city: 'San Francisco',
        category: 'Estate',
        bedrooms: 15,
        image: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg',
        description: "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests."
      }
    }, {
      type: 'rentals',
      id: 'urban-living',
      attributes: {
        title: 'Urban Living',
        owner: 'Mike Teavee',
        city: 'Seattle',
        category: 'Condo',
        bedrooms: 1,
        image: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg',
        description: "A commuters dream. This rental is within walking distance of 2 bus stops and the Metro."
      }
    }, {
      type: 'rentals',
      id: 'downtown-charm',
      attributes: {
        title: 'Downtown Charm',
        owner: 'Violet Beauregarde',
        city: 'Portland',
        category: 'Apartment',
        bedrooms: 3,
        image: 'https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg',
        description: "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet."
      }
    }];
  };
});

  this.get('/rentals', function(db, request) {
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
```

After updating our mirage configuration, we should see a simple filter on the home screen that will update the rental list as you type:

![home screen with filter component](../../images/autocomplete-component/styled-super-rentals-filter.png)

#### Handling Results Coming Back at Different Times

In our example, you might notice that if you type quickly that the results might get out of sync with the current filter text entered.
This is because our data filtering function is _asynchronous_, meaning that the code in the function gets scheduled for later, while the code that calls the function continues to execute.
Often code that may make network requests is set up to be asynchronous because the server may return its responses at varying times.

Lets add some protective code to ensure our results do not get out of sync with our filter input.
To do this we'll simply provide the filter text to the filter function, so that when the results come back we can compare the original filter value with the current filter value.
We will update the results on screen only if the original filter value and the current filter value are the same.

```app/controllers/rentals.js{-7,+8,+9,+10,+11,-13,+14,+15,+16,+17}
import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    filterByCity(param) {
      if (param !== '') {
        return this.get('store').query('rental', { city: param });
        return this.get('store')
          .query('rental', { city: param }).then((results) => {
            return { query: param, results: results };
          });
      } else {
        return this.get('store').findAll('rental');
        return this.get('store')
          .findAll('rental').then((results) => {
            return { query: param, results: results };
          });
      }
    }
  }
});
```

In the `filterByCity` function in the rentals controller above,
we've added a new property called `query` to the filter results instead of just returning an array of rentals as before.

```app/components/list-filter.js{-19,-9,+10,+11,+12,+20,+21,+22,+23,+24}
import Component from '@ember/component';

export default Component.extend({
  classNames: ['list-filter'],
  value: '',

  init() {
    this._super(...arguments);
    this.get('filter')('').then((results) => this.set('results', results));
    this.get('filter')('').then((allResults) => {
      this.set('results', allResults.results);
    });
  },

  actions: {
    handleFilterEntry() {
      let filterInputValue = this.get('value');
      let filterAction = this.get('filter');
      filterAction(filterInputValue).then((filterResults) => this.set('results', filterResults));
      filterAction(filterInputValue).then((filterResults) => {
        if (filterResults.query === this.get('value')) {
          this.set('results', filterResults.results);
        }
      });
    }
  }

});
```

In our list filter component JavaScript, we use the `query` property to compare to the `value` property of the component.
The `value` property represents the latest state of the input field.
Therefore we now check that results match the input field, ensuring that results will stay in sync with the last thing the user has typed.

While this approach will keep our results order consistent, there are other things to consider when dealing with multiple concurrent tasks,
such as [limiting the number of requests made to the server](https://www.emberjs.com/api/ember/release/classes/@ember%2Frunloop/methods/debounce?anchor=debounce).
To create effective and robust autocomplete behavior for your applications,
we recommend considering the [`ember-concurrency`](http://ember-concurrency.com/#/docs/introduction) addon project.


You can now proceed on to implement the [next feature](../service/), or continue on to test our newly created filter component.

### An Integration Test

Now that we've created a new component for filtering a list,
we want to create a test to verify it.
Let's use a [component integration test](../../testing/testing-components)
to verify our component behavior,
similar to [how we tested our rental listing component earlier](../simple-component/#toc_an-integration-test).

Lets begin by opening the component integration test created when we generated our `list-filter` component, `tests/integration/components/list-filter-test.js`.
Remove the default test, and create a new test that verifies that by default, the component will list all items.

```tests/integration/components/list-filter-test.js{+9,+10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28}
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | rental-listing', function(hooks) {
  setupRenderingTest(hooks);

  test('should initially load all listings', function (assert) {
  });

  test('it renders', async function(assert) {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.set('myAction', function(val) { ... });

    await render(hbs`{{rental-listing}}`);

    assert.equal(this.element.textContent.trim(), '');

    // Template block usage:
    await render(hbs`
      {{#rental-listing}}
        template block text
      {{/rental-listing}}
    `);

    assert.equal(this.element.textContent.trim(), 'template block text');
  });

});
```

Our list-filter component takes a function as an argument, used to find the list of matching rentals based on the filter string provided by the user.

```tests/integration/components/list-filter-test.js{+5,+7,+8,+14,+15,+16,+17,+18}
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import { resolve } from 'rsvp';

const ITEMS = [{city: 'San Francisco'}, {city: 'Portland'}, {city: 'Seattle'}];
const FILTERED_ITEMS = [{city: 'San Francisco'}];

module('Integration | Component | rental-listing', function(hooks) {
  setupRenderingTest(hooks);

  test('should initially load all listings', async function (assert) {
    // we want our actions to return promises,
    //since they are potentially fetching data asynchronously
    this.set('filterByCity', () => resolve({ results: ITEMS }));
  });

});
```

Calling `this.set` on `filterByCity` will add the provided function to the test local scope.

Our `filterByCity` function is going to pretend to be the action function for our component, that does the actual filtering of the rental list.

We are not testing the actual filtering of rentals in this test, since it is focused on only the capability of the component.
We will test the full logic of filtering in application tests, described in the next section.

Since our component is expecting the filter process to be asynchronous, we return promises from our filter, using [Ember's RSVP library](https://www.emberjs.com/api/ember/release/modules/rsvp).

Next, we'll add the call to render the component to show the cities we've provided above.

```tests/integration/components/list-filter-test.js{+20,+21,+22,+23,+24,+25,+26,+27,+28,+29,+30,+31,+32,+33}
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import { resolve } from 'rsvp';

const ITEMS = [{city: 'San Francisco'}, {city: 'Portland'}, {city: 'Seattle'}];
const FILTERED_ITEMS = [{city: 'San Francisco'}];

module('Integration | Component | rental-listing', function(hooks) {
  setupRenderingTest(hooks);

  test('should initially load all listings', async function (assert) {
    // we want our actions to return promises,
    //since they are potentially fetching data asynchronously
    this.set('filterByCity', () => resolve({ results: ITEMS }));

    // with an integration test,
    // you can set up and use your component in the same way your application
    // will use it.
    await render(hbs`
      {{#list-filter filter=(action filterByCity) as |results|}}
        <ul>
        {{#each results as |item|}}
          <li class="city">
            {{item.city}}
          </li>
        {{/each}}
        </ul>
      {{/list-filter}}
    `);

  });

});
```

Finally we add a `settled` call at the end of our test to assert the results.

Ember's [settled helper](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#settled)
waits for all asynchronous tasks to complete before running the given function callback.
It returns a promise that we also return from the test.

If you return a promise from a QUnit test, the test will wait to finish until that promise is resolved.
In this case our test completes when the `settled` helper decides that processing is finished,
and the function we provide that asserts the resulting state is completed.

```tests/integration/components/list-filter-test.js{+3,+31,+32,+33,+34}
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, settled } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import { resolve } from 'rsvp';

const ITEMS = [{city: 'San Francisco'}, {city: 'Portland'}, {city: 'Seattle'}];
const FILTERED_ITEMS = [{city: 'San Francisco'}];

module('Integration | Component | rental-listing', function(hooks) {
  setupRenderingTest(hooks);

  test('should initially load all listings', async function (assert) {
    // we want our actions to return promises, since they are potentially fetching data asynchronously
    this.set('filterByCity', () => resolve({ results: ITEMS }));

    // with an integration test,
    // you can set up and use your component in the same way your application will use it.
    await render(hbs`
      {{#list-filter filter=(action filterByCity) as |results|}}
        <ul>
        {{#each results as |item|}}
          <li class="city">
            {{item.city}}
          </li>
        {{/each}}
        </ul>
      {{/list-filter}}
    `);

    return settled().then(() => {
      assert.equal(this.element.querySelectorAll('.city').length, 3);
      assert.equal(this.element.querySelector('.city').textContent.trim(), 'San Francisco');
    });
  });

});
```

For our second test, we'll check that typing text in the filter will actually appropriately call the filter action and update the listings shown.

We'll add some additional functionality to our `filterByCity` action to additionally return a single rental,
represented by the variable `FILTERED_ITEMS` when any value is set.

We force the action by generating a `keyUp` event on our input field, and then assert that only one item is rendered.

First add `triggerKeyEvent` and `fillIn` to the list of imports.  The [`fillIn`](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#fillin) helper simulates the user filling in the element. The [`triggerKeyEvent`](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#triggerkeyevent) helper sends a key stroke event to the UI, simulating the user typing a key.

```tests/integration/components/list-filter-test.js
import { render, settled, triggerKeyEvent, fillIn } from '@ember/test-helpers';
```

Now use it to simulate the user typing a key into the search field.

```tests/integration/components/list-filter-test.js{+27}
test('should update with matching listings', async function (assert) {
  this.set('filterByCity', (val) =>  {
    if (val === '') {
      return resolve({
        query: val,
        results: ITEMS });
    } else {
      return resolve({
        query: val,
        results: FILTERED_ITEMS });
    }
  });

  await render(hbs`
    {{#list-filter filter=(action filterByCity) as |results|}}
      <ul>
      {{#each results as |item|}}
        <li class="city">
          {{item.city}}
        </li>
      {{/each}}
      </ul>
    {{/list-filter}}
  `);

  // filling in the component's input field with 's'
  await fillIn(this.element.querySelector('.list-filter input'),'s');
  // The keyup event here should invoke an action that will cause the list to be filtered
  await triggerKeyEvent(this.element.querySelector('.list-filter input'), "keyup", 83);

  return settled().then(() => {
    assert.equal(this.element.querySelectorAll('.city').length, 1, 'One result returned');
    assert.equal(this.element.querySelector('.city').textContent.trim(), 'San Francisco');
  });
});

```
Now both integration test scenarios should pass.
You can verify this by starting up our test suite by typing `ember t -s` at the command line.

### Application Tests

Now that we've tested that the `list-filter` component behaves as expected, let's test that the page itself also behaves properly with an application test.
We'll verify that a user visiting the rentals page can enter text into the search field and narrow the list of rentals by city.

Open our existing application test, `tests/acceptance/list-rentals-test.js`, and implement the test labeled "should filter the list of rentals by city".


```/tests/acceptance/list-rentals-test.js
test('should filter the list of rentals by city', async function(assert) {
  await visit('/');
  await fillIn('.list-filter input', 'seattle');
  await triggerKeyEvent('.list-filter input', 'keyup', 69);
  assert.equal(this.element.querySelectorAll('.results .listing').length, 1, 'should display 1 listing');
  assert.ok(this.element.querySelector('.listing .location').textContent.includes('Seattle'), 'should contain 1 listing with location Seattle');
});
```

Notice we introduce a new helper into this test, `fillIn`.

* The [`fillIn`](https://github.com/emberjs/ember-test-helpers/blob/master/API.md#fillin) helper "fills in" the given text into an input field matching the given selector.

Let's not forget to add these two helpers to our list of imports.

```/tests/acceptance/list-rentals-test.js{+5,+6}
import {
  click,
  currentURL,
  visit,
  fillIn,
  triggerKeyEvent
} from '@ember/test-helpers'
```

In `app/components/list-filter.js`, we have as the top-level element rendered by the component a class called `list-filter`.
We locate the search input within the component using the selector `.list-filter input`,
since we know that there is only one input element located in the list-filter component.

Our test fills out "Seattle" as the search criteria in the search field,
and then sends a `keyup` event to the same field with a code of `69` (the `e` key) to simulate a user typing, which is the event our code is looking for.

In the case of our code the key code sent can be anything, since we read the value of the input field, and not the key events coming in.
We only use the key event to let our code know that its time to make a search.

The test locates the results of the search by finding elements with a class of `listing`,
which we gave to our `rental-listing` component in the ["Building a Simple Component"](../simple-component) section of the tutorial.

Since our data is hard-coded in Mirage, we know that there is only one rental with a city name of "Seattle",
so we assert that the number of listings is one and that the location it displays is named, "Seattle".

The test verifies that after filling in the search input with "Seattle", the rental list reduces from 3 to 1,
and the item displayed shows "Seattle" as the location.

You should be down to only 2 failing tests: One remaining application test failure; and our ESLint test that fails on an unused assert for our unimplemented test.

![passing application tests](../../images/autocomplete-component/passing-acceptance-tests.png)
