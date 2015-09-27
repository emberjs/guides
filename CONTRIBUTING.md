# Contributing

The Ember Guides are maintained and updated by an all-volunteer group of Ember community members. We'd love to have you join our efforts! Here are a few ways you can help:

* _Fixing problems_: If you find a problem on a particular page in the Guides, the most helpful thing you can do is open a pull request. If you're not sure how to fix it, open an issue.
* _Contributing solicited content_: We try to make it easy for people to contribute to the Guides by tagging issues with [help wanted](https://github.com/emberjs/guides/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) when appropriate. The best way to get started contributing content is to pick up one of these issues.
* _Contributing unsolicited content_: If you'd like to contribute content that you think is missing, please start by checking the issues page. There may already be a plan to add this content! If not, open an issue yourself so that you can get feedback before you start writing. Our core contributors may ask you to start off by writing a blog post on your topic instead of or before opening a pull request on the Guides. This helps us keep the Guides consistent and streamlined.
* _Writing infrastructure code_: You can also help out with the Guides by improving the code for the app that is used to build the content. Issues related to writing infrastructure code have the label [infrastructure](https://github.com/emberjs/guides/issues?q=is%3Aopen+is%3Aissue+label%3A%22infrastructure%22).

Please note that no attempt is made to update content, layout, or styles for older versions of the Guides. They are considered static and immutable, as it is too difficult to maintain content for every version ever released. Issues will only be fixed for future releases.

## Style Guide

Before you open a PR with anything but a minor fix, please familiarize yourself with this style guide so that we can ensure a high quality, consistent style of writing throughout the documentation.

- The **Guides** refers to the entire Ember Guides project. Here, _Guides_ is capitalized.
- A **guide** is one page of the Guides, for example "Defining Your Routes". Here, _guide_ is lowercase.
- A **section** is one of the top-level grouping of several guides, for example "Routing".

Write in complete sentences. Use a friendly tone of voice. Use American English. Use gender-neutral pronouns - for example, "Is the user logged in? Are _they_ an admin user?" Use title case for all titles and headers. If English is not your native language and you aren't sure about any of these, don't hesitate to ask for help in your pull request!

Be as brief as possible, but don't sacrifice clarity for brevity. If a guide is more than a couple screens of scrolling, consider breaking it into multiple pages.

The target audience of the Guides are developers whose skills range from beginner developer with perhaps some jQuery experience, to experienced Ember developer learning about a new feature. Be sure to write content that covers both of their needs: keep explanations thorough enough for the beginner, while including more advanced topics for the experienced developer.

The Guides are primarily meant to cover the "Ember happy path", and are not intended to be comprehensive. Leave edge cases and rarely-used features to the API documentation. Start each guide and each section with the simplest, most commonly-used features, and progress to the more advanced and less commonly-used features.

Each guide should thoroughly explain the feature it documents, and include links to the API documentation. Links to authoritative sources of information on background concepts are also encouraged: for example, the _Handlebars Basics_ guide appropriately links to http://handlebarsjs.com/. Do not link to other outside content like blog posts or meetup slides, as reviewing and updating this content is better suited for content aggregators.

Liberally use examples in your writing. For example, the sentence "Templates can contain expressions in double curly braces" should be expanded to something like "Templates can contain expressions in double curly braces, such as \`&lt;h1&gt;Welcome {{user.name}}&lt;/h1&gt;\`" A short example is often more clear than a long explanation. In fact, it is often helpful to give two examples to make things even clearer.

In code samples:

* Follow the [Ember Style Guide](https://github.com/emberjs/ember.js/blob/master/STYLEGUIDE.md).
* Use double-quotes in templates, i.e., `<div class="awesome">{{foo-bar title="Tomster"}}</div>`.
* Omit the boilerplate that Ember CLI generates, especially the `import Ember from 'ember'` at the top of every file.
* In fenced code blocks, include the filename or language after the triple-backticks, like <code>&#96;&#96;&#96;routes/kittens.js</code> or <code>&#96;&#96;&#96;hbs</code>.
* Write paths relative to the project root.

Write once, edit twice (at least!) before opening a PR. When you edit your own writing, ask yourself:

* Am I using proper grammar and spelling?
* Can I clarify or simplify any of my explanations or examples?
* Have I included clear examples of everything I am documenting?
* Did I include links where appropriate?

You'll be amazed at how much better your writing gets as you edit and re-edit!
