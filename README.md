## Ember Guides Source

The source for the Ember.js guides.


### Contributing

The Ember Guides are maintained and updated by an all-volunteer group of Ember community members. We'd love to have you join our efforts!

Please note that no attempt is made to update content, layout, or styles for older versions of the Guides. They are considered static and immutable, as it is too difficult to maintain content for every version ever released. Issues will only be fixed for future releases.

## Fixing problems

If you find a problem on a particular page in the Guides, the most helpful thing you can do is open a pull request. If you're not sure how to fix it, open an issue.

## Contributing solicited content

We try to make it easy for people to contribute to the Guides by tagging issues with [help wanted](https://github.com/emberjs/guides/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) when appropriate. The best way to get started contributing content is to pick up one of these issues.

## Contributing unsolicited content

If you'd like to contribute content that you think is missing, please start by checking the issues page. There may already be a plan to add this content! If not, open an issue yourself so that you can get feedback before you start writing. Our core contributors may ask you to start off by writing a blog post on your topic instead of or before opening a pull request on the Guides. This helps us keep the Guides consistent and streamlined.

## Writing code

You can also help out with the Guides by improving the code for the app that is used to build the content. Issues related to writing code have the label [code](https://github.com/emberjs/guides/issues?q=is%3Aopen+is%3Aissue+label%3A%22code%22).


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
