"use strict";
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
const util_1 = require("./util");
const configuration_1 = require("./common/configuration");
exports.filesCache = new Map();
exports.cacheBuilding = false;
let folderCaching = false;
let cancel = false;
function cancelBuildCache(wait) {
    return __awaiter(this, void 0, void 0, function* () {
        let waitCount = 20;
        if (!exports.cacheBuilding) {
            return;
        }
        cancel = true;
        while (wait && exports.cacheBuilding && waitCount > 0) {
            waitCount--;
            yield util_1.timeout(500);
        }
    });
}
exports.cancelBuildCache = cancelBuildCache;
function waitForCache() {
    return __awaiter(this, void 0, void 0, function* () {
        while (exports.cacheBuilding === true || folderCaching === true) {
            yield util_1.timeout(100);
        }
    });
}
exports.waitForCache = waitForCache;
function rebuildCache() {
    return __awaiter(this, void 0, void 0, function* () {
        exports.filesCache.clear();
        yield addFolderToCache();
    });
}
exports.rebuildCache = rebuildCache;
function buildCache(taskAlias, taskType, fileBlob, wsfolder, setCacheBuilding = true) {
    return __awaiter(this, void 0, void 0, function* () {
        util_1.log("Start cache building");
        util_1.logValue("   task alias", taskAlias, 2);
        util_1.logValue("   task type", taskType, 2);
        util_1.logValue("   blob", fileBlob, 2);
        util_1.logValue("   folder", !wsfolder ? "entire workspace" : wsfolder.name);
        util_1.logValue("   setCacheBuilding", setCacheBuilding.toString(), 2);
        if (setCacheBuilding) {
            //
            // If buildCache is already running in another scope, then cancel and wait
            //
            yield waitForCache();
            exports.cacheBuilding = true;
        }
        if (!exports.filesCache.get(taskAlias)) {
            exports.filesCache.set(taskAlias, new Set());
        }
        const fCache = exports.filesCache.get(taskAlias);
        let dispTaskType = util_1.properCase(taskType);
        if (dispTaskType.indexOf("Ant") !== -1) {
            dispTaskType = "Ant";
        }
        function statusString(msg, statusLength = 0) {
            if (msg) {
                if (statusLength > 0) {
                    if (msg.length < statusLength) {
                        for (let i = msg.length; i < statusLength; i++) {
                            msg += " ";
                        }
                    }
                    else {
                        msg = msg.substring(0, statusLength - 3) + "...";
                    }
                }
                return "$(loading~spin) " + msg;
            }
            return "";
        }
        const statusBarSpace = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left, -10000);
        statusBarSpace.tooltip = "Task Explorer is building the task cache";
        statusBarSpace.show();
        if (!wsfolder) {
            util_1.log("Build cache - Scan all projects for taskType '" + taskType + "' (" + dispTaskType + ")");
            if (vscode_1.workspace.workspaceFolders) {
                try {
                    for (const folder of vscode_1.workspace.workspaceFolders) {
                        if (cancel) {
                            if (setCacheBuilding) {
                                exports.cacheBuilding = false;
                                cancel = false;
                            }
                            statusBarSpace.hide();
                            statusBarSpace.dispose();
                            util_1.log("Cache building cancelled");
                            return;
                        }
                        util_1.log("   Scan project " + folder.name + " for " + dispTaskType + " tasks");
                        statusBarSpace.text = statusString("Scanning for " + dispTaskType + " tasks in project " + folder.name, 65);
                        const relativePattern = new vscode_1.RelativePattern(folder, fileBlob);
                        const paths = yield vscode_1.workspace.findFiles(relativePattern, util_1.getExcludesGlob(folder));
                        for (const fpath of paths) {
                            if (cancel) {
                                if (setCacheBuilding) {
                                    exports.cacheBuilding = false;
                                    cancel = false;
                                }
                                statusBarSpace.hide();
                                statusBarSpace.dispose();
                                util_1.log("Cache building cancelled");
                                return;
                            }
                            if (!util_1.isExcluded(fpath.path)) {
                                fCache.add({
                                    uri: fpath,
                                    folder
                                });
                                util_1.logValue("   Added to cache", fpath.fsPath, 2);
                            }
                        }
                    }
                    // tslint:disable-next-line: no-empty
                }
                catch (error) { }
            }
        }
        else {
            util_1.log("Build cache - Scan project '" + wsfolder.name + "' for taskType '" + taskType + "'");
            statusBarSpace.text = statusString("Scanning for tasks in project " + wsfolder.name);
            const relativePattern = new vscode_1.RelativePattern(wsfolder, fileBlob);
            const paths = yield vscode_1.workspace.findFiles(relativePattern, util_1.getExcludesGlob(wsfolder));
            for (const fpath of paths) {
                if (cancel) {
                    if (setCacheBuilding) {
                        exports.cacheBuilding = false;
                        cancel = false;
                    }
                    statusBarSpace.hide();
                    statusBarSpace.dispose();
                    util_1.log("Cache building cancelled");
                    return;
                }
                if (!util_1.isExcluded(fpath.path)) {
                    // if (!isExcluded(fpath.path) && !fCache.has(fpath)) {
                    fCache.add({
                        uri: fpath,
                        folder: wsfolder
                    });
                    util_1.logValue("   Added to cache", fpath.fsPath, 2);
                }
            }
        }
        statusBarSpace.hide();
        statusBarSpace.dispose();
        util_1.log("Cache building complete");
        if (setCacheBuilding) {
            cancel = false;
            exports.cacheBuilding = false;
        }
    });
}
exports.buildCache = buildCache;
function addFileToCache(taskAlias, uri) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!exports.filesCache.get(taskAlias)) {
            exports.filesCache.set(taskAlias, new Set());
        }
        const taskCache = exports.filesCache.get(taskAlias);
        taskCache.add({
            uri,
            folder: vscode_1.workspace.getWorkspaceFolder(uri)
        });
    });
}
exports.addFileToCache = addFileToCache;
function removeFileFromCache(taskAlias, uri) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!exports.filesCache.get(taskAlias)) {
            return;
        }
        const taskCache = exports.filesCache.get(taskAlias);
        const toRemove = [];
        taskCache.forEach((item) => {
            if (item.uri.fsPath === uri.fsPath) {
                toRemove.push(item);
            }
        });
        if (toRemove.length > 0) {
            for (const tr in toRemove) {
                taskCache.delete(toRemove[tr]);
            }
        }
    });
}
exports.removeFileFromCache = removeFileFromCache;
function waitForFolderCaching() {
    return __awaiter(this, void 0, void 0, function* () {
        while (folderCaching === true) {
            yield util_1.timeout(100);
        }
    });
}
function addFolderToCache(folder) {
    return __awaiter(this, void 0, void 0, function* () {
        util_1.log("Add folder to cache");
        util_1.logValue("   folder", !folder ? "entire workspace" : folder.name);
        yield waitForCache();
        yield waitForFolderCaching();
        folderCaching = true;
        exports.cacheBuilding = true;
        if (!cancel && configuration_1.configuration.get("enableAnt")) {
            yield buildCache("ant", "ant", "**/[Bb]uild.xml", folder, false);
            const includeAnt = configuration_1.configuration.get("includeAnt");
            if (includeAnt && includeAnt.length > 0) {
                for (let i = 0; i < includeAnt.length; i++) {
                    yield buildCache("ant", "ant-" + includeAnt[i], includeAnt[i], folder, false);
                }
            }
        }
        if (!cancel && configuration_1.configuration.get("enableAppPublisher")) {
            yield buildCache("app-publisher", "app-publisher", "**/.publishrc*", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableBash")) {
            yield buildCache("script", "bash", "**/*.[Ss][Hh]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableBatch")) {
            yield buildCache("script", "batch", "**/*.[Bb][Aa][Tt]", folder, false);
            yield buildCache("script", "batch", "**/*.[Cc][Mm][Dd]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableGradle")) {
            yield buildCache("gradle", "gradle", "**/*.[Gg][Rr][Aa][Dd][Ll][Ee]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableGrunt")) {
            yield buildCache("grunt", "grunt", "**/[Gg][Rr][Uu][Nn][Tt][Ff][Ii][Ll][Ee].[Jj][Ss]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableGulp")) {
            yield buildCache("gulp", "gulp", "**/[Gg][Uu][Ll][Pp][Ff][Ii][Ll][Ee].[Jj][Ss]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableMake")) {
            yield buildCache("make", "make", "**/[Mm]akefile", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableNpm")) {
            yield buildCache("npm", "npm", "**/package.json", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableNsis")) {
            yield buildCache("script", "nsis", "**/*.[Nn][Ss][Ii]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enablePerl")) {
            yield buildCache("script", "perl", "**/*.[Pp][Ll]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enablePowershell")) {
            yield buildCache("script", "powershell", "**/*.[Pp][Ss]1", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enablePython")) {
            yield buildCache("script", "python", "**/[Ss][Ee][Tt][Uu][Pp].[Pp][Yy]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableRuby")) {
            yield buildCache("script", "ruby", "**/*.[Rr][Bb]", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableTsc")) {
            yield buildCache("tsc", "tsc", "**/tsconfig.json", folder, false);
        }
        if (!cancel && configuration_1.configuration.get("enableWorkspace")) {
            yield buildCache("workspace", "workspace", "**/.vscode/tasks.json", folder, false);
        }
        exports.cacheBuilding = false;
        folderCaching = false;
        if (cancel) {
            util_1.log("Add folder to cache cancelled");
        }
        else {
            util_1.log("Add folder to cache complete");
        }
        cancel = false;
    });
}
exports.addFolderToCache = addFolderToCache;
//# sourceMappingURL=cache.js.map