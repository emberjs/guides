## Ember Guides Source

[![Build Status](https://travis-ci.org/emberjs/guides.svg?branch=master)](https://travis-ci.org/emberjs/guides)
[![Crowdin](https://d322cqt584bo4o.cloudfront.net/emberjs/localized.svg)](https://crowdin.com/project/emberjs)

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

If you run into problems, check [Troubleshooting.md](TROUBLESHOOTING.md).

### Spellchecking

If you have a false hit during spellchecking, you can add the word to `/data/spelling-exceptions.txt`.
Words are line separated and case insensitive.

# Maintainers

See [MAINTAINERS.md](MAINTAINERS.md).

# Releasing

See https://github.com/emberjs/guides.emberjs.com.
