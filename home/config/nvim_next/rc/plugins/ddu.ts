import {
  ActionArguments,
  ActionFlags,
  BaseActionParams,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.6.0/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.1.0/filer.ts";

//type Params = Record<string, unknown>;

//async function calculateUiSize(denops: Denops):Promise<[column: number, line: number]> {
//  const columns = await ops.columns.get(denops)
//  const lines = await ops.lines.get(denops)
//  return [columns, lines]
//}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
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
          //autoAction: {
          //  name: "preview",
          //},
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
          winWidth: 100,
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
        buffer: {
          actions: {
            deleteBuffers: deleteBuffers,
          },
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
          actions: {
            openFileRightWindow: openFileRightWindow,
          },
        },
      },
      kindParams: {},
      actionOptions: {},
    });
  }
}

// 右隣のウィンドウでファイルを開く
async function openFileRightWindow(
  args: ActionArguments<BaseActionParams>,
): Promise<ActionFlags> {
  const action = args.items[0]?.action as ActionData;
  await args.denops.cmd("wincmd l");
  await args.denops.cmd(`edit ${action.path}`);
  return ActionFlags.None;
}

async function deleteBuffers(
  args: ActionArguments<BaseActionParams>,
): Promise<ActionFlags> {
  for (const item of args.items) {
    const action = item.action as ActionData;
    await args.denops.cmd(`bdelete ${action.bufNr}`);
  }
  return ActionFlags.RefreshItems;
}
