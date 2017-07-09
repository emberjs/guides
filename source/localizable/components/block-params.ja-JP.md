コンポーネントへはプロパティを渡すことができ ([コンポーネントへプロパティを渡す](../passing-properties-to-a-component/))、それらをブロック式で使う出力として戻すこともできます。

### `yield`を使ってコンポーネントから値を渡す

```app/templates/index.hbs
{{blog-post post=model}}
```

```app/templates/components/blog-post.hbs
{{yield post.title post.body post.author}}
```

上記ではブロク記事モデル全体が単一のプロパティとしてコンポーネントに渡されています。 次にコンポーネントは`yield`を使って値を返しています。 この場合は返された値は渡したブログ記事から参照されていますが、内部プロパティやサービスから参照した値など、コンポーネントが参照できるものは全て返すことが可能です。

### ブロック引数を使ってyieldで渡された値を使う

ブロック式では、ブロック引数を使用して、yieldで渡された値に名前をバインドできます。 これによって、コンポーンネントを使用していてその中のテンプレートによってマークアップが提供されている箇所でも、テンプレートのカスタマイズが可能になります。そして、その場合でもコンポーネント内で実装されたイベントハンドラの処理(`click()`ハンドラなど)は保持されたままとなります。

```app/templates/index.hbs
{{#blog-post post=model as |title body author|}}
  <h2>{{title}}</h2>
  <p class="author">by {{author}}</p>
  <p class="post-body">{{body}}</p>
{{/blog-post}}
```

名前は、コンポーネントテンプレート内で`yield`に渡される順序でバインドされます。

### 一つのテンプレート内でコンポーネントをブロック付きで利用するケースとブロック無しで利用するケースの両方をサポートする

`hasBlock`プロパティを使って、一つのコンポーネントテンプレート内でブロックを付けるケースと付けないケースの両方をサポートできます。

```app/templates/components/blog-post.hbs
{{#if hasBlock}}
  {{yield post.title post.body post.author}}  
{{else}}
  <h1>{{post.title}}</h1>
  <p class="author">Authored by {{post.author}}</p>
  <p>{{post.body}}</p>
{{/if}}
```

これには、ブロック式を使う際にブロック引数と一緒に使うためにyieldされた値を使うようにしている場合に、ブロック無しでコンポーネントを利用する際のデフォルトテンプレートを提供できるという効果があります。