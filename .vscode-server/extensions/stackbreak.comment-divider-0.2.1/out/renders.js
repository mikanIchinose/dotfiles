"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const config_1 = require("./config");
const constants_1 = require("./constants");
const errors_1 = require("./errors");
const builders_1 = require("./builders");
const transforms_1 = require("./transforms");
const isEmptyLine = (lineNum) => vscode_1.window.activeTextEditor.document.lineAt(lineNum).isEmptyOrWhitespace;
const computeMargins = (line) => {
    const lastLineNum = vscode_1.window.activeTextEditor.document.lineCount - 1;
    const prevLineNum = line.lineNumber - 1;
    const nextLineNum = line.lineNumber + 1;
    const margins = {
        top: false,
        bottom: false
    };
    margins.top = prevLineNum >= 0 && !isEmptyLine(prevLineNum);
    margins.bottom = nextLineNum <= lastLineNum && !isEmptyLine(nextLineNum);
    return margins;
};
exports.wrapWithMargins = (content, line) => {
    const margins = computeMargins(line);
    const before = margins.top ? constants_1.NEW_LINE_SYM : '';
    const after = margins.bottom ? constants_1.NEW_LINE_SYM : '';
    return before + content + after;
};
exports.wrapWithLinebreaker = (content) => content + constants_1.NEW_LINE_SYM;
exports.renderHeader = (type, rawText, lang) => {
    const config = config_1.getConfig(type, lang);
    const croppedText = rawText.trim();
    errors_1.checkCommentChars(croppedText, config.limiters);
    errors_1.checkLongText(croppedText, config.lineLen, config.limiters);
    errors_1.checkFillerLen(config.sym);
    const transformedWords = transforms_1.TRANSFORM_MAP[config.transform](croppedText);
    const build = builders_1.BUILDERS_MAP[config.height];
    return build(config, transformedWords);
};
exports.renderLine = (lang) => {
    const config = config_1.getConfig('line', lang);
    errors_1.checkFillerLen(config.sym);
    const build = builders_1.buildSolidLine;
    return build(config);
};
//# sourceMappingURL=renders.js.map