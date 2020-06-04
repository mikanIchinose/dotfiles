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
const path = require("path");
const util = require("./util");
const assert = require("assert");
const vscode_1 = require("vscode");
const jsonc_parser_1 = require("jsonc-parser");
const nls = require("vscode-nls");
const tasks_1 = require("./tasks");
const storage_1 = require("./common/storage");
const views_1 = require("./views");
const cache_1 = require("./cache");
const configuration_1 = require("./common/configuration");
const taskProviderAnt_1 = require("./taskProviderAnt");
const taskProviderMake_1 = require("./taskProviderMake");
const taskProviderScript_1 = require("./taskProviderScript");
const taskProviderGradle_1 = require("./taskProviderGradle");
const taskProviderGrunt_1 = require("./taskProviderGrunt");
const taskProviderGulp_1 = require("./taskProviderGulp");
const taskProviderAppPublisher_1 = require("./taskProviderAppPublisher");
const localize = nls.loadMessageBundle();
class NoScripts extends vscode_1.TreeItem {
    constructor() {
        super(localize("noScripts", "No scripts found"), vscode_1.TreeItemCollapsibleState.None);
        this.contextValue = "noscripts";
    }
}
class TaskTreeDataProvider {
    constructor(name, context) {
        this.taskTree = null;
        this.tasks = null;
        this.needsRefresh = [];
        this._onDidChangeTreeData = new vscode_1.EventEmitter();
        this.onDidChangeTreeData = this._onDidChangeTreeData.event;
        this.busy = false;
        this.lastTasksText = "Last Tasks";
        const subscriptions = context.subscriptions;
        this.extensionContext = context;
        this.name = name;
        subscriptions.push(vscode_1.commands.registerCommand(name + ".run", (item) => __awaiter(this, void 0, void 0, function* () { yield this.run(item); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".runLastTask", () => __awaiter(this, void 0, void 0, function* () { yield this.runLastTask(); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".stop", (item) => __awaiter(this, void 0, void 0, function* () { yield this.stop(item); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".restart", (item) => __awaiter(this, void 0, void 0, function* () { yield this.restart(item); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".pause", (item) => __awaiter(this, void 0, void 0, function* () { yield this.pause(item); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".open", (item) => __awaiter(this, void 0, void 0, function* () { yield this.open(item); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".openTerminal", (item) => __awaiter(this, void 0, void 0, function* () { yield this.openTerminal(item); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".refresh", () => __awaiter(this, void 0, void 0, function* () { yield this.refresh(true, false); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".runInstall", (taskFile) => __awaiter(this, void 0, void 0, function* () { yield this.runNpmCommand(taskFile, "install"); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".runUpdate", (taskFile) => __awaiter(this, void 0, void 0, function* () { yield this.runNpmCommand(taskFile, "update"); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".runUpdatePackage", (taskFile) => __awaiter(this, void 0, void 0, function* () { yield this.runNpmCommand(taskFile, "update <packagename>"); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".runAudit", (taskFile) => __awaiter(this, void 0, void 0, function* () { yield this.runNpmCommand(taskFile, "audit"); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".runAuditFix", (taskFile) => __awaiter(this, void 0, void 0, function* () { yield this.runNpmCommand(taskFile, "audit fix"); }), this));
        subscriptions.push(vscode_1.commands.registerCommand(name + ".addToExcludes", (taskFile, global, prompt) => __awaiter(this, void 0, void 0, function* () { yield this.addToExcludes(taskFile, global, prompt); }), this));
        vscode_1.tasks.onDidStartTask((_e) => this.refresh(false, _e.execution.task.definition.uri, _e.execution.task));
        vscode_1.tasks.onDidEndTask((_e) => this.refresh(false, _e.execution.task.definition.uri, _e.execution.task));
    }
    invalidateTasksCache(opt1, opt2) {
        return __awaiter(this, void 0, void 0, function* () {
            this.busy = true;
            //
            // All internal task providers export an invalidate() function...
            //
            // If 'opt1' is a string then a filesystemwatcher or taskevent was triggered for the
            // task type defined in the 'opt1' parameter.
            //
            // 'opt2' should contain the Uri of the file that was edited, or the Task if this was
            // a task event
            //
            if (opt1 && opt1 !== "tests" && opt2 instanceof vscode_1.Uri) {
                if (opt1 === "ant") {
                    yield taskProviderAnt_1.invalidateTasksCacheAnt(opt2);
                }
                else if (opt1 === "gradle") {
                    yield taskProviderGradle_1.invalidateTasksCacheGradle(opt2);
                }
                else if (opt1 === "grunt") {
                    yield taskProviderGrunt_1.invalidateTasksCacheGrunt(opt2);
                }
                else if (opt1 === "gulp") {
                    yield taskProviderGulp_1.invalidateTasksCacheGulp(opt2);
                }
                else if (opt1 === "make") {
                    yield taskProviderMake_1.invalidateTasksCacheMake(opt2);
                }
                else if (opt1 === "app-publisher") {
                    yield taskProviderAppPublisher_1.invalidateTasksCacheAppPublisher(opt2);
                }
                else if (opt1 === "bash" || opt1 === "batch" || opt1 === "nsis" || opt1 === "perl" || opt1 === "powershell" || opt1 === "python" || opt1 === "ruby") {
                    yield taskProviderScript_1.invalidateTasksCacheScript(opt2);
                }
            }
            else {
                yield taskProviderAnt_1.invalidateTasksCacheAnt();
                yield taskProviderMake_1.invalidateTasksCacheMake();
                yield taskProviderScript_1.invalidateTasksCacheScript();
                yield taskProviderGradle_1.invalidateTasksCacheGradle();
                yield taskProviderGrunt_1.invalidateTasksCacheGrunt();
                yield taskProviderGulp_1.invalidateTasksCacheGulp();
                yield taskProviderAppPublisher_1.invalidateTasksCacheAppPublisher();
            }
            this.busy = false;
        });
    }
    run(taskItem) {
        return __awaiter(this, void 0, void 0, function* () {
            const me = this;
            if (!taskItem || this.busy) {
                vscode_1.window.showInformationMessage("Busy, please wait...");
                return;
            }
            //
            // If this is a script, check to see if args are required
            //
            // A script task will set the 'requiresArgs' parameter to true if command line arg
            // parameters are detected in the scripts contents when inported.  For example, if a
            // batch script contains %1, %2, etc, the task definition's requiresArgs parameter
            // will be set.
            //
            /*
            if (taskItem.task.definition.requiresArgs === true)
            {
                let opts: InputBoxOptions = { prompt: 'Enter command line arguments separated by spaces'};
                window.showInputBox(opts).then(function(str)
                {
                    if (str !== undefined)
                    {
                        //let origArgs = taskItem.task.execution.args ? taskItem.task.execution.args.slice(0) : []; // clone
                        if (str) {
                            //origArgs.push(...str.split(' '));
                            taskItem.task.execution  = new ShellExecution(taskItem.task.definition.cmdLine + ' ' + str, taskItem.task.execution.options);
                        }
                        else {
                            taskItem.task.execution  = new ShellExecution(taskItem.task.definition.cmdLine, taskItem.task.execution.options);
                        }
                        tasks.executeTask(taskItem.task)
                        .then(function(execution) {
                            //taskItem.task.execution.args = origArgs.slice(0); // clone
                            me.saveRunTask(taskItem);
                        },
                        function(reason) {
                            //taskItem.task.execution.args = origArgs.slice(0); // clone
                        });
                    }
                });
            }
            else
            {*/
            // Execute task
            //
            if (taskItem.paused) {
                const term = this.getTerminal(taskItem);
                if (term) {
                    term.sendText("N", true);
                    taskItem.paused = false;
                }
            }
            else {
                yield vscode_1.tasks.executeTask(taskItem.task);
                me.saveRunTask(taskItem);
            }
        });
    }
    pause(taskItem) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!taskItem || this.busy) {
                vscode_1.window.showInformationMessage("Busy, please wait...");
                return;
            }
            if (taskItem.execution) {
                const terminal = this.getTerminal(taskItem);
                if (terminal) {
                    if (taskItem.paused) {
                        taskItem.paused = false;
                        terminal.sendText("N");
                    }
                    else {
                        taskItem.paused = true;
                        terminal.sendText("\u0003");
                    }
                }
            }
        });
    }
    stop(taskItem) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!taskItem || this.busy) {
                vscode_1.window.showInformationMessage("Busy, please wait...");
                return;
            }
            if (taskItem.execution) {
                if (configuration_1.configuration.get("keepTermOnStop") === true) {
                    const terminal = this.getTerminal(taskItem);
                    if (terminal) {
                        if (taskItem.paused) {
                            terminal.sendText("Y");
                        }
                        else {
                            terminal.sendText("\u0003");
                            function yes() {
                                terminal.sendText("Y", true);
                            }
                            setTimeout(yes, 300);
                        }
                        taskItem.paused = false;
                    }
                }
                else {
                    taskItem.execution.terminate();
                }
            }
        });
    }
    restart(taskItem) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!taskItem || this.busy) {
                vscode_1.window.showInformationMessage("Busy, please wait...");
                return;
            }
            this.stop(taskItem);
            this.run(taskItem);
        });
    }
    runLastTask() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.busy) {
                vscode_1.window.showInformationMessage("Busy, please wait...");
                return;
            }
            let lastTaskId;
            const lastTasks = storage_1.storage.get("lastTasks", []);
            if (lastTasks && lastTasks.length > 0) {
                lastTaskId = lastTasks[lastTasks.length - 1];
            }
            if (!lastTaskId) {
                vscode_1.window.showInformationMessage("No saved tasks!");
                return;
            }
            util.logValue("Run last task", lastTaskId);
            const taskItem = yield this.getTaskItems(lastTaskId);
            if (taskItem && taskItem instanceof tasks_1.TaskItem) {
                this.run(taskItem);
            }
            else {
                vscode_1.window.showInformationMessage("Task not found!  Check log for details");
                util.removeFromArray(lastTasks, lastTaskId);
                storage_1.storage.update("lastTasks", lastTasks);
                this.showLastTasks(true);
            }
        });
    }
    getTerminal(taskItem) {
        const me = this;
        let checkNum = 0;
        let term = null;
        util.log("Get terminal", 1);
        if (!vscode_1.window.terminals || vscode_1.window.terminals.length === 0) {
            util.log("   zero terminals alive", 2);
            return term;
        }
        if (vscode_1.window.terminals.length === 1) {
            util.log("   return only terminal alive", 2);
            return vscode_1.window.terminals[0];
        }
        function check(taskName) {
            let term = null;
            util.logValue("   Checking possible task terminal name #" + (++checkNum).toString(), taskName, 2);
            vscode_1.window.terminals.forEach((t, i) => __awaiter(this, void 0, void 0, function* () {
                util.logValue("      == terminal " + i + " name", t.name, 2);
                if (taskName.toLowerCase().replace("task - ", "").indexOf(t.name.toLowerCase().replace("task - ", "")) !== -1) {
                    term = t;
                    util.log("   found!", 2);
                    return false; // break forEach()
                }
            }));
            return term;
        }
        let relPath = taskItem.task.definition.path ? taskItem.task.definition.path : "";
        if (relPath[relPath.length - 1] === "/") {
            relPath = relPath.substring(0, relPath.length - 1);
        }
        else if (relPath[relPath.length - 1] === "\\") {
            relPath = relPath.substring(0, relPath.length - 1);
        }
        let taskName = "Task - " + taskItem.taskFile.label + ": " + taskItem.label +
            " (" + taskItem.taskFile.folder.workspaceFolder.name + ")";
        term = check(taskName);
        if (!term && taskItem.label.indexOf("(") !== -1) {
            taskName = "Task - " + taskItem.taskSource + ": " + taskItem.label.substring(0, taskItem.label.indexOf("(")).trim() +
                " (" + taskItem.taskFile.folder.workspaceFolder.name + ")";
            term = check(taskName);
        }
        if (!term) {
            taskName = "Task - " + taskItem.taskSource + ": " + taskItem.label +
                " - " + relPath + " (" + taskItem.taskFile.folder.workspaceFolder.name + ")";
            term = check(taskName);
        }
        if (!term && taskItem.label.indexOf("(") !== -1) {
            taskName = "Task - " + taskItem.taskSource + ": " + taskItem.label.substring(0, taskItem.label.indexOf("(")).trim() +
                " - " + relPath + " (" + taskItem.taskFile.folder.workspaceFolder.name + ")";
            term = check(taskName);
        }
        if (!term) {
            taskName = taskItem.getFolder().name + " (" + relPath + ")";
            term = check(taskName);
        }
        if (!term) {
            taskName = taskItem.getFolder().name + " (" + path.basename(relPath) + ")";
            term = check(taskName);
        }
        return term;
    }
    openTerminal(taskItem) {
        return __awaiter(this, void 0, void 0, function* () {
            const term = this.getTerminal(taskItem);
            if (term) {
                term.show();
            }
        });
    }
    getTaskItems(taskId, logPad = "", executeOpenForTests = false) {
        return __awaiter(this, void 0, void 0, function* () {
            const me = this;
            const taskMap = new Map();
            let done = false;
            util.log(logPad + "Get task tree items, start task tree scan");
            util.logValue(logPad + "   task id", taskId ? taskId : "all tasks");
            util.logValue(logPad + "   execute open", executeOpenForTests.toString());
            const treeItems = yield this.getChildren(undefined, "   ");
            if (!treeItems || treeItems.length === 0) {
                vscode_1.window.showInformationMessage("No tasks found!");
                storage_1.storage.update("lastTasks", []);
                return;
            }
            if (!treeItems || treeItems.length === 0) {
                return;
            }
            function processItem2g(pitem2) {
                return __awaiter(this, void 0, void 0, function* () {
                    const treeFiles = yield me.getChildren(pitem2, "   ");
                    if (treeFiles.length > 0) {
                        yield util.asyncForEach(treeFiles, (item2) => __awaiter(this, void 0, void 0, function* () {
                            if (done) {
                                return false;
                            }
                            if (item2 instanceof tasks_1.TaskItem) {
                                const tmp = me.getParent(item2);
                                assert(tmp instanceof tasks_1.TaskFile, "Invaid parent type, should be TaskFile for TaskItem");
                                yield processItem2(item2);
                            }
                            else if (item2 instanceof tasks_1.TaskFile && item2.isGroup) {
                                util.log("        Task File (grouped): " + item2.path + item2.fileName);
                                yield processItem2g(item2);
                            }
                            else if (item2 instanceof tasks_1.TaskFile && !item2.isGroup) {
                                util.log("        Task File (grouped): " + item2.path + item2.fileName);
                                yield processItem2(item2);
                            }
                        }));
                    }
                });
            }
            function processItem2(pitem2) {
                return __awaiter(this, void 0, void 0, function* () {
                    const treeTasks = yield me.getChildren(pitem2, "   ");
                    if (treeTasks.length > 0) {
                        yield util.asyncForEach(treeTasks, (item3) => __awaiter(this, void 0, void 0, function* () {
                            if (done) {
                                return false;
                            }
                            if (item3 instanceof tasks_1.TaskItem) {
                                if (executeOpenForTests) {
                                    yield me.open(item3);
                                }
                                const tmp = me.getParent(item3);
                                assert(tmp instanceof tasks_1.TaskFile, "Invaid parent type, should be TaskFile for TaskItem");
                                if (item3.task && item3.task.definition) {
                                    const tpath = item3.task.definition.uri ? item3.task.definition.uri.fsPath :
                                        (item3.task.definition.path ? item3.task.definition.path : "root");
                                    util.log(logPad + "   ✔ Processed " + item3.task.name);
                                    util.logValue(logPad + "        id", item3.id);
                                    util.logValue(logPad + "        type", item3.taskSource + " @ " + tpath);
                                    taskMap.set(item3.id, item3);
                                    if (taskId && taskId === item3.id) {
                                        done = true;
                                    }
                                }
                            }
                            else if (item3 instanceof tasks_1.TaskFile && item3.isGroup) {
                                yield processItem2(item3);
                            }
                        }));
                    }
                });
            }
            function processItem(pitem) {
                return __awaiter(this, void 0, void 0, function* () {
                    let tmp;
                    const treeFiles = yield me.getChildren(pitem, "   ");
                    if (treeFiles.length > 0) {
                        yield util.asyncForEach(treeFiles, (item2) => __awaiter(this, void 0, void 0, function* () {
                            if (done) {
                                return false;
                            }
                            if (item2 instanceof tasks_1.TaskFile && !item2.isGroup) {
                                util.log(logPad + "   Task File: " + item2.path + item2.fileName);
                                tmp = me.getParent(item2);
                                assert(tmp instanceof tasks_1.TaskFolder, "Invaid parent type, should be TaskFolder for TaskFile");
                                yield processItem2(item2);
                            }
                            else if (item2 instanceof tasks_1.TaskFile && item2.isGroup) {
                                yield processItem2g(item2);
                            }
                            else if (item2 instanceof tasks_1.TaskItem) {
                                yield processItem2(item2);
                            }
                        }));
                    }
                });
            }
            yield util.asyncForEach(treeItems, (item) => __awaiter(this, void 0, void 0, function* () {
                if (item instanceof tasks_1.TaskFolder) {
                    const tmp = me.getParent(item);
                    assert(tmp === null, "Invaid parent type, should be null for TaskFolder");
                    util.log(logPad + "Task Folder " + item.label + ":  " + (item.resourceUri ?
                        item.resourceUri.fsPath : me.lastTasksText));
                    yield processItem(item);
                }
            }));
            util.log(logPad + "   finished task tree scan");
            util.logValue(logPad + "   # of items found", taskMap.keys.length, 2);
            if (taskId) {
                return taskMap.get(taskId);
            }
            return taskMap;
        });
    }
    saveRunTask(taskItem, logPad = "") {
        util.log(logPad + "save run task");
        const lastTasks = storage_1.storage.get("lastTasks", []);
        util.logValue(logPad + "   current saved task ids", lastTasks.toString(), 2);
        const taskId = taskItem.id.replace(this.lastTasksText + ":", "");
        if (util.existsInArray(lastTasks, taskId)) {
            util.removeFromArray(lastTasks, taskId);
        }
        if (lastTasks.length >= configuration_1.configuration.get("numLastTasks")) {
            lastTasks.shift();
        }
        lastTasks.push(taskId);
        util.logValue(logPad + "   pushed taskitem id", taskItem.id, 2);
        storage_1.storage.update("lastTasks", lastTasks);
        util.logValue(logPad + "   new saved task ids", lastTasks.toString(), 2);
        if (configuration_1.configuration.get("showLastTasks") === true) {
            util.log(logPad + "   call showLastTasks()");
            this.showLastTasks(true, taskItem);
        }
    }
    showLastTasks(show, taskItem, logPad = "") {
        return __awaiter(this, void 0, void 0, function* () {
            let changed = true;
            const tree = this.taskTree;
            util.log(logPad + "show last tasks");
            util.logValue(logPad + "   show", show);
            if (!this.taskTree || this.taskTree.length === 0 ||
                (this.taskTree.length === 1 && this.taskTree[0].contextValue === "noscripts")) {
                return;
            }
            if (show) {
                if (!taskItem) // refresh
                 {
                    tree.splice(0, 1);
                    changed = true;
                }
                if (tree[0].label !== this.lastTasksText) {
                    util.log(logPad + "   create last tasks folder", 2);
                    const lastTasks = storage_1.storage.get("lastTasks", []);
                    const ltfolder = new tasks_1.TaskFolder(this.lastTasksText);
                    tree.splice(0, 0, ltfolder);
                    yield util.asyncForEach(lastTasks, (tId) => __awaiter(this, void 0, void 0, function* () {
                        const taskItem2 = yield this.getTaskItems(tId);
                        if (taskItem2 && taskItem2 instanceof tasks_1.TaskItem) {
                            const taskItem3 = new tasks_1.TaskItem(this.extensionContext, taskItem2.taskFile, taskItem2.task);
                            taskItem3.id = this.lastTasksText + ":" + taskItem3.id;
                            taskItem3.label = this.getLastTaskName(taskItem3);
                            ltfolder.insertTaskFile(taskItem3, 0);
                        }
                    }));
                    changed = true;
                }
                else if (taskItem) {
                    let taskItem2;
                    const ltfolder = tree[0];
                    let taskId = taskItem.id.replace(this.lastTasksText + ":", "");
                    taskId = this.lastTasksText + ":" + taskItem.id;
                    ltfolder.taskFiles.forEach((t) => {
                        if (t.id === taskId) {
                            taskItem2 = t;
                            return false;
                        }
                    });
                    if (taskItem2) {
                        ltfolder.removeTaskFile(taskItem2);
                    }
                    else if (ltfolder.taskFiles.length >= configuration_1.configuration.get("numLastTasks")) {
                        ltfolder.removeTaskFile(ltfolder.taskFiles[ltfolder.taskFiles.length - 1]);
                    }
                    if (!taskItem2) {
                        taskItem2 = new tasks_1.TaskItem(this.extensionContext, taskItem.taskFile, taskItem.task);
                        taskItem2.id = taskId;
                        taskItem2.label = this.getLastTaskName(taskItem2);
                    }
                    util.logValue(logPad + "   add item", taskItem2.id, 2);
                    ltfolder.insertTaskFile(taskItem2, 0);
                    changed = true;
                }
            }
            else {
                if (tree[0].label === this.lastTasksText) {
                    tree.splice(0, 1);
                    changed = true;
                }
            }
            if (changed) {
                this._onDidChangeTreeData.fire();
            }
        });
    }
    pickLastTask() {
        return __awaiter(this, void 0, void 0, function* () {
            // let taskItem: TaskItem;
            // let lastTasks = storage.get<Array<string>>("lastTasks", []);
            // lastTasks.forEach(each =>
            // {
            // });
            // this.run(taskItem);
        });
    }
    open(selection) {
        return __awaiter(this, void 0, void 0, function* () {
            let uri;
            if (selection instanceof tasks_1.TaskFile) {
                uri = selection.resourceUri;
            }
            else if (selection instanceof tasks_1.TaskItem) {
                uri = selection.taskFile.resourceUri;
            }
            if (uri) {
                util.log("Open script at position");
                util.logValue("   command", selection.command.command);
                util.logValue("   source", selection.taskSource);
                util.logValue("   uri path", uri.path);
                util.logValue("   file path", uri.fsPath);
                if (util.pathExists(uri.fsPath)) {
                    const document = yield vscode_1.workspace.openTextDocument(uri);
                    const offset = this.findScriptPosition(document, selection instanceof tasks_1.TaskItem ? selection : undefined);
                    const position = document.positionAt(offset);
                    yield vscode_1.window.showTextDocument(document, { selection: new vscode_1.Selection(position, position) });
                }
            }
        });
    }
    refresh(invalidate, opt, task) {
        return __awaiter(this, void 0, void 0, function* () {
            util.log("Refresh task tree");
            util.logValue("   invalidate", invalidate, 2);
            util.logValue("   opt fsPath", opt && opt instanceof vscode_1.Uri ? opt.fsPath : "n/a", 2);
            util.logValue("   task name", task ? task.name : "n/a", 2);
            //
            // Show status bar message (if ON in settings)
            //
            if (task && configuration_1.configuration.get("showRunningTask") === true) {
                const exec = vscode_1.tasks.taskExecutions.find(e => e.task.name === task.name && e.task.source === task.source &&
                    e.task.scope === task.scope && e.task.definition.path === task.definition.path);
                if (exec) {
                    if (!TaskTreeDataProvider.statusBarSpace) {
                        TaskTreeDataProvider.statusBarSpace = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left, -10000);
                        TaskTreeDataProvider.statusBarSpace.tooltip = "Task Explorer running task";
                    }
                    let statusMsg = task.name;
                    if (task.scope.name) {
                        statusMsg += " (" + task.scope.name + ")";
                    }
                    TaskTreeDataProvider.statusBarSpace.text = "$(loading~spin) " + statusMsg;
                    TaskTreeDataProvider.statusBarSpace.show();
                }
                else if (TaskTreeDataProvider.statusBarSpace) {
                    TaskTreeDataProvider.statusBarSpace.dispose();
                    TaskTreeDataProvider.statusBarSpace = undefined;
                }
            }
            //
            // If a view was turned off in settings, the disposable view still remains
            // ans will still receive events.  CHeck visibility property, and of this view
            // is hidden/disabled, then exit.  Unless opt is defined, in which case this is just a
            // task ending, so we can proceed just invalidating that task set
            //
            if (this.taskTree && views_1.views.get(this.name) && invalidate !== "tests") {
                if (!views_1.views.get(this.name).visible) {
                    util.log("   Delay refresh, exit");
                    this.needsRefresh.push({ invalidate, opt, task });
                    return;
                }
            }
            //
            // The invalidate param will be equal to 'visible-event' when this method is called from the
            // visibility change event in extension.ts.
            //
            // If a view isnt visible on any refresh request, a requested refresh will exit and record the refresh
            // parameters in an object (above block of code).  When the view becomes visible again, we refresh if we
            // need to, if not then just exit on this refresh request
            //
            if (this.taskTree && invalidate === "visible-event") {
                util.log("   Handling 'visible' event");
                if (this.needsRefresh && this.needsRefresh.length > 0) {
                    // If theres more than one pending refresh request, just refresh the tree
                    //
                    if (this.needsRefresh.length > 1 || this.needsRefresh[0].invalidate === undefined) {
                        this.refresh();
                    }
                    else {
                        this.refresh(this.needsRefresh[0].invalidate, this.needsRefresh[0].uri, this.needsRefresh[0].task);
                    }
                    this.needsRefresh = [];
                }
                return;
            }
            if (invalidate === "visible-event") {
                invalidate = undefined;
            }
            //
            // TODO - performance enhancement
            // Can only invalidate a section of the tree depending on tasktype/uri?
            //
            this.taskTree = null;
            //
            // If invalidate is false, then this is a task start/stop
            //
            // If invalidate is true and opt is false, then the refresh button was clicked
            //
            // If invalidate is "tests" and opt undefined, then extension.refreshTree() called in tests
            //
            // If task is truthy, then a task has started/stopped, opt will be the task deifnition's
            // 'uri' property, note that task types not internally provided will not contain this property.
            //
            // If invalidate and opt are both truthy, then a filesystemwatcher event or a task just triggered
            //
            // If invalidate and opt are both undefined, then a configuration has changed
            //
            let treeItem;
            if (invalidate !== false) {
                if ((invalidate === true || invalidate === "tests") && !opt) {
                    util.log("   Handling 'rebuild cache' event");
                    this.busy = true;
                    yield cache_1.rebuildCache();
                    this.busy = false;
                }
                if (invalidate !== "tests") {
                    util.log("   Handling 'invalidate tasks cache' event");
                    yield this.invalidateTasksCache(invalidate, opt);
                }
            }
            if (task) {
                treeItem = task.definition.treeItem;
            }
            else {
                this.tasks = null;
            }
            this._onDidChangeTreeData.fire(treeItem);
            util.log("   Refresh task tree finished");
            return true;
        });
    }
    addToExcludes(selection, global, prompt) {
        return __awaiter(this, void 0, void 0, function* () {
            const me = this;
            let uri;
            let pathValue = "";
            if (selection instanceof tasks_1.TaskFile) {
                uri = selection.resourceUri;
                if (!uri && !selection.isGroup) {
                    return;
                }
            }
            util.log("Add to excludes");
            util.logValue("   global", global === false ? "false" : "true", 2);
            if (selection instanceof tasks_1.TaskFile) {
                if (selection.isGroup) {
                    util.log("  File group");
                    pathValue = "";
                    selection.scripts.forEach(each => {
                        pathValue += each.resourceUri.path;
                        pathValue += ",";
                    });
                    if (pathValue) {
                        pathValue = pathValue.substring(0, pathValue.length - 1);
                    }
                }
                else {
                    util.logValue("  File glob", uri.path);
                    pathValue = uri.path;
                }
            }
            else {
                pathValue = selection;
            }
            if (!pathValue) {
                return;
            }
            util.logValue("   path value", pathValue, 2);
            function saveExclude(str) {
                return __awaiter(this, void 0, void 0, function* () {
                    if (str) {
                        let excludes = [];
                        const excludes2 = configuration_1.configuration.get("exclude");
                        if (excludes2 && excludes2 instanceof Array) {
                            excludes = excludes2;
                        }
                        else if (excludes2 instanceof String) {
                            excludes.push(excludes2.toString());
                        }
                        const strs = str.split(",");
                        for (const s in strs) {
                            if (!util.existsInArray(excludes, strs[s])) {
                                excludes.push(strs[s]);
                            }
                        }
                        if (global !== false) {
                            configuration_1.configuration.update("exclude", excludes);
                        }
                        else {
                            configuration_1.configuration.updateWs("exclude", excludes);
                        }
                        yield me.refresh(selection instanceof tasks_1.TaskFile ? selection.taskSource : false, uri);
                    }
                });
            }
            if (selection instanceof tasks_1.TaskFile && prompt !== false) {
                const opts = { prompt: "Add the following file to excluded tasks list?", value: pathValue };
                vscode_1.window.showInputBox(opts).then((str) => __awaiter(this, void 0, void 0, function* () {
                    yield saveExclude(str);
                }));
            }
            else {
                yield saveExclude(pathValue);
            }
        });
    }
    runNpmCommand(taskFile, command) {
        return __awaiter(this, void 0, void 0, function* () {
            const options = {
                cwd: path.dirname(taskFile.resourceUri.fsPath)
            };
            const kind = {
                type: "npm",
                script: "install",
                path: path.dirname(taskFile.resourceUri.fsPath)
            };
            if (command.indexOf("<packagename>") === -1) {
                const execution = new vscode_1.ShellExecution("npm " + command, options);
                const task = new vscode_1.Task(kind, taskFile.folder.workspaceFolder, command, "npm", execution, undefined);
                yield vscode_1.tasks.executeTask(task);
            }
            else {
                const opts = { prompt: "Enter package name to " + command };
                yield vscode_1.window.showInputBox(opts).then((str) => __awaiter(this, void 0, void 0, function* () {
                    if (str !== undefined) {
                        const execution = new vscode_1.ShellExecution("npm " + command.replace("<packagename>", "").trim() + " " + str.trim(), options);
                        const task = new vscode_1.Task(kind, taskFile.folder.workspaceFolder, command.replace("<packagename>", "").trim() + str.trim(), "npm", execution, undefined);
                        yield vscode_1.tasks.executeTask(task);
                    }
                }));
            }
        });
    }
    findPosWithJsonVisitor(documentText, script) {
        const me = this;
        let inScripts = false;
        let inTasks = false;
        let inTaskLabel;
        let scriptOffset = 0;
        const visitor = {
            onError() {
                return scriptOffset;
            },
            onObjectEnd() {
                if (inScripts) {
                    inScripts = false;
                }
            },
            onLiteralValue(value, offset, _length) {
                if (inTaskLabel) {
                    if (typeof value === "string") {
                        if (inTaskLabel === "label") {
                            if (script.task.name === value) {
                                scriptOffset = offset;
                            }
                        }
                    }
                    inTaskLabel = undefined;
                }
            },
            onObjectProperty(property, offset, _length) {
                if (property === "scripts") {
                    inScripts = true;
                    if (!script) { // select the script section
                        scriptOffset = offset;
                    }
                }
                else if (inScripts && script) {
                    const label = me.getTaskName(property, script.task.definition.path, true);
                    if (script.task.name === label) {
                        scriptOffset = offset;
                    }
                }
                else if (property === "tasks") {
                    inTasks = true;
                    if (!inTaskLabel) { // select the script section
                        scriptOffset = offset;
                    }
                }
                else if (property === "label" && inTasks && !inTaskLabel) {
                    inTaskLabel = "label";
                    if (!inTaskLabel) { // select the script section
                        scriptOffset = offset;
                    }
                }
                else { // nested object which is invalid, ignore the script
                    inTaskLabel = undefined;
                }
            }
        };
        jsonc_parser_1.visit(documentText, visitor);
        return scriptOffset;
    }
    findScriptPosition(document, script) {
        let scriptOffset = 0;
        const documentText = document.getText();
        util.log("findScriptPosition");
        util.logValue("   task source", script.taskSource);
        util.logValue("   task name", script.task.name);
        if (script.taskSource === "tsc") {
            scriptOffset = 0;
        }
        if (script.taskSource === "make") {
            scriptOffset = documentText.indexOf(script.task.name + ":");
            if (scriptOffset === -1) {
                scriptOffset = documentText.indexOf(script.task.name);
                let bLine = documentText.lastIndexOf("\n", scriptOffset) + 1;
                let eLine = documentText.indexOf("\n", scriptOffset);
                if (eLine === -1) {
                    eLine = documentText.length;
                }
                let line = documentText.substring(bLine, eLine).trim();
                while (bLine !== -1 && bLine !== scriptOffset && scriptOffset !== -1 && line.indexOf(":") === -1) {
                    scriptOffset = documentText.indexOf(script.task.name, scriptOffset + 1);
                    bLine = documentText.lastIndexOf("\n", scriptOffset) + 1;
                    eLine = documentText.indexOf("\n", scriptOffset);
                    if (bLine !== -1) {
                        if (eLine === -1) {
                            eLine = documentText.length;
                        }
                        line = documentText.substring(bLine, eLine).trim();
                    }
                }
                if (scriptOffset === -1) {
                    scriptOffset = 0;
                }
            }
        }
        else if (script.taskSource === "ant") {
            //
            // TODO This is crap - need regex search
            //
            scriptOffset = documentText.indexOf("name=\"" + script.task.name);
            if (scriptOffset === -1) {
                scriptOffset = documentText.indexOf("name='" + script.task.name);
            }
            if (scriptOffset === -1) {
                scriptOffset = 0;
            }
            else {
                scriptOffset += 6;
            }
        }
        else if (script.taskSource === "gulp") {
            //
            // TODO This is crap - need regex search
            //
            scriptOffset = documentText.indexOf("gulp.task('" + script.task.name);
            if (scriptOffset === -1) {
                scriptOffset = documentText.indexOf("gulp.task(\"" + script.task.name);
            }
            if (scriptOffset === -1) {
                scriptOffset = 0;
            }
        }
        else if (script.taskSource === "grunt") {
            //
            // TODO This is crap - need regex search
            //
            scriptOffset = documentText.indexOf("grunt.registerTask('" + script.task.name);
            if (scriptOffset === -1) {
                scriptOffset = documentText.indexOf("grunt.registerTask(\"" + script.task.name);
            }
            if (scriptOffset === -1) {
                scriptOffset = 0;
            }
        }
        else if (script.taskSource === "npm" || script.taskSource === "Workspace") {
            scriptOffset = this.findPosWithJsonVisitor(documentText, script);
        }
        util.logValue("   Offset", scriptOffset);
        return scriptOffset;
    }
    getTreeItem(element) {
        return element;
    }
    getParent(element) {
        if (element instanceof tasks_1.TaskFolder) {
            return null;
        }
        if (element instanceof tasks_1.TaskFile) {
            return element.folder;
        }
        if (element instanceof tasks_1.TaskItem) {
            return element.taskFile;
        }
        if (element instanceof NoScripts) {
            return null;
        }
        return null;
    }
    getChildren(element, logPad = "") {
        return __awaiter(this, void 0, void 0, function* () {
            let items = [];
            util.log("");
            util.log(logPad + "Tree get children");
            if (!this.taskTree) {
                util.log(logPad + "   Build task tree");
                //
                // TODO - search enable* settings and apply enabled types to filter
                //
                // let taskItems = await tasks.fetchTasks({ type: 'npm' });
                if (!this.tasks) {
                    this.tasks = yield vscode_1.tasks.fetchTasks();
                }
                if (this.tasks) {
                    this.taskTree = this.buildTaskTree(this.tasks);
                    if (this.taskTree.length === 0) {
                        this.taskTree = [new NoScripts()];
                    }
                }
            }
            if (element instanceof tasks_1.TaskFolder) {
                util.log(logPad + "   Get folder task files");
                items = element.taskFiles;
            }
            else if (element instanceof tasks_1.TaskFile) {
                util.log(logPad + "   Get file tasks/scripts");
                items = element.scripts;
            }
            else if (!element) {
                util.log(logPad + "   Get task tree");
                if (this.taskTree) {
                    items = this.taskTree;
                }
            }
            return items;
        });
    }
    isInstallTask(task) {
        const fullName = this.getTaskName("install", task.definition.path);
        return fullName === task.name;
    }
    getLastTaskName(taskItem) {
        return taskItem.label = taskItem.label + " (" + taskItem.taskFile.folder.label + " - " + taskItem.taskSource + ")";
    }
    getTaskName(script, relativePath, forcePathInName) {
        if (relativePath && relativePath.length && forcePathInName === true) {
            return `${script} - ${relativePath.substring(0, relativePath.length - 1)}`;
        }
        return script;
    }
    isWorkspaceFolder(value) {
        return value && typeof value !== "number";
    }
    logTaskDefinition(definition) {
        util.logValue("   type", definition.type, 2);
        if (definition.scriptType) {
            util.logValue("      script type", definition.scriptType, 2); // if 'script' is defined, this is type npm
        }
        if (definition.script) {
            util.logValue("   script", definition.script, 2); // if 'script' is defined, this is type npm
        }
        if (definition.path) {
            util.logValue("   path", definition.path, 2);
        }
        //
        // Internal task providers will set a fileName property
        //
        if (definition.fileName) {
            util.logValue("   file name", definition.fileName, 2);
        }
        //
        // Internal task providers will set a uri property
        //
        if (definition.uri) {
            util.logValue("   file path", definition.uri.fsPath, 2);
        }
        //
        // Script task providers will set a fileName property
        //
        if (definition.requiresArgs) {
            util.logValue("   script requires args", "true", 2);
        }
        if (definition.cmdLine) {
            util.logValue("   script cmd line", definition.cmdLine, 2);
        }
    }
    buildTaskTree(tasks) {
        let taskCt = 0;
        const folders = new Map();
        const files = new Map();
        let folder = null, ltfolder = null;
        let taskFile = null;
        //
        // The 'Last Tasks' folder will be 1st in the tree
        //
        const lastTasks = storage_1.storage.get("lastTasks", []);
        if (configuration_1.configuration.get("showLastTasks") === true) {
            if (lastTasks && lastTasks.length > 0) {
                ltfolder = new tasks_1.TaskFolder(this.lastTasksText);
                folders.set(this.lastTasksText, ltfolder);
            }
        }
        //
        // Loop through each task provided by the engine and build a task tree
        //
        tasks.forEach(each => {
            taskCt++;
            util.log("");
            util.log("Processing task " + taskCt.toString() + " of " + tasks.length.toString());
            util.logValue("   name", each.name, 2);
            util.logValue("   source", each.source, 2);
            let settingName = "enable" + util.properCase(each.source);
            if (settingName === "enableApp-publisher") {
                settingName = "enableAppPublisher";
            }
            if (configuration_1.configuration.get(settingName) && this.isWorkspaceFolder(each.scope) && !this.isInstallTask(each)) {
                folder = folders.get(each.scope.name);
                if (!folder) {
                    folder = new tasks_1.TaskFolder(each.scope);
                    folders.set(each.scope.name, folder);
                }
                const definition = each.definition;
                let relativePath = definition.path ? definition.path : "";
                //
                // Ignore VSCode provided gulp and grunt tasks, which are always and only from a gulp/gruntfile
                // in a workspace folder root directory.  All internaly provided tasks will have the 'uri' property
                // set in its task definition
                //
                if (!definition.uri && (each.source === "gulp" || each.source === "grunt")) {
                    return; // continue forEach() loop
                }
                //
                // TSC tasks are returned with no path value, the relative path is in the task name:
                //
                //     watch - tsconfig.json
                //     watch - .vscode-test\vscode-1.32.3\resources\app\tsconfig.schema.json
                //
                if (each.source === "tsc") {
                    if (each.name.indexOf(" - ") !== -1 && each.name.indexOf(" - tsconfig.json") === -1) {
                        relativePath = path.dirname(each.name.substring(each.name.indexOf(" - ") + 3));
                        if (util.isExcluded(path.join(each.scope.uri.path, relativePath))) {
                            return; // continue forEach loop
                        }
                    }
                }
                //
                // Create an id so group tasks together with
                //
                let id = each.source + ":" + path.join(each.scope.name, relativePath);
                if (definition.fileName && !definition.scriptFile) {
                    id = path.join(id, definition.fileName);
                }
                //
                // Logging
                //
                util.logValue("   scope.name", each.scope.name, 2);
                util.logValue("   scope.uri.path", each.scope.uri.path, 2);
                util.logValue("   scope.uri.fsPath", each.scope.uri.fsPath, 2);
                util.logValue("   relative Path", relativePath, 2);
                this.logTaskDefinition(definition);
                taskFile = files.get(id);
                //
                // Create taskfile node if needed
                //
                if (!taskFile) {
                    taskFile = new tasks_1.TaskFile(this.extensionContext, folder, definition, each.source, relativePath);
                    folder.addTaskFile(taskFile);
                    files.set(id, taskFile);
                    util.logValue("   Added source file container", each.source);
                }
                //
                // Create and add task item to task file node
                //
                const taskItem = new tasks_1.TaskItem(this.extensionContext, taskFile, each);
                taskItem.task.definition.taskItem = taskItem;
                taskFile.addScript(taskItem);
                //
                // Addd this task to the 'Last Tasks' folder if we need to
                //
                if (ltfolder && lastTasks.includes(taskItem.id)) {
                    const taskItem2 = new tasks_1.TaskItem(this.extensionContext, taskFile, each);
                    taskItem2.id = this.lastTasksText + ":" + taskItem2.id;
                    taskItem2.label = this.getLastTaskName(taskItem2);
                    ltfolder.insertTaskFile(taskItem2, 0);
                }
            }
            else {
                util.log("   Skipping");
                util.logValue("   enabled", configuration_1.configuration.get(settingName));
                util.logValue("   is install task", this.isInstallTask(each));
            }
        });
        //
        // Sort nodes.  By default the project folders are sorted in the same order as that
        // of the Explorer.  Sort TaskFile nodes and TaskItems nodes alphabetically, by default
        // its entirley random as to when the individual providers report tasks to the engine
        //
        const subfolders = new Map();
        folders.forEach((folder, key) => {
            if (key === this.lastTasksText) {
                return; // continue forEach()
            }
            folder.taskFiles.forEach(each => {
                if (each instanceof tasks_1.TaskFile) {
                    each.scripts.sort((a, b) => {
                        return a.label.localeCompare(b.label);
                    });
                }
            });
            folder.taskFiles.sort((a, b) => {
                return a.taskSource.localeCompare(b.taskSource);
            });
            //
            // Create groupings by task type
            //
            let prevTaskFile;
            folder.taskFiles.forEach(each => {
                if (!(each instanceof tasks_1.TaskFile)) {
                    return; // continue forEach()
                }
                if (prevTaskFile && prevTaskFile.taskSource === each.taskSource) {
                    const id = folder.label + each.taskSource;
                    let subfolder = subfolders.get(id);
                    if (!subfolder) {
                        subfolder = new tasks_1.TaskFile(this.extensionContext, folder, each.scripts[0].task.definition, each.taskSource, each.path, true);
                        subfolders.set(id, subfolder);
                        folder.addTaskFile(subfolder);
                        subfolder.addScript(prevTaskFile);
                    }
                    subfolder.addScript(each);
                }
                prevTaskFile = each;
                //
                // Build dashed groupings
                //
                // For example, consider the set of task names/labels:
                //
                //     build-prod
                //     build-dev
                //     build-server
                //     build-sass
                //
                // If the option 'groupDashed' is ON, then group this set of tasks like so:
                //
                //     build
                //         prod
                //         dev
                //         server
                //         sass
                //
                if (configuration_1.configuration.get("groupDashed")) {
                    let prevName;
                    let prevTaskItem;
                    const newNodes = [];
                    each.scripts.forEach(each2 => {
                        let id = folder.label + each.taskSource;
                        let subfolder;
                        const prevNameThis = each2.label.split("-");
                        if (prevName && prevName.length > 1 && prevName[0] && prevNameThis.length > 1 && prevName[0] === prevNameThis[0]) {
                            // We found a pair of tasks that need to be grouped.  i.e. the first part of the label
                            // when split by the '-' character is the same...
                            //
                            id += prevName[0];
                            subfolder = subfolders.get(id);
                            if (!subfolder) {
                                // Create the new node, add it to the list of nodes to add to the tree.  We must
                                // add them after we loop since we are looping on the array that they need to be
                                // added to
                                //
                                subfolder = new tasks_1.TaskFile(this.extensionContext, folder, each2.task.definition, each.taskSource, each2.taskFile.path, true, prevName[0]);
                                subfolders.set(id, subfolder);
                                subfolder.addScript(prevTaskItem);
                                newNodes.push(subfolder);
                            }
                            subfolder.addScript(each2);
                        }
                        prevName = each2.label.split("-");
                        prevTaskItem = each2;
                    });
                    //
                    // If there are new dashed grouped nodes to add to the tree...
                    //
                    if (newNodes.length > 0) {
                        let numGrouped = 0;
                        newNodes.forEach(n => {
                            each.insertScript(n, numGrouped++);
                        });
                    }
                }
            });
            //
            // Perform some removal based on dashed groupings.  The nodes added within the new
            // group nodes need to be removed from the old parent node still...
            //
            function removeScripts(each) {
                const taskTypesRmv2 = [];
                each.scripts.forEach(each2 => {
                    if (each2.label.split("-").length > 1 && each2.label.split("-")[0]) {
                        const id = folder.label + each.taskSource + each2.label.split("-")[0];
                        if (subfolders.get(id)) {
                            taskTypesRmv2.push(each2);
                        }
                    }
                });
                taskTypesRmv2.forEach(each2 => {
                    each.removeScript(each2);
                });
            }
            const taskTypesRmv = [];
            folder.taskFiles.forEach(each => {
                if (!(each instanceof tasks_1.TaskFile)) {
                    return; // continue forEach()
                }
                const id = folder.label + each.taskSource;
                if (!each.isGroup && subfolders.get(id)) {
                    taskTypesRmv.push(each);
                }
                else if (each.isGroup) {
                    each.scripts.forEach(each2 => {
                        removeScripts(each2);
                    });
                }
                else {
                    removeScripts(each);
                }
            });
            taskTypesRmv.forEach(each => {
                folder.removeTaskFile(each);
            });
            //
            // For dashed groupings, now go through and rename the labels within each group minus the
            // first part of the name split by the '-' character (the name of the new dashed-grouped node)
            //
            folder.taskFiles.forEach(each => {
                if (!(each instanceof tasks_1.TaskFile)) {
                    return; // continue forEach()
                }
                each.scripts.forEach(each2 => {
                    if (each2 instanceof tasks_1.TaskFile && each2.isGroup) {
                        let rmvLbl = each2.label;
                        rmvLbl = rmvLbl.replace(/\(/gi, "\\(");
                        rmvLbl = rmvLbl.replace(/\[/gi, "\\[");
                        each2.scripts.forEach(each3 => {
                            const rgx = new RegExp(rmvLbl + "-", "i");
                            each3.label = each3.label.replace(rgx, "");
                        });
                    }
                });
            });
            //
            // Resort after making adds/removes
            //
            folder.taskFiles.sort((a, b) => {
                return a.taskSource.localeCompare(b.taskSource);
            });
            folder.taskFiles.forEach(each => {
                if (!(each instanceof tasks_1.TaskFile)) {
                    return; // continue forEach()
                }
                if (each.isGroup) {
                    each.scripts.sort((a, b) => {
                        return a.label.localeCompare(b.label);
                    });
                }
            });
        });
        //
        // Sort the 'Last Tasks' folder by last time run
        //
        if (ltfolder) {
            ltfolder.taskFiles.sort((a, b) => {
                const aIdx = lastTasks.indexOf(a.id.replace(this.lastTasksText + ":", ""));
                const bIdx = lastTasks.indexOf(b.id.replace(this.lastTasksText + ":", ""));
                return (aIdx < bIdx ? 1 : (bIdx < aIdx ? -1 : 0));
            });
        }
        return [...folders.values()];
    }
}
exports.TaskTreeDataProvider = TaskTreeDataProvider;
//# sourceMappingURL=taskTree.js.map