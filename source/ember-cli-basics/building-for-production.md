When you're ready to deploy your app to production, you can build it by running:

```bash
ember build --environment=production
```

Like in development, Ember will use Broccoli to compile your JavaScript and CSS,
but with a few important changes:

* Your JavaScript will be minified.
* Your JavaScript, CSS, and images, will be _fingerprinted_ by appending an MD5
checksum to the end of their filename (e.g. `assets/yourapp-9c2cbd818d09a4a742406c6cb8219b3b.js`). This prevents an
out-of-date version from being used if your production environment caches these
types of files.
* Production versions of your dependencies will be used (e.g. the production
version of Ember that does not include debug statements).

The build will be saved in the `dist/` folder of your application. From there,
you can deploy it to your production environment. Depending on how your app is
set up, this may involve FTPing into a server where your website is stored,
uploading the files to Amazon S3, or some other procedure.
