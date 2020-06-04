"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const FormatComponent_1 = require("./FormatComponent");
const FormatTableTool_1 = require("./FormatTableTool");
const removeReplace_1 = require("./removeReplace");
var escapeStringRegexp = require('escape-string-regexp');
class FormatTable extends FormatComponent_1.FormatComponent {
    constructor() {
        super(...arguments);
        this.name = 'table';
    }
    super(text) {
        this.text = text;
    }
    formatted({ TABLE_EXP, LINK_EXP, CODE_BLOCK_EXP, CODE_AREA_EXP }) {
        this.text = removeReplace_1.removeReplace({
            text: this.text, reg: [LINK_EXP, CODE_BLOCK_EXP, CODE_AREA_EXP], func(text) {
                const _tableArr = text.match(TABLE_EXP);
                if (_tableArr && _tableArr.length > 0) {
                    _tableArr.forEach((table) => {
                        var re = new RegExp(escapeStringRegexp(String(table)), 'g');
                        text = text.replace(re, (substring) => '\n\n' + new FormatTableTool_1.FormatTableTool().reformat(table) + '\n\n');
                    });
                }
                return text;
            }
        });
        return this.text;
    }
}
exports.FormatTable = FormatTable;
//# sourceMappingURL=FormatTable.js.map