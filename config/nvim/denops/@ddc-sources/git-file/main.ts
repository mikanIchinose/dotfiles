import type { DdcGatherItems } from "@shougo/ddc-vim/types";
import { BaseSource } from "@shougo/ddc-vim/source";
import type {
  GatherArguments,
  GetCompletePositionArguments,
} from "@shougo/ddc-vim/source";
import * as fn from "@denops/std/function";

import { git } from "../../ddc-source-git-shared/git.ts";

type Params = Record<string, never>;

export class Source extends BaseSource<Params> {
  override getCompletePosition(
    args: GetCompletePositionArguments<Params>,
  ): Promise<number> {
    const input = args.context.input;
    const match = input.match(/@\S*$/);
    if (!match) return Promise.resolve(-1);
    return Promise.resolve(input.length - match[0].length);
  }

  override async gather(
    args: GatherArguments<Params>,
  ): Promise<DdcGatherItems> {
    const cwd = await fn.getcwd(args.denops) as string;
    const root = await git(cwd, "rev-parse", "--show-toplevel");
    if (!root) return [];
    const list = await git(root.trim(), "ls-files");
    if (!list) return [];
    return list.split("\n")
      .filter((item) => item.length > 0)
      .map((item) => ({
        word: `@${item.trim()}`,
      }));
  }

  override params(): Params {
    return {};
  }
}
