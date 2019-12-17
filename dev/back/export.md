ODE Framework allows to export transverse user resources in Json format using its `Archive` module. To do so, it delegates to every single application (via the Vert.x EventBus) the actions of extracting wanted resources from their respective database and placing them in a shared temporary folder on the Vert.x filesystem. When all applications are done, the folder is zipped and sent for download.

# How does it look like ?

Here you can see how organized the exported archive is. The first thing to notice is the `Manifest.json` file which reminds the version of all exported modules. Then, for every module choosen to be exported, you can find the corresponding folder. Every one may contains a subfolder named `Documents` where will be located all resources from `Workspace` and used by the module (suffixed by their id). The remaining content of the folder is depending on the module:

-   For MongoDB modules, like `Community` there will be a Json file for every single resources owned (or shared to) by the user. Take note that for homonymous files (as in Mindmap), the second one will be suffixed by its id. Also, for multi-collection based modules, like `Blog`, every file will prefixed by its respective collection.

-   For SQL modules, like `Exercizer`, a file will be created for every table holding user resources, and filled by values related to the user. Some specific content can be found for some modules, like `Messaging`, which contains an additionnal folder for attachments.

<!-- -->

    1550842852408_dc28b594-82d7-46e7-9279-3fe1523192f0/
        Manifest.json
        Blog/
            blog_myblog
            post_mypost
        Community/
            music
            Documents/
                test_5aded4ff-491e-42b3-bf3c-4822d6f138f3.mp3
        Exercizer/
            exercizer.subject
            exercizer.grain
            execrizer.folder
        Messaging/
            conversation.usermessagesattachments
            conversation.usermessages
            conversation.messages
            conversation.folders
            conversation.attachments
            Attachments/
                Folder_8e9ae498-51e3-43f3-9569-29f0cfe38bb4.java
                index_60bbe797-2b3a-4eb0-958f-095f64f9b917.html
            Documents/
                Image_762680a3-a421-472e-98c8-5b453ddd211f.jpg
        Mindmap/
            testmap
            testmap__849ab19b-6998-4e32-ac0d-199aae61f94a

# The REST API

The `Archive` module exposes a REST API in its `org.entcore.archive.controllers.ArchiveController` composed of the three following methods:

-   The `POST` service at `/export` which reads the list of modules to export in the body of the request, launches the export process server-side (see below), and adds the id of the export in the response.

``` java
@Post("/export")
@SecuredAction("archive.export")
public void export(final HttpServerRequest request) {
    ...
}
```

-   The `GET` service at `/export/verify/:exportId` which waits for the export represented by the `exportId` parameter to be over and, when it is, adds to the response whether the process was successful.

``` java
@Get("/export/verify/:exportId")
@SecuredAction(value = "", type = ActionType.RESOURCE)
public void verifyExport(final HttpServerRequest request) {
    ...
}
```

-   The `GET` service at `/export/:exportId` which starts the download of the archive respresented by `exportId`, and then deletes the Zip file on the Vert.x filesystem. It is therefore meant to be called only once per export and only after the above `verify` method, to ensure the export was successful.

``` java
@Get("/export/:exportId")
@SecuredAction(value = "", type = ActionType.RESOURCE)
public void downloadExport(final HttpServerRequest request) {
    ...
}
```

# What happens when the export is triggered ?

Here you can find the sequential stack trace from the moment the export is launched to the download of the archive:

-   When the download button is clicked by the user, a POST HTTP request is sent to `/archive/export`. The body of this request contains a list of modules selected by the user for the export.

-   The service initiates a new export process by calling the `export` method in the `org.entcore.archive.services.impl.FileSystemExportService` class.

-   If an export isn’t currently in progress for the same user, the method will create a temporary folder on the Vert.x filesystem and launch a `publish` call to the Vert.x EventBus, which notifies all other modules to start their respective export.

-   Every module extending `org.entcore.common.http.BaseServer` has a `org.entcore.common.user.RepositoryHandler`, which handles the `EventBus` message described above. When receiving the instruction to start exporting, it first checks if it is present among the expected exports, and then calls the `exportResources` method (see below).

