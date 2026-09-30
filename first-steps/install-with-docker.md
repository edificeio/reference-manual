This document describes the development environment installation for frontend and backend developers

1.  Install Docker & Docker Compose

2.  Install Git and configure SSH Key for Github

3.  Clone a Springboard and run it

> **Note**
>
> Code Editor software is up to developer’s choice

# Basic Installation

## 1. Install Docker and Docker Compose

1.  Install Docker by following the reference documentation : <https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository>

2.  Grant non-root user to run Docker : <https://docs.docker.com/install/linux/linux-postinstall/>

3.  Install the Docker Compose plugin (`docker compose`) by following the reference documentation : <https://docs.docker.com/compose/install/linux/>. The legacy `docker-compose` binary is not required: `build.sh` falls back to `docker compose` when it is missing.

> **Warning**
>
> Step 2 is mandatory

> **Note**
>
> Installation’s documentation for others OS is available here : <https://docs.docker.com/install/>
>
> On Windows, please read [Windows (WSL 2)](#windows-wsl-2) first.

## 2. Install Git and configure SSH Key for Github

Install Git:

    $ sudo apt install git

To set SSH key for Github, please follow the reference documentations below:

-   <https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/>

-   <https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/>

## 3. Clone a Springboard and run it
        
Two public springboards are available:

| Springboard | Content |
| ----------- | ------- |
| [edificeio/springboard](https://github.com/edificeio/springboard) | Boilerplate: core modules only (portal, directory, conversation, workspace, ...) |
| [OPEN-ENT-NG/springboard-open-ent](https://github.com/OPEN-ENT-NG/springboard-open-ent) | Same base with many more applications (blog, forum, mindmap, collaborative wall, ...) |

Clone one of them:

        $ git clone https://github.com/edificeio/springboard.git
        $ cd springboard

> **Note**
>
> No credentials are needed: backend artefacts are downloaded from the public Nexus group (`https://maven.opendigitaleducation.com/nexus/content/groups/public`) and frontend packages from npmjs. The `NEXUS_*`, `NPM_TOKEN` and `BOWER_*` variables used by `build.sh` can be left unset.

> **Warning**
>
> Make sure you have at least 15 GB of free disk space: Docker images, Gradle cache, modules and node modules add up quickly. A full disk can freeze Docker (and WSL on Windows).

Run it (first time)

        ./build.sh init
        ./build.sh generateConf
        ./build.sh buildFront
        ./build.sh run

What each step does:

- `init` fetches the springboard files (templates, default configuration) with Gradle.
- `generateConf` downloads the modules into `mods/`, generates `docker-compose.yml` and `ent-core.json` from `conf.properties`, then fills the list of services of `ent-core.json` from the `template.j2` of each module (with the `opendigitaleducation/vertx-cli` image). The first run downloads every module and can take several minutes without printing much.
- `buildFront` installs themes, widgets and front libraries (yarn and pnpm in the `opendigitaleducation/node:18-alpine-pnpm` image) and copies the static files of each module into `static/`.
- `run` starts the databases and middlewares, then vertx.

Check that everything is up:

        docker compose ps
        docker compose logs -f vertx

All containers should be `healthy`. The first start of vertx takes a minute or two. Then open:

- the ENT: <http://localhost:8090>
- the Traefik dashboard (routes registered by the modules): <http://localhost:8080>

For the next runs, just launch

    ./build.sh stop run

After changing `conf.properties` or module versions, run `./build.sh generateConf` again, then `docker compose restart vertx`.

### Local customization

`generateConf` regenerates `docker-compose.yml`, so do not edit it. Put your local changes in a `docker-compose.override.yml` file at the root of the springboard: Docker Compose merges it automatically. Keep it out of git with:

    echo docker-compose.override.yml >> .git/info/exclude

For example, to reach the databases from your host:

```yaml
services:
  postgres:
    ports: ["5432:5432"]
  mongo:
    ports: ["27017:27017"]
  neo4j:
    ports: ["7474:7474", "7687:7687"]
```

Available commands for build.sh script are:

                    clean : clean springboard and docker's containers
                     init : fetch files and artefacts useful for springboard's execution
             generateConf : download modules, generate docker-compose.yml and the vertx configuration file (ent-core.json) from conf.properties
                      run : run databases and vertx in distinct containers
                     stop : stop containers
                     down : stop and remove containers
          integrationTest : run integration tests
               buildFront : install themes, widgets and front libraries (yarn/pnpm) and copy modules' static files
                  archive : make an archive with folder /assets /static
                  publish : upload the archive on nexus
                  
## 4. Clone entcore, infra-front, clean install and watchers.

    $ git clone https://github.com/edificeio/entcore.git
    $ git clone https://github.com/edificeio/infra-front.git
    

Clean install

    $./build.sh clean install
    
Watch infra-front 

    $./build.sh watch
    
Watch infra-front   

    $./build.sh -m=[module] watch
    (ex) $./build.sh -m=directory watch
    
You should see ressource copy on code change.    

# For Backend Development

## Install JDK 8

Installation:

    $ sudo add-apt-repository ppa:webupd8team/java
    $ sudo apt-get update
    $ sudo apt-get install oracle-java8-installer
    
    Other repo with java8 available (ppa:ts.sch.gr/ppa)
    

Check installation:

    $ java -version
    java version "1.8.0_152"
    Java(TM) SE Runtime Environment (build 1.8.0_152-b16)
    Java HotSpot(TM) 64-Bit Server VM (build 25.152-b16, mixed mode)

## Install Gradle 4.5

Installation:

    $ cd ~/apps
    $ wget https://services.gradle.org/distributions/gradle-4.5-bin.zip
    $ unzip gradle-4.5-bin.zip
    $ ln -s gradle-4.5 gradle
    $ rm gradle-4.5-bin.zip

Add binary to Path:

    $ echo PATH=\"\$HOME/apps/gradle/bin:\$PATH\" >> ~/.profile
    $ . ~/.profile
    
In case of error :  
    Failed to load native library 'libnative-platform.so' for Linux amd64.
    Please care about giving full rights on .gradle home folder (~/.gradle)
    drwxrwxrwx  5 root    root    4096 juil.  7 09:15 .gradle/

Check version:

    $ gradle -v

## Monitor the containers

Docker Compose names container with [COMPOSE\_PROJECT\_NAME](https://docs.docker.com/compose/reference/envvars/#compose_project_name) convention. In our context container’s name are prepended with Springboard’s directory name (${SPRINGBOARD\_DIR}).

You can run the below commands from the springboard directory to monitor your container’s activity

-   List the springboard’s containers : `docker compose ps`

-   Open Neo4j’s shell : `docker compose exec neo4j bin/neo4j-shell`

-   Open PostgreSQL’s shell : `docker compose exec postgres psql -U web-education ong`

-   Open MongoDB’s shell : `docker compose exec mongo mongosh one_gridfs`

-   Open a Bash’s shell on vertx’s container : `docker compose exec vertx bash`

-   Display Vertx’s logs : `docker compose logs -f vertx`

-   Display all containers logs : `docker compose logs -f`

### use your maven local

Uncomment

    #    - ~/.m2:/home/vertx/.m2

### Use your local data

## Use Neo4j console

Add the next port’s mapping in your `docker-compose.override.yml` (see [Local customization](#local-customization))

```yaml
services:
  neo4j:
    ports:
      - "7474:7474"
      - "7687:7687"
```

Enable Bolt Protocol in neo4j-conf/neo4j.conf

    dbms.connector.bolt.enabled=true

Neo4j’s Console is accessible via <http://localhost:7474/browser>

## Enable Remote Debugging

As vertx services are running inside a docker container, it is not possible to enable local debugging. So we will use remote debugging to bypass this issue.

First, make sure you have exposed the remote agent port from the vertx docker container.

To do so, add the following port configuration to your `docker-compose.override.yml` (see [Local customization](#local-customization)):

```yaml
services:
  vertx:
    ports:
      - "5000:5000"
```

Then, recreate the vertx container using:

    docker compose up -d vertx

> **Note**
>
> Behind the scene, remote debugging is enabled in vertx-service-launcher using this JVM property:
>
> `-agentlib:jdwp=transport=dt_socket,address=5000,server=y,suspend=n`
>
> This JVM option start an agent listening on port 5000 and letting your IDE debugging the application.

Your vertx container is now ready. Let’s configure your IDE.

To configure your IDE, create a new debug configuration and set followings properties:

-   Host = localhost (or any IP address allowing to reach the vertx container)

-   Port = 5000

-   Connection Type = Socket Attach

> **Warning**
>
> If you are using Eclipse you must select all source folders you would like to debug

You can now use your configuration to start a remote debug session.

# Windows (WSL 2)

The springboard runs on Windows through WSL 2 (Ubuntu), with Docker installed either inside WSL or with Docker Desktop (WSL 2 backend). Run every command from a WSL terminal.

- **Clone inside the WSL filesystem** (e.g. `~/springboard`), not under `/mnt/c` or `/mnt/d`. Windows drives are very slow from WSL and Gradle can hang while writing its cache there.

- **Check the free space of the drive hosting your WSL distribution** (usually `C:`). The WSL virtual disk grows with images and caches; when the drive is full, WSL freezes (no new terminal can be opened). To move the distribution to another drive:

        wsl --shutdown
        wsl --manage Ubuntu --move D:\wsl\Ubuntu

    You can also let the virtual disk give back freed space, in `%UserProfile%\.wslconfig`:

        [experimental]
        sparseVhd=true

# Troubleshooting

| Symptom | Cause and fix |
| ------- | ------------- |
| `Failed to load native library 'libnative-platform.so'` during `init` | `~/.gradle` (or `~/.m2`) was created by Docker and belongs to root. Fix it with `sudo chown -R $(id -u):$(id -g) ~/.gradle ~/.m2` |
| `docker-compose: command not found` | Only Compose v2 is installed. Recent versions of `build.sh` fall back to `docker compose`; otherwise create a wrapper: `printf '#!/bin/sh\nexec docker compose "$@"\n' \| sudo tee /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose` |
| `cp: cannot stat 'mods/...-fat.jar/public': Not a directory` at the end of `buildFront` | Harmless: the copy loop also goes through the fat jars, which are not directories |
| Vertx logs `The -conf argument does not point to an existing file` | `ent-core.json` is not mounted where the launcher expects it, or is not readable by the vertx user. Check that the vertx service of `docker-compose.yml` defines `VERTX_CONF_PATH=/srv/springboard/conf/vertx.conf`, and that `ent-core.json` is readable (`ls -l ent-core.json`) |
| Vertx logs `Missing services to deploy` and `ent-core.json` ends with `{{generatedServicesPath\|safe}}` | The services list was not generated. Run `./build.sh generateConf` again (it calls `vertx-cli`) and check its output |

# For Mac OS Installation

## 0. Descriptors configuration

As you will be handling multiple databases which will need to manipulate many files you need to increase the number of files that can be opened by your system.

1. Execute the following commands

```
cat <<EOT >> /Library/LaunchDaemons/limit.maxfiles.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>64000</string>
      <string>200000</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
  </dict>
</plist>
EOT

sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist

cat <<EOT >> ~/.zprofile
# Changes the ulimit limits.
ulimit -Sn 64000      # Increase open files.
ulimit -Sl unlimited # Increase max locked memory.
EOT

```

2. Reboot your machine

## 1. Brew

c.f. https://brew.sh/index_fr

## 2. sdkman

c.f. https://sdkman.io/install

## 3. Java

```
sdk install java 8.0.352-amzn
```

## 4. Gradle

Execute the following command

```
sdk install gradle 4.5
```

## 5. NVM and Node

Execute the following command

```
brew install nvm
echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.zshrc
nvm install 10
```

## 6. Maven

Follow the instructions listed here https://maven.apache.org/install.html.

## 7. Docker Desktop

**Warning !!!** Before you dive into the installation of Docker, keep in mind that you need to select the right executable for your chip (it will probably be an Apple Silicon one if your have a recent computer).

Follow the instructions here https://docs.docker.com/desktop/install/mac-install/.

After the installation, execute the following command to check that docker compose is working properly

```
docker-compose -v
```

If an error is returned, install it via brew https://formulae.brew.sh/formula/docker-compose.


## 8. Configure `sed` and `xargs`

For `sed`, follow these steps: https://medium.com/@bramblexu/install-gnu-sed-on-mac-os-and-set-it-as-default-7c17ef1b8f64

For `xargs`, execute the following command

```
brew install findutils
```

It will install gxargs which runs exactly as GNU xargs.

## 9. Ode User and bower user

- Add ODE User in the gradle.properties file
- Create bower credentials file to your root folder (~/.bower_credentials) and add credentials info

## 10. Build.Gradle

# Running the springboard

        ./build-noDocker.sh init
        ./build-noDocker.sh generateConf
        ./build-noDocker.sh buildFront
        ./build-noDocker.sh run

In general, you will have to use the script `build-noDocker.sh` instad of the script `build.sh` in the different projects to build the assets.

# Integration Test

- You can run the test or go to step 2 to configure data manually.
- Please check `recette_neo4j_1` is running before.
- Then run `./build.sh integrationTest`