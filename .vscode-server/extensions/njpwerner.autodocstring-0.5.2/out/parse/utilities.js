"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function getIndentation(line) {
    const whiteSpaceMatches = line.match(/^[^\S\r]+/);
    if (whiteSpaceMatches == undefined) {
        return "";
    }
    return whiteSpaceMatches[0];
}
exports.getIndentation = getIndentation;
function indentationOf(line) {
    return getIndentation(line).length;
}
exports.indentationOf = indentationOf;
function blankLine(line) {
    return line.match(/[^\s]/) == undefined;
}
exports.blankLine = blankLine;
function getDefaultIndentation(useSpaces, tabSize) {
    if (!useSpaces) {
        return "\t";
    }
    return " ".repeat(tabSize);
}
exports.getDefaultIndentation = getDefaultIndentation;
//# sourceMappingURL=utilities.js.map