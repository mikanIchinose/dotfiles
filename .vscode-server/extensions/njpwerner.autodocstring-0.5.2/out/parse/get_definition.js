"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utilities_1 = require("./utilities");
function getDefinition(document, linePosition) {
    const lines = document.split("\n");
    let precedingLines = lines.slice(0, linePosition);
    precedingLines = precedingLines.map((line) => line.trim());
    const precedingText = precedingLines.join(" ");
    // Don't parse if the preceding line is blank
    const precedingLine = precedingLines[precedingLines.length - 1];
    if (utilities_1.blankLine(precedingLine)) {
        return "";
    }
    const pattern = /\b(((async\s+)?\s*def)|\s*class)\b/g;
    // Get starting index of last def match in the preceding text
    let index;
    while (pattern.test(precedingText)) {
        index = pattern.lastIndex - RegExp.lastMatch.length;
    }
    if (index == undefined) {
        return "";
    }
    const lastFunctionDef = precedingText.slice(index);
    return lastFunctionDef.trim();
}
exports.getDefinition = getDefinition;
//# sourceMappingURL=get_definition.js.map