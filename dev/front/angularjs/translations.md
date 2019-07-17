---
title: translations
id: translations
---
Translations use the same .json files inside `/src/main/resources/i18n` as the server. The keys from the portal are available everywhere in the application. In the view, you can use the following directives to add translations:

``` html
<i18n>my.label</i18n>
<input type=”text” i18n-placeholder=”my.label” />
<button><i18n>my.label</i18n></button>
<div translate content=”[[ ‘my.label.’ + index ]]”></div>
```

In the labels, you can use properties from the scope, which will be rendered inside your text:

`“my.label”: “Hi, ! How are you?”`

In your code, you can also access translations through idiom:

``` typescript
import { idiom } from ‘entcore’;

idiom.translate(‘my.label’);
```

You can add translations from other applications with the addBundle method:

`idiom.addBundle(‘workspace/i18n’);`
