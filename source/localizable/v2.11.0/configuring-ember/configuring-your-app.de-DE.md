Ember CLI ships with support for managing your application's environment. Ember CLI will setup a default environment config file at `config/environment`. Here, you can define an `ENV` object for each environment, which are currently limited to three: development, test, and production.

The ENV object contains three important keys:

- `EmberENV` can be used to define Ember feature flags (see the [Feature Flags guide](../feature-flags/)).
- `APP` can be used to pass flags/options to your application instance.
- `environment` contains the name of the current environment (`development`,`production` or `test`).

You can access these environment variables in your application code by importing from `your-application-name/config/environment`.

For example:

```js
import ENV from 'your-application-name/config/environment';

if (ENV.environment === 'development') {
  // ...
}
```