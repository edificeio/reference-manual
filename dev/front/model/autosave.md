---
title: autosave
id: autosave
---
Sometimes, a good interface will allow the user to make a variety of changes and save modifications without having to click on a save button. The Autosave functionality will save modifications only when the object being watched has changed. The differentiation is based on the toJSON return value, as it’s the value actually being sent to the server (other property won’t be saved anyway). The watcher checks for changes every 500 ms.

``` typesript
import { Autosave } from ‘entcore-toolkit’;

// Watching an object
Autosave.watch(‘/path/to/save’, myObj);
// Using a callback instead of a path
Autosave.watch(() => myObj.save(), myObj);
// Stop watching
Autosave.unwatch(myObj);
// Stop all watchers
Autosave.unwatchAll
();
```
