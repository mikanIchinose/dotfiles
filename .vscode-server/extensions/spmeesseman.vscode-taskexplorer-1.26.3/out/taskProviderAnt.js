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
const xml2js_1 = require("xml2js");
const configuration_1 = require("./common/configuration");
const cache_1 = require("./cache");
let cachedTasks;
class AntTaskProvider {
    constructor() { }
    provideTasks() {
        return provideAntScripts();
    }
    resolveTask(_task) {
        return undefined;
    }
}
exports.AntTaskProvider = AntTaskProvider;
function invalidateTasksCacheAnt(opt) {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("invalidateTasksCacheAnt");
        util.logValue("   uri", opt ? opt.path : (opt === null ? "null" : "undefined"), 2);
        util.logValue("   has cached tasks", cachedTasks ? "true" : "false", 2);
        if (opt && cachedTasks) {
            const rmvTasks = [];
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
                //
                // If this isn't a 'delete file' event then read the file for tasks
                //
                if (util.pathExists(opt.fsPath) && !util.existsInArray(configuration_1.configuration.get("exclude"), opt.path)) {
                    const tasks = yield readAntfile(opt);
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
exports.invalidateTasksCacheAnt = invalidateTasksCacheAnt;
function detectAntScripts() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("detectAntScripts");
        const allTasks = [];
        const visitedFiles = new Set();
        const paths = cache_1.filesCache.get("ant");
        if (vscode_1.workspace.workspaceFolders && paths) {
            for (const fobj of paths) {
                if (!util.isExcluded(fobj.uri.path) && !visitedFiles.has(fobj.uri.fsPath)) {
                    visitedFiles.add(fobj.uri.fsPath);
                    const tasks = yield readAntfile(fobj.uri);
                    allTasks.push(...tasks);
                }
            }
        }
        util.logValue("   # of tasks", allTasks.length, 2);
        return allTasks;
    });
}
function provideAntScripts() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("provideAntScripts");
        if (!cachedTasks) {
            cachedTasks = yield detectAntScripts();
        }
        return cachedTasks;
    });
}
exports.provideAntScripts = provideAntScripts;
function readAntfile(uri) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = [];
        const folder = vscode_1.workspace.getWorkspaceFolder(uri);
        if (folder) {
            const contents = yield util.readFile(uri.fsPath);
            const scripts = yield findAllAntScripts(contents);
            if (scripts) {
                Object.keys(scripts).forEach(each => {
                    const task = createAntTask(scripts[`${each}`] ? scripts[`${each}`] : `${each}`, each, folder, uri);
                    task.group = vscode_1.TaskGroup.Build;
                    result.push(task);
                });
            }
        }
        return result;
    });
}
function findAllAntScripts(buffer) {
    return __awaiter(this, void 0, void 0, function* () {
        let json = "";
        const scripts = {};
        util.log("");
        util.log("FindAllAntScripts");
        xml2js_1.parseString(buffer, (err, result) => {
            json = result;
        });
        if (json && json.project && json.project.target) {
            const defaultTask = json.project.$.default;
            const targets = json.project.target;
            for (const tgt in targets) {
                if (targets[tgt].$ && targets[tgt].$.name) {
                    util.logValue("   Found target", targets[tgt].$.name);
                    scripts[defaultTask === targets[tgt].$.name ? targets[tgt].$.name + " - Default" : targets[tgt].$.name] = targets[tgt].$.name;
                }
            }
        }
        return scripts;
    });
}
function createAntTask(target, cmdName, folder, uri) {
    function getCommand(folder) {
        let ant = "ant";
        if (process.platform === "win32") {
            ant = "ant.bat";
        }
        if (configuration_1.configuration.get("pathToAnt")) {
            ant = configuration_1.configuration.get("pathToAnt");
            if (process.platform === "win32" && ant.endsWith("\\ant")) {
                ant += ".bat";
            }
        }
        return ant;
    }
    function getRelativePath(folder, uri) {
        if (folder) {
            const rootUri = folder.uri;
            const absolutePath = uri.path.substring(0, uri.path.lastIndexOf("/") + 1);
            return absolutePath.substring(rootUri.path.length + 1);
        }
        return "";
    }
    const cwd = path.dirname(uri.fsPath);
    const antFile = path.basename(uri.path);
    let args = [target];
    let options = {
        cwd
    };
    const kind = {
        type: "ant",
        script: target,
        path: getRelativePath(folder, uri),
        fileName: antFile,
        uri
    };
    //
    // Ansicon for Windows
    //
    if (process.platform === "win32" && configuration_1.configuration.get("enableAnsiconForAnt") === true) {
        let ansicon = "ansicon.exe";
        const ansiPath = configuration_1.configuration.get("pathToAnsicon");
        if (ansiPath && util.pathExists(ansiPath)) {
            ansicon = ansiPath;
            if (!ansicon.endsWith("ansicon.exe") && !ansicon.endsWith("\\")) {
                ansicon = path.join(ansicon, "ansicon.exe");
            }
            else if (!ansicon.endsWith("ansicon.exe")) {
                ansicon += "ansicon.exe";
            }
        }
        args = ["-logger", "org.apache.tools.ant.listener.AnsiColorLogger", target];
        options = {
            cwd,
            executable: ansicon
        };
    }
    if (antFile.toLowerCase() !== "build.xml") {
        args.push("-f");
        args.push(antFile);
    }
    const execution = new vscode_1.ShellExecution(getCommand(folder), args, options);
    return new vscode_1.Task(kind, folder, cmdName ? cmdName : target, "ant", execution, undefined);
}
//# sourceMappingURL=taskProviderAnt.js.map