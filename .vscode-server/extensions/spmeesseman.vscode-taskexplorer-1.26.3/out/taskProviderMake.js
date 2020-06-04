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
class MakeTaskProvider {
    constructor() {
    }
    provideTasks() {
        return provideMakefiles();
    }
    resolveTask(_task) {
        return undefined;
    }
}
exports.MakeTaskProvider = MakeTaskProvider;
function invalidateTasksCacheMake(opt) {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("invalidateTasksCacheMake");
        util.logValue("   uri", opt ? opt.path : (opt === null ? "null" : "undefined"), 2);
        util.logValue("   has cached tasks", cachedTasks ? "true" : "false", 2);
        if (opt && cachedTasks) {
            const rmvTasks = [];
            yield util.asyncForEach(cachedTasks, (each) => {
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
                yield util.asyncForEach(rmvTasks, (each) => {
                    util.log("   removing old task " + each.name);
                    util.removeFromArray(cachedTasks, each);
                });
                if (util.pathExists(opt.fsPath) && !util.existsInArray(configuration_1.configuration.get("exclude"), opt.path)) {
                    const tasks = yield readMakefile(opt);
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
exports.invalidateTasksCacheMake = invalidateTasksCacheMake;
function detectMakefiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("detectMakefiles");
        const allTasks = [];
        const visitedFiles = new Set();
        const paths = cache_1.filesCache.get("make");
        if (vscode_1.workspace.workspaceFolders && paths) {
            for (const fobj of paths) {
                if (!util.isExcluded(fobj.uri.path) && !visitedFiles.has(fobj.uri.fsPath)) {
                    visitedFiles.add(fobj.uri.fsPath);
                    const tasks = yield readMakefile(fobj.uri);
                    allTasks.push(...tasks);
                }
            }
        }
        util.logValue("   # of tasks", allTasks.length, 2);
        return allTasks;
    });
}
function provideMakefiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("provideMakefiles");
        if (!cachedTasks) {
            cachedTasks = yield detectMakefiles();
        }
        return cachedTasks;
    });
}
function readMakefile(uri) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = [];
        const folder = vscode_1.workspace.getWorkspaceFolder(uri);
        if (folder) {
            const scripts = yield findTargets(uri.fsPath);
            if (scripts) {
                Object.keys(scripts).forEach(each => {
                    const task = createMakeTask(each, `${each}`, folder, uri);
                    task.group = vscode_1.TaskGroup.Build;
                    result.push(task);
                });
            }
        }
        return result;
    });
}
function findTargets(fsPath) {
    return __awaiter(this, void 0, void 0, function* () {
        const json = "";
        const scripts = {};
        util.log("");
        util.log("Find makefile targets");
        const contents = yield util.readFile(fsPath);
        let idx = 0;
        let eol = contents.indexOf("\n", 0);
        while (eol !== -1) {
            const line = contents.substring(idx, eol);
            //
            // Target names always start at position 0 of the line.
            //
            // TODO = Skip targets that are environment variable names, for now.  Need to
            // parse value if set in makefile and apply here for $() target names.
            //
            if (line.length > 0 && !line.startsWith("\t") && !line.startsWith(" ") &&
                !line.startsWith("#") && !line.startsWith("$") && line.indexOf(":") > 0) {
                const tgtName = line.substring(0, line.indexOf(":")).trim();
                const dependsName = line.substring(line.indexOf(":") + 1).trim();
                //
                // Don't incude object targets
                //
                if (tgtName.indexOf("/") === -1 && tgtName.indexOf("=") === -1 && tgtName.indexOf("\\") === -1) {
                    scripts[tgtName] = "";
                    util.log("   found target");
                    util.logValue("      name", tgtName);
                    util.logValue("      depends target", dependsName);
                }
            }
            idx = eol + 1;
            eol = contents.indexOf("\n", idx);
        }
        util.log("   done");
        return scripts;
    });
}
function createMakeTask(target, cmd, folder, uri) {
    function getCommand(folder, cmd) {
        let make = "make";
        if (process.platform === "win32") {
            make = "nmake";
        }
        if (configuration_1.configuration.get("pathToMake")) {
            make = configuration_1.configuration.get("pathToMake");
        }
        return make;
    }
    function getRelativePath(folder, uri) {
        if (folder) {
            const rootUri = folder.uri;
            const absolutePath = uri.path.substring(0, uri.path.lastIndexOf("/") + 1);
            return absolutePath.substring(rootUri.path.length + 1);
        }
        return "";
    }
    const kind = {
        type: "make",
        script: target,
        path: getRelativePath(folder, uri),
        fileName: path.basename(uri.path),
        uri
    };
    const cwd = path.dirname(uri.fsPath);
    const args = [target];
    const options = {
        cwd
    };
    const execution = new vscode_1.ShellExecution(getCommand(folder, cmd), args, options);
    // const pm = {
    //     owner: "cpp",
    //     fileLocation: ["absolute"],
    //     pattern: {
    //         regexp: "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
    //         file: 1,
    //         line: 2,
    //         column: 3,
    //         severity: 4,
    //         message: 5
    //     }
    // };
    return new vscode_1.Task(kind, folder, target, "make", execution, "cpp");
}
//# sourceMappingURL=taskProviderMake.js.map