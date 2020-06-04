"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Fs = require("fs");
const Path = require("path");
const vscode_1 = require("vscode");
const Messages = require("./messages");
const utils_1 = require("./utils");
function default_1() {
    if (!vscode_1.workspace.rootPath) {
        Messages.noProjectOpenError();
        return;
    }
    if (utils_1.packageExists()) {
        Messages.alreadyExistsError();
        return;
    }
    const directory = Path.basename(vscode_1.workspace.rootPath);
    const options = {
        name: directory,
        version: '1.0.0',
        description: '',
        main: 'index.js',
        scripts: {
            test: 'echo "Error: no test specified" && exit 1'
        },
        author: '',
        license: 'ISC'
    };
    vscode_1.window.showInputBox({
        prompt: 'Package name',
        placeHolder: 'Package name...',
        value: directory
    })
        .then((value) => {
        if (value) {
            options.name = value.toLowerCase();
        }
        return vscode_1.window.showInputBox({
            prompt: 'Version',
            placeHolder: '1.0.0',
            value: '1.0.0'
        });
    })
        .then((value) => {
        if (value) {
            options.version = value.toString();
        }
        return vscode_1.window.showInputBox({
            prompt: 'Description',
            placeHolder: 'Package description'
        });
    })
        .then((value) => {
        if (value) {
            options.description = value.toString();
        }
        return vscode_1.window.showInputBox({
            prompt: 'main (entry point)',
            value: 'index.js'
        });
    })
        .then((value) => {
        if (value) {
            options.main = value.toString();
        }
        return vscode_1.window.showInputBox({
            prompt: 'Test script'
        });
    })
        .then((value) => {
        if (value) {
            options.scripts.test = value.toString();
        }
        return vscode_1.window.showInputBox({
            prompt: 'Author'
        });
    })
        .then((value) => {
        if (value) {
            options.author = value.toString();
        }
        return vscode_1.window.showInputBox({
            prompt: 'License',
            value: 'ISC'
        });
    })
        .then((value) => {
        if (value) {
            options.license = value.toString();
        }
        const packageJson = JSON.stringify(options, null, 4);
        const path = Path.join(vscode_1.workspace.rootPath, 'package.json');
        Fs.writeFile(path, packageJson, (err) => {
            if (err) {
                Messages.cannotWriteError();
            }
            else {
                Messages.createdInfo();
                vscode_1.workspace.openTextDocument(path).then((document) => {
                    vscode_1.window.showTextDocument(document);
                });
            }
        });
    });
}
exports.default = default_1;
;
//# sourceMappingURL=init.js.map