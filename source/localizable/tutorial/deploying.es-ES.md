Para desplegar una aplicación de Ember simplemente transferir la salida de `ember build` a un servidor web. Esto puede hacerse con las herramientas de transferencia de archivo de Unix estándar como `rsync` o `scp`. También hay servicios que te permitirán desplegar fácilmente.

## Desplegar con scp

Puede desplegar la aplicación en cualquier servidor web copiando la salida de `ember build` en cualquier servidor web:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Desplegar a surge.sh

[Surge.sh](http://surge.sh/) allows you to publish any folder to the web for free. To deploy an Ember application you can simply deploy the folder produced by `ember build`.

Necesitarás tener instalada la herramienta surge cli:

```shell
npm install -g surge
```

Entonces podrás utilizar el comando `surge` para desplegar tu aplicación. Ten en cuenta que también tendrás que proporcionar una copia de index.html con el nombre de archivo 200.html, así surge puede ayudar al enrutamiento desde el lado del cliente de Ember.

```shell
ember build --environment=production
cd dist
cp index.html 200.html
surge
```

Presiona enter para aceptar los valores predeterminados al desplegar por primera vez. Se te proporcionará una URL en la forma `funny-name.surge.sh` que podrás utilizar para varios despliegues.

Para implementar a la misma URL después de hacer cambios, realiza los mismos pasos, esta vez proporcionando la URL de tu sitio:

```shell
rm -rf dist
ember build --environment=production
cd dist
cp index.html 200.html
surge funny-name.surge.sh
```