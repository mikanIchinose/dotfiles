"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const FormatComponent_1 = require("./FormatComponent");
var escapeStringRegexp = require('escape-string-regexp');
const removeReplace_1 = require("./removeReplace");
class FormatList extends FormatComponent_1.FormatComponent {
    constructor() {
        super(...arguments);
        this.name = 'list';
    }
    super(text) {
        this.text = text;
    }
    repeatZero({ number, str }) {
        if (number === 0) {
            return str;
        }
        else {
            return this.repeatZero({ number: number - 1, str: `0${str}` });
        }
    }
    formatLineBetween({ LIST_EXP }) {
        this.text = this.text.replace(LIST_EXP, '\n\n' + '$1' + '\n\n');
    }
    formatUL(text, { formatULSymbol, LIST_UL_ST_EXP, LIST_UL_ND_EXP, LIST_UL_TH_EXP }) {
        if (formatULSymbol) {
            text = text.replace(LIST_UL_ST_EXP, '\n* ' + '$1');
            text = text.replace(LIST_UL_ND_EXP, '\n  + ' + '$1');
            text = text.replace(LIST_UL_TH_EXP, '\n    - ' + '$1');
        }
        return text;
    }
    formatOL({ LIST_OL_LI_EXP }) {
        // format ol
        const _arr = this.text.match(LIST_OL_LI_EXP);
        const _length = _arr !== null ? _arr.map(e => {
            return e.replace(LIST_OL_LI_EXP, '$2').length;
        }) : [];
        const maxLength = Math.max(..._length);
        if (maxLength > 1) {
            _arr.forEach((e, i) => {
                e = escapeStringRegexp(e);
                if (_length[i] < maxLength) {
                    const _reg = new RegExp((e), 'g');
                    this.text = this.text.replace(_reg, e.replace(LIST_OL_LI_EXP, `$1${this.repeatZero({ number: maxLength - _length[i], str: '' })}$2$3`));
                }
            });
        }
    }
    formatted({ formatULSymbol, LIST_EXP, LIST_UL_ST_EXP, LIST_UL_ND_EXP, LIST_UL_TH_EXP, LIST_OL_LI_EXP, SPLIT_LINE_EXP }) {
        // this.outputBeforeInfo()
        // format list
        this.formatLineBetween({ LIST_EXP });
        // format ul
        const self = this;
        // https://github.com/sumnow/markdown-formatter/issues/23
        this.text = removeReplace_1.removeReplace({
            text: this.text,
            reg: [SPLIT_LINE_EXP],
            func(text) {
                text = self.formatUL(text, { formatULSymbol, LIST_UL_ST_EXP, LIST_UL_ND_EXP, LIST_UL_TH_EXP });
                return text;
            }
        });
        // format ol
        this.formatOL({ LIST_OL_LI_EXP });
        // this.outputAfterInfo()
        return this.text;
    }
}
exports.FormatList = FormatList;
//# sourceMappingURL=FormatList.js.map