# Admin v2 - Troubleshooting

This document presents common admin v2 build issues and how to solve them

## Metadata version mismatch for module

Error:

```
Error: Metadata version mismatch for module /home/node/app/admin/src/main/ts/node_modules/@angular/core/core.d.ts, found version 4, expected 3/home/node/app/admin/src/main/ts/main.aot.ts (3,38): Cannot find module './aot/app/app.module.ngfactory'../admin/src/main/ts/main.aot.ts
Module not found: Error: Can't resolve './aot/app/app.module.ngfactory' in '/home/node/app/admin/src/main/ts'
resolve './aot/app/app.module.ngfactory' in '/home/node/app/admin/src/main/ts'
```

How to solve:

Please delete the folder `node_modules` in `entcore/admin/src/main/ts/` 

## Gulp series is not a function

Error:

```
npm WARN awesome-typescript-loader@3.5.0 requires a peer of typescript@^2 but none was installed.
Using springboard at /home/node/recette/
/home/node/app/admin/src/main/ts/gulpfile.js:28
gulp.task('build', gulp.series('clean', () => {
                        ^

TypeError: gulp.series is not a function
```

How to solve:

- Please delete the folder `node_modules` in `entcore/admin/src/main/ts/`
- If your branch is derived from `dev` branch please set the FRONT_TAG environment variable to the dev branch:

```
export FRONT_TAG=dev
```

- If your branch is derived from `next` branch please set the FRONT_TAG environment variable to the next branch:

```
export FRONT_TAG=next
```

## Entcore or Ngx-ode-* no matching version found

Error:

```
npm ERR! code ETARGET
npm ERR! notarget No matching version found for ngx-ode-ui@~4.0.0-dev
npm ERR! notarget In most cases you or one of your dependencies are requesting
npm ERR! notarget a package version that doesn't exist.
npm ERR! A complete log of this run can be found in:
npm ERR!     /.npm/_logs/2022-02-08T14_16_36_349Z-debug.log
Build step 'Exécuter un script shell' marked build as failure
Finished: FAILURE
```

How to solve:

- Please delete the folder `node_modules` in `entcore/admin/src/main/ts/`
- If your branch is derived from `dev` branch please set the FRONT_TAG environment variable to the dev branch:

```
export FRONT_TAG=dev
```

- If your branch is derived from `next` branch please set the FRONT_TAG environment variable to the next branch:

```
export FRONT_TAG=next
``` 

## Node Saas error

Error:

```
fs.js:961
  return binding.readdir(pathModule._makeLong(path), options.encoding);
                 ^

Error: ENOENT: no such file or directory, scandir '/home/node/app/node_modules/node-sass/vendor'
    at Error (native)
    at Object.fs.readdirSync (fs.js:961:18)
    at Object.getInstalledBinaries (/home/node/app/node_modules/node-sass/lib/extensions.js:133:13)
    at foundBinariesList (/home/node/app/node_modules/node-sass/lib/errors.js:20:15)
    at foundBinaries (/home/node/app/node_modules/node-sass/lib/errors.js:15:5)
    at Object.module.exports.missingBinary (/home/node/app/node_modules/node-sass/lib/errors.js:45:5)
    at module.exports (/home/node/app/node_modules/node-sass/lib/binding.js:15:30)
    at Object.<anonymous> (/home/node/app/node_modules/node-sass/lib/index.js:14:35)
    at Module._compile (module.js:570:32)
    at Object.Module._extensions..js (module.js:579:10)
```

How to solve:

```
npm rebuild node-sass
```