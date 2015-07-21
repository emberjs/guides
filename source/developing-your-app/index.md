Your development process can be sped up drastically by using the built in `ember` toolchain.
Common use-cases like running a development server, asset management and tests are just a command away.

### Commands

<table class="table">
  <thead>
    <tr>
      <th style="text-align: left">Command</th>
      <th style="text-align: left">Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left"><code>ember</code></td>
      <td style="text-align: left">Prints out a list of available commands.</td>
    </tr>
    <tr>
      <td style="text-align: left"><code>ember new &lt;app-name&gt;</code></td>
      <td style="text-align: left">Creates a directory called <code>&lt;app-name&gt;</code> and generates an application structure for you.  If git is available the directory will be initialized as a git repository and an initial commit will be created.  Use  <code>--skip-git</code> flag to disable this feature.</td>
    </tr>
    <tr>
      <td style="text-align: left"><code>ember init</code></td>
      <td style="text-align: left">Generates an application structure for you in the current directory.</td>
    </tr>
    <tr>
      <td style="text-align: left"><code>ember build</code></td>
      <td style="text-align: left">Builds the application to <code>dist/</code> directory (customize via <code>--output-path</code> flag). Use <code>--environment</code> flag to specify the environment to build for (defaults to <code>development</code>). Use <code>--watch</code> flag keep the process running, observing the filesystem and rebuilding when changes occur.</td>
    </tr>
    <tr>
      <td style="text-align: left"><code>ember server</code></td>
      <td style="text-align: left">Starts up the server. Default port is <code>4200</code>. Use <code>--proxy</code> flag to proxy all ajax requests to the given address. For example <code>ember server --proxy http://127.0.0.1:8080</code> will proxy all your apps XHR to your server running at port 8080.</td>
    </tr>
    <tr>
      <td style="text-align: left"><span style="white-space:nowrap"><code>ember generate &lt;generator-name&gt; &lt;options&gt;</code></span></td>
      <td style="text-align: left">Runs a specific generator. To see available generators, run <code>ember help generate</code>.</td>
    </tr>
    <tr>
      <td style="text-align: left"><span style="white-space:nowrap"><code>ember destroy &lt;generator-name&gt; &lt;options&gt;</code></span></td>
      <td style="text-align: left">Uninstalls a module created by the generator command.  If the module was generated with the <code>--pod</code> option, then its removal needs to also include <code>--pod</code>.</td>
    </tr>
    <tr>
      <td style="text-align: left"><code>ember test</code></td>
      <td style="text-align: left">Run tests with Testem on CI mode. You can pass any options to Testem through <code>testem.json</code>, by default we’ll search for it under your project’s root or you can specify <code>config-file</code>.</td>
    </tr>
    <tr>
      <td style="text-align: left"><code>ember install &lt;addon-name&gt;</code></td>
      <td style="text-align: left">Installs the given addon to your project and saves it to the <code>package.json</code>. It will run the addon’s <code>defaultBlueprint</code> if it provides one.</td>
    </tr>
  </tbody>
</table>