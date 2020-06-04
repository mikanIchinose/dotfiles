"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const constants_1 = require("./constants");
const buildBlankCharList = (lineLen, filler) => Array(lineLen).fill(filler);
const charListToString = (charList) => charList.join('');
const isEven = (num) => num % 2 === 0;
const getCenterAlignedAnchors = (words, charList) => {
    const smartRound = !isEven(words.length) && !isEven(charList.length) ? Math.floor : Math.ceil;
    const halfLen = smartRound(charList.length / 2);
    const halfWord = Math.floor(words.length / 2);
    const leftAnchor = halfLen - halfWord;
    const rightAnchor = leftAnchor + (words.length - 1);
    return { leftAnchor, rightAnchor };
};
const getLeftAlignedAnchors = (words, charList) => {
    let leftAnchor;
    let rightAnchor;
    for (const idx of Object.keys(charList)) {
        if (charList[idx] === constants_1.GAP_SYM) {
            leftAnchor = Number(idx) + 1;
            break;
        }
    }
    rightAnchor = leftAnchor + (words.length - 1);
    return { leftAnchor, rightAnchor };
};
const getRightAlignedAnchors = (words, charList) => {
    let leftAnchor;
    let rightAnchor;
    const last = charList.length - 1;
    for (const idx of Object.keys(charList)) {
        if (charList[last - Number(idx)] === constants_1.GAP_SYM) {
            rightAnchor = last - (Number(idx) + 1);
            break;
        }
    }
    leftAnchor = rightAnchor - (words.length - 1);
    return { leftAnchor, rightAnchor };
};
const getWordsAnchors = (align, words, charList) => {
    switch (align) {
        case 'center':
            return getCenterAlignedAnchors(words, charList);
        case 'left':
            return getLeftAlignedAnchors(words, charList);
        case 'right':
            return getRightAlignedAnchors(words, charList);
    }
};
exports.withLimiters = (leftLim, rightLim) => (charList) => {
    const rightLimAnchor = charList.length - rightLim.length;
    return charList.map((char, i) => {
        if (i < leftLim.length)
            return leftLim[i];
        else if (i >= rightLimAnchor)
            return rightLim[i - rightLimAnchor];
        else if ((leftLim.length && i === leftLim.length) ||
            (rightLim.length && i === rightLimAnchor - 1))
            return constants_1.GAP_SYM;
        else
            return char;
    });
};
exports.withWords = (align, words) => (charList) => {
    const { leftAnchor, rightAnchor } = getWordsAnchors(align, words, charList);
    return charList.map((char, i) => {
        if (i >= leftAnchor && i <= rightAnchor)
            return words[i - leftAnchor];
        else if (i === leftAnchor - 1 || i === rightAnchor + 1)
            return constants_1.GAP_SYM;
        else
            return char;
    });
};
const composeInjectors = (...injectors) => (charList) => injectors.reduce((res, injector) => injector(res), charList);
exports.buildSolidLine = (config) => {
    const injectLimiters = exports.withLimiters(config.limiters.left, config.limiters.right);
    const blankCharList = buildBlankCharList(config.lineLen, config.sym);
    const computedCharList = composeInjectors(injectLimiters)(blankCharList);
    return charListToString(computedCharList);
};
exports.buildWordsLine = (config, transformedWords) => {
    const injectLimiters = exports.withLimiters(config.limiters.left, config.limiters.right);
    const injectWords = exports.withWords(config.align, transformedWords);
    const blankCharList = buildBlankCharList(config.lineLen, config.sym);
    const computedCharList = composeInjectors(injectLimiters, injectWords)(blankCharList);
    return charListToString(computedCharList);
};
exports.buildBlock = (config, transformedWords) => {
    const textConfig = Object.assign({}, config, { sym: constants_1.GAP_SYM });
    const topLine = exports.buildSolidLine(config);
    const textLine = exports.buildWordsLine(textConfig, transformedWords);
    const bottomLine = exports.buildSolidLine(config);
    return topLine + constants_1.NEW_LINE_SYM + textLine + constants_1.NEW_LINE_SYM + bottomLine;
};
exports.BUILDERS_MAP = {
    block: exports.buildBlock,
    line: exports.buildWordsLine
};
//# sourceMappingURL=builders.js.map