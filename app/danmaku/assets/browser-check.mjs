import { chromium } from "playwright-core";

const url = process.env.BROWSER_CHECK_URL ?? "http://127.0.0.1:4000/";
const executablePath = process.env.CHROMIUM_BIN ?? "/usr/bin/chromium";

const browser = await chromium.launch({
  executablePath,
  headless: true,
  args: ["--no-sandbox", "--disable-dev-shm-usage"],
});

try {
  const page = await browser.newPage();
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

  const finalTick = Number(
    await page.locator('[data-testid="game-tick"]').getAttribute("data-game-tick"),
  );

  if (!Number.isFinite(finalTick) || finalTick <= initialTick) {
    throw new Error(`tick did not advance: initial=${initialTick}, final=${finalTick}`);
  }

  console.log("browser check passed");
} finally {
  await browser.close();
}
