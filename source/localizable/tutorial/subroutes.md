In addition to displaying a list of rentals, we want to show detailed information for individual rentals.
To do this, we can generate `rentals` route to display all rentals and a `show` sub-route to display additional information.

# A Parent Route

To begin, let's generate our new route.
We'll call this `rentals`, since it will list all of our current rental properties.

```shell
ember g route rentals
```

You will see output like this:

```text
installing route
  create app/routes/rentals.js
  create app/templates/rentals.hbs
updating router
  add route rentals
installing route-test
  create tests/unit/routes/rentals-test.js
```

If it is unclear what Ember is doing for us here, visit the [Routes and Templates tutorial](../routes-and-templates) for more information.

Let's start by opening our new Handlebars template (`app/templates/rentals.hbs`).
Ember generates route-level templates files with an `outlet`.

```app/templates/rentals.hbs
{{outlet}}
```

Much like our application template (`app/templates/application.hbs`), the `outlet` is where our sub-routes will render.
This means that any content on our parent route will be present as we browse down through our child routes, allowing us to add things like navigation, footers or sidebars.
Let's start by adding a welcome header and link to our About page (`app/templates/about.hbs`).

```app/templates/rentals.hbs
<div class="jumbo">
  <div class="right tomster"></div>
  <h2>Welcome!</h2>
  <p>
    We hope you find exactly what you're looking for in a place to stay.
  </p>
  {{#link-to 'about' class="button"}}
    About Us
  {{/link-to}}
</div>

{{outlet}}
```

Run `ember serve` (or `ember s` for short) from the shell to start the Ember development server,
and then go to `localhost:4200/rentals` to see our new app in action!

# Creating a Sub-route

Next, we will want to create a sub-route that will list information for a specific rental.
To do this, we will need to update a couple of files.
To find a specific rental, we will want to use Ember Data's `queryRecord` function [(see "Finding Records" for more details)](../../models/finding-records/).
The `queryRecord` function requires that we search by a unique key.
Many APIs return a `slug`, which is a URL-friendly string to identify a record.

While on the `show` route, we will also want to show additional information about our specific rental.

In order to do this, we need to modify the Mirage `config.js` file.
If you need a refresher on how Mirage works, go back to the [Installing Addons section](../installing-addons)
We will add a `slug` and `description` to our rentals array.

```mirage/config.js{+14,+15,+28,+29,+42,+43,+53,+54,+55,+56,+57}
export default function() {
  this.get('/rentals', function(db, request) {
    let rentals = [
      {
        type: 'rentals',
        id: 1,
        attributes: {
          "title": "Grand Old Mansion",
          "owner": "Veruca Salt",
          "city": "San Francisco",
          "type": "Estate",
          "bedrooms": 15,
          "image": "https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg",
          "slug": "grand-old-mansion",
          "description": "This grand old mansion sits on over 100 acres of rolling hills and dense redwood forests."
        }
      },
      {
        type: 'rentals',
        "id": 2,
        attributes: {
          "title": "Urban Living",
          "owner": "Mike Teavee",
          "city": "Seattle",
          "type": "Condo",
          "bedrooms": 1,
          "image": "https://upload.wikimedia.org/wikipedia/commons/0/0e/Alfonso_13_Highrise_Tegucigalpa.jpg",
          "slug": "urban-living",
          "description": "A commuters dream. This rental is within walking distance of 2 bus stops and the Metro."
        }
      },
      {
        type: 'rentals',
        "id": 3,
        attributes: {
          "title": "Downtown Charm",
          "owner": "Violet Beauregarde",
          "city": "Portland",
          "type": "Apartment",
          "bedrooms": 3,
          "image": "https://upload.wikimedia.org/wikipedia/commons/f/f7/Wheeldon_Apartment_Building_-_Portland_Oregon.jpg",
          "slug": "downtown-charm",
          "description": "Convenience is at your doorstep with this charming downtown rental. Great restaurants and active night life are within a few feet."
        }
      }
    ];

    if (request.queryParams.city !== undefined) {
      let filteredRentals = rentals.filter(function (i) {
        return i.attributes.city.toLowerCase().indexOf(request.queryParams.city.toLowerCase()) !== -1;
      });
      return { data: filteredRentals };
    } else if (request.queryParams.slug !== undefined) {
      const selectedRental = rentals.find(function(rental) {
       return rental.attributes.slug === request.queryParams.slug;
      });
      return { data: selectedRental };
    } else {
      return { data: rentals };
    }
  });
}
```

