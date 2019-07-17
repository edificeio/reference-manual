---
title: security
id: security
---
ODE Framework uses an hybrid security model in order to deal with the various cases you will come accross when designing and developing educational applications. It can be done in 4 ways :

-   **AUTHENTICATED** : The right grants user access if he is authenticated

-   **WORKFLOW** : The right grants user access to an application process. It is managed by an administrator

-   **RESOURCE** : The right grants user access to a resource process. It is managed by the resource’s owner

-   **CUSTOM** : the right grants access to anything the designer / developer want in the application.

This document describes how to use the security framework. You can read the [Security Architecture](architecture/security) document to understand the design choices.

# Rights definition and convention

The right has to be defined on actions in a controller that extends `fr.wseduc.webutils.http.BaseController`.

``` java
public class MyController extends BaseController {
}
```

Actions are protected with a `` SecuredAction’s annotation set up with the security policy you want.
In the following example, acces to `GET myApp/message `` is granted only for authenticated users.

``` java
@Get("/message")
@SecuredAction(value = "", type = ActionType.AUTHENTICATED)
public void getMessage(final HttpServerRequest request){
    renderJson(request, new JsonObject().putString("message","coucou !"));
}
```

## AUTHENTICATED

To grant access to authenticated users, use :

``` java
@SecuredAction(value = "", type = ActionType.AUTHENTICATED)
```

> **Note**
>
> `value` is useless in this case. It can be empty

## WORKFLOW

To grant access to an application process managed by the administrator :

``` java
@SecuredActioni18n.key.myRight", type = ActionType.WORKFLOW)
// or
@SecuredAction(value = "i18n.key.myRight")
```

> **Note**
>
> -   `value` nains the i18n key of the right displayed in adminitration UI
>
> -   `type` can be omitted. The defaut type for SecuredAction is WORKFLOW
>
> **Warning**
>
> When you mark an action with a WORKFLOW right, rebuild and restart your platform. Connect to the adminitration UI. In application management section you will discover your new WORFLOW’s right.

## RESOURCE

To grant access to an resource’s process managed by the resource’s owner :

``` java
@SecuredAction(value = "i18n.key.myRight.[read|contrib|manager|publish|comment]", type = ActionType.RESOURCE)
```

WARN : `value` i18n key must be suffixed with ".read", ".contrib", ".manager", ".publish" or ".comment". This convention is used by the framework to group fine grained rights into generic one’s. Those generic right are displayed to the end user in the share panel directive

## CUSTOM

To grant access to a specific process with spécific rules, you can yan use or develop a `RessourceFilter` :

``` java
@ResourceFilter(MyResourceFilter.class)
@SecuredAction(value = "", type = ActionTypeMyResourceFilterRESOURCE)
```

> **Warning**
>
> `value` must be empty to allow the framework to load a custom ResourceFilter.

You can find ready to use RessourceFilter in `org.entcore.common.http.filter` package, like `OwnerOnly` or `SuperAdminFilter`

To add a custom filter to your application write a class that implements `ResourcesProvider` interface.

``` java
public interface ResourcesProvider {

    void authorize(HttpServerRequest resourceRequest, Binding binding,
                   UserInfos user, Handler<Boolean> handler);

}
```

In `authorized` method you have acces to request context through

-   `resourceRequest` : the current http request

-   `user` : the current user’s UserInfos

-   `binding` : the current action

And you can request the database to check specific stuff.

> **Warning**
>
> Be aware that your code will be comupte every time the associated action is requested. So you are accountable for the performance concerns.
