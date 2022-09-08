# Admin v2 - Build And Deploy Process

This document presents the admin v2 build and deploy process for developers.

Mac OS X users are facing performance issues while building the app with Docker, so we will also describe how to build the app with node and gradle command line tools for better performance and developer experience :)

## Required tools

- Git
- Docker OR Gradle (4.5.1) and NodeJS (16)

## Clone the project

The admin v2 project is located in the `entcore` project, in the `admin` folder.

Clone `entcore` project from github:

```
git clone https://github.com/opendigitaleducation/entcore.git
```

## Build the Admin Maven Artefact

To build both frontend and backend files and generate the admin v2 maven artefact, please run this command:

with Docker:

```
./build.sh -m=admin install
```

with Node and Gradle:

```
cd admin/src/main/ts
npm install && npm rm --no-save ngx-ode-core ngx-ode-sijil ngx-ode-ui && npm install --no-save ngx-ode-core@$BRANCH_NAME ngx-ode-sijil@$BRANCH_NAME ngx-ode-ui@$BRANCH_NAME && npm run build-docker-prod
gradle :admin:clean :admin:shadowJar :admin:install :admin:publishToMavenLocal
```

where `$BRANCH_NAME` is the name of your current git branch.

This command will install the maven artefact in your local maven repository.

## Deploy the Artefact in your Springboard

If it's the first time you start your springboard then there's nothing to do :) The springboard will get the admin maven artefact from your local maven repository, just make sure the volume `~/.m2:/home/vertx/.m2` is not commented in your `docker-compose.yml`.

To redeploy admin maven artefact in your local springboard, you just need to delete existing admin mod in the springboard mods folder and restart vertx. Please follow these instructions:

In your local springboard, run:

```
docker-compose stop vertx
rm -rf mods/org.entcore~admin~${version}/
docker-compose up -d vertx
```

Replace `${version}` with actual entcore version, example:

```
rm -rf mods/org.entcore~admin~4.0-SNAPSHOT
```

Admin v2 will be available at http://localhost:8090/admin

## Use Frontend Dev Server mode

To optimise your developing time, please use the Angular dev server mode, you will benefit of hot reload after code editing.

NOTE: Before using dev server the first time, you need to build entcore and deploy it to your springboard. See the "Build Admin Maven Artefact" and "Deploy" section above.

To use the dev server, please run this command:

with Docker:

```
./build.sh ngWatch
```

with Node:

```
cd admin/src/main/ts
npm start
```

Admin v2 will be available at http://localhost:4200

NOTE: You need to be authenticated before you can use adminv2 app, please go to http://localhost:8090 and authenticate with an ADML/ADMC user. Then you can come back to http://localhost:4200 and use the adminv2 app with dev server mode.