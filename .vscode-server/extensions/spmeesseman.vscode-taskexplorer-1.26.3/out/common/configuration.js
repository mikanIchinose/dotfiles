"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const extensionName = "taskExplorer";
class Configuration {
    constructor() {
        this._onDidChange = new vscode_1.EventEmitter();
        this.configuration = vscode_1.workspace.getConfiguration(extensionName);
        vscode_1.workspace.onDidChangeConfiguration(this.onConfigurationChanged, this);
    }
    get onDidChange() {
        return this._onDidChange.event;
    }
    onConfigurationChanged(event) {
        if (!event.affectsConfiguration(extensionName)) {
            return;
        }
        this.configuration = vscode_1.workspace.getConfiguration(extensionName);
        this._onDidChange.fire(event);
    }
    get(section, defaultValue) {
        return this.configuration.get(section, defaultValue);
    }
    update(section, value) {
        return this.configuration.update(section, value, vscode_1.ConfigurationTarget.Global);
    }
    updateWs(section, value) {
        return vscode_1.workspace.getConfiguration(extensionName).update(section, value, vscode_1.ConfigurationTarget.Workspace);
    }
    updateWsf(section, value, uri) {
        return vscode_1.workspace.getConfiguration(extensionName, uri ? uri : vscode_1.workspace.workspaceFolders[0].uri).update(section, value, vscode_1.ConfigurationTarget.WorkspaceFolder);
    }
    inspect(section) {
        return this.configuration.inspect(section);
    }
}
exports.configuration = new Configuration();
//# sourceMappingURL=configuration.js.map