Ember のコードを書き始める前に、Ember アプリケーションのしくみの概要を確認するのをおすすめします。

![ember core concepts](../../images/ember-core-concepts/ember-core-concepts.png)

## ルーターとルート ハンドラー

レンタルのWeb アプリケーションを書いていると仮定してみてください。 いつでも、*何を探しているのか?* や *編集をしているのか?* といったそのときの状況がすぐに分かるようにしたいものです、Ember.jsではそれらの問題の答えは、URLによって解決されています。 URL はいくつかの方法で設定することが可能です。

* ユーザーが、初めてアプリケーションを読み込みこんだとき。
* ユーザーが手動で、[戻る] ボタンをクリックするあるいは、アドレス バーを編集して、手動でURL の変更を行ったとき。
* ユーザーがアプリケーション内のリンクをクリックしたとき。
* それら以外のイベンドによってURLが変更されたとき。

URL がどのように設定されたかに関わらず、まず Ember ルーターがルートハンドラと URL を関連付けます。

通常、ルートハンドラは次の二つのことを行います。

* テンプレートを描画する。
* It loads a model that is then available to the template.

## Templates

Ember.js uses templates to organize the layout of HTML in an application.

Most templates in an Ember codebase are instantly familiar, and look like any fragment of HTML. For example:

```handlebars
<div>Hi, this is a valid Ember template!</div>
```

Ember templates use the syntax of [Handlebars](http://handlebarsjs.com) templates. Anything that is valid Handlebars syntax is valid Ember syntax.

Templates can also display properties provided to them from their context, which is either a component or a route (technically, a controller presents the model from the route to the template, but this is rarely used in modern Ember apps and will be deprecated soon). For example:

```handlebars
<div>Hi {{name}}, this is a valid Ember template!</div>
```

Here, `{{name}}` is a property provided by the template's context.

Besides properties, double curly braces (`{{}}`) may also contain helpers and components, which we'll discuss later.

## Models

Models represent persistent state.

For example, a property rentals application would want to save the details of a rental when a user publishes it, and so a rental would have a model defining its details, perhaps called the *rental* model.

A model typically persists information to a web server, although models can be configured to save to anywhere else, such as the browser's Local Storage.

## Components

While templates describe how a user interface looks, components control how the user interface *behaves*.

Components consist of two parts: a template written in Handlebars, and a source file written in JavaScript that defines the component's behavior. For example, our property rental application might have a component for displaying all the rentals called `all-rentals`, and another component for displaying an individual rental called `rental-tile`. The `rental-tile` component might define a behavior that lets the user hide and show the image property of the rental.

Let's see these core concepts in action by building a property rental application in the next lesson.