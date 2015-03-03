## Ember Guides Source

The source for the Ember.js guides.

### Contributing

To get started:

``` sh
git clone git://github.com/emberjs/guides.git
cd guides
bundle
bundle exec middleman
```

Then visit [http://localhost:4567/](http://localhost:4567/)

### Publishing
When a new version of Ember.js is released we use this repo to generate a guides snapshot. This represents the state of the Guides at the moment of Ember.js release. This allows us to continually update the guides for current best practices in the Ember.js ecosystem while still providing stable documentation for users on early versions of the framework.

No attempt is made to update content, layout, or styles for older versions of the Guides. They are considrered static and immutable.

To publish a new Guide versions, you'll also need a copy of the Guides site repo: https://github.com/emberjs/guides.emberjs.com

First, tag a copy of the repo:

```shell
git tag <revision number>
git push --tags
```

Next, build a new artifact and move it to the guides site repo, committing it to GitHub

```shell
middleman swiftype --only-generate
mv ./build <path to guides site repo>/artifacts/<revision number>
cd <path to guides site repo>
git add --all
gc -m "Adding artifact for Ember.js revision <revision number>"
git push
```

Finally, publish this to Divshot's staging environment (our site host)

```
cd <path to guides site repo>
npm stage # runs `divshot push staging`
```

Visit the site to ensure that everything looks good. Assuming there are no issues, you're ready to publish the site content and search content:

```shell
cd <path to guides site repo>
npm publish # runs `divshot promote staging production` && `npm switftype`
```


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

If you get an error like this:

```Unable to download data from https://rubygems.org/ - SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (https://rubygems.org/latest_specs.4.8.gz)```

1. Follow the [instructions on this post](https://gist.github.com/luislavena/f064211759ee0f806c88) to install the trust cert
2. If the error still happens, try running ```gem update --system```
3. Lastly, you can try [downloading this cacert file](http://curl.haxx.se/ca/cacert.pem) locally and setting your ```SSL_CERT_FILE``` environment variable to point to its path (System > Advanced system settings > Environment variables > then "New" under system variables).

After these workarounds, you should finally be able to run ```bundle exec middleman```. You may be prompted by Windows Firewall; Click "Allow access" and you'll be in business!
