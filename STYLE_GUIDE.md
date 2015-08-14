# Style Guide

Thanks for contributing to the Ember Guides! Please familiarize yourself with this style guide so that we can ensure a high quality, consistent style of writing throughout the documentation.

- The **Guides** refers to the entire Ember Guides project. Here, _Guides_ is capitalized.
- A **guide** is one page of the Guides, for example "Defining Your Routes". Here, _guide_ is lowercase.
- A **section** is one of the top-level grouping of several guides, for example "Routing".

Write in complete sentences. Use a friendly tone of voice. Use American English. User gender-neutral pronouns - for example, "Is the user logged in? Are _they_ an admin user?" Use title case for all titles and headers. If English is not your native language and you aren't sure about any of these, don't hesitate to ask for help in your pull request!

Be as brief as possible, but don't sacrifice clarity for brevity. If a guide is more than a couple screens of scrolling, consider breaking it into multiple pages.

The target audience of the Guides are developers whose skills range from beginner developer with perhaps some jQuery experience, to experienced Ember developer learning about a new feature. Be sure to write content that covers both of their needs: keep explanations thorough enough for the beginner, while including more advanced topics for the experienced developer.

The Guides are primarily meant to cover the "Ember happy path", and are not intended to be comprehensive. Leave edge cases and rarely-used features to the API documentation. Start each guide and each section with the simplest, most commonly-used features, and progress to the more advanced and less commonly-used features.

Each guide should thoroughly explain the feature it documents, and include links to the API documentation. Links to authoritative sources of information on background concepts are also encouraged: for example, the _Handlebars Basics_ guide appropriately links to http://handlebarsjs.com/. Do not link to other outside content like blog posts or meetup slides, as reviewing and updating this content is better suited for content aggregators.

Liberally use examples in your writing. For example, the sentence "Templates can contain expressions in double curly braces." should have added to it "Templates can contain expressions in double curly braces, like \`&lt;h1&gt;Welcome {{user.name}}&lt;/h1&gt;\`." A short example is often more clear than a long explanation. In fact, it is often helpful to give two examples to make things even clearer.

In code samples:

* Follow the [Ember Style Guide](https://github.com/emberjs/ember.js/blob/master/STYLEGUIDE.md).
* Omit the boilerplate that Ember CLI generates, especially the `import Ember from 'ember'` at the top of every file.
* In fenced code blocks, include the filename or language after the triple-backticks, like <code>&#96;&#96;&#96;routes/kittens.js</code> or <code>&#96;&#96;&#96;hbs</code>.
* Write paths relative to the `app` folder, except when talking about any other folder (like `config`), in which case make them relative to the project root.

Write once, edit twice (at least!) before opening a PR. When you edit your own writing, ask yourself:

* Am I using proper grammar and spelling?
* Can I clarify or simplify any of my explanations or examples?
* Have I included clear examples of everything I am documenting?
* Did I include links where appropriate?

You'll be amazed at how much better your writing gets as you edit and re-edit!
