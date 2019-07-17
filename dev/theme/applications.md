Usually, when an application needs some additional SASS, it should be a new component, added in the theme. Sometimes, however, applications can have a very specific presentation, for instance when they provide UX-based functionalities, or when you need to use a CSS library. In these cases, it’s possible to use custom SASS in your applications.

# Usage

To add customized styles to your application, you need to add a new sass folder in your public folder:

    /my-app/main/src/resources/public/sass

Subfolders will be matched with themes of the same name. For instance, if your parent theme is "my-theme", you may add a "my-theme" subfolder:

    /my-app/main/src/resources/public/sass/my-theme/_my-app.scss
    /my-app/main/src/resources/public/sass/my-other-theme/_my-app.scss

If you add a "global" subfolder, its content will be added to all themes:

    /my-app/main/src/resources/public/sass/my-theme/_my-app.scss
    /my-app/main/src/resources/public/sass/my-other-theme/_my-app.scss
    /my-app/main/src/resources/public/sass/global/_my-app.scss

If several files are present, they will be added in alphabetical order:

    /my-app/main/src/resources/public/sass/my-theme/_my-app1.scss
    /my-app/main/src/resources/public/sass/my-theme/_my-app2.scss

Files in subfolders won’t be added, but can be imported from the main file:

    /my-app/main/src/resources/public/sass/my-theme/navigation/_navigation1.scss
    /my-app/main/src/resources/public/sass/my-theme/navigation/_navigation2.scss
    /my-app/main/src/resources/public/sass/my-theme/_my-app1.scss

In \\\_my-app.scss:

    @import "navigation/navigation2";
    @import "navigation/navigation1";

Variables and mixins from the main theme can be used in apps customization:

    color: $accent;

> **Warning**
>
> Keep in mind that this is not the place to add new components. If other applications rely on customized SASS, they might lose their SASS when the application is unavailable. If the parent theme is proprietary, and the application is open source, it’s best to put the application SASS in the theme repository in an applications folder, or you might run into some legal issues.
