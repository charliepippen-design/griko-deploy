// Scarica i file di Wikimedia Commons indicati nel front matter.
// Un'immagine entra nel manifest solo se il download coincide con
// l'originale (SHA1 e dimensione) e la licenza dichiarata coincide
// con quella della pagina Commons. I JPEG piu' larghi di 1600 px o
// piu' pesanti di 300 KB vengono salvati come copia web (JPEG + WebP).
// Le voci con role "og" gia' presenti nel manifest restano.

import { spawnSync } from "child_process";
import { createHash } from "crypto";
import { mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from "fs";
import { tmpdir } from "os";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { parse as parseYaml } from "yaml";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const contentDir = join(root, "content/approfondimenti");
const UA = "griko.online approfondimenti (archivio statico; https://www.griko.online)";

function stripTags(value) {
  return String(value || "")
    .replace(/<[^>]+>/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function metaValue(info, key) {
  const bag = info && info.extmetadata;
  const entry = bag && bag[key];
  if (!entry) return "";
  return stripTags(entry.value);
}

function fileTitleFromPage(pageUrl) {
  const marker = "/wiki/File:";
  const at = pageUrl.indexOf(marker);
  if (at < 0) return "";
  return decodeURIComponent(pageUrl.slice(at + marker.length).replace(/_/g, " "));
}

function ccToken(value) {
  const match = String(value || "").toLowerCase().match(/cc by(?:-sa|-nc-nd|-nc-sa|-nc|-nd)?\s*\d(?:\.\d)?/);
  return match ? match[0].replace(/\s+/g, " ") : "";
}

function licenceAgrees(stated, commonsShort) {
  const a = String(stated || "").toLowerCase();
  const b = String(commonsShort || "").toLowerCase();
  const statedPd = /pubblico dominio|public domain|cc0/.test(a);
  const commonsPd = /public domain|cc0|\bpd\b/.test(b);
  if (statedPd || commonsPd) return statedPd && commonsPd;
  const left = ccToken(a);
  const right = ccToken(b);
  return Boolean(left) && left === right;
}

function sha1Matches(buffer, remote) {
  const expected = String(remote || "").toLowerCase();
  if (!expected) return false;
  const hex = createHash("sha1").update(buffer).digest("hex");
  if (hex === expected) return true;
  const base36 = BigInt(`0x${hex}`).toString(36);
  return expected === base36 || expected === base36.padStart(31, "0");
}

function looksLikeImage(buffer, mime) {
  if (mime === "image/png") return buffer[0] === 0x89 && buffer[1] === 0x50 && buffer[2] === 0x4e && buffer[3] === 0x47;
  if (mime === "image/jpeg") return buffer[0] === 0xff && buffer[1] === 0xd8 && buffer[2] === 0xff;
  if (mime === "image/svg+xml") {
    const head = buffer.subarray(0, 400).toString("utf8").toLowerCase();
    return head.includes("<svg");
  }
  if (mime === "image/webp" || mime === "image/gif") return buffer.length > 12;
  return false;
}

async function commonsInfo(fileTitle) {
  const params = new URLSearchParams({
    action: "query",
    format: "json",
    formatversion: "2",
    prop: "imageinfo",
    iiprop: "url|size|mime|sha1|extmetadata",
    titles: `File:${fileTitle}`,
  });
  const response = await fetch(`https://commons.wikimedia.org/w/api.php?${params}`, {
    headers: { "User-Agent": UA, Accept: "application/json" },
  });
  if (!response.ok) throw new Error(`API Commons ${response.status}`);
  const payload = await response.json();
  const page = payload && payload.query && payload.query.pages && payload.query.pages[0];
  if (!page || page.missing || !page.imageinfo || !page.imageinfo[0]) {
    throw new Error("file assente su Commons");
  }
  return page.imageinfo[0];
}

async function downloadOriginal(url) {
  const response = await fetch(url, {
    headers: { "User-Agent": UA, Accept: "image/*,image/svg+xml,*/*" },
    redirect: "follow",
  });
  if (!response.ok) throw new Error(`download ${response.status}`);
  const mime = (response.headers.get("content-type") || "").split(";")[0].trim().toLowerCase();
  const buffer = Buffer.from(await response.arrayBuffer());
  return { mime, buffer };
}

function writeWebJpeg(buffer, destPath) {
  const tmpDir = mkdtempSync(join(tmpdir(), "griko-img-"));
  const tmpPath = join(tmpDir, "original.jpg");
  try {
    writeFileSync(tmpPath, buffer);
    const result = spawnSync("python3", [join(root, "scripts/resize-web-image.py"), tmpPath, destPath], {
      encoding: "utf8",
    });
    if (result.status !== 0) {
      throw new Error((result.stderr || result.stdout || "resize fallito").trim());
    }
    return JSON.parse(result.stdout);
  } finally {
    rmSync(tmpDir, { recursive: true, force: true });
  }
}

function safeFilename(fileTitle) {
  const base = fileTitle.split("/").pop() || "immagine";
  return base.replace(/[^\w.\-]+/g, "_");
}

async function main() {
  let previous = {};
  try {
    previous = JSON.parse(readFileSync(join(contentDir, "immagini.json"), "utf8"));
  } catch {
    previous = {};
  }
  const manifest = {};
  const files = readdirSync(contentDir).filter((name) => name.endsWith(".md")).sort();
  for (const filename of files) {
    const raw = readFileSync(join(contentDir, filename), "utf8");
    const end = raw.indexOf("\n---\n", 4);
    const data = parseYaml(raw.slice(4, end));
    const slug = data.slug;
    manifest[slug] = [];
    const images = Array.isArray(data.images) ? data.images : [];
    for (const image of images) {
      const label = `${slug}: ${image.file || image.url}`;
      try {
        const fileTitle = fileTitleFromPage(image.url);
        if (!fileTitle) throw new Error("url Commons non riconosciuto");
        const info = await commonsInfo(fileTitle);
        const commonsLicence = metaValue(info, "LicenseShortName");
        if (!licenceAgrees(image.licence, commonsLicence)) {
          console.log(`SKIP ${label}: licenza "${image.licence}" diversa da Commons "${commonsLicence}"`);
          continue;
        }
        const downloaded = await downloadOriginal(info.url);
        if (downloaded.mime !== String(info.mime || "").toLowerCase()) {
          console.log(`SKIP ${label}: mime ${downloaded.mime} diverso da ${info.mime}`);
          continue;
        }
        if (!looksLikeImage(downloaded.buffer, downloaded.mime)) {
          console.log(`SKIP ${label}: il file scaricato non e' un'immagine`);
          continue;
        }
        if (!sha1Matches(downloaded.buffer, info.sha1) || downloaded.buffer.length !== info.size) {
          console.log(`SKIP ${label}: il file scaricato non coincide con l'originale Commons`);
          continue;
        }
        const dir = join(root, "public/images/approfondimenti", slug);
        mkdirSync(dir, { recursive: true });
        const filenameOnDisk = safeFilename(fileTitle);
        const destPath = join(dir, filenameOnDisk);
        const heavyJpeg = downloaded.mime === "image/jpeg" && ((info.width || 0) > 1600 || downloaded.buffer.length > 300000);
        let width = Number.isInteger(info.width) ? info.width : null;
        let height = Number.isInteger(info.height) ? info.height : null;
        let bytes = downloaded.buffer.length;
        let sha1 = info.sha1 || "";
        let webp = "";
        let sourceSha1 = "";
        if (heavyJpeg) {
          try {
            const meta = writeWebJpeg(downloaded.buffer, destPath);
            width = meta.width;
            height = meta.height;
            bytes = meta.jpegBytes;
            sha1 = meta.sha1;
            sourceSha1 = info.sha1 || "";
            webp = `/images/approfondimenti/${slug}/${filenameOnDisk.replace(/\.jpe?g$/i, ".webp")}`;
            console.log(`OK ${label}: copia web ${bytes} byte (originale ${downloaded.buffer.length}), ${commonsLicence}`);
          } catch (error) {
            writeFileSync(destPath, downloaded.buffer);
            console.log(`WARN ${label}: resize non riuscito (${error.message}), salvato l'originale`);
            console.log(`OK ${label}: ${downloaded.buffer.length} byte, ${commonsLicence}`);
          }
        } else {
          writeFileSync(destPath, downloaded.buffer);
          console.log(`OK ${label}: ${downloaded.buffer.length} byte, ${commonsLicence}`);
        }
        const entry = {
          pageUrl: image.url,
          src: `/images/approfondimenti/${slug}/${filenameOnDisk}`,
          mime: downloaded.mime,
          width,
          height,
          bytes,
          sha1,
        };
        if (webp) entry.webp = webp;
        if (sourceSha1) entry.sourceSha1 = sourceSha1;
        manifest[slug].push(entry);
      } catch (error) {
        console.log(`SKIP ${label}: ${error.message}`);
      }
    }
    const keptOg = (Array.isArray(previous[slug]) ? previous[slug] : []).filter((item) => item && item.role === "og");
    manifest[slug].push(...keptOg);
  }
  writeFileSync(join(contentDir, "immagini.json"), `${JSON.stringify(manifest, null, 2)}\n`);
  console.log("immagini.json aggiornato");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
