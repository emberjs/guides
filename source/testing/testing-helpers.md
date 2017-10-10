_Testing helpers follows previous patterns shown in [Testing Components],
because helpers are rendered to templates just like components._

Helpers are best tested with integration tests, but can also be tested with unit
tests. Integration tests will provide better coverage for helpers, as it more
closely simulates the lifecycle of a helper than in isolation.

We're going to demonstrate how to test helpers by testing the `format-currency`
helper from [Writing Helpers].

> You can follow along by generating your own helper with `ember generate helper
> format-currency`.

```app/helpers/format-currency.js
import { helper } from "@ember/component/helper";

export function formatCurrency([value, ...rest], namedArgs) {
  let dollars = Math.floor(value / 100);
  let cents = value % 100;
  let sign = namedArgs.sign === undefined ? '$' : namedArgs.sign;

  if (cents.toString().length === 1) { cents = '0' + cents; }
  return `${sign}${dollars}.${cents}`;
}

export default helper(formatCurrency);
```

Let's start by testing the helper by showing a simple unit test and then move on
to testing with integration tests afterwards.

We don't have to use the `moduleFor` helper for unit testing helpers. Helpers
are functions, which can be easily tested with `module`.

```tests/unit/helpers/format-currency-test.js
import { formatCurrency } from 'my-app/helpers/format-currency';
import { module, test } from 'qunit';

module('Unit | Helper | format currency');

test('formats 199 with $ as currency sign', function(assert) {
  assert.equal(formatCurrency([199], { sign: '$' }), '$1.99');
});
```

As seen in the [Writing Helpers] guide. The helper function expects the unnamed
arguments as an array as the first argument. It expects the named arguments as
an object as the second argument.

Now we can move on to an integration test. Integration testing helpers is done
with the `moduleForComponent` helpers, as shown in [Testing Components].

```tests/integration/helpers/format-currency-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('format-currency', 'Integration | Helper | format currency', {
  integration: true
});

test('formats 199 with $ as currency sign', function(assert) {
  this.set('value', 199);
  this.set('sign', '$');

  this.render(hbs`{{format-currency value sign=sign}}`);

  assert.equal(this.$().text().trim(), '$1.99');
});
```

We can now also properly test if a helper will respond to property changes.

```tests/integration/helpers/format-currency-test.js
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('format-currency', 'Integration | Helper | format currency', {
  integration: true
});

test('updates the currency sign when it changes', function(assert) {
  this.set('value', 199);
  this.set('sign', '$');

  this.render(hbs`{{format-currency value sign=sign}}`);

  assert.equal(this.$().text().trim(), '$1.99', 'Value is formatted with $');

  this.set('sign', '€');

  assert.equal(this.$().text().trim(), '€1.99', 'Value is formatted with €');
});
```

[Testing Components]: ../unit-testing-basics
[Writing Helpers]: ../../templates/writing-helpers
