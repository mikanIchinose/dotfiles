"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class TableDocumentPrettyfier {
    constructor(_tableFinder, _tableDocumentRangePrettyfier) {
        this._tableFinder = _tableFinder;
        this._tableDocumentRangePrettyfier = _tableDocumentRangePrettyfier;
    }
    provideDocumentFormattingEdits(document, options, token) {
        let result = [];
        let tables = this._tableFinder.getTables(document);
        for (let tableRange of tables) {
            let edits = this._tableDocumentRangePrettyfier.provideDocumentRangeFormattingEdits(document, tableRange, options, token);
            result = result.concat(edits);
        }
        return result;
    }
}
exports.TableDocumentPrettyfier = TableDocumentPrettyfier;
//# sourceMappingURL=tableDocumentPrettyfier.js.map