Para publicar um aplicativo Ember simplesmente transfira a saída do comando `ember build` para um servidor web. Isso pode ser feito com ferramentas de transferência de arquivos padrões do Unix como `rsync` ou `scp`. Existem também serviços que lhe permitem publicar facilmente.

## Publicando com scp

Você pode publicar seu aplicativo para qualquer servidor copiando a saída do comando `ember build` para qualquer servidor web:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Publicando para o surge.sh

[Surge.sh](http://surge.sh/) permite que você publique qualquer pasta na web gratuitamente. Para publicar um aplicativo Ember, você simplesmente pode publicar a pasta produzida pelo comando `ember build`.

Você precisará ter o programa de linha de comando surge cli instalado:

```shell
npm install -g surge
```

Then you can use the `surge` command to deploy your application. Note you will also need to rename index.html to 200.html to enable Ember's client-side routing.

```shell
ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

We chose funny-name.surge.sh but you may use any unclaimed subdomain you like or use a custom domain that you own and have pointed the DNS to one of surges servers. If the second argument is left blank surge will prompt you with a suggested subdomain.

To deploy to the same URL after making changes, perform the same steps, reusing the same domain as before.

```shell
rm -rf dist
ember build --environment=development
mv dist/index.html dist/200.html
surge dist funny-name.surge.sh
```

We use `--environment=development` here so that Mirage will continue to mock fake data. However, normally we would use `ember build --environment=production` which optimizes your application for production.

## Servers

### Apache

On an Apache server, the rewrite engine (mod-rewrite) must be enabled in order for Ember routing to work properly. If you upload your dist folder, going to your main URL works, but when you try to go to a route such as '{main URL}/example' and it returns 404, your server has not been configured for "friendly" URLs.

To fix this add a file called '.htaccess' to the root folder of your website. Add these lines:

```text
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) index.html [L]
</IfModule>
```

Your server's configuration may be different so you may need different options. Please see the [Apache URL Rewriting Guide](http://httpd.apache.org/docs/2.0/misc/rewriteguide.html) for more information.