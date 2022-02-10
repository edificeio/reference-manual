# Admin v2 - Build Process

This document presents the admin v2 build process for developers.

## Required tools

- git
- docker
- docker-compose

## Clone the project

The admin v2 project is located in the `entcore` project, in the `admin` folder.

Clone `entcore` project from github:

```
git clone https://github.com/opendigitaleducation/entcore.git
```

## Build

This section describes the different build tasks available.

---
**IMPORTANT:** 
All tasks will run under Docker containers. Please make sure Docker is running in your system.

---

### Frontend Dev Server mode

To use the dev server mode from Angular, please run this command:

```
./build.sh ngWatch
```

Admin v2 will be available at http://localhost:4200/admin

(This command will run the traditional `npm run start` command under a node v12 container)

### Backend

To build backend files, please run this command:

```
./build.sh -m=admin buildGradle
```

This command will install the maven artefact in your local maven repository.

### Build Admin Maven Artefact

To build both frontend and backend files and generate the admin v2 maven artefact, please run this command:

```
./build.sh -m=admin install
```

This command will install the maven artefact in your local maven repository.


## Deploy

To deploy admin maven artefact in your local springboard, please follow these instructions:

In your local springboard, run:

```
./build.sh stop
rm -rf mods/org.entcore~admin~${version}/
./build.sh run
```

Replace `${version}` with actual entcore version, example:

```
rm -rf mods/org.entcore~admin~4.0-SNAPSHOT
```

Admin v2 will be available at http://localhost:8090/admin
