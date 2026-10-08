// Metadati e piccole funzioni condivise fra l'indice di /leggi e la scheda
// del singolo testo. Nessun dato e nessun accesso a file: il modulo puo'
// stare nel bundle del browser.

export const CATEGORY_META = {
  proverbio: {
    order: 1,
    label: "Proverbi e massime di vita",
    note: "Saggezza tramandata a voce: la famiglia, il lavoro, la ricchezza, la povertà, l'amore.",
  },
  filastrocca: {
    order: 2,
    label: "Filastrocche e ninne nanne",
    note: "Versi per addormentare e per giocare, trasmessi di madre in figlia.",
  },
  canto_popolare: {
    order: 3,
    label: "Canti popolari e religiosi",
    note: "Canti d'amore, di preghiera e di festa cantati nelle case e nelle chiese della Grecìa Salentina.",
  },
  canto: {
    order: 4,
    label: "Canti d'autore in pubblico dominio",
    note: "Componimenti di autori defunti, fuori dai diritti d'autore.",
  },
  canto_carmine_greco: {
    order: 4,
    label: "Canti commentati da Carmine Greco",
    note: "Quattro canti tradizionali griki presentati e commentati nel corso video di Carmine Greco.",
  },
  "morolòj": {
    order: 5,
    label: "Morolòj, lamenti funebri",
    note: "Il pianto rituale intonato alla morte di un familiare, forma poetica antichissima.",
  },
  fiaba: {
    order: 6,
    label: "Fiabe popolari",
    note: "Racconti lunghi della tradizione orale salentina, trascritti dalle raccolte storiche.",
  },
};

export function categoryMeta(cat) {
  return CATEGORY_META[cat] || { order: 99, label: cat, note: "" };
}

export function leadingNumber(titolo) {
  const m = String(titolo || "").match(/(\d+)/);
  return m ? parseInt(m[1], 10) : Number.MAX_SAFE_INTEGER;
}

export function excerpt(testo, len = 90) {
  const clean = String(testo || "").replace(/\s+/g, " ").trim();
  if (!clean) return "";
  return clean.length > len ? clean.slice(0, len).trim() + "…" : clean;
}

// Tutte le categorie sono testo in griko da proteggere dalla traduzione
// automatica, tranne il commento parlato di Carmine Greco, che e' in italiano.
export function isGrikoText(categoria) {
  return categoria !== "canto_carmine_greco";
}

export function licenseLabel(licenza) {
  if (licenza === "pubblico_dominio_tradizione_orale") {
    return "pubblico dominio / tradizione orale";
  }
  if (licenza === "cortesia_carmine_greco") {
    return "trascrizione del video-lezione di Carmine Greco, contenuto a lui attribuito";
  }
  return licenza || "";
}
