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
const scriptTable = {
    sh: {
        exec: "",
        type: "bash",
        args: [],
        enabled: configuration_1.configuration.get("enableBash")
    },
    py: {
        exec: configuration_1.configuration.get("pathToPython"),
        type: "python",
        args: [],
        enabled: configuration_1.configuration.get("enablePython")
    },
    rb: {
        exec: configuration_1.configuration.get("pathToRuby"),
        type: "ruby",
        args: [],
        enabled: configuration_1.configuration.get("enableRuby")
    },
    ps1: {
        exec: configuration_1.configuration.get("pathToPowershell"),
        type: "powershell",
        args: [],
        enabled: configuration_1.configuration.get("enablePowershell")
    },
    pl: {
        exec: configuration_1.configuration.get("pathToPerl"),
        type: "perl",
        args: [],
        enabled: configuration_1.configuration.get("enablePerl")
    },
    bat: {
        exec: "cmd",
        type: "batch",
        args: ["/c"],
        enabled: configuration_1.configuration.get("enableBatch")
    },
    cmd: {
        exec: "cmd",
        type: "batch",
        args: ["/c"],
        enabled: configuration_1.configuration.get("enableBatch")
    },
    nsi: {
        exec: configuration_1.configuration.get("pathToNsis"),
        type: "nsis",
        args: [],
        enabled: configuration_1.configuration.get("enableNsis")
    }
};
class ScriptTaskProvider {
    constructor() {
    }
    provideTasks() {
        return provideScriptFiles();
    }
    resolveTask(_task) {
        return undefined;
    }
}
exports.ScriptTaskProvider = ScriptTaskProvider;
function refreshScriptTable() {
    scriptTable.py.exec = configuration_1.configuration.get("pathToPython");
    scriptTable.rb.exec = configuration_1.configuration.get("pathToRuby");
    scriptTable.pl.exec = configuration_1.configuration.get("pathToPerl");
    scriptTable.nsi.exec = configuration_1.configuration.get("pathToNsis");
    scriptTable.ps1.exec = configuration_1.configuration.get("pathToPowershell");
    scriptTable.py.enabled = configuration_1.configuration.get("enablePython");
    scriptTable.rb.enabled = configuration_1.configuration.get("enableRuby");
    scriptTable.ps1.enabled = configuration_1.configuration.get("enablePerl");
    scriptTable.nsi.enabled = configuration_1.configuration.get("enableNsis");
    scriptTable.nsi.enabled = configuration_1.configuration.get("enablePowershell");
    scriptTable.sh.enabled = configuration_1.configuration.get("enableBash");
    scriptTable.bat.enabled = configuration_1.configuration.get("enableBatch");
}
function invalidateTasksCacheScript(opt) {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("invalidateTasksCacheScript");
        util.logValue("   uri", opt ? opt.path : (opt === null ? "null" : "undefined"), 2);
        util.logValue("   has cached tasks", cachedTasks ? "true" : "false", 2);
        if (opt && cachedTasks) {
            const rmvTasks = [];
            const folder = vscode_1.workspace.getWorkspaceFolder(opt);
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
                    const task = createScriptTask(scriptTable[path.extname(opt.fsPath).substring(1)], folder, opt);
                    cachedTasks.push(task);
                }
                if (cachedTasks.length > 0) {
                    return;
                }
            }
        }
        cachedTasks = undefined;
    });
}
exports.invalidateTasksCacheScript = invalidateTasksCacheScript;
function provideScriptFiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("provideScriptFiles");
        if (!cachedTasks) {
            refreshScriptTable();
            cachedTasks = yield detectScriptFiles();
        }
        return cachedTasks;
    });
}
function detectScriptFiles() {
    return __awaiter(this, void 0, void 0, function* () {
        util.log("");
        util.log("detectScriptFiles");
        const allTasks = [];
        const visitedFiles = new Set();
        const paths = cache_1.filesCache.get("script");
        if (vscode_1.workspace.workspaceFolders && paths) {
            for (const fobj of paths) {
                if (!util.isExcluded(fobj.uri.path) && !visitedFiles.has(fobj.uri.fsPath)) {
                    visitedFiles.add(fobj.uri.fsPath);
                    allTasks.push(createScriptTask(scriptTable[path.extname(fobj.uri.fsPath).substring(1).toLowerCase()], fobj.folder, fobj.uri));
                    util.log("   found script target");
                    util.logValue("      script file", fobj.uri.fsPath);
                }
            }
        }
        util.logValue("   # of tasks", allTasks.length, 2);
        return allTasks;
    });
}
function createScriptTask(scriptDef, folder, uri) {
    function getRelativePath(folder, uri) {
        let rtn = "";
        if (folder) {
            const rootUri = folder.uri;
            const absolutePath = uri.path.substring(0, uri.path.lastIndexOf("/") + 1);
            rtn = absolutePath.substring(rootUri.path.length + 1);
        }
        return rtn;
    }
    const cwd = path.dirname(uri.fsPath);
    const fileName = path.basename(uri.fsPath);
    let sep = (process.platform === "win32" ? "\\" : "/");
    const kind = {
        type: "script",
        scriptType: scriptDef.type,
        fileName,
        scriptFile: true,
        path: getRelativePath(folder, uri),
        requiresArgs: false,
        uri
    };
    //
    // Check if this script might need command line arguments
    //
    // TODO:  Other script types
    //
    if (scriptDef.type === "batch") {
        const contents = util.readFileSync(uri.fsPath);
        kind.requiresArgs = (new RegExp("%[1-9]")).test(contents);
    }
    //
    // Set current working dircetory in oprions to relative script dir
    //
    const options = {
        cwd
    };
    //
    // If the defualt terminal cmd/powershell?  On linux and darwin, no, on windows, maybe...
    //
    let isWinShell = false;
    if (process.platform === "win32") {
        isWinShell = true;
        const winShell = vscode_1.workspace.getConfiguration().get("terminal.integrated.shell.windows");
        if (winShell && winShell.includes("bash.exe")) {
            sep = "/";
            isWinShell = false;
        }
    }
    //
    // Handle bash script on windows - set the shell executable as bash.exe if it isnt the default.
    // This can be set by usernin settings, otherwise Git Bash will be tried in the default install
    // location ("C:\Program Files\Git\bin). Otherwise, use "bash.exe" and assume the command and
    // other shell commands are in PATH
    //
    if (isWinShell) {
        if (scriptDef.type === "bash") {
            let bash = configuration_1.configuration.get("pathToBash");
            if (!bash) {
                bash = "C:\\Program Files\\Git\\bin\\bash.exe";
            }
            if (!util.pathExists(bash)) {
                bash = "bash.exe";
            }
            options.executable = bash;
            sep = "/"; // convert path separator to unix-style
        }
    }
    const pathPre = "." + sep; // ; (scriptDef.type === "powershell" ? "." + sep : "")
    const fileNamePathPre = pathPre + fileName;
    //
    // Build arguments list
    //
    const args = [];
    //
    // Identify the 'executable'
    //
    let exec = scriptDef.exec;
    if (scriptDef.type === "bash") {
        exec = fileNamePathPre;
    }
    else { // All scripts except for 'bash'
        //
        // Add any defined arguments to the command line exec
        //
        if (scriptDef.args) {
            args.push(...scriptDef.args);
        }
        //
        // Add the filename as an argument to the script exe (i.e. 'powershell', 'cmd', etc)
        //
        args.push(scriptDef.type !== "powershell" ? fileName : fileNamePathPre);
    }
    //
    // For python setup.py scripts, use the bdist_egg argument - the egg will be built and stored
    // at dist/PackageName-Version.egg
    //
    if (scriptDef.type === "python") {
        args.push("bdist_egg");
    }
    //
    // Make sure there are no windows style slashes in any configured path to an executable
    // if this isnt running in a windows shell
    //
    if (!isWinShell) {
        exec = exec.replace(/\\/g, "/");
    }
    //
    // Create the shell execution object and task
    //
    const execution = new vscode_1.ShellExecution(exec, args, options);
    return new vscode_1.Task(kind, folder, scriptDef.type !== "python" ? fileName : "build egg", scriptDef.type, execution, undefined);
}
//# sourceMappingURL=taskProviderScript.js.map