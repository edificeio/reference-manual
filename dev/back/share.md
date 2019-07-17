---
title: share
id: share
---
# Conventions

Server-side resource shares require the following conventions:

1.  The data model must respect some modeling specific to the database service used.

2.  Helpers exist to interact with the sharing directive and thus manage for you the lifecycle of the shared resources (Creation, update, deletion), as well as sharing notifications.

3.  The resource listing service that potentially contains shared resources must also in its response respect exchange semantics.

# Data model

## PosgreSQL

### Design

#### Tables

Each table, function, trigger, and type must be prefixed to the schema defined in your application. The $schema variable must be replaced.

Table **users**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>id</p></td>
<td><p>VARCHAR(36)</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>username</p></td>
<td><p>VARCHAR(255)</p></td>
<td></td>
</tr>
</tbody>
</table>

Table **groups**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>id</p></td>
<td><p>VARCHAR(36)</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>name</p></td>
<td><p>VARCHAR(255)</p></td>
<td></td>
</tr>
</tbody>
</table>

Table **members**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>id</p></td>
<td><p>VARCHAR(36)</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>user_id</p></td>
<td><p>VARCHAR(36)</p></td>
<td><p>One entry contain only an user_id value or a group id value</p></td>
</tr>
<tr class="odd">
<td><p>group_id</p></td>
<td><p>VARCHAR(36)</p></td>
<td></td>
</tr>
</tbody>
</table>

