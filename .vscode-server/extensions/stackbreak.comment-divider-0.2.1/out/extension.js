"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const constants_1 = require("./constants");
const commands_1 = require("./commands");
function activate(context) {
    context.subscriptions.push(vscode_1.commands.registerCommand(`${constants_1.EXT_ID}.makeMainHeader`, commands_1.mainHeaderCommand));
    context.subscriptions.push(vscode_1.commands.registerCommand(`${constants_1.EXT_ID}.makeSubHeader`, commands_1.subHeaderCommand));
    context.subscriptions.push(vscode_1.commands.registerCommand(`${constants_1.EXT_ID}.insertSolidLine`, commands_1.solidLineCommand));
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map