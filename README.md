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

If you run into problems, check [Troubleshooting.md](TROUBLESHOOTING.md).

### Spellchecking

If you have a false hit during spellchecking, you can add the word to `/data/spelling-exceptions.txt`.
Words are line separated and case insensitive.

# Maintainers

This section will document some of the processes that members of the documentation team should adhere to.

## Review Period

The two weeks preceeding a scheduled release is considered the review period of the Guides.
It is only during this period that pull requests for the relevant milestone are to be merged in.

Before the review period starts, the previous version should be re-released with any updates.

## Labels

* `infrastructure`: This label refers to issues that involve writing code, rather than writing documentation.
* `help wanted`: This label is for issues that are suitable for any interested contributor to work on.

## Milestones

* `Future`: Any future work that has is not scheduled for the next release
* `M.N`: Work that is scheduled for the `M.N` (Major.Minor) release

## Pull Requests

You should use [homu](http://homu.io) when accepting pull requests.
You can read about the available commands in the front page.

The Guides repository has homu [configured to auto-squash commits](http://homu.io/r/emberjs/guides).

Before merging you should check the following:

- Milestone. If it's assigned to the Milestone of the next release, only merge during the review period.
- Assignee. If it's assigned to someone, get explicit authorization from them before merging.

# Releasing

See https://github.com/emberjs/guides.emberjs.com.
