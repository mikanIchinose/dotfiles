"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const vs = require("vscode");
const docstring_factory_1 = require("./docstring/docstring_factory");
const get_template_1 = require("./docstring/get_template");
const parse_1 = require("./parse");
class AutoDocstring {
    constructor(editor, logger) {
        this.editor = editor;
        this.logger = logger;
    }
    generateDocstring() {
        const position = this.editor.selection.active;
        this.log(`Generating Docstring at line: ${position.line}`);
        const document = this.editor.document.getText();
        const docstringSnippet = this.generateDocstringSnippet(document, position);
        const insertPosition = position.with(undefined, 0);
        this.log(`Docstring generated:\n${docstringSnippet.value}`);
        this.log(`Inserting at position: ${insertPosition.line} ${insertPosition.character}`);
        const success = this.editor.insertSnippet(docstringSnippet, insertPosition);
        success.then(() => this.log("Successfully inserted docstring"), (reason) => {
            this.log("Error: " + reason);
            vs.window.showErrorMessage("AutoDocstring could not insert docstring:", reason);
        });
        return success;
    }
    generateDocstringSnippet(document, position) {
        const config = this.getConfig();
        const docstringFactory = new docstring_factory_1.DocstringFactory(this.getTemplate(), config.get("quoteStyle").toString(), config.get("startOnNewLine") === true, config.get("includeExtendedSummary") === true, config.get("includeName") === true, config.get("guessTypes") === true);
        const docstringParts = parse_1.parse(document, position.line);
        const defaultIndentation = parse_1.getDefaultIndentation(this.editor.options.insertSpaces, this.editor.options.tabSize);
        const indentation = parse_1.getDocstringIndentation(document, position.line, defaultIndentation);
        const docstring = docstringFactory.generateDocstring(docstringParts, indentation);
        return new vs.SnippetString(docstring);
    }
    getTemplate() {
        const config = this.getConfig();
        let customTemplatePath = config.get("customTemplatePath").toString();
        if (customTemplatePath === "") {
            const docstringFormat = config.get("docstringFormat").toString();
            return get_template_1.getTemplate(docstringFormat);
        }
        if (!path.isAbsolute(customTemplatePath)) {
            customTemplatePath = path.join(vs.workspace.rootPath, customTemplatePath);
        }
        try {
            return get_template_1.getCustomTemplate(customTemplatePath);
        }
        catch (err) {
            const errorMessage = "AutoDocstring Error: Template could not be found: " + customTemplatePath;
            this.log(errorMessage);
            vs.window.showErrorMessage(errorMessage);
        }
    }
    getConfig() {
        return vs.workspace.getConfiguration("autoDocstring");
    }
    log(line) {
        const time = new Date();
        this.logger.appendLine(`${time.toISOString()}: ${line}`);
    }
}
exports.AutoDocstring = AutoDocstring;
//# sourceMappingURL=generate_docstring.js.map