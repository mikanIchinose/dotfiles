"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const utils_1 = require("./utils");
const Messages = require("./messages");
const run_command_1 = require("./run-command");
function yarnRemovePackage() {
    return _removePackage();
}
exports.yarnRemovePackage = yarnRemovePackage;
;
const _removePackage = function () {
    if (!utils_1.packageExists()) {
        Messages.noPackageError();
        return;
    }
    vscode_1.window.showInputBox({
        prompt: 'Package to remove',
        placeHolder: 'lodash, underscore, ...'
    })
        .then((value) => {
        if (!value) {
            Messages.noValueError();
            return;
        }
        const packages = value.split(' ');
        const args = ['remove', ...packages];
        run_command_1.runCommand(args);
    });
};
//# sourceMappingURL=remove.js.map