Table **$resource$\\\_shares**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>member_id</p></td>
<td><p>VARCHAR(36</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>resource_id</p></td>
<td><p>BIGINT</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>action</p></td>
<td><p>VARCHAR(255)</p></td>
<td><p>Contains the right of access to a service, in the following form: Namespace separated by dashes followed by the class name followed by a pipe followed by the name of the method</p></td>
</tr>
</tbody>
</table>

> **Note**
>
> $resource$ is replaced by the name of the table that contains the resources

**SQL example:**

``` sql
CREATE TABLE $schema.users (
id VARCHAR(36) NOT NULL PRIMARY KEY,
username VARCHAR(255)
);
CREATE TABLE $schema.groups (
id VARCHAR(36) NOT NULL PRIMARY KEY,
name VARCHAR(255)
);
CREATE TABLE $schema.members (
id VARCHAR(36) NOT NULL PRIMARY KEY,
user_id VARCHAR(36),
group_id VARCHAR(36),
CONSTRAINT user_fk FOREIGN KEY(user_id) REFERENCES $schema.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT group_fk FOREIGN KEY(group_id) REFERENCES $schema.groups(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE $schema.$resource$_shares (
member_id VARCHAR(36) NOT NULL,
resource_id BIGINT NOT NULL,
action VARCHAR(255) NOT NULL,
CONSTRAINT thread_share PRIMARY KEY (member_id, resource_id, action),
CONSTRAINT thread_share_member_fk FOREIGN KEY(member_id) REFERENCES $schema.members(id) ON UPDATE CASCADE ON DELETE CASCADE
);
```

> **Note**
>
> $schema is schema of the application and $resource$ is replaced by the name of the table that contains the resources

#### Function and trigger

This modeling requires the addition of function, trigger and a new type

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>merge_users</p></td>
<td><p>FUNCTION</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>insert_users_members</p></td>
<td><p>FUNCTION</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>insert_groups_members</p></td>
<td><p>FUNCTION</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>users_trigger</p></td>
<td><p>TRIGGER</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>groups_trigger</p></td>
<td><p>TRIGGER</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>share_tuple</p></td>
<td><p>TYPE</p></td>
<td></td>
</tr>
</tbody>
</table>

**SQL example:**

``` sql
CREATE FUNCTION $schema.merge_users(key VARCHAR, data VARCHAR) RETURNS VOID AS
$$
BEGIN
LOOP
UPDATE $schema.users SET username = data WHERE id = key;
IF found THEN
RETURN;
END IF;
BEGIN
INSERT INTO $schema.users(id,username) VALUES (key, data);
RETURN;
EXCEPTION WHEN unique_violation THEN
END;
END LOOP;
END;
$$
LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION $schema.insert_users_members() RETURNS TRIGGER AS
$$
BEGIN
IF (TG_OP = 'INSERT') THEN
INSERT INTO $schema.members (id, user_id) VALUES (NEW.id, NEW.id);
RETURN NEW;
END IF;
RETURN NULL;
END;
$$
LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION $schema.insert_groups_members() RETURNS TRIGGER AS
$$
BEGIN
IF (TG_OP = 'INSERT') THEN
INSERT INTO $schema.members (id, group_id) VALUES (NEW.id, NEW.id);
RETURN NEW;
END IF;
RETURN NULL;
END;
$$
LANGUAGE plpgsql;
CREATE TRIGGER users_trigger
AFTER INSERT ON $schema.users
FOR EACH ROW EXECUTE PROCEDURE $schema.insert_users_members();
CREATE TRIGGER groups_trigger
AFTER INSERT ON actualites.groups
FOR EACH ROW EXECUTE PROCEDURE $schema.insert_groups_members();

CREATE TYPE $schema.share_tuple as (member_id VARCHAR(36), action VARCHAR(255));
```

> **Note**
>
> $schema is schema of the application and $resource$ is replaced by the name of the table that contains the resources

## MongoDB

### Design

Each mongo document represents a resource and has a shared JsonArray field.

**Json example:**

``` json
"shared" : [
{
"userId" : "5b9e362c-7e03-43d6-b51b-4f196ca86551",
"org.entcore.blog.controllers.BlogController|get" : true,
"org.entcore.blog.controllers.BlogController|delete" : true,
"org.entcore.blog.controllers.BlogController|update" : true,
"org.entcore.blog.controllers.BlogController|publish" : true,

},
{
"groupId" : "4232-1487939357094",
"org.entcore.blog.controllers.BlogController|get" : true
}
]
```

The share table contains as much occurrence as sharing on the resource. If the resource has been shared for a user then the JSON instance contains a "userId" field, so for a group this is "groupId".

The rest of the fields in a share instance correspond to the share rights set.

# Helper, Request and API

## Mongo Helper

The helper, MongoDbControllerHelper, which must be inherited by your controllers, it offers APIs to manage the lifecycle of the shares.

The easiest way to understand parameters and their use and look at the source code of an existing ONG application:

see share, shareSubmit and shareRemove methods: <https://github.com/OPEN-ENT-NG/share-big-files/blob/0.4.0/src/main/java/fr/openent/sharebigfiles/controllers/ShareBigFilesController.java#L524>

## Postgre Helper

The helper, ControllerHelper, which must be inherited by your controllers, it offers standard APIs to manage the lifecycle of the shares.

The easiest way to understand parameters and their use and look at the source code of an existing ONG application:

see share, shareSubmit and shareRemove methods: <https://github.com/OPEN-ENT-NG/exercizer/blob/0.3.0/src/main/java/fr/openent/exercizer/controllers/SubjectController.java#L272>

> **Warning**
>
> You must declare a SQL configuration for use it in your verticule class

**SQL Conf example:**

``` java
SqlConf yourControllerConf = SqlConfs.createConf(YourController.class.getName());
        yourControllerConf.setSchema("$schema");
        yourControllerConf.setTable("$resourceTable$");
        yourControllerConf.setShareTable("$resourceTable$_shares");
```

> **Note**
>
> $schema is schema of the application and $resourceTable$ is replaced by the name of the table that contains the resources

# Request and API

For both backend databases APIs are provided.

## MongoDB

The MongoDbCrudService, crud service, allows you to use the list service that manages the shares.

The search query for resources is completed by these search criteria:

``` java
new QueryBuilder().or(
QueryBuilder.start("owner.userId").is(user.getUserId()).get(),
QueryBuilder.start("shared").elemMatch(
new QueryBuilder().or(groups.toArray(new DBObject[groups.size()])).get()
)
```

That query will therefore return all resources owned by the user (*userId*) or shared with him.

> **Note**
>
> "groups" contains all of the user’s groups, plus the user’s identifier, which allows you to link the shared resources directly to that user.

It is quite possible to manage either the sharing criterion in specific requests without going through the CRUD.

## PostgreSQL

The SqlCrudService, crud service, allows to use the service list that manages the shares.

The search query for resources accessible by the user:

``` sql
"SELECT r.id FROM $schema.$resourceTable as r LEFT JOIN $schema.$resource$_shares as rs ON r.id = rs.resource_id " +
"WHERE re.member_id IN " + Sql.listPrepared(groupsAndUserIds) + " OR owner = ?";
```

> **Note**
>
> **$schema** is schema of the application and **$resource$** is replaced by the name of the table that contains the resources

> **Note**
>
> "groupsAndUserIds" contains all of the user’s groups, plus its user ID, which allows you to link shared resources directly to that user.

That query will therefore return all resources owned by the user (*userId*) or shared with him.

It is quite possible to manage either the sharing criterion in plain PostgreSQL query without going through the CRUD.
