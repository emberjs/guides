To deploy an Ember application simply transfer the output from `ember build` to a web server.
This can be done with standard Unix file transfer tools such as `rsync` or `scp`.
There are also services that will let you deploy easily.

## Deploying with scp

You can deploy your application to any web server by copying the output from `ember build` to any web server:

```shell
ember build
scp -r dist/* myserver.com:/var/www/public/
```

## Deploying to surge.sh

Surge.sh allows you to publish any folder to the web for free.

You will need to install the `ember-cli-surge` addon:

```shell
ember install ember-cli-surge
```

Then you can use the `ember surge` command to deploy your application.

```shell
ember surge --new-domain
```

Press return to accept the defaults when deploying the first time.
You will be provided with a URL in the form `funny-name.surge.sh` that you can use for repeated deployments.

So to deploy to the same URL after making changes:

```shell
ember generate surge-domain funny-name.surge.sh
ember surge
```
