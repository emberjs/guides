Para demostrar la configuración básica y procesamiento de una aplicación de Ember, esta sección te guiará a través de una aplicación de Ember para un sitio de alquiler de propiedades llamado Super Rentals. Iniciará con una página, una página "acerca de" y una página de contacto. Echemos un vistazo a la aplicación desde la perspectiva del usuario antes de empezar.

![captura de pantalla de la página de inicio de super rentals](../../images/service/style-super-rentals-maps.png)

Llegamos a la página de inicio que muestra una lista de alquileres. Desde aquí, podremos navegar a la página "acerca de" y a la página de contacto.

Vamos a asegurarnos de que tenemos una aplicación de Ember CLI fresca llamada `super-rentals` ejecutando:

```shell
ember new super-rentals
```

Antes de empezar a construir las tres páginas de nuestra aplicación, vamos a borrar el contenido del archivo `app/templates/application.hbs` y solo dejaremos el código `{{outlet}}` en su lugar. Vamos a hablar más sobre el papel del archivo `application.hbs` después de que nuestro sitio tenga algunas rutas.

Ahora, vamos a empezar con la creación de nuestra página "acerca de". Recuerda, cuando se carga la URL `/about`, el router mapeará la URL al route (routa) del mismo nombre, *about.js*. La route (ruta) entonces carga una template (plantilla).

## Route (ruta) "acerca de"

Si corremos `ember help generate`, podemos ver una variedad de herramientas que vienen con Ember para generar automáticamente archivos para diferentes recursos de Ember. Vamos a usar el generador de route para iniciar con nuestra ruta `about`.

```shell
ember generate route about
```

o, para abreviar,

```shell
ember g route about
```

A continuación podemos ver qué acciones fueron realizadas por el generador:

```shell
installing route
  create app/routes/about.js
  create app/templates/about.hbs
updating router
  add route about
installing route-test
  create tests/unit/routes/about-test.js
```

Se crean tres archivos nuevos: uno para el route (ruta), uno para la (template) plantilla que el route (ruta) renderizará y un archivo de prueba. El cuarto archivo que se modifica es el router.

Cuando abrimos el router, vemos que el generador ha asignado una nueva route (ruta) *about* para nosotros. Esta ruta carga el route (ruta) `about`.

```app/router.js import Ember from 'ember'; import config from './config/environment';

const Router = Ember.Router.extend({ location: config.locationType });

Router.map(function() { this.route('about'); });

export default Router;

    <br />Por defecto el route (ruta) carga la template (plantilla) `about.hbs`.
    Esto significa que realmente no tenemos que cambiar nada en el nuevo archivo 'app/routes/about.js' para que la template (plantilla) 'about.hbs' se renderice.
    
    Con todo el enrutamiento generado por el generador, podemos empezar a trabajar en el código de nuestra template (plantilla).
    Para nuestra página `about` (acerca de), agregaremos HTML que tiene un poco de información acerca del sitio:
    
    ```app/templates/about.hbs
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling
        AND building Ember applications.
      </p>
    </div>
    

¡Ejecuta `ember serve` (o más corto aún `ember s`) desde una línea de comandos para iniciar el servidor de desarrollo de Ember, y luego visita`localhost:4200/about` para ver nuestra nueva aplicación en acción!

## La ruta de contacto

Vamos a crear otra ruta con los detalles para ponerse en contacto con la empresa. Una vez más, comenzaremos generando una route (ruta), su controlador y una template (plantilla).

```shell
ember g route contact
```

Vemos que nuestro generador ha creado una ruta `contact` en el archivo `app/router.js` y una route (ruta) correspondiente en `app/routes/contact.js`. Debido a que estaremos usando el template (plantilla) `contact`, la route (ruta) `contact` no necesita más cambios adicionales.

En `contact.hbs`, podemos agregar los datos para contactar a Super Alquiler HQ:

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Contáctenos
  </h2>
  
  <p>
    A los representantes de Super Rentals les gustaría <br />escoger un destino o responder cualquier pregunta que puedas tener.
  </p>
  
  <p>
    Super Rentals HQ 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p>
