## Ember Guides Source

The source for the Ember.js Guides.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## Project layout

The Guides' content is in the `source` folder. The left nav bar is produced from
`data/pages.yml`. `lib` contains Middleman plugins, and `spec` contains tests
for those plugins.

## Dependencies

The Guides are built with Middleman, which runs on Ruby 1.9.3 or newer
(2.0.0 recommended).

During build, Middleman will require Aspell to look for misspellings. On Macs, it can be installed via Homebrew:

``` sh
brew install aspell --with-lang-en
```

On Windows, you can download an [installer](http://aspell.net/win32/), but unfortunately it is unmaintained. On Linux, you can install with your distribution's package manager. On all platforms, you can also [build the most recent version from source](http://aspell.net/man-html/Installing.html).

## Developing with the Guides

To get started:

``` sh
git clone git://github.com/emberjs/guides.git
cd guides
bundle
bundle exec middleman
```

Then visit [http://localhost:4567/](http://localhost:4567/).

### Spellchecking

If you have a false hit during spellchecking, you can add the word to `/data/spelling-exceptions.txt`.
Words are line separated and case insensitive.

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

### Other Troubleshooting tips
If you're running into other problems, check [Troubleshooting.md](TROUBLESHOOTING.md) for other suggestions.
