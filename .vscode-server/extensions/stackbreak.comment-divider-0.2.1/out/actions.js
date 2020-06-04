"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const renders_1 = require("./renders");
const errors_1 = require("./errors");
exports.insertMainHeader = (line, lang) => {
    errors_1.checkEmptyLine(line);
    const rendered = renders_1.renderHeader('mainHeader', line.text, lang);
    const content = renders_1.wrapWithMargins(rendered, line);
    vscode_1.window.activeTextEditor
        .edit((textEditorEdit) => {
        textEditorEdit.replace(line.range, content);
    })
        .then(() => {
        vscode_1.commands.executeCommand('cursorEnd');
    });
};
exports.insertSubHeader = (line, lang) => {
    errors_1.checkEmptyLine(line);
    const rendered = renders_1.renderHeader('subheader', line.text, lang);
    const content = renders_1.wrapWithMargins(rendered, line);
    vscode_1.window.activeTextEditor
        .edit((textEditorEdit) => {
        textEditorEdit.replace(line.range, content);
    })
        .then(() => {
        vscode_1.commands.executeCommand('cursorEnd');
    });
};
exports.insertSolidLine = (line, lang) => {
    const rendered = renders_1.renderLine(lang);
    const content = renders_1.wrapWithLinebreaker(rendered);
    vscode_1.window.activeTextEditor
        .edit((textEditorEdit) => {
        textEditorEdit.insert(line.range.start, content);
    })
        .then(() => {
        vscode_1.commands.executeCommand('cursorHome');
    });
};
//# sourceMappingURL=actions.js.map