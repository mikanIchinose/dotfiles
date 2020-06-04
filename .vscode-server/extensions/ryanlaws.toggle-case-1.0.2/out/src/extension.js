"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const toggle_case_commands_1 = require("./toggle-case-commands");
function activate(context) {
    vscode.commands.registerCommand('extension.toggleCase.commands', toggle_case_commands_1.toggleCaseCommands);
    vscode.commands.registerCommand('extension.toggleCase.camel', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.camel); });
    vscode.commands.registerCommand('extension.toggleCase.constant', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.constant); });
    vscode.commands.registerCommand('extension.toggleCase.dot', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.dot); });
    vscode.commands.registerCommand('extension.toggleCase.kebab', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.kebab); });
    vscode.commands.registerCommand('extension.toggleCase.lower', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.lower); });
    vscode.commands.registerCommand('extension.toggleCase.lowerFirst', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.lowerFirst); });
    vscode.commands.registerCommand('extension.toggleCase.no', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.no); });
    vscode.commands.registerCommand('extension.toggleCase.param', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.param); });
    vscode.commands.registerCommand('extension.toggleCase.pascal', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.pascal); });
    vscode.commands.registerCommand('extension.toggleCase.path', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.path); });
    vscode.commands.registerCommand('extension.toggleCase.sentence', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.sentence); });
    vscode.commands.registerCommand('extension.toggleCase.snake', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.snake); });
    vscode.commands.registerCommand('extension.toggleCase.swap', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.swap); });
    vscode.commands.registerCommand('extension.toggleCase.title', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.title); });
    vscode.commands.registerCommand('extension.toggleCase.upper', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.upper); });
    vscode.commands.registerCommand('extension.toggleCase.upperFirst', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.upperFirst); });
    // New from fork
    vscode.commands.registerCommand('extension.toggleCase.toggleCase', () => { toggle_case_commands_1.runCommand(toggle_case_commands_1.COMMAND_LABELS.toggleCase); });
    vscode.commands.registerCommand('extension.toggleCase.copyToggled', () => { toggle_case_commands_1.copyToggled(); });
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map