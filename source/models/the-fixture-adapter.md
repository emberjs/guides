When developing client-side applications, your server may not have an API ready
to develop against. The FixtureAdapter allows you to begin developing Ember.js
apps now, and switch to another adapter when your API is ready to consume
without any changes to your application code.

### Getting Started

Using the fixture adapter entails three very simple setup steps:

1. Create a new store using the fixture adapter and attach it to your app.
2. Define your model using `DS.Model.extend`.
3. Attach fixtures (also known as sample data) to the model's class.

#### Creating a Fixture Adapter

Simply set the default adapter of your `Ember.Application` to be a `FixtureAdapter` by creating `app/adapters/application.js` and inserting the following:

```app/adapters/application.js
import DS from 'ember-data';
export default DS.FixtureAdapter.extend();
```

#### Define Your Model

You should refer to [Defining a Model][1] for a more in-depth guide on using
Ember Data Models, but for the purposes of demonstration we'll use an example
modeling people who document Ember.js.

```app/models/documenter.js
export default DS.Model.extend({
  firstName: DS.attr( 'string' ),
  lastName: DS.attr( 'string' )
});
```

#### Attach Fixtures to the Model Class

In order to attach fixtures to your model, you have to use `reopenClass` method and define
fixtures:

```app/models/documenter.js
let Documenter = DS.Model.extend({
  firstName: DS.attr( 'string' ),
  lastName: DS.attr( 'string' )
});

Documenter.reopenClass({
  FIXTURES: [
    { id: 1, firstName: 'Trek', lastName: 'Glowacki' },
    { id: 2, firstName: 'Tom' , lastName: 'Dale'     }
  ]
});

export default Documenter
```

That's it! You can now use all of methods for [Finding Records][2] in your
application. For example:

```app/routes/documenter.js
export default Ember.Route.extend({
  model: function() {
    return this.store.find('documenter', 1); // returns a promise that will resolve
                                             // with the record representing Trek Glowacki
  }
});
```

#### Naming Conventions

Unlike the [REST Adapter][3], the Fixture Adapter does not make any assumptions
about the naming conventions of your model. As you saw in the example above,
if you declare the attribute as `firstName` during `DS.Model.extend`, you use
`firstName` to represent the same field in your fixture data.

Importantly, you should make sure that each record in your fixture data has
a uniquely identifiable field. By default, Ember Data assumes this key
is called `id`. Should you not provide an `id` field in your fixtures, or
not override the primary key, the Fixture Adapter will throw an error.

[1]: /guides/models/defining-models
[2]: /guides/models/finding-records
[3]: /guides/models/the-rest-adapter
