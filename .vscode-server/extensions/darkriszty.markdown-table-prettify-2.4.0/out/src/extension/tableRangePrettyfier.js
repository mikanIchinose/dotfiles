"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const selectionBasedLogToogler_1 = require("../diagnostics/selectionBasedLogToogler");
class TableRangePrettyfier {
    constructor(_tableFactory, _tableValidator, _viewModelFactory, _writer, _loggers) {
        this._tableFactory = _tableFactory;
        this._tableValidator = _tableValidator;
        this._viewModelFactory = _viewModelFactory;
        this._writer = _writer;
        this._loggers = _loggers;
    }
    provideDocumentRangeFormattingEdits(document, range, options, token) {
        const result = [];
        const selection = document.getText(range);
        this.toogleLogging(document, range);
        let message = null;
        try {
            if (this._tableValidator.isValid(selection)) {
                const table = this._tableFactory.getModel(selection);
                const tableVm = this._viewModelFactory.build(table);
                const formattedTable = this._writer.writeTable(tableVm);
                result.push(new vscode.TextEdit(range, formattedTable));
            }
            else {
                message = "Can't parse table from invalid text.";
            }
        }
        catch (ex) {
            this._loggers.forEach(_ => _.logError(ex));
        }
        if (!!message)
            this._loggers.forEach(_ => _.logInfo(message));
        return result;
    }
    toogleLogging(document, range) {
        const toogler = new selectionBasedLogToogler_1.SelectionBasedLogToogler(document, range);
        toogler.toogleLoggers(this._loggers);
    }
}
exports.TableRangePrettyfier = TableRangePrettyfier;
//# sourceMappingURL=tableRangePrettyfier.js.map