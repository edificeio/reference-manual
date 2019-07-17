---
title: properties-inventory
id: properties-inventory
---
TODO : For each section description and default value and behaviors

# General

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>mode</p></td>
<td><p>dev</p></td>
</tr>
<tr class="even">
<td><p>host</p></td>
<td><p><a href="http://localhost:8090" class="uri">http://localhost:8090</a></p></td>
</tr>
<tr class="odd">
<td><p>httpProxy</p></td>
<td><p>true</p></td>
</tr>
<tr class="even">
<td><p>senderEmail</p></td>
<td><p><a href="mailto:noreply@entcore.org">noreply@entcore.org</a></p></td>
</tr>
<tr class="odd">
<td><p>ssl</p></td>
<td><p>false</p></td>
</tr>
<tr class="even">
<td><p>logDirectory</p></td>
<td><p>data/log</p></td>
</tr>
<tr class="odd">
<td><p>signKey</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>entcoreVersion</p></td>
<td></td>
</tr>
</tbody>
</table>

# Neo4J

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>neo4jUri</p></td>
<td><p><a href="http://localhost:7474" class="uri">http://localhost:7474</a></p></td>
</tr>
</tbody>
</table>

# Mongo DB

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>dbName</p></td>
<td><p>${MONGO_DB_NAME}</p></td>
</tr>
<tr class="even">
<td><p>mongoHost</p></td>
<td><p>localhost</p></td>
</tr>
<tr class="odd">
<td><p>mongoPort</p></td>
<td><p>27017</p></td>
</tr>
</tbody>
</table>

# Authentification and Identification

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>passwordRegex</p></td>
<td><p>\^.\*$</p></td>
</tr>
<tr class="even">
<td><p>logoutCallback</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>activationAutoLogin</p></td>
<td><p>false</p></td>
</tr>
<tr class="even">
<td><p>authMandatoryFields</p></td>
<td><p>{}</p></td>
</tr>
<tr class="odd">
<td><p>activationWelcomeMessage</p></td>
<td><p>false</p></td>
</tr>
<tr class="even">
<td><p>teacherForgotPasswordEmail</p></td>
<td><p>false</p></td>
</tr>
<tr class="odd">
<td><p>createdUserEmail</p></td>
<td><p>false</p></td>
</tr>
</tbody>
</table>

# Postgres

> **Note**
>
> \[optionnal\] Usefull for applications that need relationnal data storage

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>sqlUrl</p></td>
<td><p>jdbc:postgresql://localhost:5432/$PSQL_DB_NAME?stringtype=unspecified</p></td>
</tr>
<tr class="even">
<td><p>sqlUsername</p></td>
<td><p>$PSQL_USER</p></td>
</tr>
<tr class="odd">
<td><p>sqlPassword</p></td>
<td><p>$PSQL_USER_PWD</p></td>
</tr>
</tbody>
</table>

# Assets

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>assetsPath</p></td>
<td><p>../..</p></td>
</tr>
<tr class="even">
<td><p>skins</p></td>
<td><p>{&quot;localhost:8090&quot;:&quot;ode&quot;, &quot;localhost:9000&quot;:&quot;ode&quot;&quot;}</p></td>
</tr>
</tbody>
</table>

# User’s Communication Default Policy

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>applycommunication</p></td>
<td><p>false</p></td>
</tr>
<tr class="even">
<td><p>defaultCommunicationRules</p></td>
<td></td>
</tr>
</tbody>
</table>

# Batch Data Feeding

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>feeder</p></td>
<td><p>BE1D</p></td>
</tr>
<tr class="even">
<td><p>importDirectory</p></td>
<td><p>/opt/one/be1d</p></td>
</tr>
</tbody>
</table>

# Batch Referential Export

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>webdavCredential</p></td>
<td><p>false</p></td>
</tr>
<tr class="even">
<td><p>webdavHost</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>webdavUsername</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>webdavPassword</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>webdavInsecure</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>exporter</p></td>
<td><p>ELIOT</p></td>
</tr>
<tr class="odd">
<td><p>exportPath</p></td>
<td><p>/tmp</p></td>
</tr>
<tr class="even">
<td><p>exportDestination</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>autoExport</p></td>
<td><p>false</p></td>
</tr>
</tbody>
</table>

# Identity Federation

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>federationLoginUri</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>federationCallBackParam</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>federatedAddress</p></td>
<td><p>{}</p></td>
</tr>
<tr class="even">
<td><p>samlMetadataFolder</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>samlPrivateKey</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>samlServicesProviders</p></td>
<td><p>{}</p></td>
</tr>
<tr class="odd">
<td><p>samlIssuer</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>samlSLO</p></td>
<td><p>true</p></td>
</tr>
</tbody>
</table>

# Swift (Bloc Storage)

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>swiftUri</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>swiftContainer</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p>swiftUser</p></td>
<td></td>
</tr>
<tr class="even">
<td><p>swiftKey</p></td>
<td></td>
</tr>
</tbody>
</table>

**TODO** : to classify …​

    | resourcesApplications | "workspace"
    | sharedConf |
    | xitiSwitch |
    | classDefaultRoles | false
    | emailConfig |
