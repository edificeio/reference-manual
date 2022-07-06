This document describes the development environment installation for frontend and backend developers

1.  Install Docker. Docker Compose

2.  Install Git and configure SSH Key for Github

3.  Clone a Springboard and run it

> **Note**
>
> Code Editor software is up to developer’s choice

# Basic Installation

## 1. Install Docker and Docker Compose

1.  Install Docker by following the reference documentation : <https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository>

2.  Grant non-root user to run Docker : <https://docs.docker.com/install/linux/linux-postinstall/>

3.  Install Docker Compose by following the reference documentation : <https://docs.docker.com/compose/install/#install-using-pip>

> **Warning**
>
> Step 2 is mandatory

> **Note**
>
> Installation’s documentation for others OS is available here : <https://docs.docker.com/install/>

## 2. Install Git and configure SSH Key for Github

Install Git:

    $ sudo apt install git

To set SSH key for Github, please follow the reference documentations below:

-   <https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/>

-   <https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/>

## 3. Clone a Springboard and run it

Get the Springboard’s boilerplate repository:

        $ git clone git@github.com:entcore/springboard.git
        $ cd springboard

Run it (first time)

        ./build.sh init
        ./build.sh generateConf
        ./build.sh buildFront
        ./build.sh run

For the next runs, just launch

    ./build.sh run

Available commands for build.sh script are:

                    clean : clean springboard and docker's containers
                     init : fetch files and artefacts useful for springboard's execution
             generateConf : generate an vertx configuration file (ent-core.json) from conf.properties
                      run : run databases and vertx in distinct containers
                     stop : stop containers
          integrationTest : run integration tests
               buildFront : fetch widgets and themes using Bower and run Gulp build. (/!\ first run can be long because of node-sass's rebuild).
                  archive : make an archive with folder /mods /assets /static
                  publish : upload the archive on nexus

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

Check version:

    $ gradle -v

## Install your favorite Java IDE

## Monitor the containers

Docker Compose names container with [COMPOSE\_PROJECT\_NAME](https://docs.docker.com/compose/reference/envvars/#compose_project_name) convention. In our context container’s name are prepended with Springboard’s directory name (${SPRINGBOARD\_DIR}).

You can run the below command to monitor your container’s activity

-   List running’s containers : `` docker ps` ``

-   List all containers : `docker ps -a`

-   Open Neo4j’s shell : `docker exec -it ${SPRINGBOARD_DIR}_neo4j_1 bin/neo4j-shell`

-   Open PostgrSQL’s shell : `docker exec -it ${SPRINGBOARD_DIR}_postgres_1 psql -U web-education ong`

-   Open MongoDB’s shell : `docker exec -it ${SPRINGBOARD_DIR}_mongo_1 mongo one_gridfs`

-   Open a Bash’s shell on vertx’s container : `docker exec -it ${SPRINGBOARD_DIR}_vertx_1 bash`

-   Display Vertx’s logs : `docker logs -f ${SPRINGBOARD_DIR}_vertx_1`

-   Display all containers logs : `docker-compose logs -f`

## Change Vertx log level

## Map local directories to container’s volume

### use your maven local

Uncomment

    #    - ~/.m2:/home/vertx/.m2

### Use your local data

## Use Neo4j console

Add the next port’s mapping in neo4j container’s description

        ports:
            - "7474:7474"
            - "7687:7687"

Enable Bolt Protocol in neo4j-conf/neo4j.conf

    dbms.connector.bolt.enabled=true

Neo4j’s Console is accessible via <http://localhost:7474/browser>

## Enable Remote Debugging

As vertx services are running inside a docker container, it is not possible to enable local debugging. So we will use remote debugging to bypass this issue.

First, make sure you have exposed the remote agent port from the vertx docker container.

To do so, open your springboard directory and edit the file "docker-compose.yml". It should contains the following port configuration:

    vertx:
      image: opendigitaleducation/vertx-service-launcher:1.0.0
      user: "1000:1000"
      ports:
        - "8090:8090"
        - "5000:5000"

Then, restart your docker container using:

    ./build.sh stop init

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

# For Mac OS Installation

## 1. Install Docker
## 2. Configure `sed` correctly

Follow these steps: https://medium.com/@bramblexu/install-gnu-sed-on-mac-os-and-set-it-as-default-7c17ef1b8f64

## 3. Ode User and bower user

- Add ODE User in the gradle.properties file
- Create bower credentials file to your root folder (~/.bower_credentials) and add credentials info

## 4. Build.Gradle

Comment this line in build.gradle file : `deployment "fr.openent:lool:$loolVersion:deployment"`

## 5. Running the springboard

        ./build.sh init
        ./build.sh generateConf
        ./build.sh buildFront
        ./build.sh run

## 6. Warnings

- It'll take time to launch everything on Mac OS, so you can check the progression of the "run" command with :

  
`docker-compose logs -f vertx`

  
- Sometimes, `recette_neo4j_1` in the `recette` container will stop. You have to run it manually.
- Don't forget to add the `neo4j ports` in the docker-compose.yml file.

## 7. Integration Test

- You can run the test or go to step 2 to configure data manually.
- Please check `recette_neo4j_1` is running before.
- Then run `./build.sh integrationTest`
