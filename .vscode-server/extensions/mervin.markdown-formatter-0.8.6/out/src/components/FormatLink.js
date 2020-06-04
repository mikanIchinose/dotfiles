"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const removeReplace_1 = require("./removeReplace");
const FormatComponent_1 = require("./FormatComponent");
const FormatTableTool_1 = require("./FormatTableTool");
var escapeStringRegexp = require('escape-string-regexp');
class FormatLink extends FormatComponent_1.FormatComponent {
    constructor() {
        super(...arguments);
        this.name = 'html';
    }
    super(text) {
        this.text = text;
    }
    formatted({ LINK_SPACE_EXP, LINK_EXP, CODE_BLOCK_EXP, TABLE_EXP }) {
        // this.outputBeforeInfo()
        this.text = removeReplace_1.removeReplace({
            text: this.text,
            reg: [CODE_BLOCK_EXP],
            func(text) {
                text = text.replace(LINK_EXP, '\n\n' + '$1' + '\n\n');
                text = text.replace(LINK_SPACE_EXP, '\n' + '$1 $2');
                // hanler table in link
                // https://github.com/sumnow/markdown-formatter/issues/20
                if (text.match(LINK_EXP)) {
                    text.match(LINK_EXP).forEach(e => {
                        const textRemoveLinkSymbol = e.replace(/\n\>\ /g, '\n');
                        if (textRemoveLinkSymbol.match(TABLE_EXP)) {
                            const textResult = `\n${new FormatTableTool_1.FormatTableTool().reformat(textRemoveLinkSymbol)}`.replace(/\n\|/g, '\n> |');
                            const _reg = new RegExp(escapeStringRegexp(e));
                            text = text.replace(_reg, textResult);
                        }
                    });
                }
                // textTable.forEach(e => {
                //     const les = new FormatTableTool().reformat(e)
                //     console.log(456, les)
                // })
                return text;
            }
        });
        // this.outputAfterInfo()
        return this.text;
    }
}
exports.FormatLink = FormatLink;
//# sourceMappingURL=FormatLink.js.map