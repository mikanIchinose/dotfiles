"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const errors_1 = require("./errors");
const actions_1 = require("./actions");
const getEditorState = (editor) => {
    const selection = editor.selection;
    errors_1.checkMultiLineSelection(selection);
    const document = editor.document;
    const lang = document.languageId;
    const line = document.lineAt(selection.active.line);
    return {
        line,
        lang
    };
};
const generateCommand = (action) => () => {
    try {
        const editor = vscode_1.window.activeTextEditor;
        if (!editor)
            return;
        const { lang, line } = getEditorState(editor);
        action(line, lang);
    }
    catch (e) {
        errors_1.handleError(e);
    }
};
exports.mainHeaderCommand = generateCommand(actions_1.insertMainHeader);
exports.subHeaderCommand = generateCommand(actions_1.insertSubHeader);
exports.solidLineCommand = generateCommand(actions_1.insertSolidLine);
//# sourceMappingURL=commands.js.map