import { useEffect } from "react";

// Lingue proposte nel menu. L'italiano resta la lingua sorgente.
const INCLUDED_LANGUAGES =
  "en,fr,de,es,el,pt,ru,zh-CN,ja,ko,ar,sq,nl,pl,tr,ro,sv,uk";

let domPatched = false;

// Google Translate riscrive il DOM avvolgendo i nodi di testo in <font>,
// fuori dal controllo di React. Quando React prova poi a rimuovere/spostare
// quegli stessi nodi (es. chiudendo un filtro o un pannello) il DOM reale
// non corrisponde più a quello atteso e il browser lancia
// "Failed to execute 'removeChild'/'insertBefore' on 'Node'", che crasha
// la pagina. La patch è quella standard adottata per questo conflitto noto
// tra Google Translate e le librerie a Virtual DOM (React/Vue): se il nodo
// da rimuovere/spostare non è più figlio del genitore atteso, l'operazione
// viene ignorata invece di far esplodere l'eccezione.
function patchDomForGoogleTranslate() {
  if (domPatched || typeof Node === "undefined") return;
  domPatched = true;

  const originalRemoveChild = Node.prototype.removeChild;
  Node.prototype.removeChild = function (child) {
    if (child.parentNode !== this) {
      return child;
    }
    return originalRemoveChild.apply(this, arguments);
  };

  const originalInsertBefore = Node.prototype.insertBefore;
  Node.prototype.insertBefore = function (newNode, referenceNode) {
    if (referenceNode && referenceNode.parentNode !== this) {
      return newNode;
    }
    return originalInsertBefore.apply(this, arguments);
  };
}

export default function GoogleTranslate() {
  useEffect(() => {
    if (typeof window === "undefined") return;
    patchDomForGoogleTranslate();

    function init() {
      if (
        window.google &&
        window.google.translate &&
        document.getElementById("google_translate_element")
      ) {
        new window.google.translate.TranslateElement(
          {
            pageLanguage: "it",
            includedLanguages: INCLUDED_LANGUAGES,
            layout: window.google.translate.TranslateElement.InlineLayout.SIMPLE,
            autoDisplay: false,
          },
          "google_translate_element"
        );
      }
    }

    if (window.google && window.google.translate) {
      init();
      return;
    }

    window.googleTranslateElementInit = init;

    if (!document.getElementById("google-translate-script")) {
      const script = document.createElement("script");
      script.id = "google-translate-script";
      script.src = "//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit";
      script.async = true;
      document.body.appendChild(script);
    }
  }, []);

  return (
    <div
      id="google_translate_element"
      className="google-translate-widget notranslate"
      translate="no"
      aria-label="Traduci il sito in un'altra lingua (Google Translate)"
    />
  );
}
