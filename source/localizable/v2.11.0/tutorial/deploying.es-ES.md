To deploy an Ember application simply transfer the output from `ember build` to a web server. Esto puede hacerse con las herramientas de transferencia de archivo de Unix estándar como `rsync` o `scp`. También hay servicios que te permitirán desplegar fácilmente.

## Desplegar con scp

Puede desplegar la aplicación en cualquier servidor web copiando la salida de `ember build` en cualquier servidor web:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Desplegar a surge.sh

[Surge.sh](http://surge.sh/) te permite publicar gratis cualquier arpeta en la web. Para desplegar una aplicación de Ember, puedes simplemente copiar la carpeta producida por `ember build`.

Necesitarás tener instalada la herramienta surge cli:

```shell
npm install -g surge
```

Entonces podrás utilizar el comando `surge` para desplegar tu aplicación. Ten en cuenta que también tendrás que proporcionar una copia de index.html con el nombre de archivo 200.html, así surge puede ayudar al enrutamiento desde el lado del cliente de Ember.

```shell
ember build --environment=development
cd dist
cp index.html 200.html
surge
```

Presiona enter para aceptar los valores predeterminados al desplegar por primera vez. Se te proporcionará una URL en la forma `funny-name.surge.sh` que podrás utilizar para varios despliegues.

Para implementar a la misma URL después de hacer cambios, realiza los mismos pasos, esta vez proporcionando la URL de tu sitio:

```shell
rm -rf dist
ember build --environment=development
cd dist
cp index.html 200.html
surge funny-name.surge.sh
```

We use `--enviroment=development` here so that Mirage will continue to mock fake data. However, normally we would use `ember build --environment=production` which does more to make your code ready for production.

## Servers

### Apache

On an Apache server, the rewrite engine (mod-rewrite) must be enabled in order for Ember routing to work properly. If you upload your dist folder, going to your main URL works, but when you try to go to a route such as '{main URL}/example' and it returns 404, your server has not been configured for "friendly" URLs. To fix this, if it doesn't exist, add a file called '.htaccess' (just a period at the beginning, nothing before it) to the root folder of your website. Add these lines:

```text
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) index.html [L]
</IfModule>
```

Your server's configuration may be different so you may need different options. Please see http://httpd.apache.org/docs/2.0/misc/rewriteguide.html for more information.