"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function initStorage(context) {
    //
    // Set up extension custom storage
    //
    exports.storage = new Storage(context.globalState);
}
exports.initStorage = initStorage;
class Storage {
    constructor(storageMemento) {
        this.storage = storageMemento;
    }
    get(key, defaultValue) {
        return this.storage.get(key, defaultValue);
    }
    update(key, value) {
        return this.storage.update(key, value);
    }
}
//# sourceMappingURL=storage.js.map