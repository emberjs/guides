Ember CLI ships with support for managing your application's environment. Ember CLI will setup a default environment config file at `config/environment`. Here, you can define an `ENV` object for each environment, which are currently limited to three: development, test, and production.

The ENV object contains three important keys:
- `EmberENV` can be used to define Ember feature flags (see the [Feature Flags guide](http://emberjs.com/guides/configuring-ember/feature-flags/)).
- `APP` can be used to pass flags/options to your application instance.
- `environment` contains the name of the current enviroment (`development`,`producting` or `test`).

You can access these environment variables in your application code by importing from `your-application-name/config/environment`.

For example:

```js
import ENV from 'your-application-name/config/environment';

if (ENV.environment === 'development') {
  // ...
}
```

## Configuring Ember CLI

It is now also possible to override command line options by creating a file in your app's root directory called `.ember-cli` and placing desired overrides in it.

For example, a common desire is to [change the port](http://stackoverflow.com/questions/24003944/save-port-number-for-ember-cli-in-a-config-file) that ember-cli serves the app from. It's possible to pass the port number directly to ember server in the command line, e.g. `ember server --port 8080`. If you wish to make this change a permanent configuration change, make the `.ember-cli` file and add the options you wish to pass to the server in a hash.

```json
{
  "port": 8080
}
```