Let's quickly highlight the change made to the bottom, where we return our rental.

```mirage/config.js
else if (request.queryParams.slug !== undefined) {
  const selectedRental = rentals.find(function(rental) {
   return rental.attributes.slug === request.queryParams.slug;
  });
  return { data: selectedRental };
}
```

Our `show` sub-route only expects to show one rental.
This is why we will use `queryRecord` instead of `query` as we expect a single response.
This means that we cannot return an array (like we do with a normal get response to our Mirage file).
We search all of our rentals until we find the one that matches the slug passed in our `queryParams`.

Since our API is now returning two additional fields, we need to update our `rentals` model, so we can access them in our application.

```app/models/rental.js
export default DS.Model.extend({
  title: DS.attr(),
  owner: DS.attr(),
  city: DS.attr(),
  type: DS.attr(),
  image: DS.attr(),
  bedrooms: DS.attr(),
  slug: DS.attr(),
  description: DS.attr()
});
```

# Generating a Show Route

Now that our API is ready to return single records, we can generate our `show` sub-route.
Much like generating our `rentals` route, we will use `ember g` to create a nested route.

```shell
ember g route rentals/show
```

You will see output like this:

```shell
installing route
  create app/routes/rentals/show.js
  create app/templates/rentals/show.hbs
updating router
  add route rentals/show
installing route-test
  create tests/unit/routes/rentals/show-test.js
```

Let's start by looking at the changes to our Router (`app/router.js`).

```app/router.js
Router.map(function() {
  this.route('about');
  this.route('contact');
  this.route('rentals', function() {
    this.route('show');
  });
});
```

You will notice that `this.route('show')` is nested within our `rentals` route.
This tells Ember that it is a sub-route and must be accessed through `localhost:4200/rentals/show`.

In order for us to tell the application which rental we want to access, we need to pass the `slug` to our `show` route.
In addition, we will want to simplify the URL for the user so that they can access the information for a specific rental by browsing to `localhost:4200/rentals/slug-for-rental`.
To do this, we modify our router.

```app/router.js
Router.map(function() {
  this.route('about');
  this.route('contact');
  this.route('rentals', function() {
    this.route('show', { path: '/:slug' });
  });
});
```

We have modified the `path` for the `show` route.
It no longer defaults to `/rentals/show` but instead `/rentals/:slug`.
This means we can now access the `slug` on the route itself.

# Querying by Slug

Next, we will want to edit our `show` route to return the specific rental we want.

```app/routes/rentals/show.js
export default Ember.Route.extend({
  model(params) {
    return this.store.queryRecord('rental', { slug: params.slug });
  }
});
```

Since we added `:slug` to the `show` path in our router, we can now access `slug` through the `params` in our `model` hook.
When we call `this.get('store').queryRecord('rental', { slug: params.slug })`, Ember Data will make a GET request to `/rentals?slug=our-slug`.
You can read more about Ember Data in the [Models section](../../models/).

To ensure this, we should write a unit test that confirms `queryRecord` is called with the correct parameters.
Let's edit the unit test that Ember created for us when we generated our `show` route.

This means that we can access a specific rental as `model` on our template.

```tests/unit/routes/rentals/show-test.js
moduleFor('route:rentals/show', 'Unit | Route | rentals/show', {});

test('should query for selected rental by slug', function(assert) {
  let store = {
    queryRecord(path, options) {
      assert.equal(path, 'rental', 'queryRecord calls rental path on API');
      assert.deepEqual(options, { slug: 'rental-thing' });
    }
  };
  let route = this.subject({ store });
  route.model({ slug: 'rental-thing' });
});
```

In our route we call `this.store.queryRecord` and pass our `slug` to query our API appropriately.
To test this, we must stub `store.queryRecord` and pass it to our route.
First we create a fake `store` object with a `queryRecord` function.

```js
let store = {
  queryRecord(path, options) {
    assert.equal(path, 'rental', 'queryRecord calls rental path on API');
    assert.deepEqual(options, { slug: 'rental-thing' });
  }
};
```

Instead of making an AJAX request (the default behavior of `queryRecord`), we want to assert that the correct parameters are present.
Secondly, we want to pass this stubbed object to our route.
This is possible by passing a hash with our object in `this.subject`, a method available to us because of `moduleFor`.

