Every Ember application has a container that maintains object instances for you. You can
inspect these instances using the Container tab. This is useful for objects
that don't fall under a dedicated menu, such as services.

<img src="../../images/guides/ember-inspector/container-screenshot.png" width="680"/>

Click on the Container tab, and you will see a list of instances the container is holding. Click on a type to see the list of all instances of that type maintained by the container.

### Inspecting Instances

Click on a row to inspect a given instance using the Object Inspector.

<img src="../../images/guides/ember-inspector/container-object-inspector.png" width="680"/>

### Filter and Reload

You can reload the container tab by clicking on the reload icon. To search for instances, type a query in the search box.

<img src="../../images/guides/ember-inspector/container-toolbar.png" width="300"/>
