---
title: index
id: index
---
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

-   [Using AngularJs](angularjs/index)

    -   [Translations](angularjs/translations)

    -   [Templates](angularjs/templates)

    -   [Notifications](angularjs/notifications)

    -   [Routing](angularjs/routing)

    -   [UI Module](angularjs/ui-module)

-   [Making your model](model/index)

    -   [HTTP](model/http)

    -   [Mix](model/mix)

    -   [Selection](model/selection)

    -   [Eventer](model/eventer)

    -   [Provider](model/provider)

    -   [Autosave](model/autosave)

    -   [Behaviours](model/behaviours)

    -   [Rights](model/rights)

    -   [Resources (in Behaviours)](model/resources)

    -   [Sniplets](model/sniplets)

    -   [Extensions (in Behaviours)](model/extensions)

    -   [Preferences](model/preferences)

    -   [Workspace](model/workspace)

    -   [Addind others NPM modules](model/use-npm-modules)


