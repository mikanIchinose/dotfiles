"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const _1 = require(".");
function parse(document, positionLine) {
    const definition = _1.getDefinition(document, positionLine);
    const body = _1.getBody(document, positionLine);
    const parameterTokens = _1.tokenizeDefinition(definition);
    const functionName = _1.getFunctionName(definition);
    return _1.parseParameters(parameterTokens, body, functionName);
}
exports.parse = parse;
//# sourceMappingURL=parse.js.map