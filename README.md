## Ember Guides Source

The source for the Ember.js guides.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## Developing with the Guides

To get started:

``` sh
git clone git://github.com/emberjs/guides.git
cd guides
bundle
bundle exec middleman
```

Then visit [http://localhost:4567/](http://localhost:4567/)

### Requirements

If the `bundle` command fails to run, you may need to upgrade your Ruby version. The Ember.js website build requires 1.9.3 or newer (2.0.0 recommended). You can use [RVM](https://rvm.io/) to install it:

``` sh
curl -L https://get.rvm.io | bash -s stable
rvm install 2.0.0
rvm use 2.0.0
```

### Troubleshooting tips for Windows devs

For Windows developers using [RubyInstaller](http://rubyinstaller.org/), you'll need to [download the DevKit](http://rubyinstaller.org/downloads) and install it using instructions:
https://github.com/oneclick/rubyinstaller/wiki/Development-Kit

After you have a proper install, you can then run:
``` sh
gem install bundler wdm tzinfo-data
gem update listen middleman
```

If you get an error like this when doing a gem update (or bundle install):

```Unable to download data from https://rubygems.org/ - SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (https://rubygems.org/latest_specs.4.8.gz)```

1. Follow the [instructions on this post](https://gist.github.com/luislavena/f064211759ee0f806c88) to install the trust cert.
2. Create an environment variable with a name of ```SSL_CERT_FILE``` (System > Advanced system settings > Environment variables > then "New" under system variables) and set the value to the full path of the cert you [installed in step 1](https://gist.github.com/luislavena/f064211759ee0f806c88). The value should look something like ```C:\Ruby21\lib\ruby\2.1.0\rubygems\ssl_certs\AddTrustExternalCARoot-2048.pem```.
3. Close your shell and re-open, so it loads the new environment variable.
4. Try again
5. If the error still happens, try running ```gem update --system```

After these workarounds, you should finally be able to run ```bundle exec middleman```. You may be prompted by Windows Firewall; Click "Allow access" and you'll be in business!
