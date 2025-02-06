// deno-lint-ignore-file require-await
import { type DdcItem } from "jsr:@shougo/ddc-vim@~9.0.0/types";
import { BaseConfig, ConfigArguments } from "jsr:@shougo/ddc-vim@~9.0.0/config";
import { Denops } from "jsr:@denops/std@~7.3.0";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "pum",
      dynamicUi: async (_denops: Denops, args: Record<string, unknown>) => {
        const uiArgs = args as { items: DdcItem[] };
        return Promise.resolve(uiArgs.items.length === 1 ? "inline" : "pum");
      },
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineEnter",
        "CmdlineChanged",
        "TextChangedT",
      ],
      sources: ["around", "rg", "file"],
      cmdlineSources: {
        ":": ["cmdline", "cmdline_history", "around"],
        "/": ["around"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_head"],
          sorters: ["sorter_rank"],
          timeout: 1000,
        },
        around: {
          mark: "around",
        },
        cmdline: {
          mark: "cmdline",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
        },
        "cmdline_history": {
          mark: "history",
          sorters: [],
        },
        copilot: {
          mark: "cop",
          matchers: [],
          minAutoCompleteLength: 0,
          isVolatile: false,
        },
        codeium: {
          mark: "cod",
          matchers: ["matcher_length"],
          minAutoCompleteLength: 0,
          isVolatile: true,
        },
        file: {
          mark: "file",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        lsp: {
          mark: "lsp",
          //dup: "keep",
          //keywordPattern: "\k+",
          matchers: ["matcher_head"],
          sorters: ["sorter_lsp-kind"],
          converters: [],
          // matchers: ["matcher_fuzzy"],
          // sorters: ["sorter_fuzzy"],
          // converters: ["converter_fuzzy"],
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          minAutoCompleteLength: 1,
          // forceCompletionPattern: "\\(\\w+",
          // dup: "force",
        },
        vsnip: {
          mark: "snippet",
        },
        rg: {
          mark: "grep",
        },
        "shell-native": {
          mark: "fish",
        },
        skkeleton: {
          mark: "skk",
          // matchers: ["skkeleton"],
          // sorters: [],
          isVolatile: true,
        },
      },
      sourceParams: {
        file: {
          filenameChars: "[:keyword:].",
        },
        "shell-native": {
          shell: "fish",
        },
        lsp: {
          snippetEngine: async (body: string) => {
            await args.denops.call("vsnip#anonymous", body);
          },
          confirmBehavior: "replace",
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
          enableDisplayDetail: true,
        },
      },
      postFilters: ["sorter_head"],
    });

    // shell script
    for (const filetype of ["bash", "zsh", "fish"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "[0-9a-zA-Z_./#:-]*",
          },
        },
        sources: ["shell-native", "around", "file"],
      });
    }
    args.contextBuilder.patchFiletype("deol", {
      specialBufferCompletion: true,
      sources: [
        "shell-native",
        //"shell-history",
        "around",
        "file",
      ],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_./#:-]*",
        },
      },
    });

    args.contextBuilder.patchFiletype("typescript", {
      sourceOptions: {
        _: {
          keywordPattern: "#?[a-zA-Z_][0-9a-zA-Z_]*",
        },
      },
    });

    for (
      const filetype of [
        "css",
        "html",
        "typescript",
        "typescriptreact",
        "tsx",
        "vue",
        "markdown",
        "graphql",
        "yaml",
        "json",
        "toml",
        "go",
        "rust",
        "python",
        "haskell",
        "clojure",
        "nix",
        "lua",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: ["lsp", "around", "file", "vsnip"],
      });
    }

    // args.contextBuilder.patchFiletype("lua", {
    //   sources: ["codeium", "lsp", "nvim-lua", "around"],
    // });

    // Enable specialBufferCompletion for cmdwin.
    args.contextBuilder.patchFiletype("vim", {
      specialBufferCompletion: true,
    });
  }
}
