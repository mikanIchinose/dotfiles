"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const utils_1 = require("./utils");
const Messages = require("./messages");
const run_command_1 = require("./run-command");
function yarnAddPackages() {
    if (!utils_1.packageExists()) {
        Messages.noPackageError();
        return;
    }
    run_command_1.runCommand(['add']);
}
exports.yarnAddPackages = yarnAddPackages;
;
function yarnAddPackage() {
    return _addPackage(false);
}
exports.yarnAddPackage = yarnAddPackage;
;
function yarnAddPackageDev() {
    return _addPackage(true);
}
exports.yarnAddPackageDev = yarnAddPackageDev;
;
const _addPackage = function (dev) {
    if (!utils_1.packageExists()) {
        Messages.noPackageError();
        return;
    }
    vscode_1.window.showInputBox({
        prompt: 'Package to add',
        placeHolder: 'lodash, underscore, ...'
    })
        .then((value) => {
        if (!value) {
            Messages.noValueError();
            return;
        }
        const packages = value.split(' ');
        const hasSaveOption = packages.find((value) => {
            return value === '-D' ||
                value === '--dev' ||
                value === '-O' ||
                value === '--optional' ||
                value === '-E' ||
                value === '--exact';
        });
        const args = ['add', ...packages];
        if (hasSaveOption) {
            run_command_1.runCommand(args);
        }
        else {
            const save = dev ? '--dev' : '';
            run_command_1.runCommand([...args, save]);
        }
    });
};
//# sourceMappingURL=add.js.map