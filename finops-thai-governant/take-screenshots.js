const puppeteer = require('/Users/tk/.claude/plugins/cache/revealjs-skill/revealjs/1.0.0/node_modules/puppeteer');
const path = require('path');
const fs = require('fs');

const HTML = 'file://' + path.resolve(__dirname, 'presentation.html') + '?export';
const OUT = path.join(__dirname, 'shots');

fs.mkdirSync(OUT, { recursive: true });

(async () => {
  const browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox'] });
  const page = await browser.newPage();
  // Use oversized viewport so the slide (1280x720) is fully visible regardless of centering
  await page.setViewport({ width: 1920, height: 1080, deviceScaleFactor: 1 });
  await page.goto(HTML, { waitUntil: 'networkidle0', timeout: 30000 });
  await new Promise(r => setTimeout(r, 2000));

  // Find exact slide bounds so we can clip precisely
  const slideRect = await page.evaluate(() => {
    const el = document.querySelector('.reveal');
    const r = el.getBoundingClientRect();
    return { x: Math.round(r.left), y: Math.round(r.top), width: Math.round(r.width), height: Math.round(r.height) };
  });
  console.log('Slide rect:', slideRect);

  const total = await page.evaluate(() => Reveal.getTotalSlides());
  console.log(`Total slides: ${total}`);

  for (let i = 0; i < total; i++) {
    await page.evaluate((idx) => Reveal.slide(idx), i);
    await new Promise(r => setTimeout(r, 400));
    const file = path.join(OUT, `slide-${String(i + 1).padStart(2, '0')}.png`);
    await page.screenshot({ path: file, clip: slideRect });
    console.log(`  Captured slide ${i + 1}/${total}`);
  }

  await browser.close();
  console.log('Done:', OUT);
})();
