---
title: routing
id: routing
---
To create new routes, add the paths you want to handle in your app.ts:

``` typescript
import { routes } from ‘entcore’;

routes.define(function(\$routeProvider){
    $routeProvider
        .when(‘my/route’, {
            action: 'actionName'
        })
});
```

All controllers can then use the action to determine their behaviour on route change:

``` typescript
export const myNewController = ng.controller(‘MyNewController’, [‘$scope’, ‘route’,
($scope, route) => {
    route({
        actionName: async () => {
            await someAsyncMethodDefinedElsewhere();
            template.open(‘myContainer’, ‘myTemplate’);
            $scope.$apply();
        }
    });
}]);
```
