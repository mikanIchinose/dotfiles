'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const prettyfierFactory_1 = require("./prettyfierFactory");
// This method is called when the extension is activated.
// The extension is activated the very first time the command is executed.
function activate(context) {
    const MD_MODE = { language: "markdown" };
    context.subscriptions.push(vscode.languages.registerDocumentRangeFormattingEditProvider(MD_MODE, prettyfierFactory_1.getDocumentRangePrettyfier()), vscode.languages.registerDocumentFormattingEditProvider(MD_MODE, prettyfierFactory_1.getDocumentPrettyfier()));
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map