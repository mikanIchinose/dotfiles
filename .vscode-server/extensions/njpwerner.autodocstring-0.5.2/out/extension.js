"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vs = require("vscode");
const generate_docstring_1 = require("./generate_docstring");
const parse_1 = require("./parse");
exports.generateDocstringCommand = "autoDocstring.generateDocstring";
let channel;
function activate(context) {
    channel = vs.window.createOutputChannel("autoDocstring");
    context.subscriptions.push(vs.commands.registerCommand(exports.generateDocstringCommand, () => {
        const editor = vs.window.activeTextEditor;
        const autoDocstring = new generate_docstring_1.AutoDocstring(editor, channel);
        try {
            return autoDocstring.generateDocstring();
        }
        catch (error) {
            channel.appendLine("Error: " + error);
            vs.window.showErrorMessage("AutoDocstring encountered an error:", error);
        }
    }), vs.languages.registerCompletionItemProvider("python", {
        provideCompletionItems: (document, position, _) => {
            if (validEnterActivation(document, position)) {
                channel.appendLine(position.toString());
                return [new AutoDocstringCompletionItem(document, position)];
            }
        },
    }, '"', "'", "#"));
    channel.appendLine("autoDocstring was activated");
}
exports.activate = activate;
/**
 * This method is called when the extension is deactivated
 */
function deactivate() {
    channel.dispose();
}
exports.deactivate = deactivate;
/**
 * Checks that the preceding characters of the position is a valid docstring prefix
 * and that the prefix is not part of an already closed docstring
 */
function validEnterActivation(document, position) {
    const docString = document.getText();
    const quoteStyle = getQuoteStyle();
    return (parse_1.validDocstringPrefix(docString, position.line, position.character, quoteStyle) &&
        !parse_1.docstringIsClosed(docString, position.line, position.character, quoteStyle));
}
/**
 * Completion item to trigger generate docstring command on docstring prefix
 */
class AutoDocstringCompletionItem extends vs.CompletionItem {
    constructor(_, position) {
        super("Generate Docstring", vs.CompletionItemKind.Snippet);
        this.insertText = "";
        this.filterText = getQuoteStyle();
        this.sortText = "\0";
        this.range = new vs.Range(new vs.Position(position.line, 0), position);
        this.command = {
            command: exports.generateDocstringCommand,
            title: "Generate Docstring",
        };
    }
}
function getQuoteStyle() {
    return vs.workspace.getConfiguration("autoDocstring").get("quoteStyle").toString();
}
//# sourceMappingURL=extension.js.map