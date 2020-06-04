"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class RowViewModel {
    constructor(_values) {
        this._values = _values;
    }
    get columnCount() { return this._values.length; }
    getValueAt(index) {
        const maxIndex = this._values.length - 1;
        if (index < 0 || index > maxIndex)
            throw new Error(`Argument out of range; should be between 0 and ${maxIndex}, but was ${index}.`);
        return this._values[index];
    }
}
exports.RowViewModel = RowViewModel;
//# sourceMappingURL=rowViewModel.js.map