```js
let route = this.subject({ store });
```

Finally, we call the `model` function directly, which will trigger the assertions we wrote on our stubbed `store` object.

```js
route.model({ slug: 'rental-thing' });
```

# Adding the Rental To Our Template

Next, we can update the template for our show route (`app/templates/rentals/show.hbs`) and list the information for our rental.

```app/templates/rentals/show.hbs
<div class="jumbo">
  <a href="#" class="button right up-11">Edit</a>
  <h2 style="margin-bottom:15px">{{model.title}}</h2>
  <div class="right" style="width:50%;padding-left:30px">
    <div class="map right" style="background: url({{model.address}}) center center;"></div>
    <div class="detail" style="margin-top:10px">
      <strong>Owner:</strong> {{model.owner}}
    </div>
    <div class="detail">
      <strong>Type:</strong> {{rental-property-type model.type}} - {{model.type}}
    </div>
    <div class="detail">
      <strong>Location:</strong> {{model.city}}
    </div>
    <div class="detail">
      <strong>Number of bedrooms:</strong> {{model.bedrooms}}
    </div>
    <p>&nbsp;</p>
    <p>{{model.description}}</p>
  </div>
  <img src="{{model.image}}" alt="" class="" style="width:50%;height:initial;position:static">
</div>
```

We pass our `model` to the `rental-listing` component and add a new section listing the rental's `title`.
Browse to `localhost:4200/rentals/grand-old-mansion` and you should see the information listed for that specific rental.

# Adding an Index Sub-route

One of the first things you may notice is that if you browse directly to `localhost:4200/rentals`,
all we see are the items from our parent route (`app/template/rentals.hbs`).
This is because we do not have an `index` sub-route.
Much like how our application defaults to the `index` route,
our `rentals` route defaults to `index` and tries to render it in our `outlet`.

We will want to generate an `index` route and use it to list all of our rentals and allow the user to select one to view additional information.

```shell
ember g route rentals/index
```

If you open up your Router (`app/router`) you may notice that nothing has updated.

```app/router.js
Router.map(function() {
  this.route('about');
  this.route('contact');
  this.route('rentals', function() {
    this.route('show', { path: '/:slug' });
  });
});
```

Much like how our applications `index` route doesn't appear in our Router, `index` routes on sub-routes won't explicitly appear in the Router either.
Ember knows that the default action is to take the user to the `index` route.
However, you can modify the `index` route if needed.
For example, you can modify the `path` much like we do with our `show` route by adding `this.route('index', { path: '/custom-path'})`.

Next, let's modify the our `index` route.

```app/routes/rentals/index.js
export default Ember.Route.extend({
  model() {
    return this.store.findAll('rental');
  }
});
```

This will return all of our rentals.
Let's list all of our rentals on our template (`app/templates/rentals/index.hbs`).

```app/templates/rentals/index.hbs
<ul class="results">
  {{#each model as |rentalUnit|}}
    {{rental-listing rental=rentalUnit}}
  {{/each}}
</ul>
```

Here we iterate over all of the items in our model, passing each rental to the `rental-listing` component.
However, we still want to redirect users to the new `show` route that we created.
We can do this by editing the `title` in our component, making it a link.

```app/templates/components/rental-listing.hbs{+6}
<article class="listing">
  <a {{action 'toggleImageSize'}} class="image {{if isWide "wide"}}">
    <img src="{{rental.image}}" alt="">
    <small>View Larger</small>
  </a>
  <h3>{{link-to rental.title "rentals.show" rental.slug}}</h3>
  <div class="detail owner">
    <span>Owner:</span> {{rental.owner}}
  </div>
  <div class="detail type">
    <span>Type:</span> {{rental-property-type rental.type}} - {{rental.type}}
  </div>
  <div class="detail location">
    <span>Location:</span> {{rental.city}}
  </div>
  <div class="detail bedrooms">
    <span>Number of bedrooms:</span> {{rental.bedrooms}}
  </div>
  {{location-map location=rental.city}}
</article>
```
Here we changed the header in the component to a link, passing the rental's `slug` as a parameter.

Now if we run our app and visit `localhost:4200/rentals` we should see all of the rentals rendered in our `outlet`.
If we click the title of any of our rentals, we will be redirected to the `show` route and able to view additional information.

![sub-routes super rentals index route](../../images/subroutes/subroutes-super-rentals-index.png)
