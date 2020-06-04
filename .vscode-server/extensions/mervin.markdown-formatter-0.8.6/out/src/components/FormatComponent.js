"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class FormatComponent {
    constructor(text) {
        this.text = text;
    }
    outputBeforeInfo() {
        console.log(`< before format ${this.name} >`);
        console.log(`${this.text}`);
    }
    outputAfterInfo() {
        console.log(`< after format ${this.name} >`);
        console.log(`${this.text}`);
    }
}
exports.FormatComponent = FormatComponent;
//# sourceMappingURL=FormatComponent.js.map