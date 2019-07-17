# Getting started

If you’ve used [skeletons](https://github.com/entcore/skeletons) to initialize your application, you already have a gulpfile, a webpack config file, and a npm package file. To start front-end development, you first need to install nodeJS 6.11.

<https://nodejs.org/en/>

Then, you can go in your application folder and install all dependencies:

`npm install`

You will also need to make the gulp command available:

`npm install -g gulp@3.9.1`

# Gulp commands

Two gulp commands are available in your application:

`` gulp `build` ``

will start building your typescript files, bundle them in a single file, and add cache-busting utilities.

> **Warning**
>
> You need to use gulp build before gradle install, as Gradle (the server-side build tool) will use your current resources directory.

The second one is

`gulp watch`

This will start a process listening to all changes made to your files, build them and copy them to your springboard directory. You can set your springboard path with the springboard parameter:

`gulp watch --springboard /path/to/my/springboard`

This also works with relative paths:

`gulp watch --springboard ../my/springboard`

# Covered topics

-   [Using AngularJs](angularjs/index.md)

    -   [Translations](angularjs/translations.md)

    -   [Templates](angularjs/templates.md)

    -   [Notifications](angularjs/notifications.md)

    -   [Routing](angularjs/routing.md)

    -   [UI Module](angularjs/ui-module.md)

-   [Making your model](model/index.md)

    -   [HTTP](model/http.md)

    -   [Mix](model/mix.md)

    -   [Selection](model/selection.md)

    -   [Eventer](model/eventer.md)

    -   [Provider](model/provider.md)

    -   [Autosave](model/autosave.md)

    -   [Behaviours](model/behaviours.md)

    -   [Rights](model/rights.md)

    -   [Resources (in Behaviours)](model/resources.md)

    -   [Sniplets](model/sniplets.md)

    -   [Extensions (in Behaviours)](model/extensions.md)

    -   [Preferences](model/preferences.md)

    -   [Workspace](model/workspace.md)

    -   [Addind others NPM modules](model/use-npm-modules.md)


