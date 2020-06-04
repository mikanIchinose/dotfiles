"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const constants_1 = require("./constants");
exports.ERRORS = {
    EMPTY_LINE: 'Line should contain at least one character!',
    MULTI_LINE: 'Selection should be on single line!',
    LONG_TEXT: 'Too many characters! Increase divider length in settings or use less characters.',
    COMMENT_CHARS: 'Line contains comment characters!',
    FILLER_LEN: 'Incorrect filler symbol!'
};
const showErrorMsg = (msg) => vscode_1.window.showInformationMessage(`${constants_1.EXT_NAME}: ${msg}`);
exports.checkMultiLineSelection = (selection) => {
    if (!selection.isSingleLine)
        throw new Error('MULTI_LINE');
};
exports.checkEmptyLine = (line) => {
    if (line.isEmptyOrWhitespace)
        throw new Error('EMPTY_LINE');
};
exports.checkCommentChars = (text, limiters) => {
    if (text.includes(limiters.left) || text.includes(limiters.right))
        throw new Error('COMMENT_CHARS');
};
exports.checkLongText = (text, lineLen, limiters) => {
    const limitersLen = limiters.left.length + limiters.right.length;
    const gapsCount = 4;
    const minFillerCount = 2;
    const maxAllowedLen = lineLen - (limitersLen + gapsCount + minFillerCount);
    if (text.length > maxAllowedLen)
        throw new Error('LONG_TEXT');
};
exports.checkFillerLen = (fillerSym) => {
    if (fillerSym.length !== 1)
        throw new Error('FILLER_LEN');
};
exports.handleError = (e) => {
    const errorMsg = exports.ERRORS[e.message];
    if (errorMsg !== undefined)
        showErrorMsg(errorMsg);
};
//# sourceMappingURL=errors.js.map