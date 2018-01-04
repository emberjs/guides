Query parameters are optional key-value pairs that appear to the right of
the `?` in a URL. For example, the following URL has two query params,
`sort` and `page`, with respective values `ASC` and `2`:

```text
http://example.com/articles?sort=ASC&page=2
```

Query params allow for additional application state to be serialized
into the URL that can't otherwise fit into the _path_ of the URL (i.e.
everything to the left of the `?`). Common use cases for query params include
representing the current page number in a paginated collection, filter criteria, or sorting criteria.

### Specifying Query Parameters

Query params are declared on route-driven controllers. For example, to
configure query params that are active within the `articles` route,
they must be declared on `controller:articles`.

To add a `category`
query parameter that will filter out all the articles that haven't
been categorized as popular we'd specify `'category'`
as one of `controller:articles`'s `queryParams`:

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: ['category'],
  category: null
});
```

This sets up a binding between the `category` query param in the URL,
and the `category` property on `controller:articles`. In other words,
once the `articles` route has been entered, any changes to the
`category` query param in the URL will update the `category` property
on `controller:articles`, and vice versa.
Note that you can't bind `queryParams` to computed properties, they
have to be values.

Now we need to define a computed property of our category-filtered
array that the `articles` template will render:

```app/controllers/articles.js
import Controller from '@ember/controller';
import { computed } from '@ember/object';

export default Controller.extend({
  queryParams: ['category'],
  category: null,

  filteredArticles: computed('category', 'model', function() {
    let category = this.get('category');
    let articles = this.get('model');

    if (category) {
      return articles.filterBy('category', category);
    } else {
      return articles;
    }
  })
});
```

With this code, we have established the following behaviors:

1. If the user navigates to `/articles`, `category` will be `null`, so
   the articles won't be filtered.
2. If the user navigates to `/articles?category=recent`,
   `category` will be set to `"recent"`, so articles will be filtered.
3. Once inside the `articles` route, any changes to the `category`
   property on `controller:articles` will cause the URL to update the
   query param. By default, a query param property change won't cause a
   full router transition (i.e. it won't call `model` hooks and
   `setupController`, etc.); it will only update the URL.

### link-to Helper

The `link-to` helper supports specifying query params using the
`query-params` subexpression helper.

```handlebars
// Explicitly set target query params
{{#link-to "posts" (query-params direction="asc")}}Sort{{/link-to}}

// Binding is also supported
{{#link-to "posts" (query-params direction=otherDirection)}}Sort{{/link-to}}
```

In the above examples, `direction` is presumably a query param property
on the `posts` controller, but it could also refer to a `direction` property
on any of the controllers associated with the `posts` route hierarchy,
matching the leaf-most controller with the supplied property name.

The `link-to` helper takes into account query parameters when determining
its "active" state, and will set the class appropriately. The active state
is determined by calculating whether the query params end up the same after
clicking a link. You don't have to supply all of the current,
active query params for this to be true.

### transitionTo

`Route#transitionTo` and `Controller#transitionToRoute`
accept a final argument, which is an object with the key `queryParams`.

```app/routes/some-route.js
this.transitionTo('post', object, { queryParams: { showDetails: true }});
this.transitionTo('posts', { queryParams: { sort: 'title' }});

// if you want to transition the query parameters without changing the route
this.transitionTo({ queryParams: { direction: 'asc' }});
```

You can also add query params to URL transitions:

```app/routes/some-route.js
this.transitionTo('/posts/1?sort=date&showDetails=true');
```

### Opting into a full transition

When you change query params through a transition (`transitionTo` and `link-to`),
it is not considered a full transition.
This means that the controller properties associated with the query params will be updated,
as will the URL, but no `Route` method hook like `model` or `setupController` will be called.

If you need a query param change to trigger a full transition, and thus the method hooks,
you can use the optional `queryParams` configuration hash on the `Route`.
If you have a `category` query param and you want it to trigger a model refresh,
you can set it as follows:

```app/routes/articles.js
import Route from '@ember/routing/route';

export default Route.extend({
  queryParams: {
    category: {
      refreshModel: true
    }
  },

  model(params) {
    // This gets called upon entering 'articles' route
    // for the first time, and we opt into refiring it upon
    // query param changes by setting `refreshModel:true` above.

    // params has format of { category: "someValueOrJustNull" },
    // which we can forward to the server.
    return this.get('store').query('article', params);
  }
});
```

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: ['category'],
  category: null
});
```

### Update URL with `replaceState` instead

By default, Ember will use `pushState` to update the URL in the
address bar in response to a controller query param property change.
If you would like to use `replaceState` instead, which prevents an
additional item from being added to your browser's history,
you can specify this as follows:

```app/routes/articles.js
import Route from '@ember/routing/route';

export default Route.extend({
  queryParams: {
    category: {
      replace: true
    }
  }
});
```

This behaviour is similar to `link-to`,
which also lets you opt into a `replaceState` transition via `replace=true`.

### Map a controller's property to a different query param key

By default, specifying `foo` as a controller query param property will
bind to a query param whose key is `foo`, e.g. `?foo=123`.
You can also map a controller property to a different query param key using the following configuration syntax:

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: {
    category: 'articles_category'
  },

  category: null
});
```

This will cause changes to the `controller:articles`'s `category`
property to update the `articles_category` query param, and vice versa.

Query params that require additional customization can
be provided along with strings in the `queryParams` array.

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: ['page', 'filter', {
    category: 'articles_category'
  }],

  category: null,
  page: 1,
  filter: 'recent'
});
```

### Default values and deserialization

In the following example,
the controller query param property `page` is considered to have a default value of `1`.

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: 'page',
  page: 1
});
```

