The `application` template is the default template that is rendered when
your application starts.

You should put your header, footer, and any other decorative content
here. Additionally, you should have at least one `{{outlet}}`:
a placeholder that the router will fill in with the appropriate template,
based on the current URL.

Here's an example template:

```app/templates/application.hbs
<header>
  <h1>Igor's Blog</h1>
</header>

<div>
  {{outlet}}
</div>

<footer>
  &copy;2013 Igor's Publishing, Inc.
</footer>
```

The header and footer will always be displayed on screen, but the
contents of the `<div>` will change depending on if the user is
currently at `/posts` or `/posts/15`, for example.

For more information about how outlets are filled in by the router, see
[Routing](../../routing).

Ember CLI will create `application.hbs` for you by default in `app/templates/application.hbs`.
