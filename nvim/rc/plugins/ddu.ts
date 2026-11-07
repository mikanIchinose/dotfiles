import {
  type ActionArguments,
  ActionFlags,
} from "@shougo/ddu-vim/types";
import {
  BaseConfig,
  type ConfigArguments,
} from "@shougo/ddu-vim/config";
import { type ActionData } from "@shougo/ddu-kind-file";
import { type Params as FfParams } from "@shougo/ddu-ui-ff";
import { type Params as FilerParams } from "@shougo/ddu-ui-filer";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "ff",
      profile: false,
      uiOptions: {
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: {
          autoAction: {
            name: "preview",
          },
          //startAutoAction: true,
          filterSplitDirection: "floating",
          floatingBorder: "rounded",
          previewFloating: true,
          previewSplit: "vertical",
          previewCol: "&columns / 2 + 5",
          previewWidth: "&columns / 2 - 4",
          previewHeight: "&lines / 3",
          previewFloatingBorder: "rounded",
          updateTime: 0,
          winCol: "0",
          winRow: "&lines",
          winHeight: "&lines / 3",
          winWidth: "&columns",
          split: "floating",
        } as Partial<FfParams>,
        filer: {
          sort: "filename",
          split: "no",
        } as Partial<FilerParams>,
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          smartCase: true,
        },
        file: {
          matchers: [
            "matcher_hidden",
            "matcher_substring",
          ],
          sorters: ["sorter_alpha"],
          converters: ["converter_hl_dir"],
        },
        dein_update: {
          matchers: ["matcher_dein_update"],
        },
        // buffer: {
        //   actions: {
        //     deleteBuffers,
        //   },
        // },
        markdown: {
          sorters: [],
        },
      },
      sourceParams: {
        file_rec: {
          ignoredDirectories: [
            ".git",
            ".yarn",
            ".husky",
            ".next",
            ".idea",
            "node_modules",
            "target",
            ".clj-kondo",
          ],
        },
      },
      filterParams: {},
      kindOptions: {
        action: {
          defaultAction: "do",
        },
        help: {
          defaultAction: "open",
        },
        file: {
          defaultAction: "open",
          // actions: {
          //   openFileRightWindow,
          // },
        },
      },
      kindParams: {},
      actionOptions: {
        openFileRightWindow: { quit: false },
      },
    });

    return Promise.resolve();
  }
}

// 右隣のウィンドウでファイルを開く
// async function openFileRightWindow(
//   args: ActionArguments<BaseActionParams>,
// ): Promise<ActionFlags> {
//   const action = args.items[0]?.action as ActionData;
//   await args.denops.cmd("wincmd l");
//   await args.denops.cmd(`edit ${action.path}`);
//   return ActionFlags.None;
// }

// async function deleteBuffers(
//   args: ActionArguments<BaseActionParams>,
// ): Promise<ActionFlags> {
//   for (const item of args.items) {
//     const action = item.action as ActionData;
//     await args.denops.cmd(`bdelete ${action.bufNr}`);
//   }
//   return ActionFlags.RefreshItems;
// }
