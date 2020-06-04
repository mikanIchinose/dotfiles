"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Path = require("path");
const Fs = require("fs");
const vscode_1 = require("vscode");
const Messages = require("./messages");
const run_command_1 = require("./run-command");
let lastScript;
function yarnRunScript() {
    const scripts = readScripts();
    if (!scripts) {
        return;
    }
    const items = Object.keys(scripts).map((key) => {
        return { label: key, description: scripts[key] };
    });
    vscode_1.window.showQuickPick(items).then((value) => {
        lastScript = value.label;
        run_command_1.runCommand(['run', value.label]);
    });
}
exports.yarnRunScript = yarnRunScript;
;
function yarnTest() {
    const scripts = readScripts();
    if (!scripts) {
        return;
    }
    if (!scripts.test) {
        Messages.noTestScript();
        return;
    }
    lastScript = 'test';
    run_command_1.runCommand(['run', 'test']);
}
exports.yarnTest = yarnTest;
function yarnStart() {
    const scripts = readScripts();
    if (!scripts) {
        return;
    }
    if (!scripts.start) {
        Messages.noStartScript();
        return;
    }
    lastScript = 'start';
    run_command_1.runCommand(['run', 'start']);
}
exports.yarnStart = yarnStart;
function yarnBuild() {
    const scripts = readScripts();
    if (!scripts) {
        return;
    }
    if (!scripts.build) {
        Messages.noBuildScript();
        return;
    }
    lastScript = 'build';
    run_command_1.runCommand(['run', 'build']);
}
exports.yarnBuild = yarnBuild;
function yarnRunLastScript() {
    if (lastScript) {
        run_command_1.runCommand(['run', lastScript]);
    }
    else {
        Messages.noLastScript();
    }
}
exports.yarnRunLastScript = yarnRunLastScript;
const readScripts = function () {
    let filename = Path.join(vscode_1.workspace.rootPath, 'package.json');
    const confPackagejson = vscode_1.workspace.getConfiguration('yarn')['packageJson'];
    if (confPackagejson) {
        filename = Path.join(vscode_1.workspace.rootPath, confPackagejson);
    }
    const editor = vscode_1.window.activeTextEditor;
    if (editor && editor.document.fileName.endsWith("package.json")) {
        filename = editor.document.fileName;
    }
    try {
        const content = Fs.readFileSync(filename).toString();
        const json = JSON.parse(content);
        if (json.scripts) {
            return json.scripts;
        }
        Messages.noScriptsInfo();
        return null;
    }
    catch (ignored) {
        Messages.noPackageError();
        return null;
    }
};
//# sourceMappingURL=run.js.map