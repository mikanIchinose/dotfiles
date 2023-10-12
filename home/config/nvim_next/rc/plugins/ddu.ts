import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  BaseActionParams,
  Ddu,
} from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.6.0/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.6.0/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.1.0/filer.ts";
import * as ops from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts"

//type Params = Record<string, unknown>;

//async function calculateUiSize(denops: Denops):Promise<[column: number, line: number]> {
//  const columns = await ops.columns.get(denops)
//  const lines = await ops.lines.get(denops)
//  return [columns, lines]
//}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    //const [columns, lines] = await calculateUiSize(args.denops)
    args.contextBuilder.patchGlobal({
      ui: "ff",
      profile: false,
      uiOptions: {
        filer: {
          toggle: true,
        }
      },
      uiParams: {
        ff: {
          autoAction:{
            name: "preview",
          },
          filterSplitDirection: "floating",
          floatingBorder: "none",
          //onPreview: async (args: {
          //  denops: Denops;
          //  previewWinId: number;
          //}) => {
          //  await fn.win_execute(args.denops,args.previewWinId, "normal! zt")
          //},
          previewFloating: true,
          //previewFloatingBorder: "single",
          previewSplit: "vertical",
          previewCol: "&columns / 2",
          previewWidth: "&columns / 2",
          updateTime: 0,
          winCol: "0",
          winRow: "&lines",
          split: "floating",
        } as Partial<FfParams>,
        filer: {
          sort: "filename",
          winWidth: 100,
        } as Partial<FilerParams>
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          smartCase: true,
        },
        file: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
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
      sourceParams: {},
      filterParams: {},
      kindOptions: {
        action: {
          defaultAction: "do",
        },
        file: {
          defaultAction: "open",
          actions: {
            openFileRightWindow: openFileRightWindow,
          },
        },
        dein_update: {
          defaultAction: "viewDiff",
        },
      },
      kindParams: {},
      actionOptions: {
      },
    });
  }
}

// 右隣のウィンドウでファイルを開く
async function openFileRightWindow(args: ActionArguments<BaseActionParams>): Promise<ActionFlags> {
  const action = args.items[0]?.action as ActionData
  await args.denops.cmd("wincmd l")
  await args.denops.cmd(`edit ${action.path}`)
  return ActionFlags.None
}

async function deleteBuffers(args: ActionArguments<BaseActionParams>): Promise<ActionFlags> {
  for (const item of args.items) {
    const action = item.action as ActionData
    await args.denops.cmd(`bdelete ${action.bufNr}`)
  }
  return ActionFlags.RefreshItems
}

