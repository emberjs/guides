To deploy an Ember application simply transfer the output from `ember build` to a web server.
This can be done with standard Unix file transfer tools such as `rsync` or `scp`.
There are also services that will let you deploy easily.

## Building for Deployment

Before you run `ember build` for this tutorial ensure you have the environment variable `GOOGLE_MAPS_API_KEY` set on your operating system,
so that you can view [the maps we set up previously](../service).

For many Unix shell environments you can simply provide the key in front of the of the build command, such as:

```shell
GOOGLE_MAPS_API_KEY=<your key> ember build --environment=development
```

For windows environments, type the following:

```shell
set GOOGLE_MAPS_API_KEY=<your key>
ember build --environment=development
```

We use `--environment=development` here so that Mirage will continue to mock fake data.
However, normally we would use `ember build --environment=production` which optimizes your application for production.


## Deploying with scp

You can deploy your application to any web server by copying the output from `ember build` to any web server:

```shell
scp -r dist/* myserver.com:/var/www/public/
```

## Deploying to surge.sh

[Surge.sh](http://surge.sh/) allows you to publish any folder to the web for free.
To deploy an Ember application you can simply deploy the folder produced by `ember build`.

You will need to have the surge cli tool installed:

```shell
npm install -g surge
```

Then you can use the `surge` command to deploy your application.
Note you will also need to rename index.html to 200.html to enable Ember's client-side routing.

```shell
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

We chose funny-name.surge.sh but you may use any unclaimed subdomain you like or
use a custom domain that you own and have pointed the DNS to one of surges servers.
If the second argument is left blank surge will prompt you with a suggested subdomain.

To deploy to the same URL after making changes, perform the same steps, reusing
the same domain as before.

```shell
rm -rf dist
GOOGLE_MAPS_API_KEY=<your key> ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

Note we are building with the google maps api key as shown above for UNIX platforms.
For windows you will need to set the variable according the example in the previous section.

## Servers

### Apache

On an Apache server, the rewrite engine (mod-rewrite) must be enabled in order for Ember routing to work properly.
If you upload your dist folder, going to your main URL works,
but when you try to go to a route such as '{main URL}/example' and it returns 404,
your server has not been configured for "friendly" URLs.

To fix this add a file called '.htaccess' to the root folder of your website.
Add these lines:

```text
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) index.html [L]
</IfModule>
```

Your server's configuration may be different so you may need different options.
Please see the [Apache URL Rewriting Guide](http://httpd.apache.org/docs/2.0/misc/rewriteguide.html) for more information.
