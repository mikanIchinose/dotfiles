export async function git(
  cwd: string,
  ...args: string[]
): Promise<string | null> {
  try {
    const { success, stdout } = await new Deno.Command("git", {
      args,
      cwd,
      stdout: "piped",
      stderr: "null",
    }).output();
    if (!success) {
      return null;
    }
    return new TextDecoder().decode(stdout);
  } catch {
    return null;
  }
}
