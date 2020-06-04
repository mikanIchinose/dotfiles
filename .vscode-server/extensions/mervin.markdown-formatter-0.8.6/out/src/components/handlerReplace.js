"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function onReplace(source, target, handler) {
    return source.replace(target, function () {
        return handler;
    });
}
exports.default = onReplace;
//# sourceMappingURL=handlerReplace.js.map