This affects query param behavior in two ways:

1. Query param values are cast to the same datatype as the default
   value, e.g. a URL change from `/?page=3` to `/?page=2` will set
   `controller:articles`'s `page` property to the number `2`, rather than
   the string `"2"`. The same also applies to boolean default values. If the
   default value is an array, the string will be parsed using `JSON.parse`.
2. When a controller's query param property is currently set to its
   default value, this value won't be serialized into the URL. So in the
   above example, if `page` is `1`, the URL might look like `/articles`,
   but once someone sets the controller's `page` value to `2`, the URL
   will become `/articles?page=2`.

### Sticky Query Param Values

By default, query param values in Ember are "sticky",
in that if you make changes to a query param and then leave and re-enter the route,
the new value of that query param will be preserved (rather than reset to its default).
This is a particularly handy default for preserving sort/filter parameters as you navigate back and forth between routes.

Furthermore, these sticky query param values are remembered/restored according to the model loaded into the route.
So, given a `team` route with dynamic segment `/:team_name` and controller query param "filter",
if you navigate to `/badgers` and filter by `"rookies"`,
then navigate to `/bears` and filter by `"best"`,
and then navigate to `/potatoes` and filter by `"worst"`,
then given the following nav bar links:

```handlebars
{{#link-to "team" "badgers"}}Badgers{{/link-to}}
{{#link-to "team" "bears"}}Bears{{/link-to}}
{{#link-to "team" "potatoes"}}Potatoes{{/link-to}}
```

the generated links would be:

```html
<a href="/badgers?filter=rookies">Badgers</a>
<a href="/bears?filter=best">Bears</a>
<a href="/potatoes?filter=worst">Potatoes</a>
```

This illustrates that once you change a query param,
it is stored and tied to the model loaded into the route.

If you wish to reset a query param, you have two options:

1. explicitly pass in the default value for that query param into
   `link-to` or `transitionTo`.
2. use the `Route.resetController` hook to set query param values back to
   their defaults before exiting the route or changing the route's model.

In the following example, the controller's `page` query param is reset to 1,
_while still scoped to the pre-transition `ArticlesRoute` model_.
The result of this is that all links pointing back into the exited route will use the newly reset value `1` as the value for the `page` query param.

```app/routes/articles.js
import Route from '@ember/routing/route';

export default Route.extend({
  resetController(controller, isExiting, transition) {
    if (isExiting) {
      // isExiting would be false if only the route's model was changing
      controller.set('page', 1);
    }
  }
});
```

In some cases, you might not want the sticky query param value to be
scoped to the route's model but would rather reuse a query param's value
even as a route's model changes. This can be accomplished by setting the
`scope` option to `"controller"` within the controller's `queryParams`
config hash:

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: [{
    showMagnifyingGlass: {
      scope: 'controller'
    }
  }]
});
```

The following demonstrates how you can override both the scope and the query param URL key of a single controller query param property:

```app/controllers/articles.js
import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: ['page', 'filter',
    {
      showMagnifyingGlass: {
        scope: 'controller',
        as: 'glass'
      }
    }
  ]
});
```
