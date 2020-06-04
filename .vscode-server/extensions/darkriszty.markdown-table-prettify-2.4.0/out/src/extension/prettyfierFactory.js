"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const tableDocumentPrettyfier_1 = require("./tableDocumentPrettyfier");
const tableFinder_1 = require("../tableFinding/tableFinder");
const tableDocumentRangePrettyfier_1 = require("./tableDocumentRangePrettyfier");
const consoleLogger_1 = require("../diagnostics/consoleLogger");
const vsWindowLogger_1 = require("../diagnostics/vsWindowLogger");
const tableFactory_1 = require("../modelFactory/tableFactory");
const alignmentFactory_1 = require("../modelFactory/alignmentFactory");
const tableValidator_1 = require("../modelFactory/tableValidator");
const tableStringWriter_1 = require("../writers/tableStringWriter");
const contentPadCalculator_1 = require("../padCalculation/contentPadCalculator");
const tableViewModelFactory_1 = require("../viewModelFactories/tableViewModelFactory");
const rowViewModelFactory_1 = require("../viewModelFactories/rowViewModelFactory");
const trimmerTransformer_1 = require("../modelFactory/transformers/trimmerTransformer");
const borderTransformer_1 = require("../modelFactory/transformers/borderTransformer");
const selectionInterpreter_1 = require("../modelFactory/selectionInterpreter");
const padCalculatorSelector_1 = require("../padCalculation/padCalculatorSelector");
const alignmentMarking_1 = require("../viewModelFactories/alignmentMarking");
function getDocumentRangePrettyfier(strict = false) {
    return new tableDocumentRangePrettyfier_1.TableDocumentRangePrettyfier(new tableFactory_1.TableFactory(new alignmentFactory_1.AlignmentFactory(), new selectionInterpreter_1.SelectionInterpreter(strict), new trimmerTransformer_1.TrimmerTransformer(new borderTransformer_1.BorderTransformer(null))), new tableValidator_1.TableValidator(new selectionInterpreter_1.SelectionInterpreter(strict)), new tableViewModelFactory_1.TableViewModelFactory(new rowViewModelFactory_1.RowViewModelFactory(new contentPadCalculator_1.ContentPadCalculator(new padCalculatorSelector_1.PadCalculatorSelector(), " "), new alignmentMarking_1.AlignmentMarkerStrategy(":"))), new tableStringWriter_1.TableStringWriter(), [
        ...(canShowWindowMessages() ? [new vsWindowLogger_1.VsWindowLogger()] : []),
        new consoleLogger_1.ConsoleLogger()
    ]);
}
exports.getDocumentRangePrettyfier = getDocumentRangePrettyfier;
function getDocumentPrettyfier(strict = true) {
    return new tableDocumentPrettyfier_1.TableDocumentPrettyfier(new tableFinder_1.TableFinder(new tableValidator_1.TableValidator(new selectionInterpreter_1.SelectionInterpreter(strict))), getDocumentRangePrettyfier(strict));
}
exports.getDocumentPrettyfier = getDocumentPrettyfier;
function canShowWindowMessages() {
    return getConfigurationValue("showWindowMessages", true);
}
function getConfigurationValue(key, defaultValue) {
    return vscode.workspace.getConfiguration("markdownTablePrettify").get(key, defaultValue);
}
//# sourceMappingURL=prettyfierFactory.js.map