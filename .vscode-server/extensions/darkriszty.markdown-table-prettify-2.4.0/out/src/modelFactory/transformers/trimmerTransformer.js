"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const transformer_1 = require("./transformer");
const table_1 = require("../../models/table");
const cell_1 = require("../../models/cell");
class TrimmerTransformer extends transformer_1.Transformer {
    transform(input) {
        return new table_1.Table(this.trimColumnValues(input.rows), input.alignments);
    }
    trimColumnValues(rows) {
        if (rows == null)
            return;
        let result = [];
        for (let i = 0; i < rows.length; i++)
            result.push(rows[i].map(r => new cell_1.Cell(r.getValue().trim())));
        return result;
    }
}
exports.TrimmerTransformer = TrimmerTransformer;
//# sourceMappingURL=trimmerTransformer.js.map