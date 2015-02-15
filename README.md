## Ember Guides Source

The sourc for the Ember.js guides.

### Contributing

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

Once Middleman comes up, you'll be prompted by Windows Firewall. Click "Allow access" and you'll be in business!
