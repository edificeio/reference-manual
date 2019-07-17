Templates are the building blocks of your application view. They allow you to load fragments of html from your template folder. To use them, you need to set containers in your view:

`<container template=”myContainer”></container>`

The container will contain any html file loaded by the template module. The container tag itself will still be present in the rendered view. HTML inside the container is rendered by AngularJS, and uses the container’s parent scope.

Then, in your controller:

`` import { template } `from ‘entcore’; ``

Load an html file inside a container.

`template.open(‘myContainer’, ‘path/to/view’);`

This would load the template located in `/src/main/resources/public/template/path/to/view.html`.

Returns true if the container contains this view.

`template.contains(‘myContainer’, ‘path/to/view’); // true`

Unloads any template from the container.

`template.close(‘myContainer’);`
