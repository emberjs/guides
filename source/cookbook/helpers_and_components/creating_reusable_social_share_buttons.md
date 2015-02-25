### Problem
You want to create a reusable [Tweet button](https://dev.twitter.com/docs/tweet-button)
for your application.

### Solution
Write a custom component that renders the Tweet button with specific attributes
passed in.

```handlebars
{{share-twitter class='twitter-share-button' href=url
                    data-text=text
                    data-size="large"
                    data-hashtags="emberjs"}}
```

```app/components/share-twitter.js
export default Ember.Component.extend({
  tagName: 'a',
  classNames: 'twitter-share-button',
  attributeBindings: ['data-size', 'data-url', 'data-text', 'data-hashtags']
});
```

Include Twitter's widget code in your HTML:

```javascript
<script>
window.twttr=(function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],t=window.twttr||{};if(d.getElementById(id))return;js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);t._e=[];t.ready=function(f){t._e.push(f);};return t;}(document,"script","twitter-wjs"));
</script>
```

Note: the Twitter api does change from time to time. Refer to the [documents](https://dev.twitter.com/web/tweet-button) if necessary.

### Discussion
Twitter's widget library expects to find an `<a>` tag on the page with specific `data-` attributes applied.
It takes the values of these attributes and, when the `<a>` tag is clicked, opens an iFrame for twitter sharing.

The `share-twitter` component takes four options that match the four attributes for the resulting `<a>` tag:
`data-url`, `data-text`, `data-size`, `data-hashtags`. These options and their values become properties on the
component object. 

The component defines certain attributes of its HTML representation as bound to properties of the object through
its `attributeBindings` property. When the values of these properties change, the component's HTML element's
attributes will be updated to match the new values.

An appropriate tag and css class are applied through the `tagName` and `classNames` properties.

<!---#### Example

<a class="jsbin-embed" href="http://jsbin.com/hihoboforo/4/edit?live">JS Bin</a>-->
