"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const utils_1 = require("./utils");
const Messages = require("./messages");
const run_command_1 = require("./run-command");
function yarnRawCommand() {
    if (!utils_1.packageExists()) {
        Messages.noPackageError();
        return;
    }
    vscode_1.window.showInputBox({
        prompt: 'yarn command',
        placeHolder: 'install lodash@latest, ...'
    })
        .then((value) => {
        if (!value) {
            Messages.noValueError();
            return;
        }
        const args = value.split(' ');
        run_command_1.runCommand(args);
    });
}
exports.yarnRawCommand = yarnRawCommand;
;
//# sourceMappingURL=raw.js.map