</div>

    <br />Ahora hemos completado nuestra segunda ruta.
    Si visitamos la URL 'localhost:4200/contact', iremos a nuestra página de contacto.
    
    ## Navegando con enlaces y el helper {{link-to}}
    
    Realmente no queremos que nuestros usuarios conozcan nuestras URLs para navegar nuestro sitio, así que vamos a añadir algunos enlaces de navegación en la parte inferior de cada página.
    Hagamos un enlace para la página de contacto en la página "acerca de" y un enlace para la página de "acerca de" en la página de contacto.
    
    Ember tiene incorporado **helpers (ayudantes)** que proporcionan funcionalidad como enlazarse a otras rutas.
    Aquí utilizaremos el helper (ayudante) `{{link-to}}` en nuestro código para enlazar nuestras rutas:
    
    ```app/templates/about.hbs{+9,+10,+11}
    <div class="jumbo">
      <div class="right tomster"></div>
      <h2>About Super Rentals</h2>
      <p>
        The Super Rentals website is a delightful project created to explore Ember.
        By building a property rental site, we can simultaneously imagine traveling AND building Ember applications.
      </p>
      {{#link-to 'index' class="button"}}
        Get Started!
      {{/link-to}}
    </div>
    

El helper (ayudante) `{{link-to}}` toma un argumento con el nombre del enlace, en este caso: `contact`. When we look at our about page at `http://localhost:4200/about`, we now have a working link to our contact page.

![captura de pantalla de la página "acerca de" de super rentals](../../images/routes-and-templates/ember-super-rentals-about.png)

Ahora, vamos a añadir un enlace a nuestra página de contacto para que podamos navegar entre `acerca de` y `contacto`.

```app/templates/contact.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Contact Us
  </h2>
  
  <p>
    Super Rentals Representatives would love to help you<br />choose a destination or answer any questions you may have.
  </p>
  
  <p>
    Super Rentals HQ 
    
    <address>
      1212 Test Address Avenue<br /> Testington, OR 97233
    </address>
    
    <a href="tel:503.555.1212">+1 (503) 555-1212</a><br /> <a href="mailto:superrentalsrep@emberjs.com">superrentalsrep@emberjs.com</a>
  </p> {{#link-to 'about' class="button"}} About {{/link-to}}
</div>

    <br />## Ruta index
    
    Con nuestras dos páginas estáticas creadas, estamos listos para agregar nuestra página de inicio, la cual le dará la bienvenida al sitio.
    Usando el mismo proceso que hicimos para nuestras páginas "acerca de" y "contacto", primero se genera una nueva ruta llamada `index`.
    
    ```shell
    ember g route index
    

Ahora podemos ver la salida familiar del generador de route (ruta):

```shell
installing route
  create app/routes/index.js
  create app/templates/index.hbs
installing route-test
  create tests/unit/routes/index-test.js
```

A diferencia de las otras routes (rutas) que hemos hecho hasta ahora, la route (ruta) `index` es especial: no requiere una entrada en el router. Aprenderemos más acerca de por qué la entrada no es necesaria cuando veamsos las rutas anidadas en Ember.

Vamos a actualizar nuestra template (plantilla) `index.hbs` con el código HTML de nuestra página y nuestros enlaces a las otras rutas en nuestra aplicación:

```app/templates/index.hbs 

<div class="jumbo">
  <div class="right tomster">
  </div>
  
  <h2>
    Welcome!
  </h2>
  
  <p>
    We hope you find exactly what you're looking for in a place to stay. <br />Browse our listings, or use the search box above to narrow your search.
  </p> {{#link-to 'about' class="button"}} About Us {{/link-to}}
</div>

    <br />## Adding a Banner with Navigation
    
    In addition to providing button-style links in each route of our application, we would like to provide a common banner to display both the title of our application, as well as its main pages.
    
    When you create an Ember application with Ember CLI as we did, it generates a template called `application.hbs`.
    Anything you put in this template is shown for every page in the application.
    The default `application.hbs` file contains an `h2` tag with the text "Welcome to Ember", and an `outlet`.
    The `outlet` defers to the router, which will render in its place the markup for the current route.
    
    ```app/templates/application.hbs
    <h2 id="title">Welcome to Ember</h2>
    
    {{outlet}}
    

Let's replace "Welcome to Ember" with our own banner information, including links to our new routes:

    app/templates/application.hbs{-1,+2,+3,+4,+5,+6,+7,+8,+9,+10,+11,+12,+13,+14,+15,+16,+17,+18,-19,+20,+21}
    <h2 id="title">Welcome to Ember</h2>
    <div class="container">
      <div class="menu">
        {{#link-to 'index'}}
          <h1 class="left">
            <em>SuperRentals</em>
          </h1>
        {{/link-to}}
        <div class="left links">
          {{#link-to 'about'}}
            About
          {{/link-to}}
          {{#link-to 'contact'}}
            Contact
          {{/link-to}}
        </div>
      </div>
      <div class="body">
        {{outlet}}
      </div>
    </div> Now that we've added routes and linkages between then, the two acceptance tests we created for navigating the about and contact links will should now pass:

![passing navigation tests](../../images/routes-and-templates/passing-navigation-tests.png)