# **Notice:** This repository is deprecated - no PRs or Issues please

We have been working hard to make it much easier to contribute to the Ember Guides over the last 6 months. As part of this process we have re-architected the Ember Guides so they are now a fully-fledged Ember application 🎉

What does this mean right now? At the time of writing we have not swapped over to the new structure but we want to keep the swap-over time to a minimum. If you want to contribute to the guides from now on you should **contribute to the new infrastructure** instead of this repo.

If you want to contribute to the **content** of the guides then make a PR on the new [guides-source repo](https://github.com/ember-learn/guides-source). This repo is almost 100% markdown and represents the content of the guides.

If you want to contribute to **how the guides are displayed** then you will probably want to contribute to the [new guides-app](https://github.com/ember-learn/guides-app). We will be updating the contributing guides as part of this new deployment.

## Ember Guides
[![Build Status](https://travis-ci.org/emberjs/guides.svg?branch=master)](https://travis-ci.org/emberjs/guides)

This is the source for the [Ember.js Guides](https://guides.emberjs.com).

Looking for repositories for other parts of the site? Check out
[website](https://github.com/emberjs/website),
[ember-api-docs](https://github.com/ember-learn/ember-api-docs),
[super-rentals tutorial](https://github.com/ember-learn/super-rentals),
[statusboard](https://github.com/ember-learn/statusboard),
and [styleguide](https://github.com/ember-learn/ember-styleguide)

## Contributing

Welcome and thanks for your help! Please see [CONTRIBUTING.md](CONTRIBUTING.md)
for detailed instructions on how to format your work and submit a Pull Request.

## Project layout

The Guides content takes the form of Markdown files (just like most READMEs).
The Guides themselves are in the `source` folder. The left nav bar is produced from
`data/pages.yml`. `lib` contains Middleman plugins, and `spec` contains tests
for those plugins.

## Running locally with Docker (recommended)

This is the recommended method for new contributors.
Although the Guides are built with Ruby, most work is done in Markdown files.
You don't need to know Ruby or install its dependencies to help out. Simply follow
the Docker container instructions below to install and run locally.

First, install [Docker and Compose](https://store.docker.com/search?offering=community&type=edition) and leave it running.

Next, the commands below will install all necessary dependencies for the Guides
app and start a server. This will take a little while to run,
possibly a few minutes. The dependencies will be installed inside a Docker
container, and do not affect your normal developer environment.

```sh
git clone git://github.com/emberjs/guides.git
cd guides
docker-compose build
docker-compose up
```

You can view the site locally at [http://localhost:4567](http://localhost:4567)

## Running locally with Ruby and Middleman

The Docker method described above is recommended over installing dependencies
separately. However, if necessary, these are the manual steps. The Guides are built
with Middleman, which runs on Ruby 1.9.3 or newer.

Mac users should install Ruby using rbenv to avoid changing their OS dependencies:

```
brew install rbenv
```

Follow the [rbenv installation instructions](https://github.com/rbenv/rbenv) to install the Ruby version specified [here](.ruby-version), then go through the init steps, set a global version, and restart the terminal. If `gem env home` shows rbenv in the path, your installation was successful. You should not have to sudo install any gems.

Once you have installed Ruby, you will need bundler and Middleman:

```
gem install bundler middleman
```

During build, Middleman will require Aspell to look for misspellings. On Macs, it can be installed via Homebrew:

``` sh
brew install aspell --with-lang-en
```

On Windows, you can download an [installer](http://aspell.net/win32/), but unfortunately it is unmaintained. On Linux, you can install with your distribution's package manager. On all platforms, you can also [build the most recent version from source](http://aspell.net/man-html/Installing.html).

Some Mac users may also need to install openSSL, which will be indicated in an error during the bundle command. See [Troubleshooting.md](TROUBLESHOOTING.md).

To get started:

#### Local Dev
``` sh
git clone git://github.com/emberjs/guides.git
cd guides
bundle
bundle exec middleman
```

#### Viewing

Then visit [http://localhost:4567/](http://localhost:4567/).

If you run into problems, check [Troubleshooting.md](TROUBLESHOOTING.md).

### Spellchecking

If you have a false hit during spellchecking, you can add the word to `/data/spelling-exceptions.txt`.
Words are line separated and case insensitive.

# Maintainers

See [MAINTAINERS.md](MAINTAINERS.md).

# Releasing

See https://github.com/emberjs/guides.emberjs.com.
