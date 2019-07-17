ODE framework enables applications to register into the search engine module (see [Search Engine](https://github.com/OPEN-ENT-NG/search-engine))

-   Search engine uses Publish-subscribe and Point-to-Point model. It’s backed by the Vertx Event Bus.

-   Publish-subscribe model is used to push event to registered applications. While the Point-to-Point model allows applications to send their search’s result.

-   Search engine API uses a fulltext model .

-   An API and a defaut implementation are provided for standard search behaviors. You can also override it to offer alternative search’s behavior.

> **Note**
>
> Search engine module only support Document (MongoDB) and Relational (PostgreSQL) storage. File-type storage is not yet supported.

# Subscribe Search Event

In your Application BaseServer (that extends a Verticle) add the following piece of code.

``` java
// Subscribe to events published for searching
if (config.getBoolean("searching-event", true)) {
    setSearchingEvents(new $Application$SearchingEvents(new $SearchService()));
}
```

> **Note**
>
> **$Application$** by convention is the name of the verticule. This class must implement the SearchingEvents interface. **$SearchService** is a class that implements the *SearchService* interface

**examples:**

1.  Mongo example: [See](https://github.com/OPEN-ENT-NG/share-big-files/blob/0.4.0/src/main/java/fr/openent/sharebigfiles/ShareBigFiles.java#L68)

2.  Postgre example: [See](https://github.com/OPEN-ENT-NG/actualites/blob/0.13.0/src/main/java/net/atos/entng/actualites/Actualites.java#L63)

# Searching Events

See the contract service to [SearchingEvents](https://github.com/entcore/entcore/blob/1.26.0/common/src/main/java/org/entcore/common/search/SearchingEvents.java#L31)

**search contract**:

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Args</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>userId</p></td>
<td><p>String</p></td>
<td><p>User id</p></td>
</tr>
<tr class="even">
<td><p>groupIds</p></td>
<td><p>List&lt;String&gt;</p></td>
<td><p>groups id</p></td>
</tr>
<tr class="odd">
<td><p>returnFields</p></td>
<td><p>List&lt;String&gt;</p></td>
<td><p>Returned fields by the backend query</p></td>
</tr>
<tr class="even">
<td><p>searchWords</p></td>
<td><p>List&lt;String&gt;</p></td>
<td><p>Words to search</p></td>
</tr>
<tr class="odd">
<td><p>page</p></td>
<td><p>Integer</p></td>
<td><p>current page</p></td>
</tr>
<tr class="even">
<td><p>limit</p></td>
<td><p>Integer</p></td>
<td><p>Number of occurrences to return</p></td>
</tr>
<tr class="odd">
<td><p>handler</p></td>
<td><p>Handler&lt;Either&lt;String, JsonArray&gt;&gt;</p></td>
<td><p>Callback with the result</p></td>
</tr>
</tbody>
</table>

> **Warning**
>
> Looks at the Result chapter for the returned values convention

## Document

### Index

Add a JS script to "/deployment/$applicationName/migration/x.y.z/addTextIndex.js"

> **Note**
>
> $applicationName is the name of your app. x.y.z is the version of your app.

``` javascript
db.$collection.createIndex({ "$field1": "text", "$fieldN": "text"});
```

> **Note**
>
> $collection is the name of mongo collection, and $field1, $fieldN are attributes to be indexed

### Implementation

Create your own $Application$SearchingEvents class with MongoDbSearchService instance. See example : [ShareBigFilesSearchingEvents](https://github.com/OPEN-ENT-NG/share-big-files/blob/0.4.0/src/main/java/fr/openent/sharebigfiles/services/ShareBigFilesSearchingEvents.java#L36)

## Relational data

### Index

Add a SQL script to "src/main/resources/sql/xxx-$applicationName.sql"

> **Note**
>
> $applicationName is the name of your app. xxx is the number version of your script.

``` sql
 -- specific configuration to language natively create vectors without accents (one configuration per supported language)
 CREATE TEXT SEARCH CONFIGURATION  fr ( COPY = french ) ;
 ALTER TEXT SEARCH CONFIGURATION fr ALTER MAPPING
 FOR hword, hword_part, word WITH unaccent, french_stem;

 -- With evolution of create services, it is possible to manage multiple languages to search for the same application instance
 ALTER TABLE $schema.$resourceTable ADD language VARCHAR(2) NOT NULL DEFAULT('fr');

 ALTER TABLE $schema.$resourceTable ADD COLUMN text_searchable tsvector;

 -- Only if data alreay exists
 UPDATE $schema.$resourceTable SET text_searchable =
      to_tsvector(language::regconfig, coalesce(title,'') || ' ' || coalesce(regexp_replace(content, '<[^>]*>',' ','g'),'')    );

 CREATE INDEX textsearch_idx ON $schema.$resourceTable USING gin(text_searchable);

 CREATE FUNCTION $schema.text_searchable_trigger() RETURNS trigger AS $$
 begin
   new.text_searchable := to_tsvector(new.language::regconfig, coalesce(new.title,'') || ' ' || coalesce(regexp_replace(new.content, '<[^>]*>',' ','g'),''));
   return new;
 end
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER tsvector_update_trigger BEFORE INSERT OR UPDATE
     ON $schema.$resourceTable FOR EACH ROW EXECUTE PROCEDURE $schema.text_searchable_trigger();
```

> **Note**
>
> $schema is schema of the application and $resourceTable is replaced by the name of the table that contains the searchable resources

> **Warning**
>
> **text\_searchable\_trigger** function must use fields of your choice. In this case, indexed field are **title** and html **content**

### Implementation

Create your own $Application$SearchingEvents class with SqlSearchService instance. See example : [ActualitesSearchingEvents](https://github.com/OPEN-ENT-NG/actualites/blob/0.13.0/src/main/java/net/atos/entng/actualites/services/impl/ActualitesSearchingEvents.java#L46)

# Result

The result must be formatted according to the following convention

**Json result example:**

``` json
[
    {
      "title":"resource title",
      "description":"resource description",
      "modified": "modified date",
      "ownerDisplayName": "owner fullname",
      "ownerId": "owner uid",
      "url": "resource link"
    }, ...
]
```

# Reference

<https://docs.mongodb.com/manual/reference/operator/query/text> <https://www.postgresql.org/docs/9.5/static/textsearch.html>
