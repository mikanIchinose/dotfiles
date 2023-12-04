import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.8/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.8/deps.ts";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins?: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const inlineVimrcs = [
      "$BASE_DIR/keybinding.vim",
    ];

    args.contextBuilder.setGlobal({
      inlineVimrcs: inlineVimrcs,
      protocols: ["git"],
      protocolParams: {
        git: {
          partialClone: true,
        },
      },
      extParams: {
        installer: {
          checkDiff: true,
          maxProcesses: 10,
          githubAPIToken: Deno.env.get("DPP_GITHUB_TOKEN"),
        },
      },
    });

    const [context, options] = await args.contextBuilder.get(args.denops);

    // load toml plugins
    const tomls: Toml[] = [];
    for (
      const tomlFile of [
        "$BASE_DIR/base.toml",
        "$BASE_DIR/dpp.toml",
      ]
    ) {
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: tomlFile,
          options: {
            lazy: false,
          },
        },
      ) as Toml | undefined;

      if (toml) {
        tomls.push(toml);
      }
    }
    for (
      const tomlFile of [
        "$BASE_DIR/lazy.toml",
        "$BASE_DIR/denops.toml",
        "$BASE_DIR/ddc.toml",
        "$BASE_DIR/ddu.toml",
      ]
    ) {
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: tomlFile,
          options: {
            lazy: true,
          },
        },
      ) as Toml | undefined;

      if (toml) {
        tomls.push(toml);
      }
    }

    const plugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    tomls.forEach((toml) => {
      toml.plugins?.forEach((plugin) => {
        plugins[plugin.name] = plugin;
      });

      Object.keys(toml.ftplugins ?? {}).forEach((filetype) => {
        if (toml.ftplugins) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      });

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    });

    const localPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "local",
      "local",
      {
        directory: "~/ghq/github.com/mikanIchinose",
        options: {
          frozen: true,
          merged: false,
        },
        includes: [
          "ddc-*",
          "ddu-*",
          "dpp-*",
        ],
      },
    ) as Plugin[];
    localPlugins.forEach((plugin) => {
      if (plugin.name in plugins) {
        plugins[plugin.name] = Object.assign(
          plugins[plugin.name],
          plugin,
        );
      } else {
        plugins[plugin.name] = plugin;
      }
    });

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(plugins),
      },
    ) as LazyMakeStateResult | undefined;

    const config = {
      checkFiles: await fn.globpath(
        args.denops,
        Deno.env.get("BASE_DIR"),
        "*",
        1,
        1,
      ) as unknown as string[],
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };

    return config;
  }
}

