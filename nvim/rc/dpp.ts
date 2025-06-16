import { type ExtOptions, type Plugin } from "jsr:@shougo/dpp-vim@~4.2.0/types";
import {
  BaseConfig,
  ConfigArguments,
  type ConfigReturn,
  type MultipleHook,
} from "jsr:@shougo/dpp-vim@~4.2.0/config";
import { Protocol } from "jsr:@shougo/dpp-vim@~4.2.0/protocol";
import { mergeFtplugins } from "jsr:@shougo/dpp-vim@~4.2.0/utils";

import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "jsr:@shougo/dpp-ext-toml@~1.3.0";
import type {
  Ext as LazyExt,
  LazyMakeStateResult,
} from "jsr:@shougo/dpp-ext-lazy@~1.5.0";
import type {
  Params as PackspecParams,
} from "jsr:@shougo/dpp-ext-packspec@~1.3.0";

import { expandGlob } from "jsr:@std/fs@~1.0.0/expand-glob";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const inlineVimrcs = [
      "$BASE_DIR/keybinding.vim",
    ];

    args.contextBuilder.setGlobal({
      inlineVimrcs,
      protocols: ["git"],
      extParams: {
        installer: {
          checkDiff: true,
          maxProcesses: 10,
          githubAPIToken: Deno.env.get("DPP_GITHUB_TOKEN"),
        },
      },
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      string,
      Protocol
    >;

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    const multipleHooks: MultipleHook[] = [];

    // dpp-ext-toml
    const [tomlExt, tomlOptions, tomlParams] = await args.denops.dispatcher
      .getExt("toml") as [
        TomlExt | undefined,
        ExtOptions,
        TomlParams,
      ];
    if (tomlExt) {
      const action = tomlExt.actions.load;
      const tomlPromises = [
        { path: "$BASE_DIR/base.toml", lazy: false },
        { path: "$BASE_DIR/dpp.toml", lazy: false },
        { path: "$BASE_DIR/lazy.toml", lazy: true },
      ].map((tomlFile) =>
        action.callback({
          denops: args.denops,
          context,
          options,
          protocols,
          extOptions: tomlOptions,
          extParams: tomlParams,
          actionParams: {
            path: tomlFile.path,
            options: {
              lazy: tomlFile.lazy,
            },
          },
        })
      );
      const tomls = await Promise.all(tomlPromises);
      tomls.forEach((toml) => {
        toml.plugins?.forEach((plugin) => {
          recordPlugins[plugin.name] = plugin;
        });
        if (toml.ftplugins) {
          mergeFtplugins(ftplugins, toml.ftplugins);
        }
        if (toml.multiple_hooks) {
          multipleHooks.push(...toml.multiple_hooks);
          // multipleHooks = multipleHooks.concat(toml.multiple_hooks);
        }
        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
      });
    }

    // dpp-ext-lazy
    const [lazyExt, lazyOptions, lazyParams] = await args.denops.dispatcher
      .getExt("lazy") as [
        LazyExt | undefined,
        ExtOptions,
        PackspecParams,
      ];
    let lazyResult: LazyMakeStateResult | undefined = undefined;
    if (lazyExt) {
      const action = lazyExt.actions.makeState;
      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        },
      });
    }

    const checkFiles = [];
    for await (const file of expandGlob(`${Deno.env.get("BASE_DIR")}/*`)) {
      checkFiles.push(file.path);
    }

    return {
      checkFiles,
      ftplugins,
      hooksFiles,
      multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
