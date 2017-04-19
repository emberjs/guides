Imagine if functions aren't allowed to take arguments: they won't be very
useful at all, right? Likewise, if we cannot pass data to our Components, they
would just be fancy partials with limited uses. Fortunately, Ember made it very
easy to pass data into our Components.

## Passing Attributes

When invoking Components, you can pass along any number of named attributes,
just like how you can set attributes on regular HTML elements:

```app/templates/contact-us.hbs
<h5><x-icon type="speech-bubble" size="large" /> Contact Us</h5>

<x-icon type="phone" /> 1-800-EMBER-JS <br>
<x-icon type="twitter" /> @emberjs <br>
<x-icon type="map" /> 123 Some Street, Portland OR
```

These attributes can then be accessed from the Component's template via the
`attrs` hash:

```app/templates/components/x-icon.hbs
<x-icon class="icon icon-{{attrs.type}} {{attrs.size}}" />
```

You might be wondering: what's the point of going through the `attrs` hash?
Couldn't Ember just expose the attributes as `{{type}}` instead of the nosier
`{{attrs.type}}`? Hold your thoughts! We will come back to that soon.

In addition to string attributes, sometimes you might need to pass other kind
of data such as numbers and booleans. You can do this using the curlies syntax
instead of quotation marks:

```app/templates/step-two.hbs
<progress-bar value={{2}} max={{10}} animated={{true}} /> Step 2 / 10
```

```app/templates/components/progress-bar.hbs
<progress-bar>
  <div class="foreground-bar {{if attrs.animated 'animated'}}"
       style="width: {{percentage attrs.value attrs.max}}%"></div>
  <div class="background-bar"></div>
</progress-bar>
```

```app/helpers/percentage.js
export default Ember.Helper.helper(function(params) {
  return 100.0 * params[0] / params[1];
});
```

Finally, the curlies syntax also allows you to pass dynamic data to your
Components. In fact, we have already seen this in action from our
`<blog-post-excerpt>` example:

```app/templates/posts/index.hbs
<h1>Welcome To My Blog</h1>

<h2>Subscribe to the <a href="/feed.xml">RSS feed</a> for updates!</h2>

{{#each model as |post|}}
  <blog-post-excerpt post={{post}} />
{{/each}}
```

### HTML Attributes and Attributes Shadowing

Quite often, you will want to install additional HTML attributes on your
Components.

For example, the icons rendered using our `<x-icon>` Component are completely
invisible to screen readers. To address this issue, we need to add an `alt`
attribute in the HTML output to describe the icons.

In our case, we can just update the Component to pass add this extra attribute.
But what if we are using a Component from a third-party library? Also, wouldn't
it be annoying if we have to remember to pass through the `alt` attribute every
time we write a Component? What if we want to add an `id` or extra `class`es?
What about `role` and other ARIA attributes?

To avoid this whack-a-mole situation, when you invoke a Component with any
*quoted attributes*, Ember will automatically install them on to the Component's
*top-level element* for you.

For example, when this Component:

```app/templates/components/my-btn.hbs
<a href="#" class="btn">{{attrs.title}}</a>
```

Is invoked with:

```handlebars
<my-btn id="do-not-press" role="button" title="DO NOT PRESS!" />
```

It will result in the following HTML output:

```html
<a id="do-not-press" role="button" title="DO NOT PRESS!" href="#" class="btn">DO NOT PRESS!</a>
```

If an attribute is present on both the Component's invocation and template's
top-level element, the attributes from the invocation side will "win" and
*shadow* the attributes with the same names. An exception to this rule is the
`class` attribute, where their values are *merged* together instead.

Invoking the same Component like this:

```handlebars
<my-btn role="button" href="/about-us.html" title="About Us" />
<my-btn role="button" class="btn-large" title="Big Button" />
```

Will result in the following HTML output:

```handlebars
<a role="button" href="/about-us.html" title="About Us" class="btn">About Us</a>
<a role="button" href="#" title="Big Button" class="btn btn-large">Big Button</a>
```

