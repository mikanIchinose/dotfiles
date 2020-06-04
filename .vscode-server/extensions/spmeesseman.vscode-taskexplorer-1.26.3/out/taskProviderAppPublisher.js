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
const path = require("path");
const util = require("./util");
const configuration_1 = require("./common/configuration");
const cache_1 = require("./cache");
let cachedTasks;
class AppPublisherTaskProvider {
    constructor() { }
    provideTasks() {
        return provideAppPublisherfiles();
    }
    resolveTask(_task) {
        return undefined;
    }
}
exports.AppPublisherTaskProvider = AppPublisherTaskProvider;
function invalidateTasksCacheAppPublisher(opt) {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("invalidateTasksCacheAppPublisher");
        util.logValue("   uri", opt ? opt.path : (opt === null ? "null" : "undefined"), 2);
        util.logValue("   has cached tasks", cachedTasks ? "true" : "false", 2);
        if (opt && cachedTasks) {
            const rmvTasks = [];
            const folder = vscode_1.workspace.getWorkspaceFolder(opt);
            yield util.asyncForEach(cachedTasks, each => {
                const cstDef = each.definition;
                if (cstDef.uri.fsPath === opt.fsPath || !util.pathExists(cstDef.uri.fsPath)) {
                    rmvTasks.push(each);
                }
            });
            //
            // Technically this function can be called back into when waiting for a promise
            // to return on the asncForEach() above, and cachedTask array can be set to undefined,
            // this is happening with a broken await() somewere that I cannot find
            if (cachedTasks) {
                yield util.asyncForEach(rmvTasks, each => {
                    util.log("   removing old task " + each.name);
                    util.removeFromArray(cachedTasks, each);
                });
                if (util.pathExists(opt.fsPath) && !util.existsInArray(configuration_1.configuration.get("exclude"), opt.path)) {
                    const tasks = createAppPublisherTask(folder, opt);
                    cachedTasks.push(...tasks);
                }
                if (cachedTasks.length > 0) {
                    return;
                }
            }
        }
        cachedTasks = undefined;
    });
}
exports.invalidateTasksCacheAppPublisher = invalidateTasksCacheAppPublisher;
function provideAppPublisherfiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("provideAppPublisherfiles");
        if (!cachedTasks) {
            cachedTasks = yield detectAppPublisherfiles();
        }
        return cachedTasks;
    });
}
function detectAppPublisherfiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("detectAppPublisherfiles");
        const allTasks = [];
        const visitedFiles = new Set();
        const paths = cache_1.filesCache.get("app-publisher");
        if (vscode_1.workspace.workspaceFolders && paths) {
            for (const fobj of paths) {
                if (!util.isExcluded(fobj.uri.path) && !visitedFiles.has(fobj.uri.fsPath)) {
                    visitedFiles.add(fobj.uri.fsPath);
                    allTasks.push(...createAppPublisherTask(fobj.folder, fobj.uri));
                }
            }
        }
        util.logValue("   # of tasks", allTasks.length, 2);
        return allTasks;
    });
}
function createAppPublisherTask(folder, uri) {
    function getRelativePath(folder, uri) {
        if (folder) {
            const rootUri = folder.uri;
            const absolutePath = uri.path.substring(0, uri.path.lastIndexOf("/") + 1);
            return absolutePath.substring(rootUri.path.length + 1);
        }
        return "";
    }
    const cwd = path.dirname(uri.fsPath);
    const fileName = path.basename(uri.fsPath);
    const relativePath = getRelativePath(folder, uri);
    const kind1 = {
        type: "app-publisher",
        fileName,
        path: relativePath,
        cmdLine: "npx app-publisher -p ps --no-ci --republish",
        requiresArgs: false,
        uri
    };
    const kind2 = {
        type: "app-publisher",
        fileName,
        path: relativePath,
        cmdLine: "npx app-publisher -p ps --no-ci --email-only",
        uri
    };
    const kind3 = {
        type: "app-publisher",
        fileName,
        path: relativePath,
        cmdLine: "npx app-publisher -p ps --no-ci",
        uri
    };
    const kind4 = {
        type: "app-publisher",
        fileName,
        path: relativePath,
        cmdLine: "npx app-publisher -p ps --no-ci --dry-run",
        uri
    };
    const kind5 = {
        type: "app-publisher",
        fileName,
        path: relativePath,
        cmdLine: "npx app-publisher -p ps --no-ci --mantis-only",
        uri
    };
    const kind6 = {
        type: "app-publisher",
        fileName,
        path: relativePath,
        cmdLine: "npx app-publisher -p ps --no-ci --prompt-version",
        uri
    };
    //
    // Set current working dircetory in oprions to relative script dir
    //
    const options = {
        cwd
    };
    //
    // Create the shell execution objects
    //
    const execution1 = new vscode_1.ShellExecution(kind1.cmdLine, options);
    const execution2 = new vscode_1.ShellExecution(kind2.cmdLine, options);
    const execution3 = new vscode_1.ShellExecution(kind3.cmdLine, options);
    const execution4 = new vscode_1.ShellExecution(kind4.cmdLine, options);
    const execution5 = new vscode_1.ShellExecution(kind5.cmdLine, options);
    const execution6 = new vscode_1.ShellExecution(kind6.cmdLine, options);
    return [new vscode_1.Task(kind4, folder, "Dry Run", "app-publisher", execution4, undefined),
        new vscode_1.Task(kind3, folder, "Publish", "app-publisher", execution3, undefined),
        new vscode_1.Task(kind1, folder, "Re-publish", "app-publisher", execution1, undefined),
        new vscode_1.Task(kind1, folder, "Publish Mantis Release", "app-publisher", execution5, undefined),
        new vscode_1.Task(kind5, folder, "Send Release Email", "app-publisher", execution2, undefined),
        new vscode_1.Task(kind6, folder, "Publish (Prompt Version)", "app-publisher", execution6, undefined)];
}
//# sourceMappingURL=taskProviderAppPublisher.js.map