"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Table {
    constructor(rows, _alignments) {
        this._alignments = _alignments;
        this.hasLeftBorder = false;
        this.hasRightBorder = false;
        if (rows != null && rows[0] != null && rows[0].length != _alignments.length)
            throw new Error("The number of columns must match the number of alignments.");
        this._rows = rows;
    }
    get rows() { return this._rows != null ? this._rows : null; }
    get alignments() { return this._alignments; }
    get columnCount() { return this.hasRows ? this.rows[0].length : 0; }
    get rowCount() { return this.hasRows ? this.rows.length : 0; }
    get hasRows() { return this.rows != null && this.rows.length > 0; }
    isEmpty() {
        return !this.hasRows;
    }
    getLongestColumnLengths() {
        if (!this.hasRows)
            return [];
        let maxColLengths = new Array(this.columnCount).fill(0);
        for (let row = 0; row < this.rows.length; row++)
            for (let col = 0; col < this.rows[row].length; col++)
                maxColLengths[col] = Math.max(this.rows[row][col].getLength(), maxColLengths[col]);
        return maxColLengths;
    }
}
exports.Table = Table;
//# sourceMappingURL=table.js.map