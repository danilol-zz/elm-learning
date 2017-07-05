# Elm development template
This is a template used at COYA AG to develop Elm based applications.

## Why?
Elm reactor is a really nice tool, but we need some developer `opinionated` utilities, like liverload, configuration files and cli scripts.

## How?
We have a custom `bin/` directory with different yarn tasks to run: servers, tests, builds and deploys. Them can be found in the `pakage.json` under the `scripts` section.

## Installation
Run `yarn install`


## Usage
Run `yarn run scriptName` for example: `yarn run server`

### yarn scripts
Yarn scripts have a `--help` flag to check what you can do with them.

**NOTE:** to pass script arguments you need to add `--` after the script name.

**For example the server task has this output:**

```bash
$ yarn run server -- --help
yarn run v0.27.5
$ bin/server "--help"
You can use this flags together with this script:
  -h  to change the default hostname 0.0.0.0
  -p  to change the default port 3000
  -r to change the default livereload port 35729
  -d to change the default livereload directory src
Done in 0.20s.
```

All the scripts are under the `bin` path. You can run them without `yarn`.

**For example you can run the server script with:**

```bash
$ bin/server --help
```

**instead of:**

```bash
$ yarn run server -- --help
```

**WARNING:** pleas add --help flag to the new scripts that you add to flow the same patterns
