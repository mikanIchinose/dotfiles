"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const constants_1 = require("./constants");
const pass = (words) => words;
const toLowerCase = (words) => words.toLowerCase();
const toUpperCase = (words) => words.toUpperCase();
const toTitleCase = (words) => words
    .split(constants_1.GAP_SYM)
    .map((word) => Array.from(word)
    .map((char, idx) => (idx === 0 ? char.toUpperCase() : char))
    .join(''))
    .join(constants_1.GAP_SYM);
exports.TRANSFORM_MAP = {
    lowercase: toLowerCase,
    uppercase: toUpperCase,
    titlecase: toTitleCase,
    none: pass
};
//# sourceMappingURL=transforms.js.map