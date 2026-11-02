// Usage: bun ~/.claude/skills/explain-video/build.ts <workdir> [--kana]
// slidev をブラウザで実際に再生して録画し、ずんだもんの音声とテロップを重ねて <workdir>/video.mp4 を作る
// --kana は動画を作らず、各台詞を VOICEVOX がどう読むかだけを出す
import { $ } from "bun";
import { chromium, type Frame } from "playwright-chromium";
import { mkdir, readdir, rm } from "node:fs/promises";
import { join, resolve } from "node:path";

type Line = { text: string; yomi?: string };
type Narration = Line[][][]; // slide -> click step -> lines

const ENGINE = "http://127.0.0.1:50021";
const SPEAKER = Number(process.env.SPEAKER ?? 3); // ずんだもん ノーマル
const PORT = 3131;
const W = 1920, H = 1080, SLIDE_H = 880, SLIDE_W = Math.round((SLIDE_H * 16) / 9);

const dir = resolve(process.argv[2] ?? ".");
const tmp = join(dir, ".build");
const narration: Narration = await Bun.file(join(dir, "narration.json")).json();
await ensureEngine();

if (process.argv.includes("--kana")) {
  for (const line of narration.flat(2)) {
    const q = await (await fetch(`${ENGINE}/audio_query?speaker=${SPEAKER}&text=${encodeURIComponent(line.yomi ?? line.text)}`, { method: "POST" })).json();
    console.log(`${line.text}\n  -> ${q.kana}`);
  }
  process.exit(0);
}

await rm(tmp, { recursive: true, force: true });
await mkdir(tmp, { recursive: true });
const lines = narration.flat(2);
const wavs: { path: string; sec: number }[] = [];
for (const [i, line] of lines.entries()) {
  const path = join(tmp, `${String(i).padStart(4, "0")}.wav`);
  await Bun.write(path, await synthesize(line.yomi ?? line.text));
  wavs.push({ path, sec: Number((await $`ffprobe -v error -show_entries format=duration -of csv=p=0 ${path}`.text()).trim()) });
}

const server = Bun.spawn([join(import.meta.dir, "node_modules/.bin/slidev"), join(dir, "slides.md"), "--port", String(PORT)], { stdout: "ignore", stderr: "ignore" });
try {
  for (let t = 0; t < 120 && !(await fetch(`http://localhost:${PORT}`).then((r) => r.ok, () => false)); t++) await Bun.sleep(500);
  const browser = await chromium.launch();

  // 録画前に各スライドのステップ数を台本と突き合わせる
  const probe = await browser.newPage();
  await probe.goto(`http://localhost:${PORT}/1?embedded=true`);
  await probe.waitForFunction(() => (window as any).__slidev__?.nav);
  const steps: number[] = await probe.evaluate(async () => {
    const nav = (window as any).__slidev__.nav;
    const out: number[] = [];
    for (let i = 1; i <= nav.total; i++) {
      await nav.go(i);
      await new Promise((r) => setTimeout(r, 300));
      out.push(nav.clicksTotal + 1);
    }
    return out;
  });
  await probe.close();
  const mismatch = steps.map((s, i) => ({ slide: i + 1, steps: s, narration: narration[i]?.length ?? 0 })).filter((m) => m.steps !== m.narration);
  if (steps.length !== narration.length || mismatch.length) {
    console.error(`slides=${steps.length} narration=${narration.length}`, mismatch);
    throw new Error("narration.json の slide/step 数がスライドと一致しない");
  }

  const context = await browser.newContext({ viewport: { width: W, height: H }, recordVideo: { dir: tmp, size: { width: W, height: H } } });
  const videoStart = Date.now();
  const page = await context.newPage();
  await page.setContent(wrapperHtml(`http://localhost:${PORT}/1?embedded=true`));
  const slide: Frame = await (await page.waitForSelector("iframe")).contentFrame().then((f) => f!);
  await slide.waitForFunction(() => (window as any).__slidev__?.nav);
  await page.waitForTimeout(1500);

  const offsets: number[] = [];
  let n = 0;
  const start = Date.now();
  for (const [i, slideSteps] of narration.entries()) {
    for (const [j, stepLines] of slideSteps.entries()) {
      if (i || j) await slide.evaluate(() => (window as any).__slidev__.nav.next());
      for (const line of stepLines) {
        await page.evaluate((t) => (document.getElementById("sub")!.textContent = t), line.text);
        offsets.push(Date.now() - videoStart);
        await page.waitForTimeout(wavs[n++].sec * 1000);
      }
    }
  }
  await page.waitForTimeout(800);
  const end = Date.now();
  await context.close();
  await browser.close();

  const webm = join(tmp, (await readdir(tmp)).find((f) => f.endsWith(".webm"))!);
  const inputs = wavs.flatMap((w) => ["-i", w.path]);
  const filter = wavs.map((_, k) => `[${k + 1}:a]adelay=${offsets[k]}:all=1[a${k}]`).join(";") + ";" + wavs.map((_, k) => `[a${k}]`).join("") + `amix=inputs=${wavs.length}:normalize=0[a]`;
  const from = (start - videoStart - 300) / 1000, dur = (end - start + 300) / 1000;
  await $`ffmpeg -y -v error -i ${webm} ${inputs} -filter_complex ${filter} -map 0:v -map [a] -ss ${from} -t ${dur} -c:v libx264 -pix_fmt yuv420p -r 30 -c:a aac ${join(dir, "video.mp4")}`;
  console.log(join(dir, "video.mp4"));
} finally {
  server.kill();
}

async function synthesize(text: string): Promise<ArrayBuffer> {
  const query = await (await fetch(`${ENGINE}/audio_query?speaker=${SPEAKER}&text=${encodeURIComponent(text)}`, { method: "POST" })).json();
  query.postPhonemeLength = 0.4;
  const res = await fetch(`${ENGINE}/synthesis?speaker=${SPEAKER}`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(query) });
  if (!res.ok) throw new Error(`synthesis failed: ${res.status} ${text}`);
  return res.arrayBuffer();
}

async function ensureEngine() {
  const up = () => fetch(`${ENGINE}/version`).then((r) => r.ok, () => false);
  if (await up()) return;
  await $`docker start voicevox || docker run -d --rm --name voicevox -p 127.0.0.1:50021:50021 voicevox/voicevox_engine:cpu-latest`.quiet();
  for (let t = 0; t < 120; t++) {
    if (await up()) return;
    await Bun.sleep(1000);
  }
  throw new Error("VOICEVOX engine が起動しない");
}

function wrapperHtml(src: string) {
  return `<!doctype html><meta charset="utf-8"><style>
  body{margin:0;width:${W}px;height:${H}px;background:#111;font-family:"Hiragino Sans","Noto Sans JP",sans-serif;overflow:hidden}
  iframe{display:block;margin:0 auto;width:${SLIDE_W}px;height:${SLIDE_H}px;border:0}
  #sub{height:${H - SLIDE_H}px;display:flex;align-items:center;justify-content:center;padding:0 80px;box-sizing:border-box;
    color:#fff;font-size:52px;font-weight:700;line-height:1.3;text-align:center;
    text-shadow:0 0 6px #2e7d32,0 0 6px #2e7d32,0 0 6px #2e7d32}
  .credit{position:absolute;right:16px;bottom:8px;color:#888;font-size:18px}
  </style><iframe src="${src}"></iframe><div id="sub"></div><div class="credit">VOICEVOX:ずんだもん</div>`;
}