-   When the `exportResources` is done copying resources to the export folder, it sends back to the `EventBus` whether it was successuf. The message is received in the `ArchiveController`, which calls the `exported` method in `FileSystemExportService`.

-   The above method counts how many answers it got, and when all modules have answered, starts zipping the export folder. If at least one module failed for whatever reason, the folder is deleted.

-   Besides, on the client side, 5 seconds after the first HTTP request starting the export, a GET request is sent to `/archive/verify/:exportID` to wait for the export to be over server-side, and ensures it was successful.

-   If it indeed was, the archive is downloaded at `/archive/:exportId`, otherwise a error feedback is showed.

# Implementation

Applications open for export must implement interface `org.entcore.common.user.RepositoryEvents` and specifically the `exportResources` method:

``` java
void exportResources(String exportId, String userId, JsonArray groups, String exportPath,
            String locale, String host, Handler<Boolean> handler);
```

The `RepositoryEvents` interface also contains other methods, some of them `default`, which are not used by the export module. To help with implementating it, ODE Framework provides the following classes:

-   The `org.entcore.common.service.impl.AbstractRepositoryEvents` class:

<!-- -->

    public abstract class AbstractRepositoryEvents implements RepositoryEvents {

        protected void createExportDirectory(String exportPath, String locale, final Handler<String> handler) {
            ...
        }

        protected void exportDocumentsDependancies(JsonArray prevResults, String exportPath, Handler<Boolean> handler) {
            ...
        }

    }

The `createExportDirectory` method creates a folder at the path represented by `exportPath`, named after the application calling it and in the given locale. It then handles the path of the newly created folder.

The `exportDocumentsDependancies` method parses a JsonArray (typically obtained by querying databases), searching for ids of documents from the workspace module. It then copy the found documents in a new folder named `Documents` at the path represented by `exportPath`. In its current implementation, it always handles `True` so that the export process does not fail if a document could not be reached.

-   The `org.entcore.common.service.impl.MongoDbRepositoryEvents` class:

<!-- -->

    public class MongoDbRepositoryEvents extends AbstractRepositoryEvents {

        protected void exportFiles(final JsonArray results, String exportPath, Set<String> usedFileName, final AtomicBoolean exported, final Handler<Boolean> handler) {
            ...
        }

        @Override
        public void exportResources(String exportId, String userId, JsonArray g, String exportPath, String locale, String host, Handler<Boolean> handler) {
            ...
        }

    }

This class provides an implementation of `RepositoryEvents` interface for MongoDB modules based on a single collection, having a `userId` field in an array named `owner` or `author` and a field named `name` or `title`.

Here is an example from the `Mindmap` module, which verifies the rules:

``` json
{
    "_id" : "9c4b70c0-cfa9-497a-b93c-3140d32aca7e",
    "name" : "My first mindmap",
    "description" : "This is a mindmap !",
    "owner" : {
        "userId" : "7f2f7dc8-1e3e-4160-a53c-1c7eca45d4ff",
        "displayName" : "LEFEBVRE Raoul"
    },
    "created" : ISODate("2019-02-21T15:08:59.382Z"),
    "modified" : ISODate("2019-02-21T15:08:59.382Z")
}
```

The `MongoDbRepositoryEvents` class also provides the `exportFiles` method, which exports to `filePath` the results from the given JsonArray. It then handles whether it was successful or not. An example of how to use it is given in `exportResources`.

-   The `org.entcore.common.service.impl.SqlRepositoryEvents` class:

<!-- -->

    public abstract class SqlRepositoryEvents extends AbstractRepositoryEvents {

        protected void exportTables(HashMap<String, JsonArray> queries, JsonArray cumulativeResult, HashMap<String, JsonArray> fieldsToNull,
                                    String exportPath, AtomicBoolean exported, Handler<Boolean> handler) {
            ...
        }

    }

This abstract class extending `AbstractRepositoryEvents` is meant to help with SQL modules. It provides the `exportTables` method which takes a mapping of SQL tables names to JsonArray representing SQL queries (created by the `org.entcore.common.sql.SqlStatementsBuilder` class). It then writes the results of the queries in files named after the respective table and located at `exportPath`. An example of how to call this method can be found in the `Actualites` module.
