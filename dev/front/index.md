# Getting started

If you’ve used [skeletons](https://github.com/entcore/skeletons) to initialize your application, you already have a gulpfile, a webpack config file, and a npm package file. To start front-end development, you first need to install nodeJS 6.11.

<https://nodejs.org/en/>

Then, you can go in your application folder and install all dependencies:

`npm install`

You will also need to make the gulp command available:

`npm install -g gulp@3.9.1`

# Infrafront versions

## Issue 
NPM dont take care about classifier. 
For example if we have 2 features branchs on infrafront : *entcore~3.10.0-feat1* *entcore~3.10.0-feat2*, on build NPM will load the last *entcore~3.10.0* (whithout using the defined classifier).
This is a known issues while using *npm update*

## Solution
To avoid that, we used NPM tag. 
When we build infrafront on jenkins, the version is tagged using the name of the current git branch:

`npm publish --tag $GIT_BRANCH`

When we will build our apps, NPM will use the tag to load infrafront version.
For example: a build on blog#dev will load infrafront#dev.
The build use the current git branch to load the correct infrafront version.

> On master branch, the tag is not used to load the NPM version. The build use the defined version in package.json. The tag is not safe for production.

## Tag override

Some times we need to build an app that have a custom branch name not related to any infrafront tag.
For example, we have a branch *feat1* on blog and we dont have any tag *feat1* on infrafront.
So the tag *feat1* will not exists. When we build the app, NPM will fail to load the related infrafront version.

To avoid this issue we could launch the following command when building the app:
`GIT_BRANCH=fix ./build.sh install`

On jenkins, to override tag we have introduced the param 'FRONT_TAG' on some repo (entcore for example).
On build.sh we have introduced the following code:

```shell
echo "[buildNode] Get branch name from jenkins env..."
  BRANCH_NAME=`echo $GIT_BRANCH | sed -e "s|origin/||g"`
  if [ "$BRANCH_NAME" = "" ]; then
    echo "[buildNode] Get branch name from git..."
    BRANCH_NAME=`git branch | sed -n -e "s/^\* \(.*\)/\1/p"`
  fi
  if [ ! -z "$FRONT_TAG" ]; then
    echo "[buildNode] Get tag name from jenkins param... $FRONT_TAG"
    BRANCH_NAME="$FRONT_TAG"
  fi
  if [ "$BRANCH_NAME" = "" ]; then
    echo "[buildNode] Branch name should not be empty!"
    exit -1
  fi
```

On jenkins we have added a param name 'FRONT_TAG' and the value is the tag name that we want to be used on build.


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

    -   [Navigation Guards](navigation-guard.md)

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


