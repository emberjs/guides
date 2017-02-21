Bienvenue sur les Guides de Ember.js! Cette documentation vous emmènera de débutant à expert Ember.

## Organisation

Sur le côté gauche de chaque page des Guides, il y a une table des matières organisée en sections. Celles-ci peuvent être développées afin d'afficher les sujets qu'elles couvrent. Both the sections and the topics within each section are ordered from basic to advanced concepts.

Les Guides sont destinés à contenir des explications pratiques sur la façon de créer des applications Ember, mettant l'accent sur les caractéristiques les plus largement utilisées d'Ember.js. Pour une documentation complète de chaque fonctionnalité d'Ember et de l'API, consultez la [Ember.js API documentation](http://emberjs.com/api/).

The Guides begin with an explanation of how to get started with Ember, followed by a tutorial on how to build your first Ember app. If you're brand new to Ember, we recommend you start off by following along with these first two sections of the Guides.

## Présomptions

While we try to make the Guides as beginner-friendly as we can, we must establish a baseline so that the guides can keep focused on Ember.js functionality. We will try to link to appropriate documentation whenever a concept is introduced.

Pour tirer le meilleur parti des guides, vous devriez avoir une connaissance pratique de :

* **HTML, CSS, JavaScript** - les éléments de base des pages web. Vous trouverez la documentation de chacune de ces technologies sur le [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web).
* **Promises** - the native way to deal with asynchrony in your JavaScript code. See the relevant [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) section.
* **ES2015 modules** - you will better understand [Ember CLI's](https://ember-cli.com/) project structure and import paths if you are comfortable with [JavaScript Modules](http://jsmodules.io/).
* **ES2015 syntax** - Ember CLI comes with Babel.js by default so you can take advantage of newer language features such as arrow functions, template strings, destructuring, and more. You can check the [Babel.js documentation](https://babeljs.io/docs/learn-es2015/) or read [Understanding ECMAScript 6](https://leanpub.com/understandinges6/read) online.

## A Note on Mobile Performance

Ember will do a lot to help you write fast apps, but it can't prevent you from writing a slow one. This is especially true on mobile devices. To deliver a great experience, it's important to measure performance early and often, and with a diverse set of devices.

Make sure you are testing performance on real devices. Simulated mobile environments on a desktop computer give an optimistic-at-best representation of what your real world performance will be like. The more operating systems and hardware configurations you test, the more confident you can be.

Due to their limited network connectivity and CPU power, great performance on mobile devices rarely comes for free. You should integrate performance testing into your development workflow from the beginning. This will help you avoid making costly architectural mistakes that are much harder to fix if you only notice them once your app is nearly complete.

In short:

  1. Always test on real, representative mobile devices.
  2. Measure performance from the beginning, and keep testing as your app develops.

These tips will help you identify problems early so they can be addressed systematically, rather than in a last-minute scramble.

## Signaler un problème

Typos, missing words, and code samples with errors are all considered documentation bugs. If you spot one of them, or want to otherwise improve the existing guides, we are happy to help you help us!

Some of the more common ways to report a problem with the guides are:

* Using the pencil icon on the top-right of each guide page
* Opening an issue or pull request to [the GitHub repository](https://github.com/emberjs/guides/)

Clicking the pencil icon will bring you to GitHub's editor for that guide so you can edit right away, using the Markdown markup language. This is the fastest way to correct a typo, a missing word, or an error in a code sample.

If you wish to make a more significant contribution be sure to check our [issue tracker](https://github.com/emberjs/guides/issues) to see if your issue is already being addressed. If you don't find an active issue, open a new one.

If you have any questions about styling or the contributing process, you can check out our [contributing guide](https://github.com/emberjs/guides/blob/master/CONTRIBUTING.md). If your question persists, reach us at `#-team-learning` on the [Slack group](https://ember-community-slackin.herokuapp.com/).

Bonne chance !