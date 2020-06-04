"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class TableViewModel {
    constructor() {
        this.rows = [];
    }
    get columnCount() { return this.header.columnCount; }
    get rowCount() { return this.rows.length; }
}
exports.TableViewModel = TableViewModel;
//# sourceMappingURL=tableViewModel.js.map