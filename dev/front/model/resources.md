---
title: resources
id: resources
---
Making a resources list available in behaviours is done by implementing the `loadResources` method.

``` typescript
Behaviours.register('myapp', {
    rights: {...},
    loadResources: async () => {
        const response= await http.get(‘my/path’);
        this.resources = response.data.map(e => ({
            title: e.title,
            icon: e.icon,
            path: e.path,
            _id: e._id,
            owner: e.owner
        }));
    }
});
```

The `path` property refers to the unique url pointing to the resource, like `/myapp#/view/my-resource-id`.
