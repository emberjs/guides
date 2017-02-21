Bevor du damit beginnst, Code für deine Anwendung zu schreiben, solltest du dir einen Überblick darüber verschaffen, wie eine Ember-Anwendung funktioniert.

![Grundkonzepte von Ember](../../images/ember-core-concepts/ember-core-concepts.png)

## Routen und Route-Handler

Angenommen wir schreiben eine Web-Anwendung für eine Seite, die Benutzer ihre vermietbaren Liegenschaften auflisten lässt. Zu jedem Zeitpunkt sollte es möglich sein, Fragen über den aktuellen Zustand der Awendung zu beantworten wie *Welche Liegenschaft schaut sich der/die Benutzer/-in an?* und *bearbeitet er/sie die Liegenschaft gerade?* In Ember wird die Antwort auf diese Fragen durch die URL gegeben. Die URL kann sich auf verschiedene Arten ändern:

* Der Benutzer lädt die Anwendung zum ersten Mal.
* Der benutzer ändert die URL manuell, indem er auf den Zurück-Button klickt oder die Adressleiste editiert.
* Der Benutzer klickt auf einen Link in der Anwendung.
* Irgendein anderes Ereigniss in der App führt dazu, dass die URL sich ändert.

Unabhängig davon, wodurch die URL sich ändert, wird der Ember-Router nun als erstes die URL einem Route-Handler zuweisen.

Der Route-Handler wird dann in der Regel zwei Dinge tun:

* Er rendert ein Template.
* Er lädt ein Model, das dann für das Template zur Verfügung steht.

## Templates

Ember benutzt Templates, um das HTML-Layout einer Anwendung zu organisieren.

Die meisten Templates in einer Ember-Codebase wirken sofort vertraut und sehen wie übliche HTML-Fragmente aus. Zum Beispiel:

```handlebars
<div>Hi, das ist ein valides Ember-Template!</div>
```

In Ember-Templates kann [Handlebars](http://handlebarsjs.com)-Syntax verwendet werden. Alles, was in Handlebars syntaktisch erlaubt ist, ist auch in Ember erlaubt.

In Templates lassen sich auch Attribute ausgeben, die von dem jeweiligen Kontext zur Verfügung gestellt werden. Dieser Kontext ist entweder eine Komponente oder eine Route (rein technisch betrachtet wird im zweiten Fall noch ein sogenannter Controller benötigt, um das Attribut von der Route zum Template zu übermitteln, das kann aber in heutigen Ember-Apps meistens ignoriert werden und wird wahrscheinlich in einer späteren Version nicht mehr nötig sein). Zum Beispiel:

```handlebars
<div>Hi {{name}}, das ist ein valides Ember-Template!</div>
```

Hier ist `{{name}}` ein Attribut, das vom Template-Kontext bereitgestellt wird.

Abgesehen von Attributen können die doppelten geschweiften Klammern (`{{}}`) auch Helfer-Funktionen und Komponenenten (die wir später behandeln werden) enthalten.

## Models

Models repräsentieren persistenten Zustand.

In unserer Liegenschafts-Anwendung von oben würden wir zum Beispiel die Eigenschaften einer Liegenschaft speichern, wenn sie veröffentlicht wird. Eine Liegenschaft würde also durch ein Model repräsentiert werden, das seine Eigenschaften definiert. Dieses Model könnten wir etwa *rental* nennen.

In der Regel wird ein Model Daten auf einem Web-Server persistieren. Man kann Models aber auch so konfigurieren, dass sie ihre Daten woanders, zum Beispiel im Local Storage des Browsers, speichern.

## Komponenten

Während Templates das Aussehen einer Benutzeroberfläche festlegen, steuern Komponenten deren *Verhalten*.

Komponenten bestehen aus zwei Teilen: Einem in Handlebars geschriebenen Template und einer JavaScript-Datei, die das Verhalten der Komponente festlegen. In unserer Anwendung zur Liegenschaftsverwaltung könnte es zum Beispiel eine Komponente geben, die alle Liegenschaften anzeigt und die `all-rentals` benannt ist, und eine andere Komponente, die eine einzelne Liegenschaft anzeigt und `rental-tile` heißt. Die `rental-tile`-Komponente definiert dann möglicherweise das Verhalten, um einen Benutzer das Bild-Attribut der Liegenschaft ein- und ausblenden zu lassen.

In der nächsten Lektion schauen wir uns diese Grundkonzepte im Einsatz an, indem eine Anwendung zur Liegenschaftsverwaltung bauen.