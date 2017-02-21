Ember CLI 为管理应用环境提供了支持。 Ember CLI 初始化会创建一个默认的环境配置文件`config/environment`。 在这里，您可以定义一个`ENV`对象管理每种环境，目前环境有三种：development、test、和 production。

ENV 对象包含3个重要的配置属性：

- `EmberENV`可以被用于定义 Ember 功能特征标志(见 [功能特征标志指南](../feature-flags/)).
- `APP`可以用于传递应用实例的标志或选项。
- `environment` 包含当前环境的名称(`development`、`production` 或 `test`).

为了在应用代码中访问这些环境变量，您可以在代码中引入`your-application-name/config/environment`。.

例如：

```js
import ENV from 'your-application-name/config/environment';

if (ENV.environment === 'development') {
  // ...
}
```