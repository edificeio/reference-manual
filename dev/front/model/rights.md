---
title: rights
id: rights
---
An application defines rights by adding a rights property to its behaviours. The behaviours file should already contain a “rights” object, which is a mapping between server-side methods and the shorter names used in frontend.

Workflow rights are rights set by the administrator, and design actions users can perform on the application, like creating a resource, or publishing any kind of content.

They are available in the Me object, as:

``` typescript
import { Me } from ‘entcore’;

Me.session.workflow.myapp;
```

Resource rights are rights set by the owner of a resource on the resource itself. They may include editing, commenting, publishing, etc… They can be added to a resource through the Rights tool.

The Rights tool is an object you can use to compute the current user’s rights on a resource. It’s typically added on a class as a member:

``` typescript
import { Shareable, Rights }  from ‘entcore’;

export class MyClass implements Shareable{
    rights: Rights<MyClass>;

    constructor() {
        this.rights = new Rights<MyClass>(this);
    }

    get myRights(){
        return this.rights.myRights;
    }
}
```

Rights can be loaded by using the fromBehaviours method:

``` typescript
await myObj.rights.fromBehaviours();
```

They can also be defined inline with the fromObject method:

``` typescript
await myObj.rights.fromObject({
    resource: {
       read: ‘...’
    }
});
```
