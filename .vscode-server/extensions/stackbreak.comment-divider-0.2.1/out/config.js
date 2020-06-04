"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const constants_1 = require("./constants");
const limiters_1 = require("./limiters");
const getPreset = (type) => {
    const section = vscode_1.workspace.getConfiguration(constants_1.EXT_ID);
    const lineLen = section.get('length');
    const sym = section.get(`${type}Filler`);
    const height = section.get(`${type}Height`);
    const align = section.get(`${type}Align`);
    const transform = section.get(`${type}Transform`);
    return { lineLen, sym, height, align, transform };
};
const mergePresetWithLimiters = (preset, limiters) => (Object.assign({}, preset, { limiters }));
exports.getConfig = (presetId, lang) => mergePresetWithLimiters(getPreset(presetId), limiters_1.getLanguageLimiters(lang));
//# sourceMappingURL=config.js.map