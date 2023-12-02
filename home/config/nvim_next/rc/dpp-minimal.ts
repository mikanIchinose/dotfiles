import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.7/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.7/deps.ts";

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
    const [context, options] = await args.contextBuilder.get(args.denops);

    // load toml plugins
    const tomls: Toml[] = [];
    for (
      const tomlPath of [
        "$BASE_DIR/lazy-minimal.toml",
      ]
    ) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: tomlPath,
            options: {
              lazy: true,
            },
          },
        ) as Toml,
      );
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


    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(plugins),
      },
    ) as LazyMakeStateResult;

    return {
      checkFiles: await fn.globpath(
        args.denops,
        Deno.env.get("BASE_DIR"),
        "*",
        1,
        1,
      ) as unknown as string[],
      ftplugins,
      hooksFiles,
      plugins: lazyResult.plugins,
      stateLines: lazyResult.stateLines,
    };
  }
}
