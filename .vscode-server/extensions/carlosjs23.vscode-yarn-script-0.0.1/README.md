# Node yarn Script Running for Visual Studio Code

Original plugin: [npm-scripts](https://github.com/Microsoft/vscode-npm-scripts)
Author: egamma

This extension supports running yarn scripts defined in the `package.json` file.

## Features
- Install yarn pkg for you.
- Run yarn install.
- Run a script (`yarn run myscript`) defined in the `package.json` by picking a script
defined in the `scripts` section of the `package.json`.
- Rerun the last yarn script you have executed using this extension.
- Terminate a running script

## Using

The commands defined by this extensions are in the `yarn` category.


## Settings

- `yarn.runInTerminal` defines whether the command is run
in a terminal window or whether the output form the command is shown in the `Output` window. The default is to show the output in the terminal.
- `yarn.includeDirectories` define additional directories that include a  `package.json`.
- `yarn.useRootDirectory` define whether the root directory of the workspace should be ignored, the default is `false`.
- `yarn.runSilent` run yarn commands with the `--silent` option, the default is `false`.
- `yarn.bin` custom yarn bin name, the default is `yarn`.

##### Example
```javascript
{
	"yarn.runInTerminal": false,
	"yarn.includeDirectories": [
		"subdir1/path",
		"subdir2/path"
	]
}
```

## Keyboard Shortcuts

The extension defines a chording keyboard shortcut for the `R` key. As a consequence an existing keybinding for `R` is not executed immediately. If this is not desired, then please bind another key for these commands, see the [customization](https://code.visualstudio.com/docs/customization/keybindings) documentation.

## Release Notes

- 0.0.1 switch package manager from npm to yarn
