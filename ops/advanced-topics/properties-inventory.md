TODO : For each section description and default value and behaviors

# General

| Property           |      Value                      |
|--------------------|---------------------------------|
| mode               |  dev                            |
| host               |  http://localhost:8090          |
| http               |  proxy                          |
| senderEmail        |  noreply@mydomain.org           |
| ssl                |  false                          |
| senderEmail        |  noreply@mydomain.org           |
| logDirectory       |  data/log                       |
| signKey            |                                 |
| entcoreVersion     |                                 |

# Neo4J

| Property           |      Value                      |
|--------------------|---------------------------------|
| neo4jUri           |  http://localhost:7474          |

# Mongo DB

| Property           |      Value                      |
|--------------------|---------------------------------|
| dbName             |  ${MONGO_DB_NAME}               |
| mongoHost          |  localhost                      |
| mongoPort          |  20017                          |


# Postgres

| Property           |      Value                      |
|--------------------|---------------------------------|
| sqlUrl             |  jdbc:postgresql://localhost:5432/$PSQL_DB_NAME?stringtype=unspecified |
| sqlUsername        |  $PSQL_USER                      |
| sqlPassword        |  $PSQL_PASSWORD                  |

# Authentification and Identification

| Property            |      Value                      |
|---------------------|---------------------------------|
| passwordRege        |  \^.\*$                         |
| logoutCallback      |                                 |
| activationAutoLogin | false                           |
| logoutCallback      |                                 |
| authMandatoryFields | {}                              |
| activationWlecomeMessage   | false                    |
| teacherForgotPasswordEmail | false                    |
| createdUserEmail    | false                           |

# Assets

| Property            |      Value                      |
|---------------------|---------------------------------|
| assetsPath          | ../..                           |
| skins               | {"localhost:8090":"ode", "localhost:9000":"ode""}                                |

# User’s Communication Default Policy

| Property            |      Value                      |
|---------------------|---------------------------------|
| applycommunication  | false                           |
| defaultCommunicationRules  |                          |


# Batch Data Feeding

| Property            |      Value                      |
|---------------------|---------------------------------|
| fedder              | AAF                             |
| importDirectory     | /data/feed                      |


# Webdav

| Property            |      Value                      |
|---------------------|---------------------------------|
| webdavCredential    | false                           |
| webdavHost          |                                 |
| webdavUsername      |                                 |
| webdavPassword      |                                 |
| webdavInsecure      |                                 |


# Batch Referential Export

| Property            |      Value                      |
|---------------------|---------------------------------|
| exporter            | ELIOT                           |
| exportPath          | /tmp                            |
| exportDestination   |                                 |
| autoExport          | false                           |

# Identity Federation

| Property                  |      Value                      |
|---------------------------|---------------------------------|
| federationLoginUri        | ELIOT                           |
| federrationCallBackParams | /tmp                            |
| federationAdress          |                                 |
| samlMetadataFolder        |                                 |
| samlMetadataFolder        |                                 |
| samlPrivateKey            |                                 |
| samlIssuer                |                                 |
| samlSLO                   | true                            |

# **TODO** : to classify …​

| Property                  |      Value                      |
|---------------------------|---------------------------------|
| resourcesApplications     | "workspace"                     |
| sharedConf                |                                 | 
| xitiSwitch                |                                 |
| classDefaultRoles         | false                           |
| emailConfig               |                                 |
