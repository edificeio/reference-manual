---
title: class-admin
id: class-admin
---
Class-Admin is a sub-module of the `directory` module in `entcore`. It virtually gives pseudo-ADML rights to a Teacher on its class. Aong them are the rights to visualize and edit almost every user information, to block and delete them, to change their class affectation, and to generate new activation codes, in case of lost password.

# The REST API

To do so, the directory module exposes a REST API, mostly distinct from the one used for Admin oprations. The specifics routes for Class-Admin are defined as:

-   The `GET` service at `/class-admin/:userId`, in `DirectoryController`, retrieves all needed information about the user represented by the `userId` parameter. It notably gets the login, names, email, phone numbers, mood, motto, hobbies and relatives of the given user, regardless if the latter has restricted the visibility of these attributes. This route, when called, ensures that the teacher belongs to the same structure as the user.

``` java
@Get("/class-admin/:userId")
@SecuredAction(value = "", type = ActionType.RESOURCE)
public void classAdminUsers(HttpServerRequest request) {
    ...
}
```

-   The `POST` service at `/class-admin/massmail`, in `StructureController`, allows to massmail given users. Again, this route, when called, ensures that the teacher belongs to the same structure as the exported users. As a `POST` request, it cannot trigger directly the download, so it is the frontend’s job to initiate it. It takes four body parameters:

    -   `ids` which is the array of userIds to massmail

    -   `theme` which is the theme wanted for pdf massmail. If empty, the domain’s default theme will be used.

    -   `type` which is the format in which the massmail is wanted. Currently, it can be `pdf`, `simplePdf`, `mail` or `csv`.

    -   `structureId` which is the id the structure (here, the school) where all massamailed users belong.

``` java
@Post("/class-admin/massmail")
@SecuredAction(value = "", type = ActionType.RESOURCE)
public void classAdminMassMail(final HttpServerRequest request){
    ...
}
```
