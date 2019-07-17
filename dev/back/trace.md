Since ODE framework 3.6 it provides an API to trace HTTP request on specific routes.

# Description

Trace API save in a MongoDB collection called `traces` an object containing :

-   Traced application

-   Action

-   User information

-   Request (verb, route, params)

-   Dates (entry, response)

-   Response status code

-   Request body

For example :

``` json
{
    "_id" : "a4b2648f-2a89-4ce8-bfc6-05d894cfb66a",
    "application" : "Presences",
    "user" : {
        "login" : "jane.doe",
        "id" : "a25cd679-b30b-4701-8c60-231cdc30cdf2"
    },
    "request" : {
        "method" : "POST",
        "uri" : "/presences/events",
        "params" : {}
    },
    "entry" : ISODate("2019-05-03T16:15:56.329Z"),
    "response" : ISODate("2019-05-03T16:15:56.373Z"),
    "action" : "POST_EVENT",
    "status" : 201,
    "resource" : {
        "register_id" : 1019869,
        "type_id" : 1,
        "student_id" : "d2c7bbf9-baa9-4385-b5e7-cfbf66bdd9db",
        "start_date" : "2019-05-03T08:00:00.000",
        "end_date" : "2019-05-03T08:55:00.000"
    }
}
```

Trace annotation contains two parameters :

-   value (String): Set action name

-   body (Boolean): Set if the request body should be saved.

> **Note**
>
> HTTP trace API does not trace response body.

# Setting up traces

Allow ODE Framework to trace your HTTP calls by using `@Trace` annotation.

Add `Trace` annotation before your HTTP api endpoint. Trace annotation can be found in `org.entcore.common.http.filter` package.

For example :

    @Post("/events")
    @ApiDoc("Create event")
    @SecuredAction(Presences.CREATE_EVENT)
    @Trace("POST_EVENT")
    public void postEvent(HttpServerRequest request) {}

In some case, the request body should not be saved. This is possible by setting up body paramter as false.

    @Put("/events/:id")
    @ApiDoc("Update given event")
    @ResourceFilter(CreateEventRight.class)
    @SecuredAction(value = "", type = ActionType.RESOURCE)
    @Trace(value = "PUT_EVENT", body = false)
    public void putEvent(HttpServerRequest request) {}
