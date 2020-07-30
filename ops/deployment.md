# Deployment

In the following guide we are going to create a platform from scratch using consul.
> This guide consider that your are using vertx-service-launcher from 1.0.7

## Getting started

### Prepare folders

In your root folder *my/root/path*, create 4 subfolders:
- assets: will contains static content
- mods: will contains modules
- conf: will contains config files
- tmp: will contains config files

### Prepare configuration

Create a config file *conf/entcore.json* for the launcher:

```json
{
    "assets-path": "my/root/path",
    "clean": true,
    "consulMods": ["https://MY_CONSUL_SERVER/v1/kv/service/SCOPE1","http://MY_CONSUL_SERVER/v1/kv/service/SCOPE2"],
    "consulSync": "https://MY_CONSUL_SERVER/v1/kv/service/SYNC_FOLDER",
    "consuleNode": "app1",
    "pullEverySeconds": 1,
    "maxRetry": 3,
    "extraMavenRepositories": {
        "snapshots": [
            {
                "uri": "https://MY_MAVEN_REPO/MY_SNAPSHOT_PATH",
                "credential": "MY_BASE64_BASIC_TOKEN"
            }
        ],
        "releases": [
            {
                "uri": "https://MY_MAVEN_REPO/MY_RELEASE/PATH",
                "credential": "MY_BASE64_BASIC_TOKEN"
            }
        ]
    }
}
```

The file contains the following parameters:
- assets-path: The root path where the platform will be deployed
- clean: If enabled, the launcher will clean old artefact
- consulMods: An ordered list containing all Consul KV folder URIs. The launcher will watch recursively theses folders and merge values. SCOPE can be a string or a path (like *myapp/myenv/mynode*)
- consulSync: The Consul KV folder used to sync nodes (in case of cluster)
- consulNode: The name of the current node (in case of cluster)
- pullEverySeconds: An integer value to define the frequency of consulMods watch in seconds (see consulMods parameter)
- maxRetry: The number of times that the launcher will try to redeploy a module if the deployment fails
- extraMavenRepositories: a list of snapshot (and releases) repositories. The credential parameter is optional (required only if the repository has credentials)

### Start the launcher

Run the following command to start the launcher:

```shell
java -jar vertx-service-launcher.jar -Dvertx.services.path=my/root/path -Djava.io.tmpdir=my/root/path/tmp  -conf my/root/path/conf/entcore.json
```

The launcher will scan all consulMods URL and déploy all services defined in theses folders.
A config file will be dumped in *my/root/path/tmp/history*. It contains all deployed modules with their configuration.

## Watcher

The launcher will scan *consulMods* periodically (see *pullEverySeconds* parameter) in order to detect:
- new modules: if a module is added in consul the launcher will deploy it in every nodes
- deleted modules: if a module is deleted from consul the launcher will undeploy it in every nodes
- config changes: if a configuration is changed in consul the launcher will restart the related module it in every nodes
- version changes: if a version number is changed in consul the launcher will undeploy the previous version and deploy the current version

## Configuration

### Order of keys

The *consulMods* contains a list of configuration folder and each configuration folder contains a list of module and their configuration.
The order of keys matters, the launcher will sort configurations by keys and deploys modules in this order.
Keys are sorted using alphanumerical order (consul ui use the same order).

> If the configuration contains the keyword *waitDeploy*, the launcher will wait for the module to be deployed successfully else it will start deployment of the next module.

### Inheritance

The parameter *consulMods* can contains one or more configuration folder.
So the launcher will watch and scan each folders and then merge configuration from each folder using the config's *key*.

The inheritance make possible to:
- override a configuration
- add a configuration

#### Override

Let's suppose we have 2 consul folders:

```json
{
    "consulMods": ["https://MY_CONSUL_SERVER/v1/kv/service/SCOPE1","http://MY_CONSUL_SERVER/v1/kv/service/SCOPE2"]
}
```

Let's define a module with key *000-mymodule* in SCOPE1.
Let's add a module with the same key *000-mymodule* in SCOPE2.
The launcher will use the configuration defined in SCOPE2.


#### Add

Let's suppose we have 2 consul folders:

```json
{
    "consulMods": ["https://MY_CONSUL_SERVER/v1/kv/service/SCOPE1","http://MY_CONSUL_SERVER/v1/kv/service/SCOPE2"]
}
```

Let's define a module with key *000-mymodule0* in SCOPE1.
Let's define a module with the key *001-mymodule2* in SCOPE2.
The launcher will merge both SCOPE and will deploy *mymodule0* and *mymodule1*.

## Migration script

This script help to migrate old configuration files to consul:
https://raw.githubusercontent.com/opendigitaleducation/vertx-service-launcher/feat-autodeploy/migration/consulMigrationNode.js

Run the script using the following command:

```shell
node consulMigrationNode.js BASE_SCOPE SCOPE PARENT_SCOPE CONFIG_FILE HOST
```

- BASE_SCOPE: the root folder in consul for both SCOPE and PARENT_SCOPE
- SCOPE: the destination folder in consul. All modules defined in the config file will be saved in this folder
- PARENT_SCOPE: the script check the parent scope before adding a new key. If the key is already present in the parent (and the value is the same) => the key is ignored
- CONFIG_FILE: the path to the config file to migrate
- HOST: the consul hostname (and port if needed)

## Module type

The launcher can deploy the following service type:
- default: fat-JAR files containing vertx verticles
- assets: static files archived in a tar.gz file. Static files are deployed in *my/root/path/assets*
- js: JS files archived in a tar.gz. The tar file is unarchived in *my/root/path/assets/js*
- theme: CSS files archived in a tar.gz. The tar file is unarchived in *my/root/path/assets/themes*

The service is defined in the configuration as followed:

```json
{
    "name": "org.entcore~assets~3.10-SNAPSHOT",
    "type": "assets"
}
```

JS and Theme service has 2 more optional params:
- output-dir: Define a custom destination folder
- dist-dir: Define the root location in the tar file






