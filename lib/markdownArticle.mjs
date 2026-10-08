// Markdown ristretto agli articoli in content/approfondimenti:
// titoli, paragrafi, elenchi, citazioni, grassetto, corsivo e link.
// I rimandi [n] diventano ancore verso la voce n delle Fonti.

const BLOCK_START = /^(#{2,3} |> |- |\d+\. )/;

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function escapeAttr(value) {
  return escapeHtml(value).replace(/"/g, "&quot;");
}

function safeHref(href) {
  const value = String(href || "").trim();
  if (value.startsWith("/") && !value.startsWith("//")) return value;
  if (/^https?:\/\//i.test(value)) return value;
  return "";
}

function linkifyBareUrls(value) {
  return value.replace(/https?:\/\/[^\s<]+/g, (raw) => {
    let url = raw;
    let trail = "";
    while (url && /[.,;:)]$/.test(url)) {
      trail = url.slice(-1) + trail;
      url = url.slice(0, -1);
    }
    if (!url) return raw;
    return `<a href="${escapeAttr(url)}">${url}</a>${trail}`;
  });
}

function renderInline(text, { citations }) {
  let html = escapeHtml(text);
  const links = [];
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, (_, label, href) => {
    const safe = safeHref(href);
    const token = `\u0000L${links.length}\u0000`;
    const inner = escapeHtml(label);
    links.push(safe ? `<a href="${escapeAttr(safe)}">${inner}</a>` : inner);
    return token;
  });
  html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  html = html.replace(/(?<!\*)\*([^*]+)\*(?!\*)/g, "<em>$1</em>");
  if (citations) {
    html = html.replace(/\[(\d+)\]/g, (_, n) => {
      return `<a class="fonte-ref" href="#fonte-${n}" aria-label="Fonte ${n}">[${n}]</a>`;
    });
  }
  html = linkifyBareUrls(html);
  html = html.replace(/\u0000L(\d+)\u0000/g, (_, index) => links[Number(index)] || "");
  return html;
}

function parseBlocks(markdown) {
  const lines = String(markdown || "").replace(/\r\n/g, "\n").split("\n");
  const blocks = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (line.trim() === "") {
      i += 1;
      continue;
    }
    const heading = /^(#{2,3}) (.+)$/.exec(line);
    if (heading) {
      blocks.push({ type: "heading", level: heading[1].length, text: heading[2] });
      i += 1;
      continue;
    }
    if (line.startsWith("> ")) {
      const quote = [];
      while (i < lines.length && lines[i].startsWith("> ")) {
        quote.push(lines[i].slice(2));
        i += 1;
      }
      blocks.push({ type: "quote", lines: quote });
      continue;
    }
    if (line.startsWith("- ")) {
      const items = [];
      while (i < lines.length && lines[i].startsWith("- ")) {
        items.push(lines[i].slice(2));
        i += 1;
      }
      blocks.push({ type: "ul", items });
      continue;
    }
    if (/^\d+\. /.test(line)) {
      const items = [];
      while (i < lines.length && /^\d+\. /.test(lines[i])) {
        const match = /^(\d+)\. (.*)$/.exec(lines[i]);
        items.push({ n: Number(match[1]), text: match[2] });
        i += 1;
      }
      blocks.push({ type: "ol", items });
      continue;
    }
    const para = [];
    while (i < lines.length && lines[i].trim() !== "" && !BLOCK_START.test(lines[i])) {
      para.push(lines[i]);
      i += 1;
    }
    blocks.push({ type: "p", text: para.join(" ") });
  }
  return blocks;
}

function renderBlocks(blocks, options) {
  return blocks
    .map((block) => {
      switch (block.type) {
        case "heading": {
          const tag = block.level === 3 ? "h3" : "h2";
          return `<${tag}>${renderInline(block.text, options)}</${tag}>`;
        }
        case "quote":
          return `<blockquote><p>${block.lines.map((line) => renderInline(line, options)).join("<br>")}</p></blockquote>`;
        case "ul":
          return `<ul>${block.items.map((item) => `<li>${renderInline(item, options)}</li>`).join("")}</ul>`;
        case "ol": {
          const lis = block.items
            .map((item) => {
              const id = options.fonteIds ? ` id="fonte-${item.n}"` : "";
              return `<li${id}>${renderInline(item.text, options)}</li>`;
            })
            .join("");
          return `<ol>${lis}</ol>`;
        }
        case "p":
          return `<p>${renderInline(block.text, options)}</p>`;
        default: {
          const unknown = block;
          throw new Error(`Blocco markdown non gestito: ${unknown && unknown.type}`);
        }
      }
    })
    .join("\n");
}

export function renderMarkdown(markdown, options = {}) {
  const citations = options.citations !== false;
  const fonteIds = Boolean(options.fonteIds);
  return renderBlocks(parseBlocks(markdown), { citations, fonteIds });
}

const FONTI_MARK = "\n## Fonti\n";
const NOTA_MARK = "\n## Nota sui diritti\n";

export function splitArticleSections(body) {
  const fontiAt = body.indexOf(FONTI_MARK);
  const notaAt = body.indexOf(NOTA_MARK);
  if (fontiAt < 0 || notaAt < 0 || notaAt < fontiAt) {
    throw new Error("L'articolo non ha le sezioni Fonti e Nota sui diritti");
  }
  return {
    body: body.slice(0, fontiAt).trim(),
    fonti: body.slice(fontiAt + FONTI_MARK.length, notaAt).trim(),
    nota: body.slice(notaAt + NOTA_MARK.length).trim(),
  };
}

export function citationNumbers(markdown) {
  const found = new Set();
  const pattern = /\[(\d+)\](?!\()/g;
  let match = pattern.exec(markdown);
  while (match) {
    found.add(Number(match[1]));
    match = pattern.exec(markdown);
  }
  return found;
}
