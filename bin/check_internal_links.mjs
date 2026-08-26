import fs from "node:fs";
import path from "node:path";

const siteRoot = path.resolve(process.argv[2] ?? "_site");
const htmlFiles = [];

function walk(directory) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const entryPath = path.join(directory, entry.name);
    if (entry.isDirectory()) walk(entryPath);
    if (entry.isFile() && entry.name.endsWith(".html")) htmlFiles.push(entryPath);
  }
}

function targetExists(target) {
  if (fs.existsSync(target) && fs.statSync(target).isFile()) return true;
  if (fs.existsSync(target) && fs.statSync(target).isDirectory()) {
    return fs.existsSync(path.join(target, "index.html"));
  }
  if (!path.extname(target)) return fs.existsSync(path.join(target, "index.html"));
  return false;
}

walk(siteRoot);
const broken = [];
let checked = 0;

for (const htmlFile of htmlFiles) {
  const html = fs.readFileSync(htmlFile, "utf8");
  const scannableHtml = html.replace(
    /<script\b([^>]*)>[\s\S]*?<\/script>/gi,
    (_script, attributes) => `<script${attributes}></script>`,
  );
  for (const match of scannableHtml.matchAll(/<(?:a|link|img|script|source)\b[^>]*\b(?:href|src)=["']([^"']+)["'][^>]*>/gi)) {
    const rawReference = match[1];
    if (
      rawReference.startsWith("#") ||
      rawReference.startsWith("//") ||
      /^(?:https?:|mailto:|tel:|data:|javascript:)/i.test(rawReference)
    ) {
      continue;
    }

    const cleanReference = rawReference.split(/[?#]/, 1)[0];
    if (!cleanReference) continue;

    const decodedReference = decodeURIComponent(cleanReference);
    const target = decodedReference.startsWith("/")
      ? path.join(siteRoot, decodedReference)
      : path.resolve(path.dirname(htmlFile), decodedReference);

    checked += 1;
    if (!targetExists(target)) {
      broken.push(`${path.relative(siteRoot, htmlFile)} -> ${rawReference}`);
    }
  }
}

if (broken.length > 0) {
  console.error(`FAIL: ${broken.length} broken internal reference(s):`);
  for (const reference of broken) console.error(`  ${reference}`);
  process.exit(1);
}

console.log(`PASS: ${checked} internal references across ${htmlFiles.length} generated HTML files resolve.`);
