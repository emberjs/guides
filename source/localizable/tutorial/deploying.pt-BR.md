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

Então você pode usar o comando de `surge` para publicar seu aplicativo. Note que você também precisará fornecer uma cópia do arquivo index.html com o nome 200.html para que o surge dê suporte às rotas no lado do cliente (client-side routing) do Ember.

```shell
ember build --environment=development
cd dist
cp index.html 200.html
surge
```

Aperte a tecla "Enter" para aceitar as configurações padrões ao publicar pela primeira vez. Será fornecida uma URL no formato `funny-name.surge.sh` que você pode usar para publicar repetidas vezes.

Então para publicar para uma mesma URL depois de fazer alterações, siga as mesmas etapas, desta vez fornecendo a URL para seu site:

```shell
rm -rf dist
ember build --environment=development
cd dist
cp index.html 200.html
surge funny-name.surge.sh
```

No exemplo acima, nós usamos `--enviroment=development` então o Mirage continuará fornecendo mock de fake data. No entanto, normalmente nós usaríamos `ember build --environment=production` que faz mais para tornar seu código pronto para produção.