"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const utils_1 = require("./utils");
const Messages = require("./messages");
const run_command_1 = require("./run-command");
function yarnPublish() {
    _do('publish');
}
exports.yarnPublish = yarnPublish;
;
const _do = function (cmd) {
    if (!utils_1.packageExists()) {
        Messages.noPackageError();
        return;
    }
    vscode_1.window.showInputBox({
        prompt: 'Optional tag (enter to skip tag)',
        placeHolder: 'latest, 1.0.0, ...'
    })
        .then((value) => {
        if (!value) {
            run_command_1.runCommand([cmd]);
            return;
        }
        if (value.includes(' ')) {
            Messages.invalidTagError();
            return;
        }
        run_command_1.runCommand([cmd, '--tag', value]);
    });
};
//# sourceMappingURL=publish.js.map