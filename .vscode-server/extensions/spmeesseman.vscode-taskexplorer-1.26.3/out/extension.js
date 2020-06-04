"use strict";
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const taskTree_1 = require("./taskTree");
const taskProviderAnt_1 = require("./taskProviderAnt");
const taskProviderMake_1 = require("./taskProviderMake");
const taskProviderScript_1 = require("./taskProviderScript");
const taskProviderGradle_1 = require("./taskProviderGradle");
const taskProviderGrunt_1 = require("./taskProviderGrunt");
const taskProviderGulp_1 = require("./taskProviderGulp");
const taskProviderAppPublisher_1 = require("./taskProviderAppPublisher");
const configuration_1 = require("./common/configuration");
const storage_1 = require("./common/storage");
const views_1 = require("./views");
const util = require("./util");
const cache = require("./cache");
const watchers = new Map();
function activate(context, disposables) {
    return __awaiter(this, void 0, void 0, function* () {
        util.initLog("taskExplorer", "Task Explorer", context);
        storage_1.initStorage(context);
        util.log("");
        util.log("Init extension");
        //
        // Register file type watchers
        //
        yield registerFileWatchers(context);
        //
        // Register internal task providers.  Npm, VScode type tasks are provided
        // by VSCode, not internally.
        //
        registerTaskProviders(context);
        //
        // Register the tree providers
        //
        if (configuration_1.configuration.get("enableSideBar")) {
            exports.treeDataProvider = registerExplorer("taskExplorerSideBar", context);
        }
        if (configuration_1.configuration.get("enableExplorerView")) {
            exports.treeDataProvider2 = registerExplorer("taskExplorer", context);
        }
        //
        // Refresh tree when folders are added/removed from the workspace
        //
        const workspaceWatcher = vscode_1.workspace.onDidChangeWorkspaceFolders((_e) => __awaiter(this, void 0, void 0, function* () {
            yield addWsFolder(_e.added);
            removeWsFolder(_e.removed);
            yield refreshTree();
        }));
        context.subscriptions.push(workspaceWatcher);
        //
        // Register configurations/settings change watcher
        //
        const d = vscode_1.workspace.onDidChangeConfiguration((e) => __awaiter(this, void 0, void 0, function* () {
            yield processConfigChanges(context, e);
        }));
        context.subscriptions.push(d);
        util.log("   Task Explorer activated");
        return {
            explorerProvider: exports.treeDataProvider2,
            sidebarProvider: exports.treeDataProvider,
            utilities: util,
            fileCache: cache
        };
    });
}
exports.activate = activate;
function addWsFolder(wsf) {
    return __awaiter(this, void 0, void 0, function* () {
        for (const f in wsf) {
            util.log("Workspace folder added: " + wsf[f].name, 1);
            yield cache.addFolderToCache(wsf[f]);
        }
    });
}
exports.addWsFolder = addWsFolder;
function removeWsFolder(wsf) {
    for (const f in wsf) {
        util.log("Workspace folder removed: " + wsf[f].name, 1);
        // window.setStatusBarMessage("$(loading) Task Explorer - Removing projects...");
        for (const key in cache.filesCache.keys) {
            const toRemove = [];
            const obj = cache.filesCache.get(key);
            obj.forEach((item) => {
                if (item.folder.uri.fsPath === wsf[f].uri.fsPath) {
                    toRemove.push(item);
                }
            });
            if (toRemove.length > 0) {
                for (const tr in toRemove) {
                    obj.delete(toRemove[tr]);
                }
            }
        }
    }
}
exports.removeWsFolder = removeWsFolder;
function processConfigChanges(context, e) {
    return __awaiter(this, void 0, void 0, function* () {
        let refresh;
        if (e.affectsConfiguration("taskExplorer.exclude")) {
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.groupDashed")) {
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.showLastTasks")) {
            if (configuration_1.configuration.get("enableSideBar") && exports.treeDataProvider) {
                yield exports.treeDataProvider2.showLastTasks(configuration_1.configuration.get("showLastTasks"));
            }
            if (configuration_1.configuration.get("enableExplorerView") && exports.treeDataProvider2) {
                yield exports.treeDataProvider2.showLastTasks(configuration_1.configuration.get("showLastTasks"));
            }
        }
        if (e.affectsConfiguration("taskExplorer.enableAnt") || e.affectsConfiguration("taskExplorer.includeAnt")) {
            yield registerFileWatcherAnt(context, configuration_1.configuration.get("enableAnt"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableAppPublisher")) {
            yield registerFileWatcher(context, "app-publisher", "**/.publishrc*", false, configuration_1.configuration.get("enableAppPublisher"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableBash")) {
            yield registerFileWatcher(context, "bash", "**/*.[Ss][Hh]", true, configuration_1.configuration.get("enableBash"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableBatch")) {
            yield registerFileWatcher(context, "batch", "**/*.[Bb][Aa][Tt]", true, configuration_1.configuration.get("enableBatch"));
            yield registerFileWatcher(context, "batch", "**/*.[Cc][Mm][Dd]", true, configuration_1.configuration.get("enableBatch"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableGradle")) {
            yield registerFileWatcher(context, "grunt", "**/*.[Gg][Rr][Aa][Dd][Ll][Ee]", false, configuration_1.configuration.get("enableGradle"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableGrunt")) {
            yield registerFileWatcher(context, "grunt", "**/[Gg][Rr][Uu][Nn][Tt][Ff][Ii][Ll][Ee].[Jj][Ss]", false, configuration_1.configuration.get("enableGrunt"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableGulp")) {
            yield registerFileWatcher(context, "gulp", "**/[Gg][Uu][Ll][Pp][Ff][Ii][Ll][Ee].[Jj][Ss]", false, configuration_1.configuration.get("enableGulp"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableMake")) {
            yield registerFileWatcher(context, "make", "**/[Mm]akefile", false, configuration_1.configuration.get("enableMake"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableNpm")) {
            yield registerFileWatcher(context, "npm", "**/package.json", false, configuration_1.configuration.get("enableNpm"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableNsis")) {
            yield registerFileWatcher(context, "nsis", "**/*.[Nn][Ss][Ii]", true, configuration_1.configuration.get("enableNsis"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enablePerl")) {
            yield registerFileWatcher(context, "perl", "**/*.[Pp][Ll]", true, configuration_1.configuration.get("enablePerl"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enablePowershell")) {
            yield registerFileWatcher(context, "powershell", "**/*.[Pp][Ss]1", true, configuration_1.configuration.get("enablePowershell"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enablePython")) {
            yield registerFileWatcher(context, "python", "**/[Ss][Ee][Tt][Uu][Pp].[Pp][Yy]", true, configuration_1.configuration.get("enablePython"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableRuby")) {
            yield registerFileWatcher(context, "ruby", "**/*.rb", true, configuration_1.configuration.get("enableRuby"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableTsc")) {
            yield registerFileWatcher(context, "tsc", "**/tsconfig.json", false, configuration_1.configuration.get("enableTsc"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableWorkspace")) {
            yield registerFileWatcher(context, "workspace", "**/.vscode/tasks.json", false, configuration_1.configuration.get("enableWorkspace"));
            refresh = true;
        }
        if (e.affectsConfiguration("taskExplorer.enableSideBar")) {
            if (configuration_1.configuration.get("enableSideBar")) {
                if (exports.treeDataProvider) {
                    // TODO - remove/add view on enable/disable view
                    refresh = true;
                }
                else {
                    exports.treeDataProvider = registerExplorer("taskExplorerSideBar", context);
                }
            }
        }
        if (e.affectsConfiguration("taskExplorer.enableExplorerView")) {
            if (configuration_1.configuration.get("enableExplorerView")) {
                if (exports.treeDataProvider2) {
                    // TODO - remove/add view on enable/disable view
                    refresh = true;
                }
                else {
                    exports.treeDataProvider2 = registerExplorer("taskExplorer", context);
                }
            }
        }
        if (e.affectsConfiguration("taskExplorer.pathToAnsicon") || e.affectsConfiguration("taskExplorer.pathToAnt") ||
            e.affectsConfiguration("taskExplorer.pathToGradle") || e.affectsConfiguration("taskExplorer.pathToMake") ||
            e.affectsConfiguration("taskExplorer.pathToNsis") || e.affectsConfiguration("taskExplorer.pathToPerl") ||
            e.affectsConfiguration("taskExplorer.pathToPython") || e.affectsConfiguration("taskExplorer.pathToRuby") ||
            e.affectsConfiguration("taskExplorer.pathToBash") || e.affectsConfiguration("taskExplorer.pathToAppPublisher") ||
            e.affectsConfiguration("taskExplorer.pathToPowershell")) {
            refresh = true;
        }
        if (e.affectsConfiguration("terminal.integrated.shell.windows") ||
            e.affectsConfiguration("terminal.integrated.shell.linux") ||
            e.affectsConfiguration("terminal.integrated.shell.macos")) {
            //
            // Script type task defs will change with terminal change
            //
            if (configuration_1.configuration.get("enableBash") || configuration_1.configuration.get("enableBatch") ||
                configuration_1.configuration.get("enablePerl") || configuration_1.configuration.get("enablePowershell") ||
                configuration_1.configuration.get("enablePython") || configuration_1.configuration.get("enableRuby") ||
                configuration_1.configuration.get("enableNsis")) {
                refresh = true;
            }
        }
        if (refresh) {
            yield refreshTree();
        }
    });
}
function registerFileWatchers(context) {
    return __awaiter(this, void 0, void 0, function* () {
        if (configuration_1.configuration.get("enableAnt")) {
            yield registerFileWatcherAnt(context);
        }
        if (configuration_1.configuration.get("enableAppPublisher")) {
            yield registerFileWatcher(context, "app-publisher", "**/.publishrc*", true);
        }
        if (configuration_1.configuration.get("enableBash")) {
            yield registerFileWatcher(context, "bash", "**/*.[Ss][Hh]", true);
        }
        if (configuration_1.configuration.get("enableBatch")) {
            yield registerFileWatcher(context, "batch", "**/*.[Bb][Aa][Tt]", true);
            yield registerFileWatcher(context, "batch2", "**/*.[Cc][Mm][Dd]", true);
        }
        if (configuration_1.configuration.get("enableGradle")) {
            yield registerFileWatcher(context, "gradle", "**/*.[Gg][Rr][Aa][Dd][Ll][Ee]");
        }
        if (configuration_1.configuration.get("enableGrunt")) {
            yield registerFileWatcher(context, "grunt", "**/[Gg][Rr][Uu][Nn][Tt][Ff][Ii][Ll][Ee].[Jj][Ss]");
        }
        if (configuration_1.configuration.get("enableGulp")) {
            yield registerFileWatcher(context, "gulp", "**/[Gg][Uu][Ll][Pp][Ff][Ii][Ll][Ee].[Jj][Ss]");
        }
        if (configuration_1.configuration.get("enableMake")) {
            yield registerFileWatcher(context, "make", "**/[Mm]akefile");
        }
        if (configuration_1.configuration.get("enableNpm")) {
            yield registerFileWatcher(context, "npm", "**/package.json");
        }
        if (configuration_1.configuration.get("enableNsis")) {
            yield registerFileWatcher(context, "nsis", "**/*.[Nn][Ss][Ii]", true);
        }
        if (configuration_1.configuration.get("enablePerl")) {
            yield registerFileWatcher(context, "perl", "**/*.[Pp][Ll]", true);
        }
        if (configuration_1.configuration.get("enablePowershell")) {
            yield registerFileWatcher(context, "powershell", "**/*.[Pp][Ss]1", true);
        }
        if (configuration_1.configuration.get("enablePython")) {
            yield registerFileWatcher(context, "python", "**/[Ss][Ee][Tt][Uu][Pp].[Pp][Yy]", true);
        }
        if (configuration_1.configuration.get("enableRuby")) {
            yield registerFileWatcher(context, "ruby", "**/*.[Rr][Bb]", true);
        }
        if (configuration_1.configuration.get("enableTsc")) {
            yield registerFileWatcher(context, "tsc", "**/tsconfig.json");
        }
        if (configuration_1.configuration.get("enableWorkspace")) {
            yield registerFileWatcher(context, "workspace", "**/.vscode/tasks.json");
        }
    });
}
function refreshTree(taskType, uri) {
    return __awaiter(this, void 0, void 0, function* () {
        let refreshedTasks = false;
        // window.setStatusBarMessage("$(loading) Task Explorer - Refreshing tasks...");
        //
        // If the task type received from a filewatcher event is "ant-*" then it is a custom
        // defined ant file in the includeAnt setting, named accordingly so that the watchers
        // can be tracked.  change the taskType to "ant" here
        //
        if (taskType && taskType.indexOf("ant-") !== -1) {
            taskType = "ant";
        }
        //
        // Refresh tree
        //
        // Note the task cache only needs to be refreshed once if both the explorer view and
        // the sidebar view are being used and/or enabled
        //
        if (configuration_1.configuration.get("enableSideBar") && exports.treeDataProvider) {
            refreshedTasks = yield exports.treeDataProvider.refresh(taskType, uri);
        }
        if (configuration_1.configuration.get("enableExplorerView") && exports.treeDataProvider2) {
            if (!refreshedTasks) {
                yield exports.treeDataProvider2.refresh(taskType, uri);
            }
            else {
                yield exports.treeDataProvider2.refresh(taskType !== "visible-event" ? false : taskType, uri);
            }
        }
        // window.setStatusBarMessage("");
    });
}
function registerTaskProviders(context) {
    //
    // Internal Task Providers
    //
    // These tak types are provided internally by the extension.  Some task types (npm, grunt,
    //  gulp) are provided by VSCode itself
    //
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("ant", new taskProviderAnt_1.AntTaskProvider()));
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("make", new taskProviderMake_1.MakeTaskProvider()));
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("script", new taskProviderScript_1.ScriptTaskProvider()));
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("grunt", new taskProviderGrunt_1.GruntTaskProvider()));
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("gulp", new taskProviderGulp_1.GulpTaskProvider()));
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("gradle", new taskProviderGradle_1.GradleTaskProvider()));
    context.subscriptions.push(vscode_1.workspace.registerTaskProvider("app-publisher", new taskProviderAppPublisher_1.AppPublisherTaskProvider()));
}
function registerFileWatcherAnt(context, enabled) {
    return __awaiter(this, void 0, void 0, function* () {
        yield registerFileWatcher(context, "ant", "**/[Bb]uild.xml", false, enabled);
        //
        // For extra file globs configured in settings, we need to first go through and disable
        // all current watchers since there is no way of knowing which glob patterns were
        // removed (if any).
        //
        watchers.forEach((watcher, key) => {
            if (key.startsWith("ant") && key !== "ant") {
                const watcher = watchers.get(key);
                watcher.onDidChange(_e => undefined);
                watcher.onDidDelete(_e => undefined);
                watcher.onDidCreate(_e => undefined);
            }
        });
        const includeAnt = configuration_1.configuration.get("includeAnt");
        if (includeAnt && includeAnt.length > 0) {
            for (let i = 0; i < includeAnt.length; i++) {
                yield registerFileWatcher(context, "ant-" + includeAnt[i], includeAnt[i], false, enabled);
            }
        }
    });
}
function registerFileWatcher(context, taskType, fileBlob, isScriptType, enabled) {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("Register file watcher for task type '" + taskType + "'");
        let watcher = watchers.get(taskType);
        let taskAlias = taskType;
        let taskTypeR = taskType !== "batch2" ? taskType : "batch";
        if (taskType && taskType.indexOf("ant-") !== -1) {
            taskAlias = "ant";
            taskTypeR = "ant";
        }
        if (taskType && taskType.indexOf("batch2") !== -1) {
            taskAlias = "batch";
        }
        if (vscode_1.workspace.workspaceFolders) {
            yield cache.buildCache(isScriptType && taskAlias !== "app-publisher" ? "script" : taskAlias, taskTypeR, fileBlob);
        }
        if (enabled !== false) {
            if (!watcher) {
                watcher = vscode_1.workspace.createFileSystemWatcher(fileBlob);
                watchers.set(taskTypeR, watcher);
                context.subscriptions.push(watcher);
            }
            if (!isScriptType) {
                watcher.onDidChange((_e) => __awaiter(this, void 0, void 0, function* () {
                    logFileWatcherEvent(_e, "change");
                    yield refreshTree(taskTypeR, _e);
                }));
            }
            watcher.onDidDelete((_e) => __awaiter(this, void 0, void 0, function* () {
                logFileWatcherEvent(_e, "delete");
                yield cache.removeFileFromCache(taskTypeR, _e);
                yield refreshTree(taskTypeR, _e);
            }));
            watcher.onDidCreate((_e) => __awaiter(this, void 0, void 0, function* () {
                logFileWatcherEvent(_e, "create");
                yield cache.addFileToCache(taskTypeR, _e);
                yield refreshTree(taskTypeR, _e);
            }));
        }
        else if (watcher) {
            if (!isScriptType) {
                watcher.onDidChange(_e => undefined);
            }
            watcher.onDidDelete(_e => undefined);
            watcher.onDidCreate(_e => undefined);
        }
    });
}
function logFileWatcherEvent(uri, type) {
    util.log("file change event");
    util.logValue("   type", type);
    util.logValue("   file", uri.fsPath);
}
function registerExplorer(name, context, enabled) {
    util.log("Register explorer view / tree provider '" + name + "'");
    if (enabled !== false) {
        if (vscode_1.workspace.workspaceFolders) {
            const treeDataProvider = new taskTree_1.TaskTreeDataProvider(name, context);
            const treeView = vscode_1.window.createTreeView(name, { treeDataProvider, showCollapseAll: true });
            treeView.onDidChangeVisibility(_e => {
                if (_e.visible) {
                    util.log("view visibility change event");
                    refreshTree("visible-event");
                }
            });
            views_1.views.set(name, treeView);
            context.subscriptions.push(views_1.views.get(name));
            util.log("   Tree data provider registered'" + name + "'");
            return treeDataProvider;
        }
        else {
            util.log("✘ No workspace folders!!!");
        }
    }
    return undefined;
}
function deactivate() {
    return __awaiter(this, void 0, void 0, function* () {
        yield cache.cancelBuildCache(true);
    });
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map