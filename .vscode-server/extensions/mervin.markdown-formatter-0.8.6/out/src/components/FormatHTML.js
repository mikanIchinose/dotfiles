"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const FormatComponent_1 = require("./FormatComponent");
var escapeStringRegexp = require('escape-string-regexp');
class FormatHTML extends FormatComponent_1.FormatComponent {
    constructor() {
        super(...arguments);
        this.name = 'html';
    }
    super(text) {
        this.text = text;
    }
    formatted({ TAG_START_EXP, TAG_SINGLE_EXP, TAG_END_EXP }) {
        // this.outputBeforeInfo()
        var as = this.text.match(TAG_START_EXP);
        var asd = this.text.match(TAG_SINGLE_EXP);
        var asde = this.text.match(TAG_END_EXP);
        // this.outputAfterInfo()
        return this.text;
    }
}
exports.FormatHTML = FormatHTML;
//# sourceMappingURL=FormatHTML.js.map