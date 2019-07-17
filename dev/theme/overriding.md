The theme’s build process follows a waterfall composition :

1.  Configure *parent theme*

2.  Create a *child theme* that will inherit UI’s artefacts from its *parent* ('img', 'js', 'fonts', 'template', 'css')

3.  Customize UI’s artefacts in `/overrides` directory under your *child theme* root

In `theme-conf.js` (under your springboard’s root) configure the theme 'waterfall structure' with the `overriding` object

    overriding: [
        {
            parent: 'theme-open-ent',
            child: 'ode',
            skins: ['default', 'dyslexic']
        }
    ]

The whole theme 'waterfall structure' looks like bellow :

    /assets/themes
    |── <your-parent-theme>
    │   ├── css
    │   ├── img
    │   ├── js
    │   ├── portal.html
    │   ├── skins
    │   └── template
    └── <your-child-theme>
        │   ├── overrides
        │   ├── img
        │   └── template
        │       ├── override.json
        ├── css
        ├── img
        ├── js
        ├── portal.html
        ├── skins
        └── template

So the theme built process (launched with `./build.sh buildFront`) respects the next logic :

1.  Fetch parent themes and its dependencies

2.  Copy overridable UI’s artefacts ('img', 'js', 'fonts', 'template', 'css') from *parent theme* to *child theme*

3.  Squash overridable UI’s artefacts with *child theme* specific overrides (placed under `<your-child-theme>/overrides/`)

4.  Run build process (SASS …​)

# Template

Describe overriding policy into `<your-child-theme>/overrides/template/override.json` :

-   **key** must be a template’s directory (so an application name)

-   **value** must be an string array containing template’s name

<!-- -->

    {
      "auth": ["activation-form", "forgot-form"],
      "portal": ["conversation-unread"]
    }

Create directories and templates you declare into `override.json` under `` <your-child-theme>/overrides/template/` ``

    <your-child-theme>
        ├── overrides
            ├── img
            └── template
                ├── override.json

> **Warning**
>
> If you want to keep *parent theme* specific templates you need to `cp <your-parent-theme>/template/ <your-child-theme>/overrides/template/` and follow above instructions

# CSS

`writing in progress`

# Image and Fonts

`writing in progress`
