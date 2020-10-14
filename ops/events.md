# Events

## Create event

Create events are generated when a resource is created.
The event is defined by:
- resource-type: the king od resource
- event-type => "CREATE"
- date : creation date
- module: the module creating the resource
- userId: resource's creator
- ua: the user agent of the user
- platformId: id of the platform

### Create event using helper

To create an event you can do it using the helper *org.entcore.common.events.EventHelper* (entcore/commons).

Init the helper:

```java
    final EventStore eventStore = EventStoreFactory.getFactory().getEventStore(Module.class.getSimpleName());
    this.eventHelper = new EventHelper(eventStore);
```

Call the helper using:

```java
    eventHelper.onCreateResource(httpRequest, RESOURCE_NAME, asyncDefaultResponseHandler(request, 201));
```

The helper will wait the success of the handler.

Or without handler:

```java
    eventHelper.onCreateResource(httpRequest, RESOURCE_NAME);
```

It creates the event "now".

### Create event from scratch

You can also create the event without helper by calling EventStore:

```java
    final String ua = headers.get("User-Agent");
    final JsonObject attrs = new JsonObject().put("resource-type", resourceType);
    if (ua != null) {
        attrs.put("ua", ua);
    }
    eventStore.createAndStoreEvent("CREATE", userInfos, attrs);
```

### Generate past events

A migration script is available that lets you create events for resources created before tracking.
The script is available here: https://github.com/opendigitaleducation/entcore/blob/next/migration/3.11.0/createEvent.js

All parameters of the script are describe using this command:

```shell
node createEvent.js --help
```

The script need a config file to know how to create events from postgres tables (or mongo collection).
The script take as params informations about mongo, postgres and database destination.
The database destination could be:
- mongo
- postgres

The script take as param a begin date. It will generate all events from this date.
To see all details about params use *--help* option.
The script accept a config file *createEventConf.js* as follow (this file should be in the same directory):

```javascript
const configs = [
    //postgres application
    {
        module: "MODULE",//name of the module
        table: "schema.table",//postgres schema
        resourceType: "resource-type",
        ownerField: "owner",//the field containing the owner id in the table
        dateField: "date",//the field containing the resource create date in the table
        dateFieldInt: true,//the date field is an int timestamp
        dateFieldString: true,//the date field is an string
        dateFieldFormat: "YYYY-MM-DD HH:mm.ss.SSS",//the pattern used by the string date
        postgres: true, //tell the script that it is a postgres application
        searchByName: true,//true if ownerField contains the name of the owner instead of id
        where: "type='interactive'",//an sql criteria used to apply en event to some rows only
    },
    //mongo application
    {
        module: "MODULE",//name of the module
        collection: "collection",//mongo collection name
        resourceType: "resource-type",
        ownerField: "owner",//the field containing the owner id in the table
        dateField: "date",//the field containing the resource create date in the table
        dateFieldInt: true,//the date field is an int timestamp
        dateFieldString: true,//the date field is an string
        dateFieldFormat: "YYYY-MM-DD HH:mm.ss.SSS",//the pattern used by the string date
        mongodb: true,//tell the script that it is a mongo application
        searchByName: true,//true if ownerField contains the name of the owner instead of id
        criteria: { //a mongo query filter used to apply en event to some document only
            field: { $exists: false }
        },
        subResources: {//create an event foreach subResources
            messages: {//the key is the field containing an array of subresources
                resourceType: "sub-resource-type",//the subresource type
                inheritsOwner: true,//true if the owner is the same as the parent resource
                ownerField: "owner",//the field used to get the ownerid in the subresource
                dateField: "modified",//the field containing the created date in the subresource
            }
        }
    }
]

module.exports = configs;
```