# MacOS knwon problems

- [MacOS knwon problems](#macos-knwon-problems)
  - [After some time I cannot log in](#after-some-time-i-cannot-log-in)
  - [After some time docker commands timeout](#after-some-time-docker-commands-timeout)
  - [I am tired of restarting Docker](#i-am-tired-of-restarting-docker)
  - [I want to launch VertX from IntelliJ](#i-want-to-launch-vertx-from-intellij)


## After some time I cannot log in

In your springboard directory execute the following command

```
dc down
dc up -d
```

## After some time docker commands timeout

Restart Docker Desktop.

## I am tired of restarting Docker

1. In your springboard directory execute the following command

```
dc down
```

2. Remove neo4j, and postgre from your docker-compose.yml

3. Install PostgresApp by following the instructions here https://postgresapp.com/

4. Choose to install Postgres14 when prompted

5. Download the archive of Neo4J  https://neo4j.com/download-thanks/?edition=enterprise&release=3.2.14&flavour=unix&_gl=1*ips51v*_ga*MTI4MjIyODg5NS4xNjc0MTIyNjA3*_ga_DL38Q8KGQC*MTY3NTg2NTczOC4zLjAuMTY3NTg2NTczOC4wLjAuMA.

6. Untar it where you want your installation to be

7. Move to the folder containing your untarred archive and execute the following commands

```
ln -s neo4j-enterprise-3.2.14 neo4j
cd neo4j
cat <<EOT >> ./conf/neo4j.conf
dbms.security.auth_enabled=true
dbms.allow_format_migration=true
dbms.connector.bolt.enabled=true
dbms.connector.http.enabled=true
dbms.connector.http.listen_address=0.0.0.0:7474
dbms.auto_index.nodes.enabled=true
dbms.auto_index.nodes.keys=externalId,firstName,lastName,displayName,displayNameSearchField
dbms.shell.enabled=true
dbms.shell.host=127.0.0.1
dbms.jvm.additional=-XX:+UseG1GC
dbms.jvm.additional=-XX:-OmitStackTraceInFastThrow
dbms.jvm.additional=-XX:+AlwaysPreTouch
dbms.jvm.additional=-XX:+UnlockExperimentalVMOptions
dbms.jvm.additional=-XX:+TrustFinalNonStaticFields
dbms.jvm.additional=-XX:+DisableExplicitGC
server.jvm.additional=-XX:-MaxFDLimit
dbms.jvm.additional=-Djdk.tls.ephemeralDHKeySize=2048
dbms.windows_service_name=neo4j
dbms.jvm.additional=-Dunsupported.dbms.udc.source=tarball
cypher.default_language_version=2.3
EOT 
./bin/neo4j start
```
8. Visit http://localhost:7474 and change the neo4j's password as requested
9. In your springboard json configuration set neo4j's credentials in org.entcore~infra~* configuration (see example below) :

```
    {
      "name": "org.entcore~infra~4.6-explorer-SNAPSHOT",
      "waitDeploy": true,
      "config": {
        "port": 8001,
        ...
        "neo4jConfig": {
          "server-uri": "http://neo4j:7474/db/data/",
          "slave-readonly": false,
          "username": "neo4j",
          "password": "ThePasswordYouJustSet",
          "legacy-indexes": [
            {
              "for": "node",
              "name": "node_auto_index",
              "type": "fulltext"
            }
          ]
        }, 
        ...
      }
    }
```

*** Warning !!! *** Look for other neo4jConfig configuraiton blocks that might need to be updated.

## I want to launch VertX from IntelliJ

Execute the following command at the root of your idea project (customize the file based on your installation)

```
mkdir .run
cat <<EOT >> ./.run/vertxapp.run.xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="vertxapp" type="Application" factoryName="Application">
    <option name="ALTERNATIVE_JRE_PATH" value="$USER_HOME$/Library/Java/JavaVirtualMachines/corretto-1.8.0_352/Contents/Home" />
    <option name="ALTERNATIVE_JRE_PATH_ENABLED" value="true" />
    <option name="MAIN_CLASS_NAME" value="com.opendigitaleducation.launcher.VertxWithPreConfigLauncher" />
    <module name="vertx-service-launcher" />
    <option name="PROGRAM_PARAMETERS" value="run com.opendigitaleducation.launcher.VertxServiceLauncher -conf $PROJECT_DIR$/../recette_validation/ent-core-nodocker-scrapbook.json -Dvertx.disableFileCaching=true -Dvertx.services.path=$PROJECT_DIR$/../recette_validation/mods" />
    <method v="2">
      <option name="Make" enabled="true" />
    </method>
  </configuration>
</component>
EOT
```