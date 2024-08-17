import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v1.0.0/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v1.0.0/deps.ts";
import { expandGlob } from "https://deno.land/std@0.224.0/fs/expand_glob.ts";

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

    const tomlPromises = [
      { path: "$BASE_DIR/base.toml", lazy: false },
      { path: "$BASE_DIR/dpp.toml", lazy: false },
      { path: "$BASE_DIR/lazy.toml", lazy: true },
      { path: "$BASE_DIR/denops.toml", lazy: true },
      { path: "$BASE_DIR/ddc.toml", lazy: true },
      { path: "$BASE_DIR/ddu.toml", lazy: true },
    ].map((toml) => {
      return args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: toml.path,
          options: {
            lazy: toml.lazy,
          },
        },
      ) as Promise<Toml | undefined>;
    });
    const tomls = await Promise.all(tomlPromises);

    const plugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    for (const toml of tomls) {
      if (!toml) {
        continue;
      }

      for (const plugin of toml.plugins ?? []) {
        plugins[plugin.name] = plugin;
      }

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
    }

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
    ) as Plugin[] | undefined;

    if (localPlugins) {
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
    }

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

    const checkFiles = [];
    for await (const file of expandGlob(`${Deno.env.get("BASE_DIR")}/*`)) {
      checkFiles.push(file.path);
    }

    return {
      checkFiles,
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
