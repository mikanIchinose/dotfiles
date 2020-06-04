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
const fs = require("fs");
const minimatch = require("minimatch");
const configuration_1 = require("./common/configuration");
const logValueWhiteSpace = 40;
let writeToConsole = false;
let writeToConsoleLevel = 2;
let logOutputChannel;
function asyncForEach(array, callback) {
    return __awaiter(this, void 0, void 0, function* () {
        for (let index = 0; index < array.length; index++) {
            const result = yield callback(array[index], index, array);
            if (result === false) {
                break;
            }
        }
    });
}
exports.asyncForEach = asyncForEach;
function asyncMapForEach(map, callback) {
    return __awaiter(this, void 0, void 0, function* () {
        for (const entry of map.entries()) {
            const result = yield callback(entry[1], entry[0], map);
            if (result === false) {
                break;
            }
        }
    });
}
exports.asyncMapForEach = asyncMapForEach;
function initLog(settingGrpName, dispName, context, showLog) {
    function showLogOutput(show) {
        if (logOutputChannel && show) {
            logOutputChannel.show();
        }
    }
    //
    // Set up a log in the Output window
    //
    logOutputChannel = vscode_1.window.createOutputChannel(dispName);
    if (context) {
        context.subscriptions.push(logOutputChannel);
        context.subscriptions.push(vscode_1.commands.registerCommand(settingGrpName + ".showOutput", showLogOutput));
    }
    showLogOutput(showLog);
}
exports.initLog = initLog;
function getCwd(uri) {
    let dir = uri.fsPath.substring(0, uri.fsPath.lastIndexOf("\\") + 1);
    if (process.platform !== "win32") {
        dir = uri.fsPath.substring(0, uri.fsPath.lastIndexOf("/") + 1);
    }
    return dir;
}
exports.getCwd = getCwd;
function camelCase(name, indexUpper) {
    if (!name || indexUpper <= 0 || indexUpper >= name.length) {
        return name;
    }
    return name
        .replace(/(?:^\w|[A-Za-z]|\b\w)/g, (letter, index) => {
        return index !== indexUpper ? letter.toLowerCase() : letter.toUpperCase();
    })
        .replace(/[\s\-]+/g, "");
}
exports.camelCase = camelCase;
function properCase(name) {
    if (!name) {
        return name;
    }
    return name
        .replace(/(?:^\w|[A-Z]|\b\w)/g, (letter, index) => {
        return index !== 0 ? letter.toLowerCase() : letter.toUpperCase();
    })
        .replace(/[\s]+/g, "");
}
exports.properCase = properCase;
function getExcludesGlob(folder) {
    let relativePattern = new vscode_1.RelativePattern(folder, "**/node_modules/**");
    const excludes = configuration_1.configuration.get("exclude");
    if (excludes && excludes.length > 0) {
        let multiFilePattern = "{**/node_modules/**";
        if (Array.isArray(excludes)) {
            for (const i in excludes) {
                multiFilePattern += ",";
                multiFilePattern += excludes[i];
            }
        }
        else {
            multiFilePattern += ",";
            multiFilePattern += excludes;
        }
        multiFilePattern += "}";
        relativePattern = new vscode_1.RelativePattern(folder, multiFilePattern);
    }
    return relativePattern;
}
exports.getExcludesGlob = getExcludesGlob;
function isExcluded(uriPath, logPad = "") {
    function testForExclusionPattern(path, pattern) {
        return minimatch(path, pattern, { dot: true, nocase: true });
    }
    const exclude = configuration_1.configuration.get("exclude");
    log("", 2);
    log(logPad + "Check exclusion", 2);
    logValue(logPad + "   path", uriPath, 2);
    if (exclude) {
        if (Array.isArray(exclude)) {
            for (const pattern of exclude) {
                logValue(logPad + "   checking pattern", pattern, 3);
                if (testForExclusionPattern(uriPath, pattern)) {
                    log(logPad + "   Excluded!", 2);
                    return true;
                }
            }
        }
        else {
            logValue(logPad + "   checking pattern", exclude, 3);
            if (testForExclusionPattern(uriPath, exclude)) {
                log(logPad + "   Excluded!", 2);
                return true;
            }
        }
    }
    log(logPad + "   Not excluded", 2);
    return false;
}
exports.isExcluded = isExcluded;
function timeout(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
exports.timeout = timeout;
function pathExists(path) {
    try {
        fs.accessSync(path);
    }
    catch (err) {
        return false;
    }
    return true;
}
exports.pathExists = pathExists;
function readFile(file) {
    return __awaiter(this, void 0, void 0, function* () {
        return new Promise((resolve, reject) => {
            fs.readFile(file, (err, data) => {
                if (err) {
                    reject(err);
                }
                resolve(data ? data.toString() : "");
            });
        });
    });
}
exports.readFile = readFile;
function readFileSync(file) {
    const buf = fs.readFileSync(file);
    return (buf ? buf.toString() : "");
}
exports.readFileSync = readFileSync;
function removeFromArray(arr, item) {
    let idx = -1;
    let idx2 = -1;
    arr.forEach(each => {
        idx++;
        if (item === each) {
            idx2 = idx;
            return false;
        }
    });
    if (idx2 !== -1 && idx2 < arr.length) {
        arr.splice(idx2, 1);
    }
}
exports.removeFromArray = removeFromArray;
function existsInArray(arr, item) {
    let exists = false;
    if (arr) {
        arr.forEach(each => {
            if (item === each) {
                exists = true;
                return false;
            }
        });
    }
    return exists;
}
exports.existsInArray = existsInArray;
function setWriteToConsole(set, level = 2) {
    writeToConsole = set;
    writeToConsoleLevel = level;
}
exports.setWriteToConsole = setWriteToConsole;
function log(msg, level) {
    return __awaiter(this, void 0, void 0, function* () {
        if (msg === null || msg === undefined) {
            return;
        }
        if (configuration_1.configuration.get("debug") === true) {
            if (logOutputChannel && (!level || level <= configuration_1.configuration.get("debugLevel"))) {
                logOutputChannel.appendLine(msg);
            }
            if (writeToConsole === true) {
                if (!level || level <= writeToConsoleLevel) {
                    console.log(msg);
                }
            }
        }
    });
}
exports.log = log;
function logValue(msg, value, level) {
    return __awaiter(this, void 0, void 0, function* () {
        let logMsg = msg;
        const spaces = msg && msg.length ? msg.length : (value === undefined ? 9 : 4);
        for (let i = spaces; i < logValueWhiteSpace; i++) {
            logMsg += " ";
        }
        if (value || value === 0 || value === "") {
            logMsg += ": ";
            logMsg += value.toString();
        }
        else if (value === undefined) {
            logMsg += ": undefined";
        }
        else if (value === null) {
            logMsg += ": null";
        }
        if (configuration_1.configuration.get("debug") === true) {
            if (logOutputChannel && (!level || level <= configuration_1.configuration.get("debugLevel"))) {
                logOutputChannel.appendLine(logMsg);
            }
            if (writeToConsole === true) {
                if (!level || level <= writeToConsoleLevel) {
                    console.log(logMsg);
                }
            }
        }
    });
}
exports.logValue = logValue;
//# sourceMappingURL=util.js.map