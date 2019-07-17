---
title: extensions
id: extensions
---
Extensions in behaviours can be pretty much anything. Some applications expose their whole model, some don’t expose anything.

This is done simply by adding custom objects of methods on the Behaviours object. For instance, an application made for reading or editing doc files could have a method creating and returning a doc file from a HTML string :

``` typescript
Behaviours.register('myapp', {
    rights: {...},
    loadResources: async () => {...},
    sniplets: [],
    createDoc: async (content: string) => {
    // Custom method
    }
});
```

You can then call it from any application this way. First, load your behaviours. The current application’s behaviours are always loaded, along with the workspace behaviours (which are useful in pretty much every application). You need to load additional behaviours manually:

``` typescript
await Behaviours.load(‘myapp’);
```

Then call your method :

``` typescript
const myDocFile = await Behaviours.applicationsBehaviours.myapp.createDoc(content);
[source,typescript]
```