Knowing this, we can implement our `<x-icon>` Component like this:

```app/templates/components/x-icon.hbs
<x-icon class="icon icon-{{attrs.type}}" alt="{{attrs.type}}" />
```

By default, the icon's `type` will be used as the `alt` text, but you can easily
override it when invoking the Component:

```handlebars
<x-icon type="phone" /> 1-800-EMBERJS <br>
<x-icon type="twitter" /> @emberjs <br>
<x-icon type="map" alt="address" /> 123 Some Street, Portland OR
```

After rending, it will produce the following HTML output:

```html
<x-icon type="phone" class="icon icon-phone" alt="phone" /> 1-800-EMBERJS <br>
<x-icon type="twitter" class="icon icon-twitter" alt="twitter" /> @emberjs <br>
<x-icon type="map" alt="address" class="icon icon-map" /> 123 Some Street, Portland OR
```

Note that the `type` attribute also appeared in the HTML output since we
passed it as a quoted string. This is not a problem most of the time, and it
could even be helpful for debugging purposes.

However, if this is conflicting with an HTML attribute with a different
meaning, or if you find it undesirable for other reasons, you can opt-out of
this behavior by using the curlies syntax on the invocation:

```handlebars
<fancy-input type={{"credit-card"}} />
```

Conversely, if you are using curlies to pass dynamic strings to your Components
and you also want to install them as HTML attributes, you will need to
explicitly quote them on the invocation:

```handlebars
<fancy-input name="{{fieldName}}" />
```

## Passing a Block

You might be familiar with the HTML `<form>` and `<input>` elements. In fact,
you have probably written something like this before:

```html
<form>
  <label>Username: <input type="text" name="username"></label>
  <label>Password: <input type="password" name="password"></label>

  <input type="submit" value="Login">
</form>
```

Here, we have a very basic form with two fields and a submit button. The fields
are relatively uninteresting, but the submit button deserves a closer look.

By default, the `<input type="submit">` tag renders a submit button the text
"Submit" on it (or a localized version of that). However, it also allows us to
customize the text label via the `value` attribute, which we are taking
advantage here.

While this API is quite simple to use and works well most of the time, there is
a severe limitation: the `value` attribute only accept plain strings. If we
would like to add an icon or an image to the button, we are completely out of
luck – it is simply not possible using the `<input type="submit">` tag.

Fortunately, the `<button>` tag exists for exactly this purpose. Instead of
taking an attribute for its label, it allows us to put arbitrary HTML content
*inside* the tag. This makes it trivial customize the button to our liking:

```html
<button type="submit">
  <i class="icon icon-key"></i> Login to <strong>emberjs.com</strong>
</button>
```

Much better! Looking at our `<my-btn>` Component from above, it has the same
issues as the `<input type="submit">` tag. Instead of taking the button's text
from the `title` attribute, wouldn't it be better if our Component allowed the
invoker to supply whatever content they want like the `<button>` tag did?

Fortunately for us, Ember has made this pretty easy. In addition to the `attrs`
hash, we also have access to the `{{yield}}` keyword in Component templates. In
our case, we can use it like this:

```app/templates/components/my-btn.hbs
<a href="#" class="btn">{{yield}}</a>
```

When the Component is rendered, the `{{yield}}` keyword will be replaced by
the content our invoker supplied inside the tag. With this change, we can
now invoke the Component as such:

```handlebars
<my-btn href="/about-us"><i class="icon icon-information"></i> About Us</my-btn>
<my-btn href="/contact-us"><i class="icon icon-contact"></i> Contact Us</my-btn>
```

Which would result in the following HTML output when rendered:

```html
<a href="/about-us" class="btn"><i class="icon icon-information"></i> About Us</a>
<a href="/contact-us" class="btn"><i class="icon icon-contact"></i> Contact Us</a>
```

Much better!
