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
class GruntTaskProvider {
    constructor() { }
    provideTasks() {
        return provideGruntfiles();
    }
    resolveTask(_task) {
        return undefined;
    }
}
exports.GruntTaskProvider = GruntTaskProvider;
function invalidateTasksCacheGrunt(opt) {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("invalidateTasksCacheGrunt");
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
                    const tasks = yield readGruntfile(opt);
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
exports.invalidateTasksCacheGrunt = invalidateTasksCacheGrunt;
function provideGruntfiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("provideGruntfiles");
        if (!cachedTasks) {
            cachedTasks = yield detectGruntfiles();
        }
        return cachedTasks;
    });
}
function detectGruntfiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("detectGruntfiles");
        const allTasks = [];
        const visitedFiles = new Set();
        const paths = cache_1.filesCache.get("grunt");
        if (vscode_1.workspace.workspaceFolders && paths) {
            for (const fobj of paths) {
                if (!util.isExcluded(fobj.uri.path) && !visitedFiles.has(fobj.uri.fsPath)) {
                    visitedFiles.add(fobj.uri.fsPath);
                    const tasks = yield readGruntfile(fobj.uri);
                    allTasks.push(...tasks);
                }
            }
        }
        util.logValue("   # of tasks", allTasks.length, 2);
        return allTasks;
    });
}
function readGruntfile(uri) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = [];
        const folder = vscode_1.workspace.getWorkspaceFolder(uri);
        if (folder) {
            const scripts = yield findTargets(uri.fsPath);
            if (scripts) {
                Object.keys(scripts).forEach(each => {
                    const task = createGruntTask(each, `${each}`, folder, uri);
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
        util.log("Find gruntfile targets");
        const contents = yield util.readFile(fsPath);
        let idx = 0;
        let eol = contents.indexOf("\n", 0);
        while (eol !== -1) {
            let line = contents.substring(idx, eol).trim();
            if (line.length > 0 && line.toLowerCase().trimLeft().startsWith("grunt.registertask")) {
                let idx1 = line.indexOf("'");
                if (idx1 === -1) {
                    idx1 = line.indexOf('"');
                }
                if (idx1 === -1) // check next line for task name
                 {
                    let eol2 = eol + 1;
                    eol2 = contents.indexOf("\n", eol2);
                    line = contents.substring(eol + 1, eol2).trim();
                    if (line.startsWith("'") || line.startsWith('"')) {
                        idx1 = line.indexOf("'");
                        if (idx1 === -1) {
                            idx1 = line.indexOf('"');
                        }
                        if (idx1 !== -1) {
                            eol = eol2;
                        }
                    }
                }
                if (idx1 !== -1) {
                    idx1++;
                    let idx2 = line.indexOf("'", idx1);
                    if (idx2 === -1) {
                        idx2 = line.indexOf('"', idx1);
                    }
                    if (idx2 !== -1) {
                        const tgtName = line.substring(idx1, idx2).trim();
                        if (tgtName) {
                            scripts[tgtName] = "";
                            util.log("   found target");
                            util.logValue("      name", tgtName);
                        }
                    }
                }
            }
            idx = eol + 1;
            eol = contents.indexOf("\n", idx);
        }
        util.log("   done");
        return scripts;
    });
}
function createGruntTask(target, cmd, folder, uri) {
    function getCommand(folder, cmd) {
        // let grunt = 'folder.uri.fsPath + "/node_modules/.bin/grunt";
        const grunt = "grunt";
        // if (process.platform === 'win32') {
        //     grunt = folder.uri.fsPath + "\\node_modules\\.bin\\grunt.cmd";
        // }
        // if (workspace.getConfiguration('taskExplorer').get('pathToGrunt')) {
        //     grunt = workspace.getConfiguration('taskExplorer').get('pathToGrunt');
        // }
        return grunt;
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
        type: "grunt",
        script: target,
        path: getRelativePath(folder, uri),
        fileName: path.basename(uri.path),
        uri
    };
    const cwd = path.dirname(uri.fsPath);
    const args = [getCommand(folder, cmd), target];
    const options = {
        cwd
    };
    const execution = new vscode_1.ShellExecution("npx", args, options);
    return new vscode_1.Task(kind, folder, target, "grunt", execution, undefined);
}
//# sourceMappingURL=taskProviderGrunt.js.map