import { chromium } from "playwright-core";

const url = process.env.BROWSER_CHECK_URL ?? "http://127.0.0.1:4000/";
const executablePath = process.env.CHROMIUM_BIN ?? "/usr/bin/chromium";
const screenshotPath =
  process.env.BROWSER_CHECK_SCREENSHOT ?? new URL("../.browser-check.png", import.meta.url).pathname;

const browser = await chromium.launch({
  executablePath,
  headless: true,
  args: ["--no-sandbox", "--disable-dev-shm-usage"],
});

let page;
try {
  page = await browser.newPage();
  page.on("console", message => {
    console.log(`browser console: ${message.type()}: ${message.text()}`);
  });
  page.on("pageerror", error => {
    console.error(`browser pageerror: ${error.message}`);
  });
  page.on("requestfailed", request => {
    console.error(`browser requestfailed: ${request.url()} -> ${request.failure()?.errorText ?? "unknown"}`);
  });

  await page.goto(url, { waitUntil: "domcontentloaded" });
  await page.locator('[data-testid="game-tick"]').waitFor({ state: "visible" });
  await page.waitForFunction(
    () => window.liveSocket && typeof window.liveSocket.isConnected === "function" && window.liveSocket.isConnected(),
    null,
    { timeout: 15_000 },
  );

  const initialTick = Number(
    await page.locator('[data-testid="game-tick"]').getAttribute("data-game-tick"),
  );
  const initialPlayerX = Number(
    await page.locator('[data-testid="player-position"]').getAttribute("data-player-x"),
  );
  const initialHits = Number(await page.locator('[data-testid="hit-count"]').textContent());

  await page.waitForFunction(
    previousTick => {
      const element = document.querySelector('[data-testid="game-tick"]');
      if (!element) return false;

      const currentTick = Number(element.getAttribute("data-game-tick"));
      return Number.isFinite(currentTick) && currentTick > previousTick;
    },
    initialTick,
    { timeout: 15_000 },
  );

  await page.waitForFunction(
    () => {
      const element = document.querySelector('[data-testid="bullet-count"]');
      return element && Number(element.textContent) > 0;
    },
    null,
    { timeout: 15_000 },
  );

  await page.waitForFunction(
    previousHits => {
      const element = document.querySelector('[data-testid="hit-count"]');
      return element && Number(element.textContent) > previousHits;
    },
    initialHits,
    { timeout: 25_000 },
  );

  await page.keyboard.press("ArrowLeft");

  await page.waitForFunction(
    previousX => {
      const element = document.querySelector('[data-testid="player-position"]');
      if (!element) return false;

      const currentX = Number(element.getAttribute("data-player-x"));
      return Number.isFinite(currentX) && currentX < previousX;
    },
    initialPlayerX,
    { timeout: 15_000 },
  );

  const finalTick = Number(
    await page.locator('[data-testid="game-tick"]').getAttribute("data-game-tick"),
  );
  const finalPlayerX = Number(
    await page.locator('[data-testid="player-position"]').getAttribute("data-player-x"),
  );
  const finalHits = Number(await page.locator('[data-testid="hit-count"]').textContent());

  if (!Number.isFinite(finalTick) || finalTick <= initialTick) {
    throw new Error(`tick did not advance: initial=${initialTick}, final=${finalTick}`);
  }

  if (!Number.isFinite(finalPlayerX) || finalPlayerX >= initialPlayerX) {
    throw new Error(`player did not move left: initial=${initialPlayerX}, final=${finalPlayerX}`);
  }

  if (!Number.isFinite(finalHits) || finalHits <= initialHits) {
    throw new Error(`hit counter did not advance: initial=${initialHits}, final=${finalHits}`);
  }

  console.log("browser check passed");
} finally {
  if (page) {
    await page.screenshot({ path: screenshotPath, fullPage: true });
    console.log(`browser screenshot saved: ${screenshotPath}`);
  }
  await browser.close();
}
