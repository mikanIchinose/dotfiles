'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode_1 = require("vscode");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    // The command has been defined in the package.json file
    // Now provide the implementation of the command with  registerCommand
    // The commandId parameter must match the command field in package.json
    let togglequotesCommand = vscode_1.commands.registerCommand('editor.togglequotes', () => {
        // The code you place here will be executed every time your command is executed
        toggle();
        // Display a message box to the user
        // window.showInformationMessage('toggle ran');
    });
    context.subscriptions.push(togglequotesCommand);
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() {
}
exports.deactivate = deactivate;
// look at: https://github.com/dbankier/vscode-quick-select/blob/master/src/extension.ts
function toggle() {
    let editor = vscode_1.window.activeTextEditor;
    let doc = editor.document;
    const chars = getChars(editor);
    const changes = [];
    for (const sel of editor.selections) {
        const content = doc.lineAt(sel.start.line);
        const charInfo = findChar(chars, content.text, sel);
        if (charInfo) {
            const foundCharIdx = chars.indexOf(charInfo.foundChar);
            const nextChar = chars[(foundCharIdx + 1) % chars.length];
            // console.log(`found ${charInfo.start} - ${charInfo.end} will change to : ${nextChar}`);
            const first = new vscode_1.Position(sel.start.line, charInfo.start);
            const firstSelection = new vscode_1.Selection(first, new vscode_1.Position(first.line, first.character + 1));
            changes.push({ char: nextChar, selection: firstSelection });
            const second = new vscode_1.Position(sel.start.line, charInfo.end);
            const secondSelection = new vscode_1.Selection(second, new vscode_1.Position(second.line, second.character + 1));
            changes.push({ char: nextChar, selection: secondSelection });
        }
        // for (const sel of newSelections){
        // 	editor
        // }
    }
    editor.edit((edit) => {
        for (const change of changes) {
            edit.replace(change.selection, change.char);
        }
    });
}
/** Find the .start and .end of a char (from the chars list) or null if any side is not found */
function findChar(chars, txt, sel) {
    let start = -1;
    let end = -1;
    let foundChar = null;
    // find the index of next char from end selection
    for (let i = sel.end.character; i < txt.length; i++) {
        const c = txt[i];
        const beforeC = (i > 0) ? txt[i - 1] : null; // the previous character (to see if it is '\')
        if (beforeC !== '\\') {
            let idx = chars.indexOf(c);
            if (idx !== -1) {
                foundChar = chars[idx];
                end = i;
                break;
            }
        }
    }
    // find the index of previous char (note at this point we should have the found char)
    for (let i = sel.start.character - 1; i > -1; i--) {
        const c = txt[i];
        const beforeC = (i > 0) ? txt[i - 1] : null; // the previous character (to see if it is '\')
        if (beforeC !== '\\') {
            if (foundChar === c) {
                start = i;
                break;
            }
        }
    }
    if (start > -1 && end > -1) {
        return { start, end, foundChar };
    }
    else {
        return null;
    }
}
function getChars(editor) {
    const doc = editor.document;
    const langId = doc.languageId;
    let langProps = vscode_1.workspace.getConfiguration().get(`[${langId}]`);
    let chars = null;
    if (langProps) {
        chars = langProps['togglequotes.chars'];
    }
    chars = (chars) ? chars : vscode_1.workspace.getConfiguration('togglequotes').get('chars');
    return chars;
}
//# sourceMappingURL=extension.js.map