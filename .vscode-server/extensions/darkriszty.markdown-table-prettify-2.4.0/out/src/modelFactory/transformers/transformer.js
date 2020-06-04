"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Transformer {
    constructor(_next) {
        this._next = _next;
    }
    process(input) {
        if (input == null || input.isEmpty())
            return input;
        let table = this.transform(input);
        if (this._next != null)
            table = this._next.process(table);
        return table;
    }
}
exports.Transformer = Transformer;
//# sourceMappingURL=transformer.js.map