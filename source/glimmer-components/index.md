## HTML elements as an abstraction for text documents

HTML was originally designed for representing simple text documents: the `<h1>`
tag represents the headline, `<p>` tags represents paragraphs and `<img>` tags
are for images.

When you use a `<p>` tag, the brower would apply a set of default behaviors and
styles suitable for a text paragraph: it can be selected for copying, but
cannot be changed like the content of a `<textarea>`, nor can it be depressed
like a `<button>`. Likewise, an `<img>` tag hides the details of fetching,
decoding and rendering image files.

Instead of thinking about the document as a series of characters, words or
lines, having a way to group things into higher-level logical units like
paragraphs and tables allow document authors to stay focused on the high-level
task of writing.

Not only is this *abstraction* helpful for the document author, it is also a
very powerful tool for fostering collaboration: when future maintainers of the
document open up the HTML file, they can clearly visualize its structure as the
original author intended. This makes it very easy to scan through paragraphs of
text and locate the right section for editing.

## Components as an abstraction for apps

Over time, the web has evolved into a platform for delivering apps in addition
to simple text documents. When building apps, the built-in HTML elements no
longer provides the right level of abstraction.

While web apps are still composed of the same primitives found in simple text
documents (such as text and images), looking through multiple levels of nested
`<div>` tags in the source does not provide the same encapsulation benefits
like `<p>` tags offer in a document.

To solve this problem, Ember provides a higher-level abstraction called
Components. In this chapter, we will look at how Components can help you group
things into logical units suitable for your app's specific needs.
