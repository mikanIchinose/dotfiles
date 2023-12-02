// deno-lint-ignore-file require-await
import { BaseConfig } from "https://deno.land/x/ddc_vim@v4.0.4/types.ts";
//import { fn } from "https://deno.land/x/ddc_vim@v4.0.4/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddc_vim@v4.0.4/base/config.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "pum",
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
        ":": ["cmdline", "cmdline-history", "around"],
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
          mark: "A",
        },
        cmdline: {
          mark: "cmdline",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
        },
        "cmdline-history": {
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
          mark: "F",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        "lsp": {
          mark: "lsp",
          //dup: "keep",
          //keywordPattern: "\k+",
          sorters: ["sorter_lsp-kind"],
          //converters: ["converter_fuzzy"],
          //matchers: ["matcher_fuzzy"],
          //sorters: ["sorter_fuzzy"],
          //forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
        },
        vsnip: {
          mark: "snippet",
        },
        rg: {
          mark: "rg",
        },
        "shell-native": {
          mark: "fish",
        },
        skkeleton: {
          mark: "skk",
          matchers: ["skkeleton"],
          sorters: [],
          minAutoCompleteLength: 2,
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
        "lsp": {
          snippetEngine: async (body: string) => {
            await args.denops.call("vsnip#anonymous", body);
          },
          confirmBehavior: "replace",
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
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

    for (
      const filetype of [
        "css",
        "go",
        "html",
        "python",
        "typescript",
        "typescriptreact",
        "tsx",
        "graphql",
        "rust",
        "vue",
        "markdown",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: ["vsnip", "lsp", "around", "file"],
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
