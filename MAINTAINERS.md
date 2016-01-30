This document will document some of the processes that members of the documentation team should adhere to.

# Review Period

The two weeks preceeding a scheduled release is considered the review period of the Guides.
It is only during this period that pull requests for the relevant milestone are to be merged in.

Before the review period starts, the previous version should be re-released with any updates.

# Labels

* `infrastructure`: This label refers to issues that involve writing code, rather than writing documentation.
* `help wanted`: This label is for issues that are suitable for any interested contributor to work on.

# Milestones

* `Future`: Any future work that has is not scheduled for the next release
* `M.N`: Work that is scheduled for the `M.N` (Major.Minor) release

# Pull Requests

You should use [homu](http://homu.io) when accepting pull requests.
You can read about the available commands in the front page.

The Guides repository has homu [configured to auto-squash commits](http://homu.io/r/emberjs/guides).

Before merging you should check the following:

- Milestone. If it's assigned to the Milestone of the next release, only merge during the review period.
- Assignee. If it's assigned to someone, get explicit authorization from them before merging.
