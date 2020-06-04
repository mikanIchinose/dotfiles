"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const table_1 = require("../models/table");
const cell_1 = require("../models/cell");
class TableFactory {
    constructor(_alignmentFactory, _selectionInterpreter, _transformer) {
        this._alignmentFactory = _alignmentFactory;
        this._selectionInterpreter = _selectionInterpreter;
        this._transformer = _transformer;
    }
    getModel(text) {
        if (text == null)
            throw new Error("Can't create table model from null table text.");
        const rowsWithoutSeparator = this._selectionInterpreter.allRows(text).filter((v, i) => i != 1);
        const separator = this._selectionInterpreter.separator(text);
        const alignments = separator != null && separator.length > 0
            ? this._alignmentFactory.createAlignments(separator)
            : [];
        const cells = rowsWithoutSeparator.map(row => row.map(c => new cell_1.Cell(c)));
        return this._transformer.process(new table_1.Table(cells, alignments));
    }
}
exports.TableFactory = TableFactory;
//# sourceMappingURL=tableFactory.js.map