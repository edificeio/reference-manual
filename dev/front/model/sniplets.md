---
title: sniplets
id: sniplets
---
Sniplets are comprised of both an applicative part (in typescript) and a view (in html). They are stored as a small JSON object which can point on an existing resource. Usually they are used to bring functionality from an application into another.

For example, let’s say you have a todo list application, in which the user lists their tasks, and a wiki. You could display in the wiki a single todo list listing all tasks related to the wiki. That todo list would still be available in the todo app, but it would also be shown in the wiki, providing context.

Given that the sniplet can have functionality that doesn’t exist in the app, you could also add custom interactions, like scrolling to the word “TODO” in the wiki when you click on a task. Sniplets inherit rights from their parents. That is, in our example, if the wiki is shared with an user, the todo list would be shared with the same user. If the todo list is shared with a user, however, this doesn’t change anything for the wiki.

Sniplets have two states :

-   the *source state* : the resource is undefined (for instance, the todo list haven’t been created)

-   the *default state* : the resource has been defined

As such, they have two views:

-   `/src/main/resources/public/template/behaviours/sniplet-source-mysniplet.html`

-   `/src/main/resources/public/template/behaviours/sniplet-mysniplet.html`

Their AngularJS controller is defined in the Behaviours object. To add a sniplet, you first need a sniplets list :

``` typescript
sniplets: {
    mysniplet: {
        title: ‘i18n.key.to.title’,
        description: ‘i18n.key.to.description’,
        controller: {
            init: function() {
                // This function is called in the default state
                // when the sniplet is displayed
                // This is where you can initialize data.

                this;
                // This is your current scope.

                this.source;
                // this.source contains all data you store in
                // your sniplet. In the todo list example,
                // it would be the todo list id.

                this.snipletResource
                // this.snipletResource is the resource containing
                // the sniplet; in our example, it would be the wiki
            },

            initSource: function(){
                // This function is called in the source state.
                // Here you can load a list of resources to choose
                // from.

                // When you call setSnipletSource, you leave the
                // source state to join the default state.
                this.setSnipletSource({ _id: ‘my-resource-id})
            },

            myFunction: function(){
                // this method can be called from either view
            },

            getReferencedResources: function(source){
                // This function should return the list of all
                // ids of the resources which need rights propagation
                // Here, we only return the id of the todo list.
                return [source._id]
            }
        }
    }
}
```

All methods in your sniplet controller will be available in your view, for instance:

This calls myFunction : `<button ng-click=”myFunction()”>Click me</button>`
