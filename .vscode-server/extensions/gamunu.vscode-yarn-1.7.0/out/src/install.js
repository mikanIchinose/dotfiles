"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("./utils");
const Messages = require("./messages");
const run_command_1 = require("./run-command");
function yarnInstallPackages(arg) {
    if (!utils_1.packageExists(arg)) {
        Messages.noPackageError();
        return;
    }
    run_command_1.runCommand(['install'], arg);
}
exports.yarnInstallPackages = yarnInstallPackages;
;
//# sourceMappingURL=install.js.map