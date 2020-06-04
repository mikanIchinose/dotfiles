"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const constants_1 = require("./constants");
const buildCharList = (lineLen, filler) => Array(lineLen).fill(filler);
const charListToString = (charList) => charList.join('');
const isEven = (num) => num % 2 === 0;
const getWordsAnchors = (charList, words) => {
    const smartRound = !isEven(words.length) && !isEven(charList.length) ? Math.floor : Math.ceil;
    const halfLen = smartRound(charList.length / 2);
    const halfWord = Math.floor(words.length / 2);
    const leftAnchor = halfLen - halfWord;
    const rightAnchor = leftAnchor + (words.length - 1);
    return { leftAnchor, rightAnchor };
};
const withLimiters = (leftLim, rightLim) => (charList) => {
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
const withWords = (words) => (charList) => {
    const { leftAnchor, rightAnchor } = getWordsAnchors(charList, words);
    return charList.map((char, i) => {
        if (i >= leftAnchor && i <= rightAnchor)
            return words[i - leftAnchor];
        else if (i === leftAnchor - 1 || i === rightAnchor + 1)
            return constants_1.GAP_SYM;
        else
            return char;
    });
};
const passToNextInjector = (charList) => charList;
const composeInjectors = (...injectors) => (charList) => injectors.reduce((res, injector) => injector(res), charList);
const buildLine = (config, words) => {
    const injectLimiters = withLimiters(config.limiters.left, config.limiters.right);
    const injectWords = words ? withWords(words) : passToNextInjector;
    const blankCharList = buildCharList(config.lineLen, config.sym);
    const computedCharList = composeInjectors(injectLimiters, injectWords)(blankCharList);
    return charListToString(computedCharList);
};
//# sourceMappingURL=line-builders.js.map